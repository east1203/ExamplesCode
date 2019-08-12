
class slv_rsp_mon;

  slv_trans trans;
  virtual interface slv_rsp_if vif;

  task run();
    forever begin
      mon_trans();
      put_trans();
    end
  endtask

  task mon_trans();
    forever begin
     @(posedge vif.clk iff vif.rstn);
     if(vif.ck_mon.req === 1 && vif.ck_mon.ack === 1) begin
       trans = new();
       trans.data = vif.ck_mon.data;
       break;
     end
    end
  endtask

  function void put_trans();
    vif.put_trans(trans);
  endfunction 
endclass

