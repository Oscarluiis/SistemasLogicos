module LedButton (
    input clk,
    input p,
    output reg led
);
    reg [1:0] curr_state;
    // Register  Current State
    reg [1:0] next_state;

    always @ (posedge clk)
        curr_state = next_state;

    // Mux LED Status
    always @ (curr_state)
    begin
        case (curr_state)
            2'd0: led = 1'b0;
            2'd1: led = 1'b0;
            2'd2: led = 1'b1;
            2'd3: led = 1'b1;
        endcase   
    end

    // Muxes Next State
always @ (curr_state or p)
    begin
        case (curr_state)
            2'd0: next_state = p? 2'd1 : 2'd0;
            2'd1: next_state = p? 2'd1 : 2'd2;
            2'd2: next_state = p? 2'd3 : 2'd2;
            2'd3: next_state = p? 2'd3 : 2'd0;
            default:
            next_state = 2'd0;
        endcase   
    end
endmodule

