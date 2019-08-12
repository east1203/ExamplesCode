
module config_resource_db;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  class comp1 extends uvm_component; 
    `uvm_component_utils(comp1)
    int val1 = 1;
    string str1 = "null";
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction
    function void build_phase(uvm_phase phase);
      `uvm_info("SETVAL", $sformatf("val1 is %d before get", val1), UVM_LOW)
      `uvm_info("SETVAL", $sformatf("str1 is %s before get", str1), UVM_LOW)
      uvm_resource_db#(int)::read_by_name("cfg", "val1", val1);
      uvm_resource_db#(string)::read_by_name("cfg", "str1", str1);
      `uvm_info("SETVAL", $sformatf("val1 is %d after get", val1), UVM_LOW)
      `uvm_info("SETVAL", $sformatf("str1 is %s after get", str1), UVM_LOW)
    endfunction
  endclass

  class test1 extends uvm_test;
    `uvm_component_utils(test1)
    comp1 c1;
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction
    function void build_phase(uvm_phase phase);
      uvm_resource_db#(int)::set("cfg", "val1", 100);
      uvm_resource_db#(string)::set("cfg", "str1", "comp1");
      c1 = comp1::type_id::create("c1", this);
    endfunction
  endclass

  initial begin
    run_test("test1");
  end
endmodule
