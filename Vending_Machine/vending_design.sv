//Design of a simple Vending machine
module vending_machine (
    input logic clk,
    input logic rst,
    input logic coke, pepsi,
    input logic Cancel,load,
    input logic [3:0] amount,
    input logic dispence,
    output logic dispence_coke, dispence_pepsi, 
    output logic load_en,coke_in,pepsi_in
);

parameter IDLE = 3'b000, 
          SELECT   = 3'b001, 
          WAIT_MONEY   = 3'b010,
          LOAD  =    3'b011,
          PRODUCT = 3'b100;
        //   END = 3'b101;



logic [2:0] state, next_state;
logic select_coke, select_pepsi;

// State transition logic
always_ff @(posedge clk) begin
    if (rst || Cancel) begin
        state <= IDLE;
        
    end else begin
        state <= next_state;
    end
end

always_ff @(posedge clk ) begin 
      if(rst) begin
        select_coke  <= 0;
        select_pepsi <= 0;
        
    end else if(coke)begin
        select_coke <= 1;
        select_pepsi <= 0;
    end else if(pepsi)begin
        select_pepsi <= 1;
        select_coke <= 0;
    end else if(state == PRODUCT) begin
        select_coke <= 0;
        select_pepsi <= 0;
    end
end

// Next state logic
always_comb begin


dispence_coke = 0;
dispence_pepsi = 0;
next_state = state;
load_en = 0;
coke_in = 0;
pepsi_in = 0;



    case(state)
    IDLE:begin
        if(coke || pepsi)begin
            next_state = SELECT;
        end else begin
            next_state = IDLE;
        end
    end

    SELECT:begin
        if(load)begin
            load_en = 1;
            next_state = LOAD;

        end else if(dispence)begin
            next_state = WAIT_MONEY;
        end else begin
            next_state = SELECT;
        end
    end

    LOAD:begin
        if(select_coke)begin
            coke_in = 1;
            next_state = IDLE;
        end else if(select_pepsi)begin
            pepsi_in = 1;
            next_state = IDLE;
        end else begin
            next_state = IDLE;        
        end
    end

    WAIT_MONEY:begin
        if(amount > 10)begin
            next_state = PRODUCT;
        end else if(Cancel)begin
            next_state = IDLE;
        end else begin
            next_state = WAIT_MONEY;
        end
    end

    PRODUCT:begin
        if(select_coke)begin
            dispence_coke = 1;
        end else if(select_pepsi)begin
            dispence_pepsi = 1;
        end
        next_state = IDLE;
    end

    default: next_state = IDLE;
    endcase
end

endmodule