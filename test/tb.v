`default_nettype none
module tb;
    reg clk = 0;
    reg rst = 1;
    reg  [7:0] ui_in;
    reg  [7:0] uio_in;
    wire [7:0] uo_out;

    always #5 clk = ~clk;  // 100 MHz
    tt_um_turbo_enc_8bit dut (.clk(clk), .rst(rst), .ui_in(ui_in), .uio_in(uio_in), .uo_out(uo_out));

    initial begin
        ui_in = 0;
        uio_in = 0;
        #20 rst = 0;
        #200;
        $finish;
    end
endmodule

