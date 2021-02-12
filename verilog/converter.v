`define INICIO      4'b0000
`define RESULTADO1  4'b0001
`define INICIARV    4'b0010
`define CONDICION1  4'b0011
`define KILOMETROS  4'b0100
`define MILLAS      4'b0101
`define RESULTADO2  4'b0111
`define FIN         4'b1000

module converter(
    input clk,
    input rst,
    input [31:0] im,
    input iop,
    output reg [31:0]result,
    //Salidas para las 4 pantallas de conversion
    output [7:0] pc1,
    output [7:0] pc2,
    output [7:0] pc3,
    output [7:0] pc4,
    //Salidas para las 4 pantallas del numero
    output [7:0] pn5,
    output [7:0] pn6,
    output [7:0] pn7,
    output [7:0] pn8
);

    reg [3:0] curr_state;
    reg [3:0] next_state;
    reg [31:0] m;
    reg op, nop;
    reg [31:0] nm;
    reg [31:0] nresult;

     drawBits resultado(
        .ingresadoEx(nresult[13:0]), 
        .valor1(pc1), 
        .valor2(pc2), 
        .valor3(pc3), 
        .valor4(pc4));
     
     drawBits numero(   
        .ingresadoEx(im[13:0]), 
        .valor1(pn5), 
        .valor2(pn6), 
        .valor3(pn7), 
        .valor4(pn8));


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
        m <= nm;
        op <= nop;
        result <= nresult;
    end

    //next register values
    always @ (*)
    begin
        nm = m;
        
        nresult = result;

        case (curr_state)
            `RESULTADO1: nresult = 32'd0;
            `INICIARV: begin
                nm = im;
            end
            `KILOMETROS: begin
                nm = m / 1000;
            end
            `MILLAS: begin
                nm = m * 0.00062137;
            end
            `RESULTADO2: nresult =  nm;
        endcase
    end

    //next state
    always @ (*)
    begin
        case (curr_state)
        `INICIO:
            if (im == 32'd0)
               next_state = `RESULTADO1;
            else
                next_state = `INICIARV;
        `RESULTADO1:
            next_state = `FIN;
        `INICIARV:
             next_state = `CONDICION1;
        `CONDICION1:
            if (iop == 32'd1)
                next_state = `KILOMETROS;
            else
                next_state = `MILLAS;
        `KILOMETROS:
            next_state = `RESULTADO2;
        `MILLAS:
            next_state = `RESULTADO2;
        `FIN:
            next_state = `FIN;

        endcase

    end

endmodule

module drawBits(
    input [13:0] ingresadoEx,
    output [7:0] valor1,
    output [7:0] valor2,
    output [7:0] valor3,
    output [7:0] valor4
);
    
    reg [13:0] contador, contador2, contador3;
    reg [13:0] comparador;
    reg [13:0] pantalla1;
    reg [13:0] pantalla2;
    reg [13:0] pantalla3;
    reg [13:0] pantalla4;
    
    dTB np1(
        .ingresado(pantalla1), 
        .valorBits(valor1));
    dTB np2(
        .ingresado(pantalla2), 
        .valorBits(valor2));
    dTB np3(
        .ingresado(pantalla3), 
        .valorBits(valor3));
    dTB np4(
        .ingresado(pantalla4), 
        .valorBits(valor4));

//Motivo por el cual no tiene valores flotantes: https://bit.ly/2LJv48F
     always @(*) 
        begin
            comparador = ingresadoEx;
            if (comparador < 10) begin
                pantalla1 = 14'b0;
                pantalla2 = 14'b0;
                pantalla3 = 14'b0;
                pantalla4 = comparador;
            end
            else if(comparador < 100) begin
                contador = 14'b0;
                pantalla1 = 14'b0;
                pantalla2 = 14'b0;
                while (comparador >= 10) 
                begin
                    contador = contador + 4'd1;
                    comparador = comparador - 10;
                end
                pantalla3 = contador;
                pantalla4 = comparador;
            end
            else if (comparador < 1000) begin
                contador = 14'b0;
                contador2 = 14'b0;
                pantalla1 = 14'b0;
                while (comparador >= 100) begin
                    comparador = comparador - 100;
                    contador2 = contador2 + 4'd1;
                end

                while (comparador >= 10) 
                begin
                    contador = contador + 4'd1;
                    comparador = comparador - 10;
                end
                pantalla2 = contador2;
                pantalla3 = contador;
                pantalla4 = comparador;
            end 
            else
            begin
                contador = 14'b0;
                contador2 = 14'b0;
                contador3 = 14'b0;

                while (comparador >= 1000) begin 
                    comparador = comparador - 1000;
                    contador3 = contador3 + 4'd1;
                end

                while (comparador >= 100) begin
                    comparador = comparador - 100;
                    contador2 = contador2 + 4'd1;
                end

                while (comparador >= 10) 
                begin
                    contador = contador + 4'd1;
                    comparador = comparador - 10;
                end
                pantalla1 = contador3;
                pantalla2 = contador2;
                pantalla3 = contador;
                pantalla4 = comparador;
            end      
           
        end
        

endmodule


//Simulacion de decoder ¿como lo hice? : https://bit.ly/2WtoPs0
//¿Como se donde van los segmentos? : https://bit.ly/37ue52z
module dTB(
        input [13:0] ingresado,
        output [7:0] valorBits
        );

        reg [7:0] screen;
        assign valorBits = screen;
        
        always @ (*)
        begin
            if(ingresado == 0)begin
                screen <= 8'b11111100;
            end
            else if(ingresado == 1)begin
                screen <= 8'b01100000;
            end
            else if (ingresado == 2) begin
                screen <= 8'b11011010;
            end
            else if (ingresado == 3) begin
                screen <= 8'b11110010;
            end
            else if (ingresado == 4) begin
                screen <= 8'b01100110;
            end
            else if (ingresado == 5) begin
                screen <= 8'b10110110;
            end
            else if (ingresado == 6) begin
                screen <= 8'b00111110;
            end
            else if (ingresado == 7) begin
                screen <= 8'b11100000;
            end
            else if (ingresado == 8) begin
                screen <= 8'b11111110;
            end
            else if (ingresado == 9) begin
                screen <= 8'b11100110;
            end
            else
            begin
                screen <= 8'b00000000;
            end
            
        end

    endmodule   