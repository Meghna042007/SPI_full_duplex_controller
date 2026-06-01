`timescale 1ns / 1ps
module master_spi(
input clk,rst,start,MISO,   
input [7:0]data_in,
output [7:0]data_out,
output reg CS,SCLK,MOSI,done
);
//system clock=100MHz
//SCLK = 10 MHz so 100/10=10 counts
localparam IDLE=2'b00,
           LOAD=2'b01,
           TRANSFER=2'b10,
           DONE=2'b11;
reg [1:0]state;reg [7:0]tx_shift_reg;reg [3:0] tx_bit_count;reg [4:0]divider_count;
reg en;
reg [7:0]rx_shift_reg;

always @(posedge clk)
begin
if(rst)
   begin
   state<=IDLE;
   tx_bit_count<=0;
   divider_count<=0;
   en<=0;
   CS=1'b1;
   SCLK=0;
   done=0;
   end
else
   begin
   case(state)
   IDLE:begin
        CS<=1;
        SCLK<=0;
        if(start)
           begin
           state<=LOAD;
           tx_shift_reg<=data_in;
           en<=1'b1;
           end
        end
   LOAD:begin
        CS<=0;  
        if(divider_count == 5'd4)
           begin
           SCLK=~SCLK;
           divider_count<=divider_count+1;
           end
        else if(divider_count == 5'd9)
                begin
                SCLK=~SCLK; 
                divider_count<=0;
                state<=TRANSFER;
                end
        else
           divider_count<=divider_count+1;
        end
   TRANSFER:begin
            if(en)
            begin
             if(tx_bit_count == 4'd8)
                begin
                   if(divider_count == 5'd9)
                      begin
                      SCLK<=~SCLK;
                      divider_count<=divider_count+1;
                      end
                   else if(divider_count == 5'd14)
                      begin
                      SCLK=~SCLK;
                      tx_bit_count<=0;
                      divider_count<=0;
                      en<=0;
                      CS<=1;
                      state<=DONE;
                      end
                   else
                      divider_count<=divider_count+1;
                end
              else
                 begin
                 if(divider_count == 5'd4)
                    begin
                    SCLK<=~SCLK;
                    MOSI<=tx_shift_reg[7];
                    tx_bit_count<=tx_bit_count+1;
                    divider_count<=divider_count+1;
                    rx_shift_reg<=rx_shift_reg<<1;
                    end
                  else if(divider_count == 5'd9)
                           begin
                           SCLK=~SCLK;
                           divider_count<=0;
                           tx_shift_reg<=tx_shift_reg<<1;
                           rx_shift_reg[0]<=MISO;
                           end
                  else
                     divider_count<=divider_count+1;
                 end
               end
            end 
      DONE:begin
           MOSI<=1'b0;
           SCLK<=0;
           done<=1'b1;
           state<=IDLE;
           end     
    endcase
 end
end   
assign data_out = rx_shift_reg;          
endmodule
