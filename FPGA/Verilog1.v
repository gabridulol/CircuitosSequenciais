module Loteria (
    // Entradas
    input wire clk, // Clock
    input wire [3:0] num, // Número
    input wire insert, // Insert
    input wire finish, // Finish
    input wire reset, // Reset

    // Saídas
    output reg [9:0] LEDR, // LEDR -> Estado
    output reg [6:0] HEX0, // Display 0 -> Número 4
    output reg [6:0] HEX1, // Display 1 -> Número 3
    output reg [6:0] HEX2, // Display 2 -> Número 2
    output reg [6:0] HEX3, // Display 3 -> Número 1
    output reg [6:0] HEX4, // Display 4 -> Número 0
    output reg [6:0] HEX5, // Display 5 -> -
    output reg [6:0] HEX6, // Display 6 -> Prêmio
    output reg [6:0] HEX7, // Display 7 -> P
    output reg LEDG // LEDG -> Venceu?
);

// Número - 50967
parameter [3:0] b0 = 4'b0101; // 5
parameter [3:0] b1 = 4'b0000; // 0
parameter [3:0] b2 = 4'b1001; // 9
parameter [3:0] b3 = 4'b0110; // 6 
parameter [3:0] b4 = 4'b0111; // 7

// Estados da FSM
parameter [3:0] s0 = 4'b0000; // Aguardando inserção do primeiro número
parameter [3:0] s1 = 4'b0001; // Aguardando inserção do segundo número
parameter [3:0] s2 = 4'b0010; // Aguardando inserção do terceiro número
parameter [3:0] s3 = 4'b0011; // Aguardando inserção do quarto número
parameter [3:0] s4 = 4'b0100; // Aguardando inserção do quinto número
parameter [3:0] s5 = 4'b0101; // Aguardando finalização do jogo
parameter [3:0] s6 = 4'b0110; // Verificando resultado do jogo
parameter [3:0] s7 = 4'b0111; // Estado Prêmio 0
parameter [3:0] s8 = 4'b1000; // Estado Prêmio 1
parameter [3:0] s9 = 4'b1001; // Estado Prêmio 2
 
// Variáveis
reg [3:0] state; // Estado da FSM
reg [3:0] num0; // Número 0
reg [3:0] num1; // Número 1
reg [3:0] num2; // Número 2
reg [3:0] num3; // Número 3
reg [3:0] num4; // Número 4
reg [2:0] hits; // Acertos
reg lastTrue; // Último número inserido
reg win; // Venceu?
reg [1:0] p0; // Prêmio

reg [6:0] sdm [0:11]; // Mapa de Segmentos do Display
reg [9:0] lrm [0:9]; // Mapa de LEDR

initial begin
    state = s0;
    win = 0;
    num0 = 4'b0000;
    num1 = 4'b0000;
    num2 = 4'b0000;
    num3 = 4'b0000;
    num4 = 4'b0000;
    hits = 3'b000;
    lastTrue = 1'b0;
    win = 1'b0;
    p0 = 2'b00;

    sdm[0] = 7'b1000000; // 0
    sdm[1] = 7'b1111001; // 1
    sdm[2] = 7'b0100100; // 2
    sdm[3] = 7'b0110000; // 3
    sdm[4] = 7'b0011001; // 4
    sdm[5] = 7'b0010010; // 5
    sdm[6] = 7'b0000010; // 6
    sdm[7] = 7'b1111000; // 7
    sdm[8] = 7'b0000000; // 8
    sdm[9] = 7'b0010000; // 9
    sdm[10] = 7'b0111111; // -
    sdm[11] = 7'b0001100; // P

    lrm[0] = 9'b000000000; // S0
    lrm[1] = 9'b000000001; // S1
    lrm[2] = 9'b000000011; // S2
    lrm[3] = 9'b000000111; // S3
    lrm[4] = 9'b000001111; // S4
    lrm[5] = 9'b000011111; // S5
    lrm[6] = 9'b000111111; // S6
    lrm[7] = 9'b001111111; // S7
    lrm[8] = 9'b011111111; // S8
    lrm[9] = 9'b111111111; // S9
end

always @(posedge clk) begin
    if (reset) begin
        state = s0;
        win = 0;
        num0 = 4'b0000;
        num1 = 4'b0000;
        num2 = 4'b0000;
        num3 = 4'b0000;
        num4 = 4'b0000;
        hits = 3'b000;
        lastTrue = 1'b0;
        win = 1'b0;
        p0 = 2'b00;
    end
    else begin
        case (state)
            s0 : begin
                // Aguardando inserção do primeiro número
                if (insert) begin
                    num0 = num;
                    if (num == b0) begin
                        hits = hits + 1;
                    end
                    state = s1;
                end
            end
            s1 : begin
                // Aguardando inserção do segundo número
                if (insert) begin
                    num1 = num;
                    if (num == b1 && num0 == b0) begin
                        hits = hits + 1;
                    end
                    else begin
                        hits = 0;
                    end
                    state = s2;
                end
            end
            s2 : begin
                // Aguardando inserção do terceiro número
                if (insert) begin
                    num2 = num;
                    if (num == b2 && num1 == b1) begin
                        hits = hits + 1;
                    end
                    else begin
                        hits = 0;
                    end
                    state = s3;
                end
            end
            s3 : begin
                // Aguardando inserção do quarto número
                if (insert) begin
                    num3 = num;
                    if (num == b3 && num2 == b2) begin
                        hits = hits + 1;
                    end
                    else begin
                        hits = 0;
                    end
                    state = s4;
                end
            end
            s4 : begin
                // Aguardando inserção do quinto número
                if (insert) begin
                    num4 = num;
                    if (num == b4) begin
                      lastTrue = 1'b1;
                    end
                    state = s5;
                end
            end
            s5 : begin
                // Aguardando finalização do jogo
                if (finish) begin
                    state = s6;
                end
            end
            s6 : begin
                // Verificando resultado do jogo
                if (hits == 3'b100 || (hits == 3'b011 && lastTrue == 1'b1)) begin
                    state = s8; // Prêmio 1
                end
                else if (hits == 3'b010 && lastTrue == 1'b1) begin
                    state = s9; // Prêmio 2
                end
                else begin
                    state = s7; // Prêmio 0
                end
            end
            s7 : begin
                // Prêmio 0
                win = 0;
                p0 = 2'b00;
            end
            s8 : begin
                // Prêmio 1
                win = 1;
                p0 = 2'b01;
            end
            s9 : begin
                // Prêmio 2
                win = 1;
                p0 = 2'b10;
            end
        endcase
    end
end

always @(state, num0, num1, num2, num3, num4, p0) begin
    LEDR = lrm[state];
    HEX0 = sdm[num4];
    HEX1 = sdm[num3];
    HEX2 = sdm[num2];
    HEX3 = sdm[num1];
    HEX4 = sdm[num0];
    HEX5 = sdm[10];
    HEX6 = sdm[p0];
    HEX7 = sdm[11];
    LEDG = win;
end
endmodule