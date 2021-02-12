module keyboard(
    input[9:0] opciones,
    output[7:0] numero
)
    reg [6:0] nprime;
    assign n = nprime;

    always @ (*) begin
        if(opciones[0])
            nprime = 8'd0;
        else if(opciones[1])
            nprime = 8'd1;
        else if(opciones[2])
            nprime = 8'd2;
        else if(opciones[3])
            nprime = 8'd3;
        else if(opciones[4])
            nprime = 8'd4;
        else if(opciones[5])
            nprime = 8'd5;
        else if(opciones[6])
            nprime = 8'd6;
        else if(opciones[7])
            nprime = 8'd7;
        else if(opciones[8])
            nprime = 8'd8;
        else if(opciones[9])
            nprime = 8'd9;
        else
            nprime = 8'd10; 
    end

endmodule;