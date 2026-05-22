
module tb;

reg clk = 0;
always #10 clk = ~clk;

reg [3:0] key;

wire outL, outR;

top_audio_pwm uut (
    .clk50(clk),
    .key(key),
    .AUDIO_OUT_L(outL),
    .AUDIO_OUT_R(outR)
);

initial begin
    key = 4'b0000;   // wrong key → tune
    #100000;

    key = 4'b1010;   // correct key → secret
    #100000;

    $stop;
end

endmodule
