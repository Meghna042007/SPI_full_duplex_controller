`timescale 1ns / 1ps
module top_spi_tsb();
reg clk,start,rst;
reg [7:0]master_data_in,slave_data_in;
wire [7:0]master_data_out,slave_data_out;
wire master_done,slave_done,cs,sclk,mosi,miso;

top_spi top (.clk(clk),.rst(rst),.start(start),.master_data_in(master_data_in),.slave_data_in(slave_data_in),
.cs(cs),.sclk(sclk),.mosi(mosi),.miso(miso),.master_data_out(master_data_out),.slave_data_out(slave_data_out),
.master_done(master_done),.slave_done(slave_done));

always #5 clk=~clk;
initial
begin
clk=0;rst=1;start=0;
repeat(10)@(posedge clk);
rst=0;start=1;master_data_in=8'hb3;slave_data_in=8'hd6;
repeat(5)@(posedge clk);
start=0;
repeat (100)@(posedge clk);
#100;
$finish;
end
endmodule
