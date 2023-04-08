module debouncer (
    input clk, input clock_enable, input in_signal,
    output out_signal, output out_signal_enable
    );

    localparam UPPER_BOUND = 16;
    
    wire rst, tmp;
    
    wire synch;
    synchronizer synchronizer_inst(.d(in_signal), .clk(clk), .out(synch));
    
    reg out_signal_reg        = 0;
    reg out_signal_enable_reg = 0;
    
    
    wire [$clog2(UPPER_BOUND):0] streak;
    param_counter #(.UPPER_BOUND(UPPER_BOUND))
        counter(.clk(clk), .rst(rst), .cnt(streak));
    
    assign out_signal_enable = out_signal_enable_reg;
    assign out_signal = out_signal_reg;
    
    
    assign tmp = (streak == UPPER_BOUND-1) && clock_enable;
    assign rst = synch ~^ out_signal_reg;
    
    
    always @(posedge clk) begin
        out_signal_enable_reg <= tmp & synch;
        if (tmp)
            out_signal_reg <= synch;
        else
            out_signal_reg <= out_signal_reg;
    end
endmodule
