module reg_mod_tb2;

logic        clk_s;
logic        rstn_s;
logic [ 1:0] cmd_s;
logic [ 7:0] cmd_addr_is;
logic [31:0] cmd_data_i_s;
logic [31:0] cmd_data_o_s;
logic [ 7:0] slv0_avail_s;
logic [ 7:0] slv1_avail_s;
logic [ 7:0] slv2_avail_s;
logic [ 2:0] slv0_len_s;
logic [ 2:0] slv1_len_s;
logic [ 2:0] slv2_len_s;
logic [ 1:0] slv0_prio_s;
logic [ 1:0] slv1_prio_s;
logic [ 1:0] slv2_prio_s;
logic        slv0_en_s;
logic        slv1_en_s;
logic        slv2_en_s;

logic [ 8:0] reg2fmt_s;
logic [ 8:0] reg2arb_s;;

// typedef struct {
//   logic [2:0] slv0_prio;
//   logic [2:0] slv1_prio;
//   logic [2:0] slv2_prio;
// } reg2fmt_t;
// 
// reg2fmt_t reg2fmt_s;


ctrl_regs4 regs4_inst(
  .clk_i        (clk_s       ), 
  .rstn_i       (rstn_s      ), 
  .cmd_i        (cmd_s       ), 
  .cmd_addr_i   (cmd_addr_is ), 
  .cmd_data_i   (cmd_data_i_s), 
  .cmd_data_o   (cmd_data_o_s), 
  .slv0_avail_i (slv0_avail_s), 
  .slv1_avail_i (slv1_avail_s), 
  .slv2_avail_i (slv2_avail_s), 
  .reg2fmt_o    (reg2fmt_s   ),
  .reg2arb_o    (reg2arb_s   ),
  .slv0_en_o    (slv0_en_s   ), 
  .slv1_en_o    (slv1_en_s   ), 
  .slv2_en_o    (slv2_en_s   ) 
);


endmodule: reg_mod_tb2
