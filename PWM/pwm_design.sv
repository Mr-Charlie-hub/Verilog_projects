module pwm_design#(
    parameter duty = 4,
    parameter period = 8
)(
    input logic clk,
    input logic rst,
    output logic pwm_out
);

localparam int counter_width = $clog2(period);

logic [counter_width-1:0] counter;

always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
        counter <= 0;
        pwm_out <= 0;
    end else begin
        if (counter < duty) begin
            pwm_out <= 1;
        end else begin
            pwm_out <= 0;
        end

        if (counter == period-1) begin
            counter <= 0;
        end else begin
            counter <= counter + 1;
        end
    end
end
endmodule
