

interface regs_rsp_if;

  logic        clk;
  logic        rstn;
  logic [ 7:0] slv0_avail;
  logic [ 7:0] slv1_avail;
  logic [ 7:0] slv2_avail;
  logic [ 2:0] slv0_len;
  logic [ 2:0] slv1_len;
  logic [ 2:0] slv2_len;
  logic [ 1:0] slv0_prio;
  logic [ 1:0] slv1_prio;
  logic [ 1:0] slv2_prio;
  logic        slv0_en;
  logic        slv1_en;
  logic        slv2_en;

  modport dut(
    input slv0_avail, slv1_avail, slv2_avail,
          slv0_len, slv1_len, slv2_len,
          slv0_prio, slv1_prio, slv2_prio,
          slv0_en, slv1_en, slv2_en
  );

  modport stim(
    output slv0_avail, slv1_avail, slv2_avail,
           slv0_len, slv1_len, slv2_len,
           slv0_prio, slv1_prio, slv2_prio,
           slv0_en, slv1_en, slv2_en
  );

  modport mon(
    input slv0_avail, slv1_avail, slv2_avail,
          slv0_len, slv1_len, slv2_len,
          slv0_prio, slv1_prio, slv2_prio,
          slv0_en, slv1_en, slv2_en
  );

endinterface: regs_rsp_if
