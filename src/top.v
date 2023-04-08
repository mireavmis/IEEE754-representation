module top(
    input clk100mhz,
    input enter,
    input reset,
    input confirm,

    input [3:0] switches,
    output [7:0] anodes,
    output [7:0] cathodes
);

wire clk100khz;

wire enter_sync,
     reset_sync,
     confirm_sync;

wire enter_sync_enable, 
     reset_sync_enable,
     confirm_sync_enable;

wire [31:0] numb;
reg [31:0] REG_NUMB;

reg [31:0] REG_SHOW;

wire [7:0] MASK;
reg [7:0] REG_MASK;

reg REG_R_I;
reg REG_R_O;
reg REG_RESET_FSM;

wire R_O;
wire [15:0] RES;

reg REG_ERROR;
wire ERROR;

initial begin
    REG_ERROR     = 0;
    REG_MASK      = 0;
    REG_RESET_FSM = 0;
    REG_R_O       = 0;
    REG_R_I       = 0;
    REG_NUMB      = 0;
    REG_SHOW      = 0;

end

// take input
always@(posedge clk100mhz) begin
    if (confirm_sync_enable)
        REG_R_I <= 1;
    else
        REG_R_I <= 0;
end

// control output
always@(posedge clk100mhz) begin
    if (R_O) begin
        REG_SHOW <= 0;
        REG_R_O <= 1;
        REG_SHOW[15:0] <= RES;
    end
    else if (REG_R_O == 0)
        REG_SHOW <= REG_NUMB;
    else
        REG_SHOW <= REG_SHOW;
end

// handle ERROR state
always@(posedge clk100mhz) begin
    if (ERROR)
        REG_ERROR <= 1;
    else
        REG_ERROR <= REG_ERROR;
end


//handle reset
always@(posedge clk100mhz) begin
    if (reset_sync_enable) begin
        REG_ERROR     <= 0;
        REG_SHOW      <= 0;
        REG_R_I       <= 0;
        REG_R_O       <= 0;
        REG_RESET_FSM <= 1;
    end
    else
        REG_RESET_FSM <= 0;
end

always@(posedge clk100mhz)
    REG_NUMB <= numb;

always@(posedge clk100mhz)
    if (REG_R_O)
        REG_MASK <= 8'b11110000;
    else 
        REG_MASK <= MASK;

debouncer confirm_debouncer(
    
    .clock_enable      (1'b1               ),
    .in_signal         (confirm            ),

    .out_signal        (confirm_sync       ),
    .out_signal_enable (confirm_sync_enable),

    .clk               (clk100mhz          )
);
debouncer enter_debouncer(
    
    .clock_enable      (1'b1             ),
    .in_signal         (enter            ),

    .out_signal        (enter_sync       ),
    .out_signal_enable (enter_sync_enable),

    .clk               (clk100mhz        )
);

debouncer resest_debouncer(
    
    .clock_enable      (1'b1             ),
    .in_signal         (reset            ),

    .out_signal        (reset_sync       ),
    .out_signal_enable (reset_sync_enable),

    .clk               (clk100mhz        )
);

clk_divider #(
    .DIV(1000) // change to 1000
)
clk_divider_100khz(
    
    .divided_clk (clk100khz),

    .clk         (clk100mhz),
    .rst         (1'b0     )
);

shift_reg shift_reg_inst(

    .switches (switches  ),
    .NUMB     (numb      ),
    .MASK     (MASK      ),

    .clk      (clk100mhz ),
    .reset    (reset_sync_enable),
    .enter    (enter_sync_enable)
);

segment_controller controller(

    .NUMB     (REG_SHOW ),
    .MASK     (MASK     ),
    .anodes   (anodes   ),
    .cathodes (cathodes ),

    .clk      (clk100khz),
    .ERROR    (REG_ERROR)
);

fsm fsm_inst(

    .dataIn    (numb[15:0]   ),
    .R_I       (REG_R_I      ),

    .REG_ERROR (ERROR        ),
    .dataOut   (RES          ),
    .R_O       (R_O          ),

    .reset     (REG_RESET_FSM),
    .clk       (clk100mhz    )
);


endmodule
