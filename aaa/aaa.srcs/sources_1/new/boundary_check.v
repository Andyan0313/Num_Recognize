`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/28 11:40:46
// Design Name: 
// Module Name: boundary_check
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


module boundary_check(
    input clk,
    input rst_n,
    output wire [7:0] data,
    output wire data_vld,
    output reg [11:0] line_cnt,
    output reg [11:0] pix_cnt,
    output reg [11:0] x_l,
    output reg [11:0] x_r,
    output reg [11:0] y_u,
    output reg [11:0] y_d,
    output reg xy_vld//1为全部检查完毕有限，0为还在检查中
    );
    reg [7:0] last_data=8'hff;
    parameter ff=8'hff;
    parameter zz=8'h00;
        
    parameter IDLE=4'b1000;
    parameter CHECK_L_ST=4'b0100;
    parameter CHECK_R_READY=4'b0010;
    parameter CHECK_R_ST=4'b0001;
    reg [3:0] curr_st=IDLE;
    
    
    parameter IDLE0=4'b1000;
    parameter CHECK_U_ST=4'b0100;
    parameter CHECK_D_READY=4'b0010;
    parameter CHECK_D_ST=4'b0001;
    reg [3:0] curr_st0=IDLE0;
    serial_data_gen s0(
        .clk(clk),
        .rst_n(rst_n),
        .data(data),
        .data_vld(data_vld)
        );
    initial
        begin
            x_l<=12'd639;
            x_r<=12'd0;
            y_u<=12'd479;
            y_d<=12'd0;      
            curr_st<=IDLE;
            curr_st0<=IDLE0;
            pix_cnt<=0;
            line_cnt<=0;
            xy_vld<=0;
            last_data<=8'hff;
        end
        
    always@(posedge clk or negedge rst_n)
        begin
            if(!rst_n)
                curr_st<=IDLE;
            else case(curr_st)
                IDLE:
                    begin
                        if(data_vld && data==zz && last_data==ff)
                            curr_st<=CHECK_L_ST;
                        else    ;
                    end
                CHECK_L_ST:curr_st<=CHECK_R_READY;
                CHECK_R_READY:
                    begin
                        if(data_vld==0)
                            curr_st<=IDLE;
                        else if(data_vld && data==ff && last_data==zz)
                            curr_st<=CHECK_R_ST;
                        else    ;
                    end
                CHECK_R_ST:
                    begin
                        if(data_vld==0)
                            curr_st<=IDLE;
                        else
                            curr_st<=CHECK_R_READY;
                    end
                default:;
            endcase
        end

    always@(posedge clk or negedge rst_n)
        begin
            if(!rst_n)
                curr_st0<=IDLE0;
            else case(curr_st0)
                IDLE0:
                    begin
                        if(data_vld && data==zz)
                            curr_st0<=CHECK_U_ST;
                        else    ;
                    end
                CHECK_U_ST:curr_st0<=CHECK_D_READY;
                CHECK_D_READY:
                    begin
                        if(data_vld && data==zz)
                            curr_st0<=CHECK_D_ST;
                        else    ;
                    end
                CHECK_D_ST:
                    begin
                        curr_st0<=CHECK_D_READY;
                    end
                default:;
            endcase
        end        
        
    always@(posedge clk or negedge rst_n)
        begin
            pix_cnt<=pix_cnt+1;
            if(!rst_n)
                pix_cnt<=0;
            else if(data_vld==0)
                pix_cnt<=0;            
        end
        
    always@(posedge clk or negedge rst_n)
        begin
            if(!rst_n)
                line_cnt<=0;
            else if(data_vld==0)
                if(line_cnt==479)
                    line_cnt<=0;
                else
                    line_cnt<=line_cnt+1;            
        end
        
    always@(posedge clk or negedge rst_n)
        begin
            if(!rst_n)
                x_l<=12'd639;
            else if(curr_st==CHECK_L_ST)
                begin
                    if(x_l>pix_cnt)
                        x_l<=pix_cnt;
                    else    ;
                end
            else    ;
        end
    always@(posedge clk or negedge rst_n)
        begin
            if(!rst_n)
                x_r<=12'd0;
            else if(curr_st==CHECK_R_ST)
                begin
                    if(x_r<pix_cnt)
                        x_r<=pix_cnt;
                    else    ;
                end
            else    ;
        end
        
    always@(posedge clk or negedge rst_n)
        begin
            if(!rst_n)
                y_u<=12'd479;
            else if(curr_st0==CHECK_U_ST)
                begin
                    if(y_u>line_cnt)
                        begin
                            y_u<=line_cnt;
                        end
                    else    ;
                end
            else    ;
        end
    always@(posedge clk or negedge rst_n)
        begin
            if(!rst_n)
                y_d<=12'd0;
            else if(curr_st0==CHECK_D_ST)
                begin
                    if(y_d<line_cnt)
                        y_d<=line_cnt;
                    else    ;
                end
        end 
    always@(posedge clk or negedge rst_n)
        begin
            if(!rst_n)
                xy_vld<=0;
            else if(data_vld==0 && line_cnt==479)
                xy_vld<=1;
        end   
    always@(posedge clk or negedge rst_n)
        begin
            if(!rst_n)
                last_data<=8'hff;
            else
                last_data<=data;
        end
        
endmodule
