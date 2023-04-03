module fsm(
    input [15:0] dataIn,
    input R_I,
    input reset,
    input clk,
    output [15:0] dataOut,
    output reg R_O
);

parameter S0 = 0,
          S1 = 1,
          S2 = 2,
          S3 = 3,
          S4 = 4,
          S5 = 5,
          S6 = 6;

reg [3:0] state, new_state;
reg [15:0] REG_IN, REG_RES;
reg [16:0] REG_TMP;
reg REG_ERROR;
reg REG_SIGN;

integer i, j, point;

initial begin
    state     = S0;
    new_state = 0;
    REG_RES   = 0;
    REG_IN    = 0;
    REG_TMP   = 0;
    REG_SIGN  = 0;
    REG_ERROR = 0;
    i         = 0;
    j         = 0;
    point     = 0;

    R_O       = 0;
end

always@(posedge clk) begin
    
    if (reset)
        state <= S0;
    else
        state <= new_state;
end

always@(posedge clk) begin

    case(state)
        S0: begin
            R_O       <= 0;
            REG_IN    <= 0;
            REG_RES   <= 0;
            REG_TMP   <= 0;
            REG_SIGN  <= 0;
            REG_ERROR <= 0;
            
            new_state <= S1;
        end
        S1: begin
            if (R_I) begin
                REG_IN <= dataIn;

                new_state <= S2;
            end
        end
        S2: begin
            REG_SIGN = REG_IN[15];
            REG_TMP  <= REG_IN;

            if (REG_SIGN)
                new_state <= S3;
            else
                new_state <= S4;
        end
        S3: begin
            REG_TMP     = ~REG_TMP;
            REG_TMP[16] = 0;
            REG_TMP     = REG_TMP + 1;

            new_state <= S4;
        end
        S4: begin
            if (REG_TMP > 2048)
                new_state <= S5;
            else
                new_state <= S6;
        end
        S5: begin
            REG_ERROR <= 1;
            
            new_state <= S0;
        end
        S6: begin
            for (i = 0; i < 11; i = i + 1) begin
                if (REG_TMP[i] == 1)
                    point = i;
                else
                    point = point;
            end

            REG_RES[15] <= REG_SIGN;
            REG_RES[14:10] <= 15 + point;
            case(point)
                0:  for (j = 0; j < 2; j = j + 1)  REG_RES[9-j] <= REG_TMP[j];
                1:  for (j = 0; j < 2; j = j + 1)  REG_RES[9-j] <= REG_TMP[j];
                2:  for (j = 0; j < 2; j = j + 1)  REG_RES[9-j] <= REG_TMP[j];
                3:  for (j = 0; j < 3; j = j + 1)  REG_RES[9-j] <= REG_TMP[j];
                4:  for (j = 0; j < 4; j = j + 1)  REG_RES[9-j] <= REG_TMP[j];
                5:  for (j = 0; j < 5; j = j + 1)  REG_RES[9-j] <= REG_TMP[j];
                6:  for (j = 0; j < 6; j = j + 1)  REG_RES[9-j] <= REG_TMP[j];
                7:  for (j = 0; j < 7; j = j + 1)  REG_RES[9-j] <= REG_TMP[j];
                8:  for (j = 0; j < 8; j = j + 1)  REG_RES[9-j] <= REG_TMP[j];
                9:  for (j = 0; j < 9; j = j + 1)  REG_RES[9-j] <= REG_TMP[j];
                10: for (j = 0; j < 10; j = j + 1) REG_RES[9-j] <= REG_TMP[j];
            endcase

            R_O <= 1;

            new_state <= S0;
        end
    endcase
end

assign dataOut = REG_RES;


endmodule

