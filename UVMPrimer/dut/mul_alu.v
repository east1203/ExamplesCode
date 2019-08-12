module mul_alu(
  input clk,
  input rst_n,
  input [7:0] A,
  input [7:0] B,
  input start,
  output done,
  output [15:0] result
);

reg done_r,done1,done2,done3;
reg [15:0] result_r,mul1,mul2;
reg [7:0] a,b;

assign done = done_r;
assign result = result_r;

always@(posedge clk or negedge rst_n) begin
  if(rst_n <= 1'b0) begin
    done_r <= 'b0;
    done1 <= 'b0 ; 
    done2 <= 'b0 ;
    done3 <= 'b0 ;

    mul1 <= 'b0;
    mul2 <= 'b0;
    result_r <= 'b0;
    a<=0;
    b<=0;
  end
  else begin
    a <= A;
    b <= B;
    mul1 <= a*b;
    mul2 <= mul1;
    result_r <= mul2;
    done3 <= start && (~done_r);
    done2 <= done3 && (~done_r);
    done1 <= done2 && (~done_r);
    done_r <= done1 &&(~done_r);
  end
 // $display("@ %0t : [mul alu] result is %d !!!",$time,result_r);
end

endmodule
