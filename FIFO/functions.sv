task reset_fifo();
begin
    @(posedge clk);
    rst = 1;
    wr_en = 0;
    rd_en = 0;
    din = 0;
     repeat(2) @(posedge clk);
    rst = 0;     
    $display(" Reseted the fifo");
end
endtask

task write_fifo(input [Width-1:0]data);
begin
    @(posedge clk);
    if(!full)begin
         wr_en = 1;
         din = data;

    @(posedge clk);
    
         wr_en=0;
         $display("[%0t] Write done -> data = %0d", $time, data);
        
    end
    else begin
        $display("[%0t] FIFO FULL = %0d", $time, full);
    end
end
endtask

task read_fifo();
 begin
    @(posedge clk);
    if(!empty)begin
        rd_en = 1;
    
    @(posedge clk);

    rd_en = 0;
        $display("[%0t] READ done = %0d", $time, dout);
        
    end

    else 
    $display("[%0t] FIFO EMPTY = %0d",$time,empty);

end
endtask
