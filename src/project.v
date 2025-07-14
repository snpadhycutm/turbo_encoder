/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_turbo_enc_8bit (
    input  wire [7:0] ui_in,     // 8-bit input data
    input  wire [7:0] uio_in,    // use uio_in[0] as start
    output wire [7:0] uo_out,    // 8-bit encoded output
    input  wire clk,
    input  wire rst
);

    wire start = uio_in[0];
    reg [7:0] data_reg;
    reg [7:0] encoded_out;
    wire [7:0] interleaved_data;
    wire [3:0] parity1, parity2;

    // Interleaver: bit reversal (can be customized)
    assign interleaved_data = {ui_in[0], ui_in[1], ui_in[2], ui_in[3],
                               ui_in[4], ui_in[5], ui_in[6], ui_in[7]};

    // Instantiate convolutional encoders
    conv4 enc1 (.clk(clk), .rst(rst), .data_in(ui_in),           .parity(parity1));
    conv4 enc2 (.clk(clk), .rst(rst), .data_in(interleaved_data), .parity(parity2));

    // Register output on start pulse
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            encoded_out <= 8'd0;
        end else if (start) begin
            encoded_out <= {parity1, parity2};  // output 8-bit encoded data
        end
    end

    assign uo_out = encoded_out;

endmodule
