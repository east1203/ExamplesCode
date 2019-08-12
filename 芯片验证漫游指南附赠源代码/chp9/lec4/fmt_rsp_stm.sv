
interface fmt_rsp_if;
  logic clk;
  logic rstn;
  logic req;
  logic grant;
endinterface

class fmt_rsp_stm;
  typedef enum {FMT_BUSY, FMT_BLOCK, FMT_FREE} mode_t;
  mode_t mode = FMT_BUSY;
  virtual interface fmt_rsp_if vif;

  task run();
    fork 
      drive();
    join_none
  endtask

  task drive();
    forever begin
      int delay;
      @(posedge vif.clk iff vif.rstn === 1 && vif.req === 1);
      case(mode)
        FMT_BUSY: delay = $urandom_range(6, 12);
        FMT_BLOCK: delay = $urandom_range(20, 30);
        FMT_FREE: delay = $urandom_range(0, 2);
      endcase
      $display("when mode=%s , grant delay is %0d", mode, delay);
      repeat(delay) @(posedge vif.clk);
      vif.grant <= 1;
      @(posedge vif.clk);
      vif.grant <= 0;
    end
  endtask
endclass


module tb;
  bit clk;
  logic rstn;

  initial begin
    forever #5ns clk <= !clk;
  end
  initial begin
    #15ns rstn <= 0;
    #5ns rstn <= 1;
  end

  fmt_rsp_stm stm;
  fmt_rsp_if intf();

  assign intf.clk = clk;
  assign intf.rstn = rstn;


  initial begin
    stm = new();
    stm.vif = intf;
    fork
    stm.run();
    join_none
    @(posedge intf.rstn);
    @(posedge intf.clk) intf.req <= 1;
    @(posedge intf.grant) intf.req <= 0;
    stm.mode = fmt_rsp_stm::FMT_BLOCK;
    @(posedge intf.clk) intf.req <= 1;
    @(posedge intf.grant) intf.req <= 0;
    stm.mode = fmt_rsp_stm::FMT_FREE;
    @(posedge intf.clk) intf.req <= 1;
    @(posedge intf.grant) intf.req <= 0;
  end
endmodule
