`timescale 1ns / 1ps

module segment_controller(
    input clk,
    input [31:0] NUMB,
    input ERROR,
    input [7:0] MASK,
    output reg [7:0] anodes,
    output reg [7:0] cathodes
);
    
    wire [2:0] current_number_digit;    
    reg [3:0] current_digit;
    integer i;
    initial begin
        i             <= 0;
        anodes        <= 8'b11111111;
        current_digit <= 0;
        cathodes      <= 8'b11111111;
    end
    
    always@(current_number_digit) begin
        case(current_number_digit)
        3'b000: current_digit = NUMB[3:0];
        3'b001: current_digit = NUMB[7:4];
        3'b010: current_digit = NUMB[11:8];
        3'b011: current_digit = NUMB[15:12];
        3'b100: current_digit = NUMB[19:16];
        3'b101: current_digit = NUMB[23:20];
        3'b110: current_digit = NUMB[27:24];
        3'b111: current_digit = NUMB[31:28];
        endcase
    end

    always@(posedge clk) begin
        if (ERROR == 0) begin
            case(current_digit)
            4'h0: cathodes <= 8'b11000000;
            4'h1: cathodes <= 8'b11111001;
            4'h2: cathodes <= 8'b10100100;
            4'h3: cathodes <= 8'b10110000;
            4'h4: cathodes <= 8'b10011001;
            4'h5: cathodes <= 8'b10010010;
            4'h6: cathodes <= 8'b10000010;
            4'h7: cathodes <= 8'b11111000;
            4'h8: cathodes <= 8'b10000000;
            4'h9: cathodes <= 8'b10010000;
            4'ha: cathodes <= 8'b10001000;
            4'hb: cathodes <= 8'b10000011;
            4'hc: cathodes <= 8'b11000110;
            4'hd: cathodes <= 8'b10100001;
            4'he: cathodes <= 8'b10000110;
            4'hf: cathodes <= 8'b10001110;
            default: cathodes <= 8'b11111111;
            endcase

            i = current_number_digit;
            if ((MASK & (1 << i)) == 0) begin
                case(current_number_digit)
                4'h0: anodes <= 8'b11111110;
                4'h1: anodes <= 8'b11111101;
                4'h2: anodes <= 8'b11111011;
                4'h3: anodes <= 8'b11110111;
                4'h4: anodes <= 8'b11101111;
                4'h5: anodes <= 8'b11011111;
                4'h6: anodes <= 8'b10111111;
                4'h7: anodes <= 8'b01111111;
                default: anodes <= 8'b11111111;
                endcase
            end
            else
                anodes <= 8'b11111111;
        end // end if (ERROR == 0)
        else begin
            if (current_number_digit <= 4) begin
                case(current_number_digit)
                0: cathodes <= 8'b11001101; // r
                1: cathodes <= 8'b11000000; // 0
                2: cathodes <= 8'b11001101; // r
                3: cathodes <= 8'b11001101; // r
                4: cathodes <= 8'b10000110; // E
                endcase

                case(current_number_digit)
                4'h0: anodes <= 8'b11111110;
                4'h1: anodes <= 8'b11111101;
                4'h2: anodes <= 8'b11111011;
                4'h3: anodes <= 8'b11110111;
                4'h4: anodes <= 8'b11101111;
                endcase
            end
            else
                anodes <= 8'b11111111;
        end // end if (ERROR == 1)
    end // end always@(posedge clk)

    param_counter #(.UPPER_BOUND(8)) 
        counter(.clk(clk), .rst(1'b0), .cnt(current_number_digit));
endmodule
