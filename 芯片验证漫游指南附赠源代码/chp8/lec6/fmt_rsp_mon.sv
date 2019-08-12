

class fmt_rsp_mon;
   fmt_rsp_trans trans;
   event req_trans_e;
   mailbox #(fmt_rsp_trans) rsp_mb;
   virtual interface fmt_rsp_if vif;


   task run();
    fork
      forever begin
        mon_trans();
        put_trans();
      end
      mon_req_trans();
    join_none
  endtask


  task mon_trans();
    forever begin
      @(posedge vif.clk iff vif.rstn);
      if(vif.mon.fmt_start === 1) begin
        trans = new();
        trans.length = vif.mon.fmt_length;
        trans.id = vif.mon.fmt_chid;
        repeat(trans.length) begin
          trans.data_q.push_back(vif.mon.fmt_data);
          @(posedge vif.clk);
        end
        break;
      end
    end
  endtask

  task put_trans();
    rsp_mb.put(trans);
  endtask

  task mon_req_trans();
    forever begin
      @(posedge vif.mon.fmt_req iff vif.rstn);
        -> req_trans_e;
    end
  endtask

  task chk_protocol();
//    forever begin: chk_req_grant
//      @(posedge vif.clk iff vif.rstn && en_chk_prot);
//      if($rose(vif.mon.fmt_grant, @(posedge vif.clk))) begin
//        @(posedge vif.clk);
//        if(vif.mon.fmt_req !== 0)
//          $error("fmt_rsp_mon::[protocol error] req should be 0 after 1 cyle when grant rose to 1");
//      end
//    end
//    forever begin: chk_stable_id_length
//      int id, len;
//      @(posedge vif.clk iff vif.rstn && en_chk_prot);
//      if($rose(vif.mon.fmt_req, @(posedge vif.clk))) begin
//        id = vif.mon.fmt_id;
//        len = vif.mon.fmt_length;
//        @(posedge vif.clk iff $rose(vif.mon.fmt_end, @(posedge vif.clk)));
//        if(id != vif.mon.fmt_id || len != vif.mon.fmt_length)
//          $error("fmt_rsp_mon::[protocol error] id and length is not valud within a packet transaction");
//      end
//    end
//    forever begin: chk_grant_start
//      @(posedge vif.clk iff vif.rstn && en_chk_prot);
//      if($rose(vif.mon.fmt_grant, @(posedge vif.clk))) begin
//        @(posedge vif.clk);
//        if(vif.mon.fmt_start !== 1)
//          $error("fmt_rsp_mon::[protocol error] start should be 1 after 1 cyle when grant rose to 1");
//      end
//    end
//    forever begin: chk_start_pulse
//      @(posedge vif.clk iff vif.rstn && en_chk_prot);
//      if($rose(vif.mon.fmt_start, @(posedge vif.clk))) begin
//        @(posedge vif.clk);
//        if(vif.mon.fmt_start !== 0)
//          $error("fmt_rsp_mon::[protocol error] start should be raised as 1 cycle pulse");
//      end
//    end
//    forever begin: chk_end_pulse
//      @(posedge vif.clk iff vif.rstn && en_chk_prot);
//      if($rose(vif.mon.fmt_end, @(posedge vif.clk))) begin
//        @(posedge vif.clk);
//        if(vif.mon.fmt_end !== 0)
//          $error("fmt_rsp_mon::[protocol error] end should be raised as 1 cycle pulse");
//      end
//    end
//    forever begin: chk_packet_len
//      int len;
//      @(posedge vif.clk iff vif.rstn && en_chk_prot);
//      if($rose(vif.mon.fmt_start, @(posedge vif.clk))) begin
//        len = vif.mon.fmt_length;
//        repeat(len - 1) @(posedge vif.clk);
//        if(!$rose(vif.mon.fmt_end, @(posedge vif.clk)))
//          $error("fmt_rsp_mon::[protocol error] number of transferred data not equals to length ");
//      end
//    end
  endtask

endclass
