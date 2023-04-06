module ssi(
    input clk100mhz,
    input enter,
    input reset,
    input ERROR,

    input [3:0] switches,
    output [7:0] anodes,
    output [7:0] cathodes
);
    
wire enter_sync, reset_sync;
wire enter_sync_enable, reset_sync_enable;
wire [31:0] numb;

wire clk100khz;
wire [7:0] MASK;

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
    .DIV(10) // change to 1000
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

    .NUMB     (numb     ),
    .MASK     (MASK     ),
    .anodes   (anodes   ),
    .cathodes (cathodes ),

    .clk      (clk100khz),
    .ERROR    (ERROR    )
);


endmodule

