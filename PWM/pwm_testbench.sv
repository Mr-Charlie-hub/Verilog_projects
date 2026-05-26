module test;
    logic clk;
    logic rst;
    logic pwm_out;

    pwm_design #(
        .duty(4),
        .period(8)
    ) dut (
        .clk(clk),
        .rst(rst),
        .pwm_out(pwm_out)
    );

    initial begin
        clk = 0;
        rst = 1;
        #10 rst = 0; // Release reset after 10 time units
    end

    always #5 clk = ~clk; // Generate a clock with a period of 10 time units

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, test);
    end

    initial begin
        $monitor("Time: %0t | PWM Output: %b", $time, pwm_out);
        #100 $finish; // Run the simulation for 100 time units
    end

endmodule