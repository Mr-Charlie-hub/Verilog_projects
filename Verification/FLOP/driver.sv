class driver;
    dff_txn txn;
    mailbox gen2drv;

    virtual dff_if vif;

    function new(mailbox mb, virtual dff_if intf);
        gen2drv = mb;
        this.vif = intf;
    endfunction

    task run();
        forever begin
            gen2drv.get(txn);
            @(posedge vif.clk);
           
            vif.d = txn.d;
            $display("Applied transaction: d = %b", txn.d);
            // #10; // Wait for some time before applying the next transaction
        end
    endtask
endclass