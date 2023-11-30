module Jogo (
    // Entradas
    input clk, // Clock
    input [3:0] num, // Número inserido
    input insert, // Inserir número
    input finish, // Finalizar jogo
    input reset, // Reset

    // Saídas
    output [6:0] HEX0, // Número 4
    output [6:0] HEX1, // Número 3
    output [6:0] HEX2, // Número 2
    output [6:0] HEX3, // Número 1
    output [6:0] HEX4, // Número 0
    output [6:0] HEX5, // Prêmio
    output LEDG8 // Venceu?
);

// Números da loteria - 50967
parameter b0 = 4'b0101;
parameter b1 = 4'b0000;
parameter b2 = 4'b1001;
parameter b3 = 4'b0110;
parameter b4 = 4'b0111;

// Estados da FSM
reg [2:0] state;
parameter s0 = 4'b0000; // Aguardando inserção do primeiro número
parameter s1 = 4'b0001; // Aguardando inserção do segundo número
parameter s2 = 4'b0010; // Aguardando inserção do terceiro número
parameter s3 = 4'b0011; // Aguardando inserção do quarto número
parameter s4 = 4'b0100; // Aguardando inserção do quinto número
parameter s5 = 4'b0101; // Aguardando finalização do jogo
parameter s6 = 4'b0110; // Verificando resultado do jogo
parameter s7 = 4'b0111; // Prêmio 0
parameter s8 = 4'b1000; // Prêmio 1
parameter s9 = 4'b1001; // Prêmio 2

reg [3:0] num0; // Número 0
reg [3:0] num1; // Número 1
reg [3:0] num2; // Número 2
reg [3:0] num3; // Número 3
reg [3:0] num4; // Número 4
reg win; // Venceu?
reg [1:0] p0; // Prêmio

initial begin
    win <= 0;
    p0 <= 4'b00;
    num0 <= 4'b0000;
    num1 <= 4'b0000;
    num2 <= 4'b0000;
    num3 <= 4'b0000;
    num4 <= 4'b0000;
    HEX0 <= 7'b1000000;
    HEX1 <= 7'b1000000;
    HEX2 <= 7'b1000000;
    HEX3 <= 7'b1000000;
    HEX4 <= 7'b1000000;
    HEX5 <= 7'b1000000;
    LEDG8 <= 0;
    state <= s0;
end

always @(posedge clk) begin
    if (reset) begin
        win <= 0;
        p0 <= 4'b00;
        num0 <= 4'b0000;
        num1 <= 4'b0000;
        num2 <= 4'b0000;
        num3 <= 4'b0000;
        num4 <= 4'b0000;
        HEX0 <= 7'b1000000;
        HEX1 <= 7'b1000000;
        HEX2 <= 7'b1000000;
        HEX3 <= 7'b1000000;
        HEX4 <= 7'b1000000;
        HEX5 <= 7'b1000000;
        LEDG8 <= 0;
    end
    else begin
        case (state)
            s0 : begin
                // Aguardando inserção do primeiro número
                if (insert) begin
                    num0 <= num;
                    state <= s1;
                end
            end
            s1 : begin
                // Aguardando inserção do segundo número
                if (insert) begin
                    num1 <= num;
                    state <= s2;
                end
            end
            s2 : begin
                // Aguardando inserção do terceiro número
                if (insert) begin
                    num2 <= num;
                    state <= s3;
                end
            end
            s3 : begin
                // Aguardando inserção do quarto número
                if (insert) begin
                    num3 <= num;
                    state <= s4;
                end
            end
            s4 : begin
                // Aguardando inserção do quinto número
                if (insert) begin
                    num4 <= num;
                    state <= s5;
                end
            end
            s5 : begin
                // Aguardando finalização do jogo
                if (finish) begin
                    state <= s6;
                end
            end
            s6 : begin
                // Verificando resultado do jogo
                if ((num0 == b0 && num1 == b1 && num2 == b2 && num3 == b3) || 
                (num0 == b0 && num1 == b1 && num2 == b2 && num4 == b4) || 
                (num0 == b0 && num1 == b1 && num3 == b3 && num4 == b4) || 
                (num0 == b0 && num2 == b2 && num3 == b3 && num4 == b4) || 
                (num1 == b1 && num2 == b2 && num3 == b3 && num4 == b4)) begin
                    state <= s8; // Prêmio 1
                end
                else if ((num0 == b0 && num1 == b1 && num4 == b4) || 
                (num0 == b0 && num2 == b2 && num4 == b4) || 
                (num0 == b0 && num3 == b3 && num4 == b4) || 
                (num1 == b1 && num2 == b2 && num4 == b4) || 
                (num1 == b1 && num3 == b3 && num4 == b4) || 
                (num2 == b2 && num3 == b3 && num4 == b4)) begin
                    state <= s9; // Prêmio 2
                end
                else begin
                    state <= s7; // Prêmio 0
                end
            end
            s7 : begin
                // Prêmio 0
                win <= 0;
                p0 <= 4'b00;
            end
            s8 : begin
                // Prêmio 1
                win <= 1;
                p0 <= 4'b01;
            end
            s9 : begin
                // Prêmio 2
                win <= 1;
                p0 <= 4'b10;
            end
        endcase
    end
