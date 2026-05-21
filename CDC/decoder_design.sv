module decoder_parameter#(
    parameter Width = 8
    )(
        input logic clk,
        input logic rst,
        input logic empty,
        input logic [Width-1:0] din,
        input logic full,
        output logic rd_en,
        output logic [Width-1:0]dout
);
// logic [3:0] counter;
logic [Width-1:0] pattern = 8'hA5; // Example pattern to decode
logic start_read, rd_valid;

always_ff@(posedge clk)  begin
    if (rst) begin
        start_read <= 0;
        dout <= 0;
        rd_en <= 0;
    end 

    else begin
        if (full)
        start_read <= 1;
        
        if (start_read && !empty ) begin
    
        rd_en <= 1; // Enable read when not empty
        // dout <= din ^ pattern; // Output the pattern
        // rd_valid <= 1; // Indicate that read data is valid

        // if(rd_valid) begin
            dout <= din ^ pattern; // Output the pattern
            // $display("[%0t] Decoded data = %0d", $time, dout);
        // end
        

    end 
     else begin
        rd_en <= 0; // Disable read when empty
    end
    end
end

endmodule