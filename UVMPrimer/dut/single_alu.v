module single_alu(
  input clk,
  input rst_n,
  input [7:0] A,
  input [7:0] B,
  input [2:0] op,
  input start,
  output done,
  output [15:0] result
);

reg[15:0] result_r;
reg done_r;

assign result = result_r;
assign done = done_r;

always@(posedge clk ) begin //synchronize
  if(rst_n == 1'b0) begin
    result_r <= 'b0; 
  end
  else begin
    if(start == 1'b1) begin
      case(op)
        3'b001:result_r <= A+B;
        3'b010:result_r <= A&B;
        3'b011:result_r <= A^B;
        default: result_r <= 'b0;
      endcase
    end
  end
  $display("@ %0t : [single alu] result is %d !!!",$time,result_r);
end

always @(posedge clk or negedge rst_n) begin
  if(rst_n == 1'b0) done_r <= 1'b0;
  else begin
    if(start==1'b1 && op != 3'b000) begin
      done_r <= 1'b1;
    end
    else done_r <= 1'b0;
  end
end

endmodule
