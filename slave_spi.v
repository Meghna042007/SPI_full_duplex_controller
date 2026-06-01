`timescale 1ns / 1ps
module slave_spi(
input SCLK,rst,CS,MOSI,
input [7:0]data_in,
output [7:0]data_out,
output reg done,MISO
);
localparam IDLE=2'b00,
           TRANSFER=2'b01,
           DONE=2'b10;
            
reg [1:0]state1;reg [7:0] rx_shift_reg;reg [3:0] bit_count;
reg [7:0] tx_shift_reg;
reg [1:0]state2;

always @(posedge SCLK or posedge rst)
begin
if(rst)
   begin
   state1<=IDLE;
   done<=0;
   bit_count<=0;
   end
else
   begin
   case(state1)
   IDLE:begin
        state1<=TRANSFER;
        tx_shift_reg<=data_in;
        MISO<=tx_shift_reg[7];
        end
   TRANSFER:begin
            done<=0;
            if(CS==0)
               begin
               if(bit_count == 4'd8)
                  begin
                  state1<=DONE;
                  bit_count<=0;
                  done<=1;
                  end
               else
                  begin
                  rx_shift_reg<=rx_shift_reg<<1;
                  rx_shift_reg[0]<=MOSI;
                  bit_count<=bit_count+1;
                  MISO<=tx_shift_reg[7];
                  tx_shift_reg<=tx_shift_reg<<1;
                 end
               end
            end 
     DONE:begin
          bit_count<=0;
          done<=1;
          state1<=TRANSFER;
          end
    endcase
   end
 end
   
assign data_out = rx_shift_reg;
endmodule
