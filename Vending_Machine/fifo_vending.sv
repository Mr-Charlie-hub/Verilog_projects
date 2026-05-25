module fifo_vending #(
    parameter WIDTH = 1,
    parameter DEPTH = 8,
    parameter ADDR_WIDTH = 3
)(
    input  logic clk,
    input  logic rst,

    input  logic load_en,
    input  logic in,

    input  logic coke_in,
    input  logic pepsi_in,

    input  logic dispence_coke,
    input  logic dispence_pepsi,

    output logic out,

    output logic full_coke,
    output logic full_pepsi,

    output logic empty_coke,
    output logic empty_pepsi
);

////////////////////////////////////////////////////////////
// SHARED MEMORY
////////////////////////////////////////////////////////////

logic mem [0:DEPTH-1];

////////////////////////////////////////////////////////////
// POINTERS
////////////////////////////////////////////////////////////

// Coke uses addresses 0-3
logic [ADDR_WIDTH-1:0] coke_wr_ptr;
logic [ADDR_WIDTH-1:0] coke_rd_ptr;

// Pepsi uses addresses 4-7
logic [ADDR_WIDTH-1:0] pepsi_wr_ptr;
logic [ADDR_WIDTH-1:0] pepsi_rd_ptr;

////////////////////////////////////////////////////////////
// COUNTS
////////////////////////////////////////////////////////////

logic [2:0] coke_count;
logic [2:0] pepsi_count;

////////////////////////////////////////////////////////////
// STATUS FLAGS
////////////////////////////////////////////////////////////

assign full_coke   = (coke_count  == 4);
assign empty_coke  = (coke_count  == 0);

assign full_pepsi  = (pepsi_count == 4);
assign empty_pepsi = (pepsi_count == 0);

////////////////////////////////////////////////////////////
// MAIN LOGIC
////////////////////////////////////////////////////////////

always_ff @(posedge clk) begin

    ////////////////////////////////////////////////////////
    // RESET
    ////////////////////////////////////////////////////////

    if(rst) begin

        out <= 0;

        // Coke region -> 0 to 3
        coke_wr_ptr <= 0;
        coke_rd_ptr <= 0;

        // Pepsi region -> 4 to 7
        pepsi_wr_ptr <= 4;
        pepsi_rd_ptr <= 4;

        coke_count <= 0;
        pepsi_count <= 0;

    end

    ////////////////////////////////////////////////////////
    // NORMAL OPERATION
    ////////////////////////////////////////////////////////

    else begin

        ////////////////////////////////////////////////////
        // COKE WRITE
        ////////////////////////////////////////////////////

        if(coke_in && !full_coke) begin

            mem[coke_wr_ptr] <= in;

            coke_count <= coke_count + 1;

            // wrap inside 0-3
            if(coke_wr_ptr == 3)
                coke_wr_ptr <= 0;
            else
                coke_wr_ptr <= coke_wr_ptr + 1;

        end

        ////////////////////////////////////////////////////
        // PEPSI WRITE
        ////////////////////////////////////////////////////

        else if(pepsi_in && !full_pepsi) begin

            mem[pepsi_wr_ptr] <= in;

            pepsi_count <= pepsi_count + 1;

            // wrap inside 4-7
            if(pepsi_wr_ptr == 7)
                pepsi_wr_ptr <= 4;
            else
                pepsi_wr_ptr <= pepsi_wr_ptr + 1;

        end

        ////////////////////////////////////////////////////
        // COKE DISPENSE
        ////////////////////////////////////////////////////

        if(dispence_coke && !empty_coke) begin

            out <= mem[coke_rd_ptr];

            coke_count <= coke_count - 1;

            // wrap inside 0-3
            if(coke_rd_ptr == 3)
                coke_rd_ptr <= 0;
            else
                coke_rd_ptr <= coke_rd_ptr + 1;

        end

        ////////////////////////////////////////////////////
        // PEPSI DISPENSE
        ////////////////////////////////////////////////////

        else if(dispence_pepsi && !empty_pepsi) begin

            out <= mem[pepsi_rd_ptr];

            pepsi_count <= pepsi_count - 1;

            // wrap inside 4-7
            if(pepsi_rd_ptr == 7)
                pepsi_rd_ptr <= 4;
            else
                pepsi_rd_ptr <= pepsi_rd_ptr + 1;

        end

    end

end

endmodule