end
    // Primeiro número inserido
    assign HEX4[6] = ~((~num0[0] & ~num0[1] & ~num0[3]) + (~num0[0] & num0[2]) | (~num0[0] & num0[1] & num0[3]) | (num0[0] & ~num0[1] & ~num0[2]));
    assign HEX4[5] = ~((~num0[0] & ~num0[1]) | (~num0[0] & ~num0[2] & ~num0[3]) | (~num0[1] & ~num0[2]) | (~num0[0] & num0[2] & num0[3]));
    assign HEX4[4] = ~((~num0[1] & ~num0[2]) | (~num0[0] & num0[3]) | (~num0[0] &  num0[1]));
    assign HEX4[3] = ~((~num0[0] & ~num0[1] & ~num0[3]) | (~num0[0] & ~num0[1] & num0[2]) | (~num0[0] & num0[2] &  ~num0[3]) | (~num0[0] &  num0[1] &  ~num0[2] & num0[3]) | (num0[0] &  ~num0[1] & ~num0[2]));
    assign HEX4[2] = ~((~num0[1] & ~num0[2] & ~num0[3]) | (~num0[0] & num0[2] & ~num0[3]));
    assign HEX4[1] = ~((~num0[0] & ~num0[2] & ~num0[3]) | (~num0[0] & num0[1] & ~num0[2]) | (~num0[0] & num0[1] & ~num0[3]) | (num0[0] & ~num0[1] & ~num0[2]));
    assign HEX4[0] = ~((~num0[0] & ~num0[1] & num0[2]) | (~num0[0] & num0[1] & ~num0[2]) | (~num0[0] & num0[1] & ~num0[3]) | (num0[0] & ~num0[1] & ~num0[2]));

    // Segundo número inserido
    assign HEX3[6] = ~((~num1[0] & ~num1[1] & ~num1[3]) | (~num1[0] & num1[2]) | (~num1[0] & num1[1] & num1[3]) | (num1[0] & ~num1[1] & ~num1[2]));
    assign HEX3[5] = ~((~num1[0] & ~num1[1]) | (~num1[0] & ~num1[2] & ~num1[3]) | (~num1[1] & ~num1[2]) | (~num1[0] & num1[2] & num1[3]));
    assign HEX3[4] = ~((~num1[1] & ~num1[2]) | (~num1[0] & num1[3]) | (~num1[0] &  num1[1]));
    assign HEX3[3] = ~((~num1[0] & ~num1[1] & ~num1[3]) | (~num1[0] & ~num1[1] & num1[2]) | (~num1[0] & num1[2] &  ~num1[3]) | (~num1[0] &  num1[1] &  ~num1[2] & num1[3]) | (num1[0] &  ~num1[1] & ~num1[2]));
    assign HEX3[2] = ~((~num1[1] & ~num1[2] & ~num1[3]) | (~num1[0] & num1[2] & ~num1[3]));
    assign HEX3[1] = ~((~num1[0] & ~num1[2] & ~num1[3]) | (~num1[0] & num1[1] & ~num1[2]) | (~num1[0] & num1[1] & ~num1[3]) | (num1[0] & ~num1[1] & ~num1[2]));
    assign HEX3[0] = ~((~num1[0] & ~num1[1] & num1[2]) | (~num1[0] & num1[1] & ~num1[2]) | (~num1[0] & num1[1] & ~num1[3]) | (num1[0] & ~num1[1] & ~num1[2]));

    // Terceiro número inserido
    assign HEX2[6] = ~((~num2[0] & ~num2[1] & ~num2[3]) | (~num2[0] & num2[2]) | (~num2[0] & num2[1] & num2[3]) | (num2[0] & ~num2[1] & ~num2[2]));
    assign HEX2[5] = ~((~num2[0] & ~num2[1]) | (~num2[0] & ~num2[2] & ~num2[3]) | (~num2[1] & ~num2[2]) | (~num2[0] & num2[2] & num2[3]));
    assign HEX2[4] = ~((~num2[1] & ~num2[2]) | (~num2[0] & num2[3]) | (~num2[0] &  num2[1]));
    assign HEX2[3] = ~((~num2[0] & ~num2[1] & ~num2[3]) | (~num2[0] & ~num2[1] & num2[2]) | (~num2[0] & num2[2] &  ~num2[3]) | (~num2[0] &  num2[1] &  ~num2[2] & num2[3]) | (num2[0] &  ~num2[1] & ~num2[2]));
    assign HEX2[2] = ~((~num2[1] & ~num2[2] & ~num2[3]) | (~num2[0] & num2[2] & ~num2[3]));
    assign HEX2[1] = ~((~num2[0] & ~num2[2] & ~num2[3]) | (~num2[0] & num2[1] & ~num2[2]) | (~num2[0] & num2[1] & ~num2[3]) | (num2[0] & ~num2[1] & ~num2[2]));
    assign HEX2[0] = ~((~num2[0] & ~num2[1] & num2[2]) | (~num2[0] & num2[1] & ~num2[2]) | (~num2[0] & num2[1] & ~num2[3]) | (num2[0] & ~num2[1] & ~num2[2]));

    // Quarto número inserido
    assign HEX1[6] = ~((~num3[0] & ~num3[1] & ~num3[3]) | (~num3[0] & num3[2]) | (~num3[0] & num3[1] & num3[3]) | (num3[0] & ~num3[1] & ~num3[2]));
    assign HEX1[5] = ~((~num3[0] & ~num3[1]) | (~num3[0] & ~num3[2] & ~num3[3]) | (~num3[1] & ~num3[2]) | (~num3[0] & num3[2] & num3[3]));
    assign HEX1[4] = ~((~num3[1] & ~num3[2]) | (~num3[0] & num3[3]) | (~num3[0] &  num3[1]));
    assign HEX1[3] = ~((~num3[0] & ~num3[1] & ~num3[3]) | (~num3[0] & ~num3[1] & num3[2]) | (~num3[0] & num3[2] &  ~num3[3]) | (~num3[0] &  num3[1] &  ~num3[2] & num3[3]) | (num3[0] &  ~num3[1] & ~num3[2]));
    assign HEX1[2] = ~((~num3[1] & ~num3[2] & ~num3[3]) | (~num3[0] & num3[2] & ~num3[3]));
    assign HEX1[1] = ~((~num3[0] & ~num3[2] & ~num3[3]) | (~num3[0] & num3[1] & ~num3[2]) | (~num3[0] & num3[1] & ~num3[3]) | (num3[0] & ~num3[1] & ~num3[2]));
    assign HEX1[0] = ~((~num3[0] & ~num3[1] & num3[2]) | (~num3[0] & num3[1] & ~num3[2]) | (~num3[0] & num3[1] & ~num3[3]) | (num3[0] & ~num3[1] & ~num3[2]));

    // Quinto número inserido
    assign HEX0[6] = ~((~num4[0] & ~num4[1] & ~num4[3]) | (~num4[0] & num4[2]) | (~num4[0] & num4[1] & num4[3]) | (num4[0] & ~num4[1] & ~num4[2]));
    assign HEX0[5] = ~((~num4[0] & ~num4[1]) | (~num4[0] & ~num4[2] & ~num4[3]) | (~num4[1] & ~num4[2]) | (~num4[0] & num4[2] & num4[3]));
    assign HEX0[4] = ~((~num4[1] & ~num4[2]) | (~num4[0] & num4[3]) | (~num4[0] &  num4[1]));
    assign HEX0[3] = ~((~num4[0] & ~num4[1] & ~num4[3]) | (~num4[0] & ~num4[1] & num4[2]) | (~num4[0] & num4[2] &  ~num4[3]) | (~num4[0] &  num4[1] &  ~num4[2] & num4[3]) | (num4[0] &  ~num4[1] & ~num4[2]));
    assign HEX0[2] = ~((~num4[1] & ~num4[2] & ~num4[3]) | (~num4[0] & num4[2] & ~num4[3]));
    assign HEX0[1] = ~((~num4[0] & ~num4[2] & ~num4[3]) | (~num4[0] & num4[1] & ~num4[2]) | (~num4[0] & num4[1] & ~num4[3]) | (num4[0] & ~num4[1] & ~num4[2]));
    assign HEX0[0] = ~((~num4[0] & ~num4[1] & num4[2]) | (~num4[0] & num4[1] & ~num4[2]) | (~num4[0] & num4[1] & ~num4[3]) | (num4[0] & ~num4[1] & ~num4[2]));

    // Prêmio
    assign HEX5[6] = ~(~p0[1]);
    assign HEX5[5] = ~(~p0[0] & ~p0[1]);
    assign HEX5[4] = ~(~p0[0]);
    assign HEX5[3] = ~((~p0[0] & p0[1]) | (p0[0] & ~p0[1]));
    assign HEX5[2] = ~(~p0[0] | ~p0[1]);
    assign HEX5[1] = ~(~p0[0] | ~p0[1]);
    assign HEX5[0] = ~(~p0[0]);

    // Venceu?
    assign LEDG8 = win;
endmodule