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

    initial begin
        gen2drv = new();
        mon2srb = new(); 

        gen = new(gen2drv);
        drv = new(gen2drv, vif);
        mon = new(mon2srb, vif);
        scb = new(mon2srb);       
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

    initial begin

        fork
            gen.run();
            drv.run();
            mon.run();
            scb.run();
        join_none

        #200 $finish;
    end

endmodule