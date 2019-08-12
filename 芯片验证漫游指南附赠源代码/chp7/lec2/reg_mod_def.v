
// definition type1
module ctrl_regs1(clk_i,rstn_i,
                cmd_i,cmd_addr_i,cmd_data_i,cmd_data_o,
								slv0_len_o,slv1_len_o,slv2_len_o,
								slv0_prio_o,slv1_prio_o,slv2_prio_o,
								slv0_avail_i,slv1_avail_i,slv2_avail_i,
								slv0_en_o,slv1_en_o,slv2_en_o);
input clk_i,rstn_i;
input [1:0] cmd_i;
input [7:0]cmd_addr_i; 
input [31:0]  cmd_data_i;
output [31:0] cmd_data_o;
input [7:0] slv0_avail_i,slv1_avail_i,slv2_avail_i;
output [2:0] slv0_len_o,slv1_len_o,slv2_len_o;
output [1:0] slv0_prio_o,slv1_prio_o,slv2_prio_o;
output slv0_en_o,slv1_en_o,slv2_en_o;


endmodule



// definition type2
module ctrl_regs2(
  input clk_i,
  input rstn_i,
  input [1:0] cmd_i,
  input [7:0]cmd_addr_i, 
  input [31:0]  cmd_data_i,
  output [31:0] cmd_data_o,
  input [7:0] slv0_avail_i,
  input [7:0] slv1_avail_i,
  input [7:0] slv2_avail_i,
  output [2:0] slv0_len_o,
  output [2:0] slv1_len_o,
  output [2:0] slv2_len_o,
  output [1:0] slv0_prio_o,
  output [1:0] slv1_prio_o,
  output [1:0] slv2_prio_o,
  output slv0_en_o,
  output slv1_en_o,
  output slv2_en_o
);


endmodule


// definition type5
module ctrl_regs5
#(parameter int addr_width = 8,
  parameter int data_width = 32)
(
  input [addr_width-1:0]cmd_addr_i, 
  input [data_width-1:0]  cmd_data_i,
  output [data_width:0] cmd_data_o
);


endmodule

// definition type6
`define ADDR_WIDTH 6
`define DATA_WIDTH 32

module ctrl_regs6
(
  input [`ADDR_WIDTH-1:0]cmd_addr_i, 
  input [`DATA_WIDTH-1:0]  cmd_data_i,
  output [`DATA_WIDTH:0] cmd_data_o
);


endmodule




