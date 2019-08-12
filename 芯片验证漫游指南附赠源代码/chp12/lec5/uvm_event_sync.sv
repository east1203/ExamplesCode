module uvm_event_sync;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  class edata extends uvm_object;
    int data;
    `uvm_object_utils(edata)
    function new(string name = "edata");
      super.new(name);
    endfunction
  endclass

  class ecb extends uvm_event_callback;
    `uvm_object_utils(ecb)
    function new(string name = "ecb");
      super.new(name);
    endfunction
    function bit pre_trigger(uvm_event e, uvm_object data = null);
      `uvm_info("EPRETRIG", $sformatf("before trigger event %s", e.get_name()), UVM_LOW)
      return 0;
    endfunction
    function void post_trigger(uvm_event e, uvm_object data = null);
      `uvm_info("EPOSTRIG", $sformatf("after trigger event %s", e.get_name()), UVM_LOW)
    endfunction
  endclass 


  class comp1 extends uvm_component;
    uvm_event e1;
    `uvm_component_utils(comp1)
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      e1 = uvm_event_pool::get_global("e1");
    endfunction
    task run_phase(uvm_phase phase);
      edata d = new();
      ecb cb = new();
      d.data = 100;
      #10ns;
      e1.add_callback(cb);
      e1.trigger(d);
      `uvm_info("ETRIG", $sformatf("trigger sync event at %t ps", $time), UVM_LOW)
    endtask
  endclass

  class comp2 extends uvm_component;
    uvm_event e1;
    `uvm_component_utils(comp2)
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      e1 = uvm_event_pool::get_global("e1");
    endfunction
    task run_phase(uvm_phase phase);
      uvm_object tmp;
      edata d;
      `uvm_info("ESYNC", $sformatf("wait sync event at %t ps", $time), UVM_LOW)
      e1.wait_trigger_data(tmp);
      void'($cast(d, tmp));
      `uvm_info("ESYNC", $sformatf("get data %0d after sync at %t ps", d.data, $time), UVM_LOW)
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
// UVM_INFO @ 0: uvm_test_top.env.c2 [ESYNC] wait sync event at                    0 ps
// UVM_INFO @ 10000: reporter [EPRETRIG] before trigger event e1
// UVM_INFO @ 10000: reporter [EPOSTRIG] after trigger event e1
// UVM_INFO @ 10000: uvm_test_top.env.c1 [ETRIG] trigger sync event at                10000 ps
// UVM_INFO @ 10000: uvm_test_top.env.c2 [ESYNC] get data 100 after sync at                10000 ps
