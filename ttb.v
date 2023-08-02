`include "test.v"
`default_nettype none

module tb_lottery;
reg clk;
reg reset;
reg luckybit, write;
reg stop;
wire [4:0] winner, id;
wire [31:0] lucky_queue;
wire full;

lottery dut ( .clk(clk), .reset(reset), .luckybit(luckybit), .write(write), .stop(stop), .winner(winner), .id(id), .full(full) );

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin
    $dumpfile("test.vcd");
    $dumpvars(0, tb_lottery);
end

initial begin
    reset = 1;
    stop = 0;
    write = 0;
    #10 reset = 0;

    for (integer k  = 0; k<36 ; k=k+1 ) begin
        luckybit = $random%2;
        #5 write = 1;
        #7 write = 0;
    end 

    #5 stop = 1;
    #5 $finish;
end

endmodule
`default_nettype wire