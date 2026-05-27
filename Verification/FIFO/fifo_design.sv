// Synchronous FIFO
// Operations-> Write, Read, Full_flag, Empty_flag, Count
// Parameterized depth and widths


module sync_fifo #(
    parameter DATA_WIDTH = 8, 
    parameter DEPTH = 16)
    (
        input wire       clk,
        input wire       rst,

        input wire       wr_en,
        input wire       rd_en,

        input wire [DATA_WIDTH-1:0] din,
        output reg [DATA_WIDTH-1:0] dout,

        output wire       full,
        output wire       empty
    );

    localparam ADDR_WIDTH = $clog2(DEPTH);

    // Memory array
    reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];

    // pointers
    reg [ADDR_WIDTH-1:0] wr_ptr;
    reg [ADDR_WIDTH-1:0] rd_ptr;

    // counter to count the number of writes 
    reg [ADDR_WIDTH:0] count;



    // write logic
    always @(posedge clk) begin
        if(rst) begin
            wr_ptr <= 0;
        end
        else if (wr_en && !full) begin     // First error - 1 (Error File)
            mem[wr_ptr] <= din;
            wr_ptr <= wr_ptr + 1;
        end
    end



    // Read logic
    always @(posedge clk) begin
        if(rst) begin
            rd_ptr  <= 0;
            dout    <= 0;
        end
        else if(rd_en && !empty) begin  // First error - 1 (Error File)
            dout <= mem[rd_ptr];
            rd_ptr <= rd_ptr + 1;
        end
    end


    // counter logic
    always @(posedge clk) begin
        if(rst) begin
            count <= 0;
        end
        else begin
            case ({wr_en && !full, rd_en && !empty})
                2'b10: count <= count + 1; // write only
                2'b01: count <= count - 1; // read only
                2'b11: count <= count ; // simultaneous read/write
                default: count <= count;
            endcase
        end
    end

    // status flags
    assign full = (count == DEPTH);

    assign empty = (count == 0);

endmodule