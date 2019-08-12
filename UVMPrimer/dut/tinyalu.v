module tinyalu(
  input clk,
  input reset_n,
  input [7:0] A,
  input [7:0] B,
  input [2:0] op,
  input start,
  output done,
  output [15:0] result
);

wire [15:0] result_sgl,result_mul;
reg start_sgl,start_mul;
wire done_sgl,done_mul;
reg done_r;
reg [15:0] result_r;

assign done = done_r;
assign result = result_r;

single_alu sgl_u(.clk(clk),.rst_n(reset_n),.A(A),.B(B),.op(op),
.start(start_sgl),.done(done_sgl),.result(result_sgl));

mul_alu mul_u(.clk(clk),.rst_n(reset_n),.A(A),.B(B),.start(start_mul),
.done(done_mul),.result(result_mul));

always@(op[2],start) begin
  case(op[2])
    1: begin
      start_mul = start;
      start_sgl = 0;
    end
    0: begin
      start_mul =0;
      start_sgl = start;
    end
  endcase
end

always@(op[2],result_mul,result_sgl) begin
  case(op[2])
    1: begin
      result_r = result_mul;
    end
    0: begin
      result_r = result_sgl;
    end
    default result_r = 0;
  endcase
end
always@(op[2],done_mul,done_sgl) begin
  case(op[2])
    1: begin
      done_r = done_mul;
    end
    0: begin
      done_r = done_sgl;
    end
    default done_r = 0;
  endcase
end
endmodule
