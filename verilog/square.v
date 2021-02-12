`define INICIO         4'b0000
`define RESULTADO1     4'b0001
`define INICIARV       4'b0010
`define CONDICION1     4'b0011
`define CONDICION2     4'b0100
`define PAR            4'b0101
`define IMPAR          4'b0110
`define RESULTADO2     4'b0111
`define FIN            4'b1000

module square(
    input clk,
    input rst,
    input [31:0] ix,
    input [31:0] in,
    output reg [31:0]result

);
    reg [3:0] curr_state;
    reg [3:0] next_state;
    reg [31:0] x, y, n;
    reg [31:0] nx, ny, nn;
    reg [31:0] nresult;

    //current state
    always @ (posedge clk)
    begin
        if(rst)
            curr_state <= `INICIO;
        else
        curr_state <= next_state; 
    end

    //Registers x, y, n, result
    always @ (posedge clk)
    begin
        x <= nx;
        y <= ny;
        n <= nn;
        result <= nresult;
    end

    //Next registers values
    always @ (*)
    begin
        nx = x;
        ny = y;
        nn = n;
        nresult = result;

        case (curr_state)
            `RESULTADO1: nresult = 32'd1;
            `INICIARV: begin
                nx = ix;
                ny = 1;
                nn = in;
            end
            `PAR: begin
                nx = x * x;
                nn = n >> 1;
            end
            `IMPAR: begin
                ny = x * y;
                nx = x * x;
                nn = (n - 1) >> 1;
            end
            `RESULTADO2: nresult = x * y;
        endcase
    end

    //Next state
    always @ (*)
    begin
        case (curr_state)
        `INICIO:
            if(in == 32'd0)
                next_state = `RESULTADO1;
            else
                next_state = `INICIARV;
        `RESULTADO1:
            next_state = `FIN;
        `INICIARV:
            next_state = `CONDICION1;
        `CONDICION1:
            if(n > 32'd1)
                next_state = `CONDICION2;
            else
                next_state = `RESULTADO2;
        `CONDICION2:
            if(n[0] == 1'b0)
                next_state = `PAR;
            else
                next_state = `IMPAR;
        `PAR:
            next_state = `CONDICION1;
        `IMPAR:
            next_state = `CONDICION1;
        `RESULTADO2:
            next_state = `FIN;
        `FIN:
            next_state = `FIN;
        endcase   
    end
endmodule