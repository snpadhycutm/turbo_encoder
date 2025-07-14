<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

This project is an 8-bit Turbo-like encoder designed for Tiny Tapeout. It takes an 8-bit input (ui_in[7:0]) and, upon receiving a one-cycle pulse on the start signal (uio_in[0]), processes the input through two convolutional encoders. The first encoder operates directly on the input, while the second can optionally use an interleaved version (such as a bit-reversed form). Each encoder generates 4 parity bits using the generator polynomial G(D) = 1 + D + D², and the final 8-bit output (uo_out[7:0]) is formed by concatenating these two 4-bit parity values. This structure offers a compact and hardware-efficient method for basic forward error correction.

## How to test

The design can be tested using either a Verilog testbench (tb.v) or a Cocotb testbench (test.py). For Verilog simulation, compile and run using a simulator like Icarus Verilog. The Cocotb test is recommended for functional testing, where a clock is started, reset is applied, and an 8-bit input value (e.g., 0b10101010) is loaded along with a one-cycle start pulse. The output (uo_out) is then verified against the expected encoded result (e.g., 0x99). You can run the Cocotb test using make -C test, and waveform analysis can be done by adding $dumpfile and viewing with GTKWave.

## External hardware

NA
