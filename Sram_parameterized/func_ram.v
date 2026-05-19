task reset();
  begin
    @(posedge clk);
    rst = 1;
    wr_en = 0;
    rd_en = 0;
    @(posedge clk);
    
    rst =0;
  end
endtask

task write_data(input [Addr_Width-1:0]addr,
                input [Width-1:0]data);
  begin
    @(posedge clk);
    wr_en = 1;
    rd_en = 0;
    
    w_addr = addr;
    data_in = data;
    $display("[%0t] write address = %0h, data = %0h", $time, addr, data);
    
    @(posedge clk);
    wr_en = 0;
  end
endtask
  
  task read_data(input [Addr_Width-1:0]addr);
  begin
    @(posedge clk);
    wr_en = 0;
    rd_en = 1;
    
    r_addr = addr;
    $display("[%0t] read address = %0d, data_out= %0h", $time, addr, data_out);
    
    
    @(posedge clk);
    rd_en = 0;
  end
  endtask