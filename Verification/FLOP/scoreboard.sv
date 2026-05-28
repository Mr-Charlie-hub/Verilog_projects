class scoreboard;
    dff_txn txn;
    mailbox mon2srb;

    bit expected_q;

    function new(mailbox mb);
        mon2srb = mb;
    endfunction

    task run();
        forever begin
            mon2srb.get(txn);
          
                      
            if (txn.q !== expected_q) begin
                $display("ERROR: Expected q = %b, but got q = %b", expected_q, txn.q);
            end else begin
                $display("PASS: Expected q = %b, got q = %b", expected_q, txn.q);
                  expected_q = txn.d; // For a D flip-flop, q should follow d on the next clock cycle
            end
            // #10; // Wait for some time before checking the next transaction
        end
    endtask
endclass