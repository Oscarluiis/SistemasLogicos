`define INICIO      4'b0000
`define INICIARV    4'b0001 
`define CONDICION1  4'b0010
`define AMAYOR      4'b0011
`define BMAYOR      4'b0100
`define CONDICION2  4'b0101
`define CICLO       4'b0110
`define VERDADEROC  4'b0111
`define FALSOC      4'b1000
`define FIN         4'b1001

module lcm(
    input clk,
    input rst,
    input [31:0] ia,
    input [31:0] ib,
    output reg [31:0]result

);
    reg [3:0] curr_state;
    reg [3:0] next_state;
    reg [31:0] a,b,lcm,step;
    reg [31:0] na,nb,nlcm,nstep;
    reg [31:0] nresult;

    //current state
    always @ (posedge clk)
    begin
        if(rst)
            curr_state <= `INICIO;
        else
            curr_state <= next_state; 
    end

    //registers 
    always @ (posedge clk)
    begin
        a <= na;
        b <= nb;
        lcm <= nlcm;
        step <= nstep;
        result <= nresult;
    end

    //next values
    always @ (*)
    begin
        na = a;
        nb = b;
        nlcm = lcm;
        nstep = step;
        nresult = result;

        case(curr_state)
        `INICIARV: begin
            na = ia;
            nb = ib;
            nlcm = lcm;
            nstep = step;
            nresult = result;
        end
        `AMAYOR: begin
            nlcm = a;
            nstep = a;
        end
        `BMAYOR: begin
            nlcm = b;
            nstep = b;
        end
        `FALSOC: begin
            nlcm = nlcm + nstep;
        end
        `VERDADEROC: nresult = nlcm;
        endcase
    end

    //next state
    always @ (*)
    begin
        case(curr_state)
        `INICIO:
            next_state = `INICIARV;
        `INICIARV:
            next_state = `CONDICION1;
        `CONDICION1: 
            if(a > b)
                next_state = `AMAYOR;
            else
                next_state = `BMAYOR;
        `AMAYOR:
            next_state = `CICLO;
        `BMAYOR:
            next_state = `CICLO;
        `CICLO:
            next_state = `CONDICION2;
        `CONDICION2:
            if ((nlcm%a)==0 && (lcm%b==0))
                next_state = `VERDADEROC;
            else
                next_state = `FALSOC;
        `VERDADEROC: 
            next_state = `FIN;
        `FALSOC:
            next_state = `CICLO;
        `FIN:
            next_state = `FIN;
            
        endcase
    end
endmodule
