`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/27 11:24:35
// Design Name: 
// Module Name: TestBench
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
//serial_data_gen
/*
module TestBench();
reg clk;
reg rst_n=1'b1;
wire [7:0] data;
wire data_vld;
serial_data_gen test(
    .clk(clk),
    .rst_n(rst_n),
    .data(data),
    .data_vld(data_vld)
    );
initial
    begin
        clk=1'b1;
        #5;
        rst_n=1'b0;
        #10
        rst_n=1'b1;
    end
    always #20 clk=~clk;
    
endmodule
*/
/*
module TestBench();
reg clk;
reg rst_n=1'b1;
wire [7:0] data;
wire data_vld;
wire [11:0] line_cnt;
wire [11:0] pix_cnt;
wire [11:0] x_l;
wire [11:0] x_r;
wire [11:0] y_u;
wire [11:0] y_d;
wire xy_vld;
boundary_check test(
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
initial
    begin
        clk=1'b1;
        #5;
        rst_n=1'b0;
        #10
        rst_n=1'b1;
    end
    always #20 clk=~clk;
    
endmodule
*/
module TestBench();
reg clk;
reg rst_n=1'b1;
wire [3:0] num;
num_rec test(
    .clk(clk),
    .rst_n(rst_n),
    .num(num)
    );
initial
    begin
        clk=1'b1;
        #5;
        rst_n=1'b0;
        #10
        rst_n=1'b1;
    end
    always #20 clk=~clk;
endmodule
