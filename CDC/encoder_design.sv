module encoder_parameter#(
    parameter Width = 8
    )(
        input logic clk,
        input logic rst,
        input logic full,
        output logic wr_en,
        output logic [Width-1:0]din
);
logic [Width-1:0] counter; 
logic [Width-1:0] pattern = 8'hA5; // Example pattern to encode

always_ff @(posedge clk) begin
    if (rst) begin
        counter <= 0;
        din <= 0;
        wr_en <= 0;
    end else if (!full) begin
        din <= pattern ^ counter; // Output the pattern
        wr_en <= 1; // Enable write when not full
        counter <= counter + 1; // Increment counter for next pattern (if needed)
    end else begin
        wr_en <= 0; // Disable write when full
    end
end
endmodule

