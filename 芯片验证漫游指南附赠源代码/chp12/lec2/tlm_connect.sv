module tlm_connect;
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
    uvm_blocking_put_port #(itrans) bp_port;
    uvm_nonblocking_get_port #(otrans) nbg_port;
    `uvm_component_utils(comp1)
    function new(string name, uvm_component parent);
      super.new(name, parent);
      bp_port = new("bp_port", this);
      nbg_port = new("nbg_port", this);
    endfunction
    task run_phase(uvm_phase phase);
      itrans itr;
      otrans otr;
      int trans_num = 6;
      fork 
        begin
          for(int i=0; i<trans_num; i++) begin
            itr = new("itr", this);
            itr.id = i;
            itr.data = 'h10 + i ;
            this.bp_port.put(itr);
            `uvm_info("PUT", $sformatf("put itrans id: 'h%0x , data: 'h%0x", itr.id, itr.data), UVM_LOW)
          end
        end
        begin
           for(int j=0; j<trans_num; j++) begin
             forever begin
               if(this.nbg_port.try_get(otr) == 1) break;
               else #1ns;
             end
             `uvm_info("TRYGET", $sformatf("get otrans id: 'h%0x , data: 'h%0x", otr.id, otr.data), UVM_LOW)
           end
        end
      join
    endtask
  endclass

  class comp2 extends uvm_component;
    uvm_blocking_put_imp #(itrans, comp2) bp_imp;
    uvm_nonblocking_get_imp #(otrans, comp2) nbg_imp;
    itrans itr_q[$];
    `uvm_component_utils(comp2)
    function new(string name, uvm_component parent);
      super.new(name, parent);
      bp_imp = new("bp_imp", this);
      nbg_imp = new("nbg_imp", this);
    endfunction
    task put(itrans t);
      itr_q.push_back(t);
    endtask
    function bit try_get (output otrans t); 
      itrans i;
      if(itr_q.size() != 0) begin
        i = itr_q.pop_front();
        t = new("t", this);
        t.id = i.id;
        t.data = i.data << 8;
        return 1;
      end
      else return 0;
    endfunction 
    function bit can_get(); 
      if(itr_q.size() != 0) return 1;
      else return 0;
    endfunction
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
      c1.bp_port.connect(c2.bp_imp);
      c1.nbg_port.connect(c2.nbg_imp);
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


// UVM_INFO @ 0: uvm_test_top.env.c1 [PUT] put itrans id: 'h0 , data: 'h10
// UVM_INFO @ 0: uvm_test_top.env.c1 [PUT] put itrans id: 'h1 , data: 'h11
// UVM_INFO @ 0: uvm_test_top.env.c1 [PUT] put itrans id: 'h2 , data: 'h12
// UVM_INFO @ 0: uvm_test_top.env.c1 [PUT] put itrans id: 'h3 , data: 'h13
// UVM_INFO @ 0: uvm_test_top.env.c1 [PUT] put itrans id: 'h4 , data: 'h14
// UVM_INFO @ 0: uvm_test_top.env.c1 [PUT] put itrans id: 'h5 , data: 'h15
// UVM_INFO @ 0: uvm_test_top.env.c1 [TRYGET] get otrans id: 'h0 , data: 'h1000
// UVM_INFO @ 0: uvm_test_top.env.c1 [TRYGET] get otrans id: 'h1 , data: 'h1100
// UVM_INFO @ 0: uvm_test_top.env.c1 [TRYGET] get otrans id: 'h2 , data: 'h1200
// UVM_INFO @ 0: uvm_test_top.env.c1 [TRYGET] get otrans id: 'h3 , data: 'h1300
// UVM_INFO @ 0: uvm_test_top.env.c1 [TRYGET] get otrans id: 'h4 , data: 'h1400
// UVM_INFO @ 0: uvm_test_top.env.c1 [TRYGET] get otrans id: 'h5 , data: 'h1500
