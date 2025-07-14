`default_nettype none
`timescale 1ns / 1ps

module tb ();

  reg clk;
  reg rst_n;
  reg ena;
  reg [7:0] ui_in;
  reg [7:0] uio_in;
  wire [7:0] uo_out;
  wire [7:0] uio_out;
  wire [7:0] uio_oe;


  // DUT instantiation
  tt_um_turbo_enc_8bit dut (
      .clk(clk),
      .rst(~rst_n),          // Your module uses active-high reset
      .ui_in(ui_in),
      .uio_in(uio_in),
      .uo_out(uo_out)
      // No uio_out/uio_oe in your design, so not connected
  );

 

endmodule

