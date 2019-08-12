module uvm_callback_sync;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  class edata extends uvm_object;
    int data;
    `uvm_object_utils(edata)
    function new(string name = "edata");
      super.new(name);
    endfunction
  endclass

  class cb1 extends uvm_callback;
    `uvm_object_utils(cb1)
    function new(string name = "cb1");
      super.new(name);
    endfunction
    virtual function void do_trans(edata d);
      d.data = 200;
      `uvm_info("CB", $sformatf("cb1 executed with data %0d", d.data), UVM_LOW)
    endfunction
  endclass

  class cb2 extends cb1;
    `uvm_object_utils(cb2)
    function new(string name = "cb2");
      super.new(name);
    endfunction
    function void do_trans(edata d);
      d.data = 300;
      `uvm_info("CB", $sformatf("cb2 executed with data %0d", d.data), UVM_LOW)
    endfunction
  endclass


  class comp1 extends uvm_component;
    `uvm_component_utils(comp1)
    `uvm_register_cb(comp1, cb1)
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
    endfunction
    task run_phase(uvm_phase phase);
      edata d = new();
      d.data = 100;
      `uvm_info("RUN", $sformatf("proceeding data %0d", d.data), UVM_LOW)
      `uvm_do_callbacks(comp1, cb1, do_trans(d))
    endtask
  endclass

  class env1 extends uvm_env;
    comp1 c1;
    cb1 m_cb1;
    cb2 m_cb2;
    `uvm_component_utils(env1)

    function new(string name, uvm_component parent);
      super.new(name, parent);
      m_cb1 = new("m_cb1");
      m_cb2 = new("m_cb2");
    endfunction

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      c1 = comp1::type_id::create("c1", this);
      uvm_callbacks #(comp1)::add(c1, m_cb1);
      uvm_callbacks #(comp1)::add(c1, m_cb2);
    endfunction: build_phase
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
    task run_phase(uvm_phase phase);
      super.run_phase(phase);
      phase.raise_objection(phase);
      #1us;
      phase.drop_objection(phase);
    endtask
  endclass

  initial begin
    run_test("test1");
  end
endmodule


// UVM_INFO @ 0: reporter [RNTST] Running test test1...
// UVM_INFO @ 0: uvm_test_top.env.c1 [RUN] proceeding data 100
// UVM_INFO @ 0: reporter [CB] cb1 executed with data 200
// UVM_INFO @ 0: reporter [CB] cb2 executed with data 300

