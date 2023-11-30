module Jogo (
    input clk, // Clock
    input [3:0] num, // Número inserido
    input insert, // Inserir número
    input finish, // Finalizar jogo
    input reset, // Reset

    output reg win, // Venceu?
    output reg [1:0] premio, // Prêmio

    output [6:0] HEX0, // Display 1
    output [6:0] HEX1, // Display 2
    output [6:0] HEX2, // Display 3
    output [6:0] HEX3, // Display 4
    output [6:0] HEX4, // Display 5
    output [6:0] HEX5  // Display do prêmio
);

// Números da loteria - 50967
parameter [3:0] b0 = 4'b0101, // 5
          [3:0] b1 = 4'b0000, // 0
          [3:0] b2 = 4'b1001, // 9
          [3:0] b3 = 4'b0110, // 6 
          [3:0] b4 = 4'b0111; // 7

// Estados da FSM
reg [2:0] state;
parameter [2:0] s0 = 3'b000, // Aguardando inserção do primeiro número
          [2:0] s1 = 3'b001, // Aguardando inserção do segundo número
          [2:0] s2 = 3'b010, // Aguardando inserção do terceiro número
          [2:0] s3 = 3'b011, // Aguardando inserção do quarto número
          [2:0] s4 = 3'b100, // Aguardando inserção do quinto número
          [2:0] s5 = 3'b101, // Aguardando finalização do jogo
          [2:0] s6 = 3'b110; // Verificando resultado do jogo

// Contador de acertos
reg [2:0] acertos;

// Números inseridos
reg [3:0] n0, n1, n2, n3, n4;

// Mapa de segmentos para os dígitos de 0 a 9
reg [6:0] segment_map [0:9];

initial begin
    win = 0;
    premio = 2'b00;
    state = s0;
    acertos = 3'b000;
    n0 = 4'b0000;
    n1 = 4'b0000;
    n2 = 4'b0000;
    n3 = 4'b0000;
    n4 = 4'b0000;
    segment_map[0] = 7'b1000000; // 0
    segment_map[1] = 7'b1111001; // 1
    segment_map[2] = 7'b0100100; // 2
    segment_map[3] = 7'b0110000; // 3
    segment_map[4] = 7'b0011001; // 4
    segment_map[5] = 7'b0010010; // 5
    segment_map[6] = 7'b0000010; // 6
    segment_map[7] = 7'b1111000; // 7
    segment_map[8] = 7'b0000000; // 8
    segment_map[9] = 7'b0010000; // 9
end

always @(posedge clk) begin
    if (reset) begin
        win = 0;
        premio = 2'b00;
        state = s0;
        acertos = 3'b000;
        n0 = 4'b0000;
        n1 = 4'b0000;
        n2 = 4'b0000;
        n3 = 4'b0000;
        n4 = 4'b0000;
    end
    else begin
        case (state)
            s0 : begin
                // Aguardando inserção do primeiro número
                if (insert) begin
                    n0 = num;
                    if (num == b0) acertos = acertos + 1;
                    state = s1;
                end
            end
            s1 : begin
                // Aguardando inserção do segundo número
                if (insert) begin
                    n1 = num;
                    if (num == b1) acertos = acertos + 1;
                    state = s2;
                end
            end
            s2 : begin
                // Aguardando inserção do terceiro número
                if (insert) begin
                    n2 = num;
                    if (num == b2) acertos = acertos + 1;
                    state = s3;
                end
            end
            s3 : begin
                // Aguardando inserção do quarto número
                if (insert) begin
                    n3 = num;
                    if (num == b3) acertos = acertos + 1;
                    state = s4;
                end
            end
            s4 : begin
                // Aguardando inserção do quinto número
                if (insert) begin
                    n4 = num;
                    if (num == b4) acertos = acertos + 1;
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
                if (acertos >= 3'b0111 || (acertos >= 3'b0110 && num == b4)) begin
                    win = 1;
                    premio = 2'b01; // Prêmio 1
                end
                else if (acertos >= 3'b0101 && num == b4) begin
                    win = 1;
                    premio = 2'b10; // Prêmio 2
                end
                else begin
                    win = 0;
                    premio = 2'b00; // Sem prêmio
                end
                state = s0;
                acertos = 3'b000;
            end
        endcase
    end
end

always @(n0, n1, n2, n3, n4, premio) begin
    HEX0 = segment_map[n0];
    HEX1 = segment_map[n1];
    HEX2 = segment_map[n2];
    HEX3 = segment_map[n3];
    HEX4 = segment_map[n4];
    HEX5 = segment_map[premio];
end
endmodule
