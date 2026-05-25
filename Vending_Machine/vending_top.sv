module top(
    input logic clk,
    input logic rst,
    input logic coke,
    input logic pepsi,
    input logic Cancel,
    input logic load,
    input logic [3:0] amount,
    input logic dispence
);

logic dispence_coke, dispence_pepsi;
logic load_en, coke_in, pepsi_in;

logic out;

logic full_coke, full_pepsi;
logic empty_coke, empty_pepsi;

logic in_data;

assign in_data = coke_in ? 1'b1 : pepsi_in ? 1'b0 : 1'b0;

//////////////////////////////////////////////////////////
// VENDING MACHINE
//////////////////////////////////////////////////////////

vending_machine vm (
    .clk(clk),
    .rst(rst),
    .coke(coke),
    .pepsi(pepsi),
    .Cancel(Cancel),
    .load(load),
    .amount(amount),
    .dispence(dispence),
    .dispence_coke(dispence_coke),
    .dispence_pepsi(dispence_pepsi),
    .load_en(load_en),
    .coke_in(coke_in),
    .pepsi_in(pepsi_in)
);

//////////////////////////////////////////////////////////
// FIFO
//////////////////////////////////////////////////////////

fifo_vending fifo (
    .clk(clk),
    .rst(rst),
    .load_en(load_en),
    .in(in_data),
    .coke_in(coke_in),
    .pepsi_in(pepsi_in),
    .dispence_coke(dispence_coke),
    .dispence_pepsi(dispence_pepsi),
    .out(out),
    .full_coke(full_coke),
    .full_pepsi(full_pepsi),
    .empty_coke(empty_coke),
    .empty_pepsi(empty_pepsi)
);

endmodule