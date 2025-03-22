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

   task reset;
      begin
         $display("%0t: Assert Reset", $time);
         reseta = 1;
         resetb = 1;
         #100;
         $display("%0t: Deassert Reset", $time);
         reseta = 0;
         resetb = 0;
      end
   endtask // reset

   task write_8bit;
      input [7:0] port;
      input  [10:0] address;
      input [7:0]  data;
      begin
         if (port == "A")
           begin
              wait(clka == 1'b0);
              wrea = 1;
              dia = { 8'h0, data };
              ada = { address, 3'b000 };
              wait(clka == 1'b1);
              wait(clka == 1'b0);
              wrea = 0;
           end
         else
           begin
              wait(clkb == 1'b0);
              wreb = 1;
              dib = { 8'h0, data };
              adb = { address, 3'b000 };
              wait(clkb == 1'b1);
              wait(clkb == 1'b0);
              wreb = 0;
           end
      end
   endtask // write_8bit

   task read_8bit;
      input [7:0] port;
      input  [10:0] address;
      begin
         if (port == "A")
           begin
              wait(clka == 1'b0);
              wrea = 0;
              ada = { address, 3'b000 };
              wait(clka == 1'b1);
              wait(clka == 1'b0);
           end
         else
           begin
              wait(clkb == 1'b0);
              wreb = 0;
              adb = { address, 3'b000 };
              wait(clkb == 1'b1);
              wait(clkb == 1'b0);
           end
      end
   endtask // read_8bit

   initial
     begin
        $monitor("%0t: DOA %x DOB %x", $time, doa, dob);

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

        reset();

        read_8bit("A", 0);
        read_8bit("B", 0);

        assert (doa == 16'h0);
        assert (dob == 16'h0);

        write_8bit("A", 0, 8'hfe);
        write_8bit("B", 1, 8'hde);
        write_8bit("A", 2, 8'hbe);
        write_8bit("B", 3, 8'hda);

        read_8bit("A", 1);
        read_8bit("B", 2);

        assert (doa == 16'hde);
        assert (dob == 16'hbe);

        read_8bit("A", 3);
        read_8bit("B", 3);

        assert (doa == 16'hda);
        assert (dob == 16'hda);

        ada = 14'h0;
        adb = 14'h0;

        assert (doa == 16'hda);
        assert (dob == 16'hda);

        wait(clka == 1'b0);
        wait(clkb == 1'b0);
        wait(clka == 1'b1);
        wait(clkb == 1'b1);
        wait(clka == 1'b0);
        wait(clkb == 1'b0);

        assert (doa == 16'hfe);
        assert (dob == 16'hfe);

        reset();

        read_8bit("A", 0);
        read_8bit("B", 0);

        #1000
        $finish;
     end

endmodule // iverilog_top
