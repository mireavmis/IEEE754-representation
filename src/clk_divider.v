module clk_divider #(parameter DIV=2)
    (input clk, input rst, output reg divided_clk);

wire [$clog2(DIV)-1:0] cnt;
initial begin
    divided_clk <= 0;
end

always@(posedge clk) begin
    divided_clk <= (cnt < DIV / 2) ? 1'b1 : 1'b0;
end

param_counter #(.STEP(1), .UPPER_BOUND(DIV))
        counter(.clk(clk),
                .rst(rst),
                .cnt(cnt));

endmodule

