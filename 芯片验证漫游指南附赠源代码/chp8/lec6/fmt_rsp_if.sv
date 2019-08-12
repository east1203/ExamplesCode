

interface fmt_rsp_if(input clk, input rstn);

  logic       fmt_grant;
  logic[1:0]  fmt_chid;                  
  logic[4:0]  fmt_length;                  
  logic       fmt_req;
  logic[31:0] fmt_data;
  logic       fmt_start;
  logic       fmt_end;

  bit en_chk_prot = 1;

  clocking mon @(posedge clk);
    default input #1step output #1ps;
    input fmt_grant;
    input fmt_chid;                  
    input fmt_length;                  
    input fmt_req;
    input fmt_data;
    input fmt_start;
    input fmt_end;
  endclocking


  initial begin: chk_req_grant
    forever begin
      @(posedge clk iff rstn && en_chk_prot);
      if($rose(mon.fmt_grant, @(posedge clk))) begin
        @(posedge clk);
        if(mon.fmt_req !== 0)
          $error("fmt_rsp_mon::[protocol error] req should be 0 after 1 cyle when grant rose to 1");
      end
    end
  end


  initial begin: chk_stable_id_length
    int id, len;
    forever begin
      @(posedge clk iff rstn && en_chk_prot);
      if($rose(mon.fmt_req, @(posedge clk))) begin
        id = mon.fmt_chid;
        len = mon.fmt_length;
        @(posedge clk iff $rose(mon.fmt_end, @(posedge clk)));
        if(id != mon.fmt_chid || len != mon.fmt_length)
          $error("fmt_rsp_mon::[protocol error] id and length is not valud within a packet transaction");
      end
    end
  end

  initial begin: chk_grant_start
    forever begin
      @(posedge clk iff rstn && en_chk_prot);
      if($rose(mon.fmt_grant, @(posedge clk))) begin
        @(posedge clk);
        if(mon.fmt_start !== 1)
          $error("fmt_rsp_mon::[protocol error] start should be 1 after 1 cyle when grant rose to 1");
      end
    end
  end

  initial begin: chk_start_pulse
    forever begin
      @(posedge clk iff rstn && en_chk_prot);
      if($rose(mon.fmt_start, @(posedge clk))) begin
        @(posedge clk);
        if(mon.fmt_start !== 0)
          $error("fmt_rsp_mon::[protocol error] start should be raised as 1 cycle pulse");
      end
    end
  end

  initial begin: chk_end_pulse
    forever begin
      @(posedge clk iff rstn && en_chk_prot);
      if($rose(mon.fmt_end, @(posedge clk))) begin
        @(posedge clk);
        if(mon.fmt_end !== 0)
          $error("fmt_rsp_mon::[protocol error] end should be raised as 1 cycle pulse");
      end
    end
  end

  initial begin: chk_packet_len
    int len;
    forever begin
      @(posedge clk iff rstn && en_chk_prot);
      if($rose(mon.fmt_start, @(posedge clk))) begin
        len = mon.fmt_length;
        repeat(len - 1) @(posedge clk);
        if(!$rose(mon.fmt_end, @(posedge clk)))
          $error("fmt_rsp_mon::[protocol error] number of transferred data not equals to length ");
      end
    end
  end


endinterface
