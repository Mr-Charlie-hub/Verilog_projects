class scoreboard #(
    parameter DATA_WIDTH = 8,
    parameter FIFO_DEPTH = 16
);

    fifo_txn #(.DATA_WIDTH(DATA_WIDTH), .FIFO_DEPTH(FIFO_DEPTH)) txn;
    mailbox mon2src;

    bit [DATA_WIDTH-1:0] model_q[$];
    bit [DATA_WIDTH-1:0] expected_data;

    // virtual fifo_if #(DATA_WIDTH, FIFO_DEPTH) vif;

    function new(mailbox mb);
        mon2src = mb;
        // this.vif = vif;
    endfunction

    task run();
        forever begin
            mon2src.get(txn);
            // @(posedge vif.clk);


            if(txn.wr_en && !txn.full) begin
            model_q.push_back(txn.data);
            $display("Stored");
        end

        if(txn.rd_en && !txn.empty) begin
            if(model_q.size() > 0) begin
                expected_data = model_q.pop_front();
                $display("Popped");
            end else begin
                $error("Scoreboard error: Attempting to read from an empty model queue!");
            end

            $display("Scoreboard: Received transaction - Data: %0h",txn.data);
            // Compare expected transaction with actual signals from the DUT
            if (expected_data !== txn.data_out) begin
                $error("Scoreboard mismatch! Expected: Data=%0h | Actual: Data=%0h",expected_data, txn.data_out);
            end else begin
                $display("Scoreboard match! Transaction is correct.");
            end
            end
        end
    endtask
endclass