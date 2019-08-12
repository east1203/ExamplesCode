module tlm_transport;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  class itrans extends uvm_transaction;
    int id;
    int data;
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction
  endclass

  class otrans extends uvm_transaction;
    int id;
    int data;
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction
  endclass

  class comp1 extends uvm_component;
    uvm_blocking_transport_port #(itrans, otrans) bt_port;
    `uvm_component_utils(comp1)
    function new(string name, uvm_component parent);
      super.new(name, parent);
      bt_port = new("bt_port", this);
    endfunction
    task run_phase(uvm_phase phase);
      itrans itr;
      otrans otr;
      int trans_num = 6;
      for(int i=0; i<trans_num; i++) begin
        itr = new("itr", this);
        itr.id = i;
        itr.data = 'h10 + i ;
        this.bt_port.transport(itr, otr);
        `uvm_info("TRSPT", $sformatf("put itrans id: 'h%0x , data: 'h%0x | get otrans id: 'h%0x , data: 'h%0x ", 
                  itr.id, itr.data, otr.id, otr.data), UVM_LOW)
      end
    endtask
  endclass

  class comp2 extends uvm_component;
    uvm_blocking_transport_imp #(itrans, otrans, comp2) bt_imp;
    `uvm_component_utils(comp2)
    function new(string name, uvm_component parent);
      super.new(name, parent);
      bt_imp = new("bt_imp", this);
    endfunction
    task transport(itrans req, output otrans rsp);
      rsp = new("rsp", this);
      rsp.id = req.id;
      rsp.data = req.data <<  8;
    endtask
  endclass

  class env1 extends uvm_env;
    comp1 c1;
    comp2 c2;
    `uvm_component_utils(env1)

    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      c1 = comp1::type_id::create("c1", this);
      c2 = comp2::type_id::create("c2", this);
    endfunction: build_phase

    function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      c1.bt_port.connect(c2.bt_imp);
    endfunction: connect_phase
  endclass

  class test1 extends uvm_test;
    `uvm_component_utils(test1)
    env1 env;
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction
    function void build_phase(uvm_phase phase);
      env = env1::type_id::create("env", this);
    endfunction
  endclass

  initial begin
    run_test("test1");
  end
endmodule


// UVM_INFO @ 0: reporter [RNTST] Running test test1...
// UVM_INFO @ 0: uvm_test_top.env.c1 [TRSPT] put itrans id: 'h0 , data: 'h10 | get otrans id: 'h0 , data: 'h1000 
// UVM_INFO @ 0: uvm_test_top.env.c1 [TRSPT] put itrans id: 'h1 , data: 'h11 | get otrans id: 'h1 , data: 'h1100 
// UVM_INFO @ 0: uvm_test_top.env.c1 [TRSPT] put itrans id: 'h2 , data: 'h12 | get otrans id: 'h2 , data: 'h1200 
// UVM_INFO @ 0: uvm_test_top.env.c1 [TRSPT] put itrans id: 'h3 , data: 'h13 | get otrans id: 'h3 , data: 'h1300 
// UVM_INFO @ 0: uvm_test_top.env.c1 [TRSPT] put itrans id: 'h4 , data: 'h14 | get otrans id: 'h4 , data: 'h1400 
// UVM_INFO @ 0: uvm_test_top.env.c1 [TRSPT] put itrans id: 'h5 , data: 'h15 | get otrans id: 'h5 , data: 'h1500
