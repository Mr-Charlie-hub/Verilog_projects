class generator;
    dff_txn txn;

    mailbox gen2drv;

    function new(mailbox mb);
        gen2drv = mb;
    endfunction 

    task run();
        repeat(10) begin
            txn = new();
            assert(txn.randomize());
            gen2drv.put(txn);
            $display("Generated transaction: d = %b", txn.d);
            // #10; // Wait for some time before generating the next transaction
        end
    endtask
endclass
