`include "interface.sv"
`include "transaction.sv"
`include "generator.sv"
`include "driver.sv"
`include "monitor.sv"
`include "scoreboard.sv"

`timescale 1ns/1ps

module fifo_testbench;

    parameter DATA_WIDTH = 8;
    parameter FIFO_DEPTH = 16;

    fifo_if #(DATA_WIDTH, FIFO_DEPTH) vif();

    fifo_design #(
        .DATA_WIDTH(DATA_WIDTH),
        .FIFO_DEPTH(FIFO_DEPTH)
    ) dut (
        .clk(vif.clk),
        .rst(vif.rst),
        .wr_en(vif.wr_en),
        .rd_en(vif.rd_en),
        .data_in(vif.data_in),
        .data_out(vif.data_out),
        .full(vif.full),
        .empty(vif.empty)
    );

    mailbox gen2drv = new();
    mailbox mon2src = new();

    generator gen;
    driver drv;
    monitor mon;
    scoreboard sb;

    initial begin
        gen2drv = new();
        mon2src = new();

        gen = new(gen2drv);
        drv = new(gen2drv, vif);
        mon = new(mon2src, vif);
        sb = new(mon2src);
    end

    initial begin
        vif.clk = 0;
        forever #5 vif.clk = ~vif.clk; // 100MHz clock
    end

    initial begin
        vif.rst = 1;
        #20;
        vif.rst = 0;

    //     $dumpfile("wave.vcd");
    //     $dumpvars(0, fifo_testbench);
    //     // $dumpvars(0, fifo_design);
    //     // $dumpvars(0, fifo_testbench.dut.mem);
    end

    initial begin
        fork
            gen.run();
            drv.run();
            mon.run();
            sb.run();
        join_none
        #200;
        $display("Testbench completed.");
        $finish;
    end
endmodule

