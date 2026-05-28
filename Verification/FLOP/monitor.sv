class monitor;
    dff_txn txn;
    mailbox mon2srb;

    virtual dff_if vif;

    function new(mailbox mb, virtual dff_if intf);
        mon2srb = mb;
        vif = intf;
    endfunction

    task run();
        forever begin
            txn = new();
            @(posedge vif.clk);
            #1;
            txn.d = vif.d;
            txn.q = vif.q;
            mon2srb.put(txn);
            $display("Monitored transaction: d = %b, q = %b", txn.d, txn.q);
            // #10; // Wait for some time before monitoring the next transaction
        end
    endtask         
endclass