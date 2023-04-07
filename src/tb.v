`timescale 1ns / 1ps

module tb();


reg clk100mhz,
    enter,
    reset,
    confirm;
reg [3:0] switches;

wire [7:0] anodes;
wire [7:0] cathodes;


initial begin
    $dumpfile("dump.vcd");
    $dumpvars;

    clk100mhz = 0;
    enter = 0;
    reset = 0;
    confirm = 0;
    switches = 0;
    #20;
    switches = 15;
    enter = 1;

    #400; enter = 0; #400;

    switches = 13;
    enter = 1;

    #400; enter = 0; #400;

    switches = 6;
    enter = 1;

    #400; enter = 0; #400;

    switches = 12;
    enter = 1;

    #400; enter = 0; #400;

    confirm = 1;

    #1000;

    reset = 1;

    #700;

    switches = 0;
    enter = 1;

    #400; enter = 0; #400;

    switches = 1;
    enter = 1;

    #400; enter = 0; #400;

    switches = 11;
    enter = 1;

    #400; enter = 0; #400;

    switches = 10;
    enter = 1;

    #400; enter = 0; confirm = 0; #400;

    confirm = 1;

    #2000;

    switches = 8;
    enter = 1;

    #400; enter = 0; #400;

    switches = 0;
    enter = 1;

    #400; enter = 0; #400;

    switches = 0;
    enter = 1;

    #400; enter = 0; #400;

    switches = 0;
    enter = 1;

    #400; enter = 0; confirm = 0; #400;

    confirm = 1;
    #2000;
    $finish;

end

always #10 clk100mhz = ~clk100mhz;
top UUT(

    .switches(switches),
    .anodes(anodes),
    .cathodes(cathodes),

    .clk100mhz(clk100mhz),
    .enter(enter),
    .reset(reset),
    .confirm(confirm)
);

endmodule
