module tb_top;

    logic clk;
    logic rst;

    logic coke;
    logic pepsi;

    logic Cancel;
    logic load;

    logic [3:0] amount;

    logic dispence;

    //////////////////////////////////////////////////////////
    // DUT
    //////////////////////////////////////////////////////////

    top dut(
        .clk(clk),
        .rst(rst),
        .coke(coke),
        .pepsi(pepsi),
        .Cancel(Cancel),
        .load(load),
        .amount(amount),
        .dispence(dispence)
    );

    //////////////////////////////////////////////////////////
    // CLOCK
    //////////////////////////////////////////////////////////

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    //////////////////////////////////////////////////////////
    // STIMULUS
    //////////////////////////////////////////////////////////

    initial begin

        //////////////////////////////////////////////////////
        // INITIAL VALUES
        //////////////////////////////////////////////////////

        rst      = 1;
        coke     = 0;
        pepsi    = 0;
        Cancel   = 0;
        load     = 0;
        amount   = 0;
        dispence = 0;

        //////////////////////////////////////////////////////
        // RESET
        //////////////////////////////////////////////////////

        #20;
        rst = 0;

        //////////////////////////////////////////////////////
        // LOAD COKE INTO FIFO
        //////////////////////////////////////////////////////

        @(posedge clk);
        coke = 1;

        @(posedge clk);
        load = 1;

        @(posedge clk);
        coke = 0;
        load = 0;

        //////////////////////////////////////////////////////
        // LOAD PEPSI INTO FIFO
        //////////////////////////////////////////////////////

        @(posedge clk);
        pepsi = 1;

        @(posedge clk);
        load = 1;

        @(posedge clk);
        pepsi = 0;
        load = 0;

        //////////////////////////////////////////////////////
        // BUY COKE
        //////////////////////////////////////////////////////

        @(posedge clk);
        coke = 1;

        @(posedge clk);
        dispence = 1;

        @(posedge clk);
        amount = 12;

        @(posedge clk);
        coke = 0;
        dispence = 0;
        amount = 0;

        //////////////////////////////////////////////////////
        // BUY PEPSI
        //////////////////////////////////////////////////////

        @(posedge clk);
        pepsi = 1;

        @(posedge clk);
        dispence = 1;

        @(posedge clk);
        amount = 13;

        @(posedge clk);
        pepsi = 0;
        dispence = 0;
        amount = 0;

        //////////////////////////////////////////////////////
        // CANCEL TEST
        //////////////////////////////////////////////////////

        @(posedge clk);
        coke = 1;

        @(posedge clk);
        Cancel = 1;

        @(posedge clk);
        Cancel = 0;
        coke = 0;

        //////////////////////////////////////////////////////
        // END SIMULATION
        //////////////////////////////////////////////////////

        #50;
        $finish;

    end

    //////////////////////////////////////////////////////////
    // DUMP WAVES
    //////////////////////////////////////////////////////////

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, tb_top);
    end

endmodule