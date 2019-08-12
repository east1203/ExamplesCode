

interface slv_rsp_if(
  input rstn,
  input clk 
);
  import slv_pkg::slv_trans;

  logic req;
  logic [31:0] data;
  logic ack;

  slv_trans mon_fifo[$];

  clocking ck_mon @(posedge clk);
    default input #1step output #1ps;
    input req;
    input data;
    input ack;
  endclocking

  function void put_trans(slv_trans t);
    mon_fifo.push_back(t);
    $display("slv_rsp_if::mon_fifo size is %0d", mon_fifo.size());
  endfunction
endinterface
