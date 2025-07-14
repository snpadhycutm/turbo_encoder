`default_nettype none
`timescale 1ns / 1ps

module tb ();

  reg clk;
  reg rst;
  reg [7:0] ui_in;
  reg [7:0] uio_in;
  wire [7:0] uo_out;

  // Instantiate the DUT
  tt_um_turbo_enc_8bit dut (
      .clk(clk),
      .rst(rst),
      .ui_in(ui_in),
      .uio_in(uio_in),
      .uo_out(uo_out)
  );

endmodule


