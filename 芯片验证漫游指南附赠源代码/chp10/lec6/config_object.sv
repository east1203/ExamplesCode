module config_object;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  class config1 extends uvm_object;
    int val1 = 1;
    int str1 = "null";
    `uvm_object_utils(config1)
    function new(string name = "config1");
      super.new(name);
    endfunction
  endclass

  class comp1 extends uvm_component; 
    `uvm_component_utils(comp1)
    config1 cfg;
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction
    function void build_phase(uvm_phase phase);
      uvm_object tmp;
      uvm_config_db#(uvm_object)::get(this, "", "cfg", tmp);
      void'($cast(cfg, tmp));
      `uvm_info("SETVAL", $sformatf("cfg.val1 is %d after get", cfg.val1), UVM_LOW)
      `uvm_info("SETVAL", $sformatf("cfg.str1 is %s after get", cfg.str1), UVM_LOW)
    endfunction
  endclass

  class test1 extends uvm_test;
    `uvm_component_utils(test1)
    comp1 c1, c2;
    config1 cfg1, cfg2;
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction
    function void build_phase(uvm_phase phase);
      cfg1 = config1::type_id::create("cfg1");
      cfg2 = config1::type_id::create("cfg2");
      cfg1.val1 = 30;
      cfg1.str1= "c1";
      cfg2.val1 = 50;
      cfg2.str1= "c2";
      uvm_config_db#(uvm_object)::set(this, "c1", "cfg", cfg1);
      uvm_config_db#(uvm_object)::set(this, "c2", "cfg", cfg2);
      c1 = comp1::type_id::create("c1", this);
      c2 = comp1::type_id::create("c2", this);
    endfunction
  endclass

  initial begin
    run_test("test1");
  end
endmodule


// UVM_INFO @ 0: reporter [RNTST] Running test test1...
// UVM_INFO @ 0: uvm_test_top.c1 [SETVAL] cfg.val1 is          30 after get
// UVM_INFO @ 0: uvm_test_top.c1 [SETVAL] cfg.str1 is   c1 after get
// UVM_INFO @ 0: uvm_test_top.c2 [SETVAL] cfg.val1 is          50 after get
// UVM_INFO @ 0: uvm_test_top.c2 [SETVAL] cfg.str1 is   c2 after get
