module test_bench_encoder;

reg rst;
reg clk_encoder;
reg clk_decoder;



top uut(
    
    .rst(rst),
    .clk_encoder(clk_encoder),
    .clk_decoder(clk_decoder)
);

// initial begin
//     clk = 0;
//     forever #5 clk = ~clk;
// end

initial begin
    clk_encoder = 0;
    forever #6.25 clk_encoder = ~clk_encoder;
end

initial begin
    clk_decoder = 0;
    forever #10 clk_decoder = ~clk_decoder;
end

initial begin
    rst = 1;
    #20;
    rst = 0;

    #200;   // let system run

    $finish;
end

initial begin
    $dumpfile("wave.vcd");
    $dumpvars(0, test_bench_encoder);
end

endmodule