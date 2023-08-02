module lottery (
    input clk, input reset, input luckybit, input write, input stop,
    output [4:0] winner, output [4:0] id, output full
);

reg [31:0] lucky_queue;
reg full = 1'b0;
reg [4:0] id = 5'b0;
reg [4:0] winner = 5'bx;
reg [4:0] data;

always @(posedge write or reset) begin
    if (reset == 1) begin
        lucky_queue = 32'b0;
        id = 5'b0;
    end
    else if(id < 31) begin
        lucky_queue[id] = luckybit;
        id = id + 1;
    end
    else begin
        full = 1;
    end
end

always @(posedge clk or reset) begin
    if (reset == 1) begin
        winner = 5'bx;
    end
    else if (data != 5'b0 && (stop || full)) begin
        winner = data;
    end
end

reg [4:0] data_next;

always @(*) begin
  data_next[4] = data[4]^data[1];
  data_next[3] = data[3]^data[0];
  data_next[2] = data[2]^data_next[4];
  data_next[1] = data[1]^data_next[3];
  data_next[0] = data[0]^data_next[2];
end

always @(posedge clk or reset)
  if(reset || id<5 || data == 5'b0)
    data <= {lucky_queue[$random%id], lucky_queue[$random%id], lucky_queue[$random%id], lucky_queue[$random%id], lucky_queue[$random%id]};
  else if(!(stop || full))
    data <= data_next;
    
endmodule