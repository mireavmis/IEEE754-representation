`timescale 1ns / 1ps

module param_counter #(
    parameter STEP = 1,
    parameter UPPER_BOUND = 65536)(
    input clk, input rst,
    output reg [$clog2(UPPER_BOUND)-1:0] cnt
    );
    
    initial 
        cnt <= 0;
        
    always@(posedge clk) begin
        if (rst)
            cnt <= 0;
        else
            cnt <= (cnt + STEP) % UPPER_BOUND;
    end
    
endmodule
