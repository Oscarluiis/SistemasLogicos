`define INICIO      4'b0000;
`define INICIARV    4'b0001; 
`define CONDICION1  4'b0010;
`define AMAYOR      4'b0011;
`define BMAYOR      4'b0100;
`define CONDICION2  4'b0101;
`define CICLO       4'b0111;
`define VERDADEROC  4'b1000;
`define FALSOC      4'b1001;
`define FIN         4'b1011;

module lmc(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    input [31:0] lcm,
    input [31:0] step,
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
endmodule
