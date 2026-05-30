class fifo_txn #(
    parameter int DATA_WIDTH = 8,
    parameter int FIFO_DEPTH = 16
);
    rand bit [DATA_WIDTH-1:0] data;
    rand bit wr_en;
    rand bit rd_en;

    bit [DATA_WIDTH-1:0] data_out;
    bit full;
    bit empty;
endclass
