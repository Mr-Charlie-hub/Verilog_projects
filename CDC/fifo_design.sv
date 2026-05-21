module fifo_parameter#(
    parameter Width = 8,
    parameter Depth = 8
    )(
        input logic clk,
        input logic rst,
        input logic wr_en,
        input logic rd_en,
        input logic [Width-1:0]din,
        output logic [Width-1:0]dout,
        output logic full,empty
    );

    localparam Addr_Width =$clog2(Depth);

    reg [Width-1:0]mem[0:Depth-1];

    reg [Addr_Width:0]wr_ptr, rd_ptr;
    integer i;

    always_ff @(posedge clk)begin
        if(rst)begin
            wr_ptr <= 0;
            // mem <= '{default:0}; // not req
            for(i=0; i<Depth; i=i+1)begin
                mem[i] <= 0;
            end

        end

        else if(wr_en && !full)begin
            mem[wr_ptr[Addr_Width-1:0]] <= din;
            if(wr_ptr[Addr_Width-1:0] == Depth-1)begin
                wr_ptr <= {~wr_ptr[3], 3'b000}; // toggle MSB and reset LSBs
            end else begin
                wr_ptr <= wr_ptr + 1;
            end
        end
    end

    always_ff @(posedge clk)begin
        if(rst)begin
            rd_ptr <= 0;
            dout <= 0;
        end
        else if(rd_en && !empty)begin
            dout <= mem[rd_ptr[Addr_Width-1:0]];
            if(rd_ptr[Addr_Width-1:0] == Depth-1)begin
                rd_ptr <= {~rd_ptr[3], 3'b000}; // toggle MSB and reset LSBs
            end else begin
                rd_ptr <= rd_ptr + 1;
            end
        end
    end

    assign empty = (rd_ptr == wr_ptr);

    assign full = (wr_ptr[Addr_Width] != rd_ptr[Addr_Width] && wr_ptr[Addr_Width-1:0] == rd_ptr[Addr_Width-1:0]);
endmodule 