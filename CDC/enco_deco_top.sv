module top(

input logic clk_encoder,clk_decoder,
input logic rst
);
parameter Width = 8;
wire wr_en_top;
wire rd_en_top;
wire [Width-1:0]din_top;
wire [Width-1:0]dout_top;
wire full_top,empty_top;
wire [Width-1:0]dout;

//`include"functions.sv"

encoder_parameter #(Width) encoder(
    .clk(clk_encoder),
    .rst(rst),
    .full(full_top),
    .wr_en(wr_en_top),
    .din(din_top)
);
fifo_parameter #(Width,8) fifo(    // Depth instanciated 45 for CDC handling
    .clk(clk_encoder),
    .rst(rst),
    .wr_en(wr_en_top),
    .rd_en(rd_en_top),
    .din(din_top),
    .dout(dout_top),
    .full(full_top),
    .empty(empty_top)
);
decoder_parameter #(Width) decoder(
    .clk(clk_decoder),
    .rst(rst),
    .empty(empty_top),
    .rd_en(rd_en_top),
    .full(full_top),
    .din(dout_top),
    .dout(dout)
);

endmodule