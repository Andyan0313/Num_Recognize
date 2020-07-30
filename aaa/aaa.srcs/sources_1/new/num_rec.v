`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/28 17:25:30
// Design Name: 
// Module Name: num_rec
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module num_rec(
    input clk,
    input rst_n,
    output reg [3:0] num
    );
    wire [11:0] x_l;
    wire [11:0] x_r;
    wire [11:0] y_u;
    wire [11:0] y_d;
    wire xy_vld;
    wire [11:0] line_cnt;
    wire [11:0] pix_cnt;
    wire [7:0] data;
    wire data_vld;   
    boundary_check d0(
        .clk(clk),
        .rst_n(rst_n),
        .data(data),
        .data_vld(data_vld),
        .line_cnt(line_cnt),
        .pix_cnt(pix_cnt),
        .x_l(x_l),
        .x_r(x_r),
        .y_u(y_u),
        .y_d(y_d),
        .xy_vld(xy_vld)    
    );
    
    wire [11:0] x1;
    wire [11:0] x2;
    wire [11:0] y;
    assign x1=y_u+(y_d-y_u)*2/5;
    assign x2=y_u+(y_d-y_u)*2/3;
    assign y=(x_l+x_r)/2;

    reg [1:0] x1_cnt;
    reg [1:0] x2_cnt;
    reg [1:0] y_cnt;
    reg lr_x1_flag;//0代表左边，1代表右边
    reg lr_x2_flag;//0代表左边，1代表右边
    reg [7:0] last_data_x1=8'hff;
    reg [7:0] last_data_x2=8'hff;
    reg [7:0] last_data_y=8'hff;
    reg x1_a;
    reg x2_a;
    reg y_a;
    parameter ff=8'hff;
    parameter zz=8'h00; 
    always@(posedge clk or negedge rst_n)
        begin
            if(!rst_n)
                begin
                    x1_cnt=2'd0;
                    lr_x1_flag=0;
                    x1_a=0;
                end
            else if(xy_vld && x1_a==0)
                begin
                    if(line_cnt==x1)
                        begin
                            if(data_vld && data==zz && last_data_x1==ff)
                                begin
                                    x1_cnt=x1_cnt+2'd1;
                                    if(pix_cnt<=y)
                                        lr_x1_flag=0;
                                    else
                                        lr_x1_flag=1;
                                end
                            else if(data_vld==0)
                                x1_a=1;
                        end
                end
        end
    always@(posedge clk or negedge rst_n)
        begin
            if(!rst_n)
                last_data_x1<=8'hff;
            else
                last_data_x1<=data;
        end
        
    always@(posedge clk or negedge rst_n)
        begin
            if(!rst_n)
                begin
                    x2_cnt=2'd0;
                    lr_x2_flag=0;
                    x2_a=0;
                end
            else if(xy_vld && x2_a==0)
                begin
                    if(line_cnt==x2)
                        begin
                            if(data_vld && data==zz && last_data_x2==ff)
                                begin
                                    x2_cnt=x2_cnt+2'd1;
                                    if(pix_cnt<=y)
                                        lr_x2_flag=0;
                                    else
                                        lr_x2_flag=1;
                                end
                            else if(data_vld==0)
                                x2_a=1;
                        end
                end
        end
    always@(posedge clk or negedge rst_n)
        begin
            if(!rst_n)
                last_data_x2<=8'hff;
            else
                last_data_x2<=data;
        end
    
    always@(posedge clk or negedge rst_n)
        begin
            if(!rst_n)
                begin
                    y_cnt=2'd0;
                    y_a=0;
                end
            else if(xy_vld && y_a==0 && pix_cnt==y)
                begin
                    if(data_vld && data==zz && last_data_y==ff)
                        y_cnt=y_cnt+2'd1;
                    else if(line_cnt==12'd479)
                        y_a=1;
                end
        end
    always@(posedge clk or negedge rst_n)
        begin
            if(!rst_n)
                last_data_y<=8'hff;
            else if(pix_cnt==y)
                last_data_y<=data;
        end
       
    always@(posedge clk or negedge rst_n)
        begin
            if(!rst_n)
                num<=0;
            else case({y_cnt,x1_cnt,x2_cnt})
                9'b000101010:num<=0;
                9'b000010101:num<=1;
                9'b000110101:
                    begin
                        if(lr_x1_flag==1 && lr_x2_flag==0) num<=2;
                        if(lr_x1_flag==1 && lr_x2_flag==1) num<=3;
                        if(lr_x1_flag==0 && lr_x2_flag==1) num<=5;
                    end
                9'b000101001:num<=4;
                9'b000110110:num<=6;
                9'b000100101:num<=7;
                9'b000111010:num<=8;
                9'b000111001:num<=9;
                default:;
                endcase
        end
        
endmodule
