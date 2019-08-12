

class fmt_ini_mon;
   fmt_ini_trans trans;
   event reset_e; 
   mailbox #(fmt_ini_trans) ini_mb;

   virtual interface fmt_ini_if vif;

   task run();
    fork
      forever begin
        mon_trans();
        put_trans();
      end
      mon_reset(); 
    join_none
  endtask

  task mon_trans();
    forever begin
      @(posedge vif.clk iff vif.rstn);
      if(vif.mon.a2f_val === 1 && vif.mon.f2a_ack === 1) begin
        trans = new();
        case(vif.mon.a2f_id)
          0: trans.length = trans.dec_length(vif.mon.slv0_len);
          1: trans.length = trans.dec_length(vif.mon.slv1_len);
          2: trans.length = trans.dec_length(vif.mon.slv2_len);
          3: $error("fmt_ini_mon:: a2f_id value is not as expected");
        endcase
        trans.id = vif.mon.a2f_id;
        trans.data = vif.mon.a2f_dat;
        break;
      end
    end
  endtask

  task put_trans();
    ini_mb.put(trans);
  endtask

  task mon_reset();
    forever begin
      @(negedge vif.rstn);
      -> reset_e;
    end
  endtask
endclass
