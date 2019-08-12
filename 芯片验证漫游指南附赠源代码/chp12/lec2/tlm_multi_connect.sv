module tlm_multi_connect;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  `uvm_blocking_put_imp_decl(_p1)
  `uvm_blocking_put_imp_decl(_p2)

  class itrans extends uvm_transaction;
    int id;
    int data;
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction
  endclass


  class comp1 extends uvm_component;
    uvm_blocking_put_port #(itrans) bp_port1;
    uvm_blocking_put_port #(itrans) bp_port2;
    `uvm_component_utils(comp1)
    function new(string name, uvm_component parent);
      super.new(name, parent);
      bp_port1 = new("bp_port1", this);
      bp_port2 = new("bp_port2", this);
    endfunction
    task run_phase(uvm_phase phase);
      itrans itr1, itr2;
      int trans_num = 3;
      fork
        for(int i=0; i<trans_num; i++) begin
          itr1 = new("itr1", this);
          itr1.id = i;
          itr1.data = 'h10 + i ;
          this.bp_port1.put(itr1);
        end
        for(int i=0; i<trans_num; i++) begin
          itr2 = new("itr2", this);
          itr2.id = 'h10 + i;
          itr2.data = 'h20 + i ;
          this.bp_port2.put(itr2);
        end
      join
    endtask
  endclass

  class comp2 extends uvm_component;
    uvm_blocking_put_imp_p1 #(itrans, comp2) bt_imp_p1;
    uvm_blocking_put_imp_p2 #(itrans, comp2) bt_imp_p2;
    itrans itr_q[$];
    semaphore key;
    `uvm_component_utils(comp2)
    function new(string name, uvm_component parent);
      super.new(name, parent);
      bt_imp_p1 = new("bt_imp_p1", this);
      bt_imp_p2 = new("bt_imp_p2", this);
      key = new(1);
    endfunction
    task put_p1(itrans t);
      key.get();
      itr_q.push_back(t);
      `uvm_info("PUTP1", $sformatf("put itrans id: 'h%0x , data: 'h%0x", t.id, t.data), UVM_LOW)
      key.put();
    endtask
    task put_p2(itrans t);
      key.get();
      itr_q.push_back(t);
      `uvm_info("PUTP2", $sformatf("put itrans id: 'h%0x , data: 'h%0x", t.id, t.data), UVM_LOW)
      key.put();
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
      c1.bp_port1.connect(c2.bt_imp_p1);
      c1.bp_port2.connect(c2.bt_imp_p2);
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



// UVM_INFO @ 0: uvm_test_top.env.c2 [PUTP1] put itrans id: 'h0 , data: 'h10
// UVM_INFO @ 0: uvm_test_top.env.c2 [PUTP1] put itrans id: 'h1 , data: 'h11
// UVM_INFO @ 0: uvm_test_top.env.c2 [PUTP1] put itrans id: 'h2 , data: 'h12
// UVM_INFO @ 0: uvm_test_top.env.c2 [PUTP2] put itrans id: 'h10 , data: 'h20
// UVM_INFO @ 0: uvm_test_top.env.c2 [PUTP2] put itrans id: 'h11 , data: 'h21
// UVM_INFO @ 0: uvm_test_top.env.c2 [PUTP2] put itrans id: 'h12 , data: 'h22
