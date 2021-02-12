`define INICIO 2'b00
`define CICLO 2'b01
`define CCICLO 2'b10
`define FIN 2'b11

module factorial(
   input clk,
   input rst,
   input[31:0] n,
   output [31:0] f 
);
    reg [1:0] cs;
    reg [1:0] ns;

    reg [31:0] a, b;
    reg [31:0] na, nb;
    assign f = a;
    //current state
    always @ (posedge clk)
    begin
        if(rst)
            cs <= `INICIO;
        else
            cs <= ns; 
    end

    //Registers (a, b)
    always @ (posedge clk)
    begin
        a <= na;
        b <= nb;
    end

    //next values register (a, b)
    always @ (*)
    begin
        case (cs)
            `INICIO: begin
                na = 32'd1;
                nb = n;
            end
            `CICLO: begin
                na = a * b;
                nb = b - 32'd1;
            end
            `CCICLO: begin
                na = a;
                nb = b;
            end
            `FIN: begin
                na = a;
                nb <= b;
            end
        endcase
    end

    //next state
    always @ (*)
    begin
        case (cs)
            `INICIO: ns = `CICLO;
            `CICLO: ns = `CCICLO;
            `CCICLO:
                if (b == 32'd0) 
                    ns = `FIN;
                else
                    ns = `CICLO;               
            `FIN: ns = `FIN;
        endcase
    end
endmodule