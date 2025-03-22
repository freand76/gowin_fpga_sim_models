`timescale 1ns / 1ns
`default_nettype none

module DPB
  #(
    parameter READ_MODE0 = 1'b0,
    parameter READ_MODE1 = 1'b0,
    parameter WRITE_MODE0 = 2'b00,
    parameter WRITE_MODE1 = 2'b00,
    parameter int BIT_WIDTH_0 = 16,
    parameter int BIT_WIDTH_1 = 16,
    parameter BLK_SEL_0 = 3'b000,
    parameter BLK_SEL_1 = 3'b000,
    parameter RESET_MODE = "SYNC"
    )
   (
    input             CLKA,
    input             CLKB,
    input             RESETA,
    input             RESETB,
    input             OCEA,
    input             OCEB,
    input             CEA,
    input             CEB,
    input             WREA,
    input             WREB,
    input [13:0]      ADA,
    input [13:0]      ADB,
    input [15:0]      DIA,
    input [15:0]      DIB,
    input [2:0]       BLKSELA,
    input [2:0]       BLKSELB,
    output reg [15:0] DOA,
    output reg [15:0] DOB
    );

   parameter          D_PORT_WIDTH = 16;
   parameter          AD_PORT_WIDTH = 14;
   parameter          BIT_ADDR_LENGTH = $clog2(BIT_WIDTH_0);
   parameter          USED_AD_PORT_WIDTH = AD_PORT_WIDTH - BIT_ADDR_LENGTH;
   parameter          MEM_LENGTH = 2 ** USED_AD_PORT_WIDTH;
   logic [BIT_WIDTH_0-1:0]       mem [0:MEM_LENGTH - 1];

   initial
     begin
        case (BIT_WIDTH_0)
          1,2,4,8,16:
               $display("BIT_WIDTH_0     = %0d", BIT_WIDTH_0);
          default:
            begin
               $display("BIT_WIDTH_0 = %0d is not supported", BIT_WIDTH_0);
               $fatal;
            end
        endcase // case (BIT_WIDTH_0)

        if (RESET_MODE != "SYNC")
          begin
             $display("Model does not (yet) support ASYNC reset");
             $fatal;
          end

        if (BIT_WIDTH_0 != BIT_WIDTH_1)
          begin
             $display("Model does not (yet) support BIT_WIDTH_0 != BIT_WIDTH_1");
             $fatal;
          end

        if ((READ_MODE0 != 1'b0) | (READ_MODE1 != 1'b0))
          begin
             $display("READ_MODEx must be 1'b0");
             $fatal;
          end

        if ((WRITE_MODE0 != 2'b00) | (WRITE_MODE1 != 2'b00))
          begin
             $display("WRITE_MODEx must be 2'b00");
             $fatal;
          end

        $display("USED_ADDR_BITS  = %0d", USED_AD_PORT_WIDTH);
        $display("MEM_LENGTH      = %0d", MEM_LENGTH);
     end

   always @ (posedge CLKA)
     begin
        if (BLK_SEL_0 == BLKSELA)
          begin
             if (RESETA)
               begin
                  int idx;
                  for (idx = 0; idx < MEM_LENGTH-1; idx++)
                    begin
                       mem[idx] = {BIT_WIDTH_0{1'b0}};
                    end
               end
             else if (CEA & !WREA)
               begin
                  DOA <= {{(D_PORT_WIDTH - BIT_WIDTH_0){1'b0} } , mem[ADA[13:BIT_ADDR_LENGTH]]};
               end
             else if (CEA & WREA)
               begin
                  mem[ADA[13:BIT_ADDR_LENGTH]] = DIA[BIT_WIDTH_0-1:0];
               end
          end
     end

   always @ (posedge CLKB)
     begin
        if (BLK_SEL_1 == BLKSELB)
          begin
             if (RESETB)
               begin
                  int idx;
                  for (idx = 0; idx < MEM_LENGTH-1; idx++)
                    begin
                       mem[idx] = {BIT_WIDTH_0{1'b0}};
                    end
               end
             else if (CEB & !WREB)
               begin
                  DOB <= {{(D_PORT_WIDTH - BIT_WIDTH_0){1'b0} } , mem[ADB[13:BIT_ADDR_LENGTH]]};
               end
             else if (CEA & WREB)
               begin
                  mem[ADB[13:BIT_ADDR_LENGTH]] = DIB[BIT_WIDTH_0-1:0];
               end
          end
     end

endmodule
