`timescale 1ns / 1ps
`default_nettype none

module top_audio_pwm
(
    input  wire clk50,         // 50 MHz clock
    input  wire [3:0] key,     // switches as key
    output wire AUDIO_OUT_L,
    output wire AUDIO_OUT_R
);

/* ================= CLOCK ================= */

wire sys_clk;

clk_wiz_0 clk_inst (
    .clk_in1(clk50),
    .clk_out1(sys_clk),
    .clk_out2(),
    .reset(1'b0)
);

/* ================= BRAM ================= */

reg [16:0] addr = 0;
wire [7:0] sample;

blk_mem_gen_0 bram (
    .clka(sys_clk),
    .addra(addr),
    .ena(1'b1),
    .wea(1'b0),
    .dina(8'd0),
    .douta(sample)
);

/* ================= SAFE RESET (IMPORTANT FIX) ================= */

reg [15:0] rst_cnt = 0;
reg reset = 1;

always @(posedge sys_clk) begin
    if (rst_cnt < 50000) begin
        rst_cnt <= rst_cnt + 1;
        reset <= 1;
    end else begin
        reset <= 0;
    end
end

/* ================= KEY ================= */

wire correct_key;
assign correct_key = (key == 4'b1010);

/* ================= DECODER ================= */

reg [7:0] selected_sample = 8'd128;

/*
MATLAB:
ODD  → tune
EVEN → secret

addr[0] = 0 → EVEN
addr[0] = 1 → ODD
*/

always @(posedge sys_clk) begin
    if (next_sample) begin
        if (correct_key) begin
            // SECRET (even index)
            if (addr[0] == 1'b0)
                selected_sample <= sample;
        end else begin
            // TUNE (odd index)
            if (addr[0] == 1'b1)
                selected_sample <= sample;
        end
    end
end

/* ================= 8 → 12 bit ================= */

wire [11:0] sample_12;
assign sample_12 = {selected_sample, 4'b0000};

/* ================= PWM ================= */

wire next_sample;

pwm_out_ddr pwm_audio_L_inst (
    .data_in(sample_12),
    .sys_clk(sys_clk),
    .sys_rst(1'b0),
    .pwm_out_p(AUDIO_OUT_L),
    .next_val(next_sample)
);

pwm_out_ddr pwm_audio_R_inst (
    .data_in(sample_12),
    .sys_clk(sys_clk),
    .sys_rst(1'b0),
    .pwm_out_p(AUDIO_OUT_R),
    .next_val()
);

/* ================= ADDRESS CONTROL (FINAL FIX) ================= */

parameter MAX_ADDR = 109797;

always @(posedge sys_clk) begin
    if (reset) begin
        // choose starting stream
        if (correct_key)
            addr <= 0;   // EVEN → secret
        else
            addr <= 1;   // ODD → tune
    end
    else if (next_sample) begin
        if (addr >= MAX_ADDR-2)
            addr <= (correct_key) ? 0 : 1;
        else
            addr <= addr + 2;   // 🔥 FIX: full speed playback
    end
end

endmodule

`default_nettype wire
