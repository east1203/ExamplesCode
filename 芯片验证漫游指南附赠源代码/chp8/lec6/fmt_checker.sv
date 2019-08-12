

class fmt_checker;
  bit en_chk_rst=1;
  bit en_chk_data=1;
  bit en_chk_len=1;

  virtual interface fmt_ini_if ini_vif;
  virtual interface fmt_rsp_if rsp_vif;

  event reset_e;
  event req_trans_e;

  mailbox #(fmt_ini_trans) ini_mb;
  mailbox #(fmt_rsp_trans) rsp_mb;
  mailbox #(fmt_rsp_trans) exp_mb;

  function new();
    ini_mb = new();
    rsp_mb = new();
    exp_mb = new();
  endfunction

  task run();
    fork
      ini2rsp_fmt();
      chk_rst();
      chk_data();
      chk_len();
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
        exp_mb.get(exp);
      join
      if(rsp.compare(exp) == 1)
        $display("fmt_checker:: data compared succeeded!");
      else 
        $error("fmt_checker:: data compared failed!");
    end
  endtask

  task ini2rsp_fmt();
    fmt_ini_trans s;
    fmt_rsp_trans t;
    forever begin
      ini_mb.get(s);
      t = new();
      t.id = s.id;
      t.length = s.length;
      t.data_q.push_back(s.data);
      repeat(t.length - 1) begin
        ini_mb.get(s);
        if(t.id != s.id)
          $error("fmt_checker:: data input id is changed!");
        t.data_q.push_back(s.data);
      end
      exp_mb.put(t);
    end
  endtask


  task chk_len();
    int length;
    forever begin
      @req_trans_e;
      if(en_chk_len == 1) begin
        case(rsp_vif.mon.fmt_chid)
          0: length = fmt_ini_trans::dec_length(ini_vif.mon.slv0_len);
          1: length = fmt_ini_trans::dec_length(ini_vif.mon.slv1_len);
          2: length = fmt_ini_trans::dec_length(ini_vif.mon.slv2_len);
          default: $error("fmt_checker:: id value is unexpected");
        endcase
        if(length != rsp_vif.mon.fmt_length)
          $error("fmt_checker:: output length is not as the value configured");
      end
    end
  endtask

  task connect();
  endtask

endclass
