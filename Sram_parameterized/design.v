module Ram_parameter#(
  parameter Width=8,
  parameter Depth = 8,
  parameter Addr_Width = $clog2(Depth)

)
  (
  
  	input clk,
  	input rst,
  	input wr_en,
  	input rd_en,
  	input [Width-1:0]data_in,
  	input [Addr_Width-1:0] w_addr,r_addr,
    output reg[Width-1:0]data_out);

  
  	reg [Width-1:0]mem[0:Depth-1];
               
             always_ff@(posedge clk)begin
               if(rst)begin
                 mem <= '{default:0};
               data_out<= '0;
               end
             
  
  else if(wr_en)begin
    mem[w_addr]<=data_in;
  end
  
  else if(rd_en)begin
    data_out<=mem[r_addr];
  end
end

endmodule
  
    
  
  