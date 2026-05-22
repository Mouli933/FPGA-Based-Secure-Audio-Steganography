`timescale 1ns / 1ps
`default_nettype none

module top_audio_pwm
(
    input  wire clk50,         // 50 MHz input
    //input  wire reset,         
    output wire AUDIO_OUT_L,
    output wire AUDIO_OUT_R
);

/* ================= CLOCK WIZARD ================= */

wire sys_clk;

clk_wiz_0 clk_inst (
    .clk_in1(clk50),
    .clk_out1(sys_clk)
);

/* ================= BRAM ================= */

reg [16:0] addr = 0;   // enough for your MAX_ADDR
wire [7:0] sample;

blk_mem_gen_0 bram (
    .clka(sys_clk),
    .addra(addr),
    .ena(1'b1),
    .douta(sample)
);

/* ====== Convert 8-bit ? 12-bit ====== */

wire [11:0] sample_12;
assign sample_12 = {sample, 4'b0000};

/* ================= PWM ================= */

wire next_sample;
wire pwm_audio_L;
wire pwm_audio_R;


pwm_out_ddr pwm_audio_L_inst (
    .data_in(sample_12),
    .sys_clk(sys_clk),
    .sys_rst(1'b0),
    .pwm_out_p( AUDIO_OUT_L),
    .next_val(next_sample)
);
pwm_out_ddr pwm_audio_R_inst (
    .data_in(sample_12),
    .sys_clk(sys_clk),
    .sys_rst(1'b0),
    .pwm_out_p( AUDIO_OUT_R),
    .next_val()
);

/* ============ ADDRESS CONTROL ============ */

parameter MAX_ADDR = 109797;

always @(posedge sys_clk) begin
    if (1'b0)
        addr <= 0;
    else if (next_sample) begin
        if (addr == MAX_ADDR-1)
            addr <= 0;
        else
            addr <= addr + 1;
    end
end

/* ============ OUTPUT ============ */



endmodule

`default_nettype wire