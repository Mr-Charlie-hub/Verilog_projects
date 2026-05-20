module test();
parameter Width =8;
 logic clk;
 logic rst;
 logic wr_en;
 logic rd_en;
 logic [Width-1:0]din;
 logic [Width-1:0]dout;
 logic full,empty;

 `include"functions.sv"

 fifo_parameter #(Width,8) uut(
    .clk(clk),
    .rst(rst),
    .wr_en(wr_en),
    .rd_en(rd_en),
    .din(din),
    .dout(dout),
    .full(full),
    .empty(empty)
);


 initial begin
    clk=0;
    rst=0;
    wr_en=0;
    rd_en=0;
    din=0;
    forever #5 clk = ~clk;
 end

 initial begin
    reset_fifo();

    write_fifo(8'h45);
    write_fifo(8'hAA);
    write_fifo(8'hFF);

    read_fifo();
    read_fifo();
    read_fifo();
    #100;
    $finish;

 end

 initial begin
    $dumpfile("wave.vcd");
    $dumpvars(0,test);
 end

endmodule