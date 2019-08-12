module reg_mod_tb1;

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

// ctrl_regs2 regs2_inst(
//   .clk_i        (clk_s       ), 
//   .rstn_i       (rstn_s      ), 
//   .cmd_i        (cmd_s       ), 
//   .cmd_addr_i   (cmd_addr_is ), 
//   .cmd_data_i   (cmd_data_i_s), 
//   .cmd_data_o   (cmd_data_o_s), 
//   .slv0_avail_i (slv0_avail_s), 
//   .slv1_avail_i (slv1_avail_s), 
//   .slv2_avail_i (slv2_avail_s), 
//   .slv0_len_o   (slv0_len_s  ), 
//   .slv1_len_o   (slv1_len_s  ), 
//   .slv2_len_o   (slv2_len_s  ), 
//   .slv0_prio_o  (slv0_prio_s ), 
//   .slv1_prio_o  (slv1_prio_s ), 
//   .slv2_prio_o  (slv2_prio_s ), 
//   .slv0_en_o    (slv0_en_s   ), 
//   .slv1_en_o    (slv1_en_s   ), 
//   .slv2_en_o    (slv2_en_s   ) 
// );

ctrl_regs5 #(.addr_width(16))
regs5_inst(
  .clk_i        (clk_s       ), 
  .rstn_i       (rstn_s      ), 
  .cmd_i        (cmd_s       ), 
  .cmd_addr_i   (cmd_addr_is ), 
  .cmd_data_i   (cmd_data_i_s), 
  .cmd_data_o   (cmd_data_o_s), 
  .slv0_avail_i (slv0_avail_s), 
  .slv1_avail_i (slv1_avail_s), 
  .slv2_avail_i (slv2_avail_s), 
  .slv0_len_o   (slv0_len_s  ), 
  .slv1_len_o   (slv1_len_s  ), 
  .slv2_len_o   (slv2_len_s  ), 
  .slv0_prio_o  (slv0_prio_s ), 
  .slv1_prio_o  (slv1_prio_s ), 
  .slv2_prio_o  (slv2_prio_s ), 
  .slv0_en_o    (slv0_en_s   ), 
  .slv1_en_o    (slv1_en_s   ), 
  .slv2_en_o    (slv2_en_s   ) 
);



ctrl_regs5 #(.addr_width(16))
regs5_inst(
  .clk_i        (clk_s       ), 
  .rstn_i       (rstn_s      ), 
  .cmd_i        (cmd_s       ), 
  .cmd_addr_i   (cmd_addr_is ), 
  .cmd_data_i   (cmd_data_i_s), 
  .cmd_data_o   (cmd_data_o_s), 
  .slv0_avail_i (slv0_avail_s), 
  .slv1_avail_i (slv1_avail_s), 
  .slv2_avail_i (slv2_avail_s), 
  .slv0_len_o   (slv0_len_s  ), 
  .slv1_len_o   (slv1_len_s  ), 
  .slv2_len_o   (slv2_len_s  ), 
  .slv0_prio_o  (slv0_prio_s ), 
  .slv1_prio_o  (slv1_prio_s ), 
  .slv2_prio_o  (slv2_prio_s ), 
  .slv0_en_o    (slv0_en_s   ), 
  .slv1_en_o    (slv1_en_s   ), 
  .slv2_en_o    (slv2_en_s   ) 
);




endmodule: reg_mod_tb1
