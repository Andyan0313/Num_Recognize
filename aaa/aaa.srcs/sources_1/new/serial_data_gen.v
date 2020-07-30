`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/27 10:40:00
// Design Name: 
// Module Name: serial_data_gen
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
module serial_data_gen(
    input clk,
    input rst_n,
    output wire [7:0] data,
    output reg data_vld
    );

reg  [7:0] data_src_mem [307199:0];
//reg  [7:0] data_src_mem [1024:0];
reg  [18:0] last=638;
reg  [18:0] mem_addr;
initial
    begin
        $readmemh("C:/Users/92949/Documents/MATLAB/Num_hex.txt",data_src_mem);//注意修改这里的绝对路径
        //$readmemh("D:/Xilinx/project/aaa/zzz.txt",data_src_mem);
    end
always @(posedge clk or negedge rst_n)
    begin
        if(!rst_n || mem_addr == 307199)
            begin
                mem_addr <= 10'd0 ;
                last<=638;
                data_vld=1;
            end
        else
            begin
                mem_addr <= mem_addr + 10'd1;
                data_vld=1;
                if(mem_addr==last)
                    begin
                        data_vld=0;
                        last<=last+640;
                    end 
            end
    end
assign data=data_src_mem[mem_addr];
endmodule

