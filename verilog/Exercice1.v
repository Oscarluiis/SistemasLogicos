`define OFF     3'b000
`define L1      3'b001
`define L2      3'b010
`define L3      3'b011
`define L4      3'b100

module ligth(
    input clk,
    input rst,
    output reg [3:0]luces
);

    reg [2:0] curr_state;
    reg [2:0] next_state;


    //current state
    always @ (posedge clk)
    begin
        if(rst)
            curr_state <= `OFF;
        else
            curr_state <= next_state;
    end

    //Turn on
    always @ (*)
    begin
        case (curr_state)
        `OFF: begin
            luces = 4'b0000;
        end
        `L1: begin
            luces = 4'b0001;
        end 
        `L2: begin
            luces = 4'b0010;
        end
        `L3: begin
            luces = 4'b0100;
        end
        `L4: begin
            luces = 4'b1000;
        end
        endcase
    end

    always @ (*)
    begin
        case (curr_state)
        `OFF:
            next_state = `L1;
        `L1:
            next_state = `L2;
        `L2:
            next_state = `L3;
        `L3:
            next_state = `L4;
        `L4:
            next_state = `L1;
        endcase
    end
endmodule