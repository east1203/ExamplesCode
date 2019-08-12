
interface intf1;
  logic enable = 0;
endinterface

module config_interface;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  class comp1 extends uvm_component; 
    `uvm_component_utils(comp1)
    virtual intf1 vif;
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction
    function void build_phase(uvm_phase phase);
      if(!uvm_config_db#(virtual intf1)::get(this, "", "vif", vif)) begin
        `uvm_error("GETVIF", "no virtual interface is assigned")
      end
      `uvm_info("SETVAL", $sformatf("vif.enable is %b before set", vif.enable), UVM_LOW)
      vif.enable = 1;
      `uvm_info("SETVAL", $sformatf("vif.enable is %b after set", vif.enable), UVM_LOW)
    endfunction
  endclass

  class test1 extends uvm_test;
    `uvm_component_utils(test1)
    comp1 c1;
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction
    function void build_phase(uvm_phase phase);
      c1 = comp1::type_id::create("c1", this);
    endfunction
  endclass

  intf1 intf();

  initial begin
    uvm_config_db#(virtual intf1)::set(uvm_root::get(), "uvm_test_top.c1", "vif", intf);
    run_test("test1");
  end
endmodule



// UVM_INFO @ 0: reporter [RNTST] Running test test1...
// UVM_INFO @ 0: uvm_test_top.c1 [SETVAL] vif.enable is 0 before set
// UVM_INFO @ 0: uvm_test_top.c1 [SETVAL] vif.enable is 1 after set
