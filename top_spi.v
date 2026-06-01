`timescale 1ns / 1ps
module top_spi(
input clk,start,rst,
input  [7:0]master_data_in,slave_data_in,
output cs,sclk,mosi,miso,
output [7:0]master_data_out,slave_data_out,
output master_done,slave_done
);

wire MISO;
wire CS;
wire SCLK;
wire MOSI;

assign cs=CS;
assign sclk=SCLK;
assign mosi=MOSI;
assign miso=MISO;

master_spi master(.clk(clk),.rst(rst),.start(start),.MISO(MISO),.data_in(master_data_in),.data_out(master_data_out),
.CS(CS),.SCLK(SCLK),.MOSI(MOSI),.done(master_done));

slave_spi slave(.SCLK(SCLK),.rst(rst),.CS(CS),.MOSI(MOSI),.data_in(slave_data_in),.data_out(slave_data_out),.MISO(MISO),
.done(slave_done));
endmodule
