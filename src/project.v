/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

module tt_um_turbo_enc_8bit (
    input  wire [7:0] ui_in,     // 8-bit input
    input  wire [7:0] uio_in,    // uio_in[0] = start
    output wire [7:0] uo_out,    // 8-bit encoded output
    input  wire clk,
    input  wire rst
);

    wire start = uio_in[0];
    wire [7:0] interleaved_data;
    wire [3:0] parity1, parity2;
    reg  [7:0] encoded_out;

    // Interleaver — pass-through (can be reversed or shuffled)
    assign interleaved_data = ui_in;

    // Updated combinational convolutional encoders
    conv4 enc1 (.data_in(ui_in), .parity(parity1));
    conv4 enc2 (.data_in(interleaved_data), .parity(parity2));

    always @(posedge clk or posedge rst) begin
        if (rst)
            encoded_out <= 8'd0;
        else if (start)
            encoded_out <= {parity1, parity2};  // Concatenate
    end

    assign uo_out = encoded_out;

endmodule
module conv4 (
    input  [7:0] data_in,
    output [3:0] parity
);
    // Simple overlapping 3-bit XOR segments as example
    assign parity[0] = data_in[0] ^ data_in[1] ^ data_in[2];
    assign parity[1] = data_in[2] ^ data_in[3] ^ data_in[4];
    assign parity[2] = data_in[4] ^ data_in[5] ^ data_in[6];
    assign parity[3] = data_in[6] ^ data_in[7] ^ data_in[0]; // wrap around

endmodule


