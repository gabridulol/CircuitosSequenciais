module Display (
    input [3:0] num0, // Número inserido 0
    input [3:0] num1, // Número inserido 1
    input [3:0] num2, // Número inserido 2
    input [3:0] num3, // Número inserido 3

    input win, // Venceu?

    input [3:0] p0; // Prêmio
    input [3:0] p1, // Total prêmio 1
    input [3:0] p2, // Total prêmio 2

    output [6:0] n0 // Display 0 (HEX0)
    output [6:0] n1 // Display 1 (HEX1)
    output [6:0] n2 // Display 2 (HEX2)
    output [6:0] n3 // Display 3 (HEX3)

    output reg win; // Venceu? (LEDG8)

    output reg [6:0] p0; // Prêmio (HEX4)
    output reg [6:0] p1; // Total prêmio 1 (HEX5)
    output reg [6:0] p2; // Total prêmio 2 (HEX6)
    output reg [6:0] null; // (HEX7)
);

module Jogo (
    input clk, // Clock

    input [3:0] num0, // Número inserido 1
    input [3:0] num1, // Número inserido 2
    input [3:0] num2, // Número inserido 3
    input [3:0] num3, // Número inserido 4

    input insert, // Inserir número
    input finish, // Finalizar jogo
    input reset, // Reset

    output win,

    output [3:0] p0, // Prêmio
    output [3:0] p1, // Total prêmio 1
    output [3:0] p2 // Total prêmio 2
);