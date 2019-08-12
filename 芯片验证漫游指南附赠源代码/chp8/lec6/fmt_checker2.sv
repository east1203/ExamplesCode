
class fmt_refmod;
  mailbox #(fmt_ini_trans) ini_mb;
  mailbox #(fmt_rsp_trans) exp_mb;

  event req_trans_e;

  virtual interface fmt_ini_if ini_vif;
  virtual interface fmt_rsp_if rsp_vif;

  function new();
    ini_mb = new();
    exp_mb = new();
  endfunction

  task run();
    fork
    ini2rsp_fmt();
    join_none
  endtask

  task ini2rsp_fmt();
    fmt_ini_trans s;
    fmt_rsp_trans t;
    int len;
    forever begin
      @(req_trans_e);
      ini_mb.get(s);
      t = new();
      t.id = s.id;
      case(rsp_vif.mon.fmt_chid)
          0: len = fmt_ini_trans::dec_length(ini_vif.mon.slv0_len);
          1: len = fmt_ini_trans::dec_length(ini_vif.mon.slv1_len);
          2: len = fmt_ini_trans::dec_length(ini_vif.mon.slv2_len);
          default: $error("fmt_checker:: id value is unexpected");
      endcase
      t.length = len;
      repeat(len - 1) begin
        ini_mb.get(s);
        if(t.id != s.id)
          $error("fmt_checker:: data input id is changed!");
        t.data_q.push_back(s.data);
      end
      exp_mb.put(t);
    end
  endtask

endclass


class fmt_checker;
  bit en_chk_rst=1;
  bit en_chk_data=1;
  bit en_chk_len=1;

  fmt_refmod refmod;

  virtual interface fmt_ini_if ini_vif;
  virtual interface fmt_rsp_if rsp_vif;

  event reset_e;
  event req_trans_e;

  mailbox #(fmt_ini_trans) ini_mb;
  mailbox #(fmt_rsp_trans) rsp_mb;
  mailbox #(fmt_rsp_trans) exp_mb;

  function new();
    rsp_mb = new();
    refmod = new();
  endfunction


  task run();
    fork
      chk_rst();
      chk_data();
      refmod.run();
    join_none
  endtask

  task chk_rst();
    forever begin
      @reset_e;
      if(en_chk_rst == 1) begin
        if(ini_vif.f2a_ack !== 0
           || rsp_vif.fmt_chid !== 0
           || rsp_vif.fmt_length !== 0
           || rsp_vif.fmt_req !== 0
           || rsp_vif.fmt_data !== 0
           || rsp_vif.fmt_start !== 0
           || rsp_vif.fmt_end !== 0)
           $error("fmt_checker:: reset value is not correct!");
      end
    end
  endtask

  task chk_data();
    fmt_rsp_trans exp, rsp;
    forever begin
      wait(en_chk_data == 1);
      fork
        rsp_mb.get(rsp);
        refmod.exp_mb.get(exp);
      join
      if(rsp.compare(exp) == 1)
        $display("fmt_checker:: data compared succeeded!");
      else 
        $error("fmt_checker:: data compared failed!");
    end
  endtask

  task connect();
    refmod.ini_vif = ini_vif;
    refmod.rsp_vif = rsp_vif;
    refmod.req_trans_e = req_trans_e;
    ini_mb = refmod.ini_mb;
    exp_mb = refmod.exp_mb;
  endtask
endclass
