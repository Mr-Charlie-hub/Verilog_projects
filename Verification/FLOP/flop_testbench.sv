    `include "interface.sv"
    `include "transaction.sv"
    `include "generator.sv"
    `include "driver.sv"
    `include "monitor.sv"
    `include "scoreboard.sv"

module tb;

    dff_if vif();

    // Instantiate the design under test (DUT)
    flop dut (
        .clk(vif.clk),
        .rst(vif.rst),
        .d(vif.d),
        .q(vif.q)
    );

    mailbox gen2drv;
    mailbox mon2srb;

    generator gen;
    driver drv;
    monitor mon;
    scoreboard scb;

    ////////////// Property //////////////
    property dff_check;
        @(posedge vif.clk)
        disable iff (vif.rst)
        vif.q == $past(vif.d);
    endproperty

    /////////// Assertion //////////

    assert_dff_check:  
    assert property (dff_check) 
    $display("DFF property passed: q follows d on the rising edge of clk");
    else
     $error("DFF property failed: q should follow d on the rising edge of clk");

     ////////// Coverage //////////

     covergroup dff_cov @(posedge vif.clk);
        coverpoint vif.d;
        coverpoint vif.q;
    endgroup

     dff_cov cov;

    initial begin
        gen2drv = new();
        mon2srb = new(); 

        gen = new(gen2drv);
        drv = new(gen2drv, vif);
        mon = new(mon2srb, vif);
        scb = new(mon2srb);

       cov = new();
    end

    initial begin
        vif.clk = 0;
        forever #5 vif.clk = ~vif.clk; // Generate a clock with a period of 10 time units
    end

    initial begin
        vif.rst = 1; // Assert reset
        #20; // Hold reset for some time
        vif.rst = 0; // Deassert reset
    end
  

     ////////// Run the testbench //////////
    initial begin

        fork
            gen.run();
            drv.run();
            mon.run();
            scb.run();
           
        join_none
        #200;

         $display("Coverage = %0.2f %%", cov.get_coverage());
         $finish;
    end

endmodule