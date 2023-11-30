module Jogo (
    // Entradas
    input clk, // Clock

    input [3:0] num // Número inserido

    input insert, // Inserir número
    input finish, // Finalizar jogo
    input reset, // Reset

    // Saídas
    output [3:0] num0, // Número 1
    output [3:0] num1, // Número 2
    output [3:0] num2, // Número 3
    output [3:0] num3, // Número 4
    output [3:0] num4, // Número 5

    output win, // Venceu?
    output [1:0] p0, // Prêmio

    // FPGA
    output HEX0 [6:0] // Número 5
    output HEX1 [6:0] // Número 4
    output HEX2 [6:0] // Número 3
    output HEX3 [6:0] // Número 2
    output HEX4 [6:0] // Número 1
    output HEX5 [6:0] // Prêmio
    output LED8 // Venceu?
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

initial begin
    win <= 0;
    p0 <= 4'b00;
    num0 <= 4'b0000;
    num1 <= 4'b0000;
    num2 <= 4'b0000;
    num3 <= 4'b0000;
    num4 <= 4'b0000;
    HEX0 <= 7'b0111111;
    HEX1 <= 7'b0111111;
    HEX2 <= 7'b0111111;
    HEX3 <= 7'b0111111;
    HEX4 <= 7'b0111111;
    HEX5 <= 7'b0111111;
    LED8 <= 0;
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
        HEX0 <= 7'b0111111;
        HEX1 <= 7'b0111111;
        HEX2 <= 7'b0111111;
        HEX3 <= 7'b0111111;
        HEX4 <= 7'b0111111;
        HEX5 <= 7'b0111111;
        LED8 <= 0;
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
            end
            s7 : begin
                // Prêmio 0
            end
            s8 : begin
                // Prêmio 1
            end
            s9 : begin
                // Prêmio 2
            end
        endcase
    end
end