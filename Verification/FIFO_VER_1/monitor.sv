class monitor #(
    parameter DATA_WIDTH = 8,
    parameter FIFO_DEPTH = 16
);
    fifo_txn #(.DATA_WIDTH(DATA_WIDTH), .FIFO_DEPTH(FIFO_DEPTH)) txn;

    //////// CoverGrroup /////////

    covergroup fifo_cg;
        coverpoint txn.wr_en;
        coverpoint txn.rd_en;
        coverpoint txn.full;
        coverpoint txn.empty;
    endgroup


    mailbox mon2src;

    // fifo_cg cov;

    virtual fifo_if #(DATA_WIDTH, FIFO_DEPTH) vif;

    function new(mailbox mb, virtual fifo_if vif);
        mon2src = mb;
        this.vif = vif;

        fifo_cg = new();
    endfunction

    task run();
        forever begin
            
            @(posedge vif.clk);
            #2; // Small delay to ensure signals are stable
            txn = new();

            txn.data = vif.data_in;
            txn.data_out = vif.data_out;
            txn.wr_en = vif.wr_en;
            txn.rd_en = vif.rd_en;
            txn.full = vif.full;
            txn.empty = vif.empty;
            mon2src.put(txn);
            $display("Monitor: Captured transaction - Data: %0h, Data_Out: %0h, WR_EN: %b, RD_EN: %b, FULL: %b, EMPTY: %b",
            txn.data, txn.data_out, txn.wr_en, txn.rd_en, txn.full, txn.empty);

            fifo_cg.sample();
            $display("Coverage: %0.2f %%",fifo_cg.get_coverage());
        end
    endtask
endclass
            