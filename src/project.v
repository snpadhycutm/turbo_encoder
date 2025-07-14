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
module conv4 (
    input clk,
    input rst,
    input [7:0] data_in,
    output reg [3:0] parity
);

    integer i;
    reg [2:0] shift;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            shift <= 3'd0;
            parity <= 4'd0;
        end else begin
            for (i = 0; i < 4; i = i + 1) begin
                shift <= {data_in[i*2], shift[2:1]};
                parity[i] <= data_in[i*2] ^ shift[0] ^ shift[2]; // G = 1 + D + D^2
            end
        end
    end

endmodule

