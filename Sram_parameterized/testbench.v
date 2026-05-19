module test_ram;
  parameter Width=8;
  parameter Depth = 8;
  parameter Addr_Width = $clog2(Depth);

  
  	reg clk;
  	reg rst;
  	reg wr_en;
  	reg rd_en;
  reg [Width-1:0]data_in;
  reg [Addr_Width-1:0] w_addr,r_addr;
    wire [Width-1:0]data_out;
  
  `include "func_ram.v"

  Ram_parameter #(.Width(Width),
                 .Depth(Depth),
                 .Addr_Width(Addr_Width))
  dut(.clk(clk),
      .rst(rst),
      .wr_en(wr_en),
      .rd_en(rd_en),
      .data_in(data_in),
      .w_addr(w_addr),
      .r_addr(r_addr),
      .data_out(data_out)
);
  
  initial begin
    clk = 0;
    data_in = 0;
    rst = 0;
    wr_en = 0;
    rd_en = 0;
    w_addr = 0;
    r_addr = 0;
    
    forever #5 clk=~clk;
  end
  
  initial begin
    reset();
    
    write_data(5, 8'hAA);
    
    write_data(6, 8'hFF);
    
    read_data(5);
    
    read_data(6);
    #100
    $finish;
  end
  
  initial begin 
    $dumpfile("ram.vcd");
    $dumpvars(0,test_ram);
  end
  
  initial begin
    $monitor("[%0t] wr_en = %0b, rd_en = %0b, data_in = %0d, data_out = %0d, w_addr = %0d, r_addr = %0d", $time, wr_en, rd_en, data_in, data_out, w_addr, r_addr);
  end
  
endmodule
  
    