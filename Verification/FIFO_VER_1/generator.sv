class generator#(
    parameter DATA_WIDTH = 8,
    parameter FIFO_DEPTH = 16
);

    fifo_txn #(.DATA_WIDTH(DATA_WIDTH), .FIFO_DEPTH(FIFO_DEPTH)) txn;

    mailbox gen2drv;

    function new(mailbox mb);
        gen2drv = mb;
    endfunction

    task run();
        repeat(10) begin
            txn = new();
            
            txn.randomize();
            gen2drv.put(txn);
            $display("Generated transaction: data = %b, wr_en = %b, rd_en = %b", txn.data, txn.wr_en, txn.rd_en);
            // #10; // Wait for some time before generating the next transaction
        end
    endtask
endclass     
