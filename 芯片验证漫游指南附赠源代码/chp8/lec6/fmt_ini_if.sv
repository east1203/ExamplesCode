

interface fmt_ini_if(input clk, input rstn);
  logic        a2f_val;
  logic [1:0]  a2f_id;
  logic [31:0] a2f_dat;
	logic [2:0]  slv0_len;
	logic [2:0]  slv1_len;
	logic [2:0]  slv2_len;
  logic        f2a_ack;

  bit en_chk_prot=1;

  clocking mon @(posedge clk);
    default input #1step output #1ps;
    input a2f_val;
    input a2f_id;
    input a2f_dat;
    input f2a_ack;
	  input slv0_len;
	  input slv1_len;
	  input slv2_len;
  endclocking

  initial begin: chk_val_ack
    forever begin
      @(posedge clk iff rstn && en_chk_prot);
      if(mon.f2a_ack === 1 && mon.a2f_val === 0)
        $error("fmt_ini_mon::[protocol error] valid is not 1 when ack is 1!");
    end
  end

endinterface
