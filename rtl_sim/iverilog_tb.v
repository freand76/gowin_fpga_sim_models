`timescale 1ns / 1ns
`default_nettype none

module iverilog_tb;

   logic clka;
   logic clkb;
   logic reseta;
   logic resetb;

   logic [15:0] dia, dib;
   logic [13:0] ada, adb;

   wire [15:0]  doa, dob;

   logic        ocea, oceb;
   logic        cea, ceb;
   logic        wrea, wreb;

   logic [2:0]  blksela, blkselb;

   DPB mem(
           .CLKA(clka),
           .CLKB(clkb),
           .RESETA(reseta),
           .RESETB(resetb),
           .OCEA(ocea),
           .OCEB(oceb),
           .CEA(cea),
           .CEB(ceb),
           .WREA(wrea),
           .WREB(wreb),
           .ADA(ada),
           .ADB(adb),
           .DIA(dia),
           .DIB(dib),
           .BLKSELA(blksela),
           .BLKSELB(blkselb),
           .DOA(doa),
           .DOB(dob)
           );
   defparam mem.READ_MODE0 = 1'b0;
   defparam mem.READ_MODE1 = 1'b0;
   defparam mem.WRITE_MODE0 = 2'b00;
   defparam mem.WRITE_MODE1 = 2'b00;
   defparam mem.BIT_WIDTH_0 = 8;
   defparam mem.BIT_WIDTH_1 = 8;
   defparam mem.BLK_SEL_0 = 3'b000;
   defparam mem.BLK_SEL_1 = 3'b000;
   defparam mem.RESET_MODE = "SYNC";

   initial
     begin
        clka = 0;
        forever
          #11
            clka = ~clka;
     end

   initial
     begin
        clkb = 0;
        forever
          #18
            clkb = ~clkb;
     end

   initial
     begin
        reseta = 1;
        resetb = 1;
        #100;
        $display("Release Reset");
        reseta = 0;
        resetb = 0;
     end

   initial
     begin
        ocea = 1'b1;
        oceb = 1'b1;
        cea = 1'b1;
        ceb = 1'b1;
        wrea = 1'b0;
        wreb = 1'b0;
        ada = 14'h0;
        adb = 14'h0;
        dia = 16'h0;
        dib = 16'h0;
        blksela = 3'b000;
        blkselb = 3'b000;
        #1000;
        $finish;
     end

endmodule // iverilog_top
