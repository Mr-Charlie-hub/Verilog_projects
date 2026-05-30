class driver #(
    parameter DATA_WIDTH = 8,
    parameter FIFO_DEPTH = 16
);

    fifo_txn #(.DATA_WIDTH(DATA_WIDTH), .FIFO_DEPTH(FIFO_DEPTH)) txn;

     virtual fifo_if #(DATA_WIDTH, FIFO_DEPTH) vif;

    mailbox gen2drv;

    function new(mailbox mb, virtual fifo_if#(DATA_WIDTH, FIFO_DEPTH) vif);
        gen2drv = mb;
        this.vif = vif;
    endfunction

    task run();
        forever begin
            @(posedge vif.clk);

            gen2drv.get(txn);
            vif.wr_en = txn.wr_en;
            vif.rd_en = txn.rd_en;
            vif.data_in = txn.data;
            $display("Received transaction: data = %b, wr_en = %b, rd_en = %b", txn.data, txn.wr_en, txn.rd_en);
            // #10; // Wait for some time before processing the next transaction
            @(posedge vif.clk); // Wait for the next clock cycle to apply the next transaction
            vif.wr_en = 0; // De-assert write enable after one cycle
            vif.rd_en = 0; // De-assert read enable after one cycle
            
        end
    endtask
endclass