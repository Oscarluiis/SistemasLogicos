`define INICIO      3'b000
`define INICIARV    3'b001
`define DIFERENTE   3'b010
`define RESULTADO   3'b011
`define FIN         3'b100
`define MAYORQUE    3'b101
`define AMAYOR      3'b110
`define AMENOR      3'b111

module gcd(
    input clk,
    input rst,
    input [31:0] ia,
    input [31:0] ib,
    output reg [31:0]result
);

    reg [2:0] curr_state;
    reg [2:0] next_state;
    reg [31:0] a, b;
    reg [31:0] na, nb;
    reg [31:0] nresult;

    //current state
    always @ (posedge clk)
    begin
        if(rst)
            curr_state <= `INICIO;
        else
            curr_state <= next_state;
    end

    //registers a, b, result
    always @ (posedge clk)
    begin
        a <= na;
        b <= nb;
        result <= nresult;
    end

    //next register values
    always @ (*)
    begin
        na = a;
        nb = b;
        nresult = result;

        case (curr_state)
        `RESULTADO: nresult = a;
        `INICIARV: begin
            na = ia;
            nb = ib;
        end
        `AMAYOR: begin
            na = a - b;
        end
        `AMENOR:begin
            nb = b - a;
        end
        endcase
    end

    //next state
    always @ (*)
    begin
        case(curr_state)
        `INICIO:
            next_state = `INICIARV;
        `INICIARV:
            next_state = `DIFERENTE;
        `DIFERENTE: 
            if ( a != b )
                next_state = `MAYORQUE;
            else
                next_state = `RESULTADO;
        `MAYORQUE:
            if (a > b)
                next_state = `AMAYOR;
            else
                next_state = `AMENOR;
        `AMAYOR:
            next_state = `DIFERENTE;
        `AMENOR:
            next_state = `DIFERENTE;
        `RESULTADO:
            next_state = `FIN;
        `FIN:
            next_state = `FIN;
        endcase
    end
endmodule