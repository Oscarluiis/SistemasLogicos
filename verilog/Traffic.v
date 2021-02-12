module Traffic(
    input rst,
    input clk,
    input north_s,
    input east_s,
    output reg [2:0] north_l,
    output reg [2:0] east_l 
);

    reg [2:0] curr_state;
    reg [2:0] next_state;

    always @ (posedge clk)
    begin
       if(rst)
        curr_state <= 3'b000;
       else
        curr_state <= next_state;
    end

    //Luces
    always @ (*)
    begin
        case (curr_state)
        3'd0: begin
            north_l = 3'b100;
            east_l = 3'b100;
        end
        3'd1: begin
            north_l = 3'b001;
            east_l = 3'b100;
        end
        3'd2: begin
            north_l = 3'b100;
            east_l = 3'b001;
        end
        3'd3: begin
            north_l = 3'b010;
            east_l = 3'b100;
        end
        3'd4: begin
            north_l = 3'b100;
            east_l = 3'b010;
        end
        3'd5: begin
            north_l = 3'b100;
            east_l = 3'b001;
        end
        3'd6: begin
            north_l = 3'b001;
            east_l = 3'b100;
        end
        default : begin
            north_l = 3'b100;
            east_l = 3'b100;
        end
        endcase
    end

    //Next
    always @ (*)
    begin
        case (curr_state)
        3'd0:
            if (north_s)
                next_state = 3'd1;
            else if (east_s)
                next_state = 3'd2;
            else
                next_state = 3'd0;  
        3'd1:
            if(east_s)
                next_state = 3'd3;
            else
                next_state = 3'd1;
        3'd2:
            if(north_s)
                next_state = 3'd4;
            else
                next_state = 3'd2;
        3'd3:
            next_state = 3'd5;
        3'd4:
            next_state = 3'd6;
        3'd5:
            if(north_s)
                next_state = 3'd4;
            else 
                next_state = 3'd5;
        3'd6:
            if(east_s)
                next_state = 3'd3;
            else
                next_state = 3'd6;
        default:
            next_state = 3'd0;
        endcase
    end
endmodule