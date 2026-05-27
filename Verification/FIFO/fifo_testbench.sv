module fifo_test;
    parameter DEPTH = 16;
    reg clk;
    reg rst;
    reg wr_en;
    reg rd_en;
    reg [7:0] din;
    wire [7:0] dout;
    wire full;
    wire empty;

    sync_fifo #(
        .DATA_WIDTH(8),
        .DEPTH(DEPTH)
    ) fifo_inst (
        .clk(clk),
        .rst(rst),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .din(din),
        .dout(dout),
        .full(full),
        .empty(empty)
    );

    ///////////////Properties and Assertions////////////////////

    property no_write_when_full;
        @(posedge clk) 
        // full &&  wr_en |-> $stable(fifo_inst.wr_ptr);
        full &&  wr_en |=> $stable(fifo_inst.wr_ptr);
    endproperty

    assert_no_write_when_full: assert property (no_write_when_full) else $error("Write occurred when FIFO was full!");  

    property no_read_when_empty;
        @(posedge clk) 
        // empty & rd_en |-> $stable(fifo_inst.rd_ptr);
        empty & rd_en |=> $stable(fifo_inst.rd_ptr);
    endproperty

    assert_no_read_when_empty: assert property (no_read_when_empty) else $error("Read occurred when FIFO was empty!"); 


    ///////////////Coverage////////////////////
   
    cover_full:
    cover property (@(posedge clk) full)
    $display("FIFO became FULL at time=%0t", $time);

    cover_empty:
    cover property (@(posedge clk) empty)
    $display("FIFO became EMPTY at time=%0t", $time);

    // cover_simultaneous_rw:
    // cover property (@(posedge clk) wr_en && rd_en)
    // $display("Simultaneous Read and Write at time=%0t", $time);

    cover_wrap:
    cover property (@(posedge clk)(fifo_inst.wr_ptr == 0) && ($past(fifo_inst.wr_ptr) == DEPTH-1))
    $display("WRITE POINTER WRAPPED");
    

    /////////////Classes and Randomization////////////////////
    class fifo_item;
    rand bit wr_en;
    rand bit rd_en;
    rand bit [7:0] din;

    constraint c1 {
        !(wr_en && rd_en); // Avoid conflicting read and write operations
    }
endclass


    class generator;

        fifo_item item;

        task run();
            item = new();
            repeat (20) begin
                item.randomize();

                wr_en <= item.wr_en;
                #20;
                rd_en <= item.rd_en;
                din <= item.din;
                #10;
            end
        endtask
    endclass

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, fifo_test);
    end

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100MHz clock
    end

    // Test sequence
    initial begin
        // Initialize signals
        rst = 1;
        wr_en = 0;
        rd_en = 0;
        din = 0;

        // Reset the FIFO
        #10 rst = 0;
    end
    generator gen;

    initial begin
        gen = new();

        if (!gen.randomize())
            $error("randomization failed");
        gen.run();
        #50 $finish;

end

endmodule