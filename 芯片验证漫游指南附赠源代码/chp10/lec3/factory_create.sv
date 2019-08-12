
module object_create;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  class comp1 extends uvm_component;
    `uvm_component_utils(comp1)
    function new(string name="comp1", uvm_component parent=null);
      super.new(name, parent);
      $display($sformatf("%s is created", name));
    endfunction: new
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
    endfunction: build_phase
  endclass

  class obj1 extends uvm_object;
    `uvm_object_utils(obj1)
    function new(string name="obj1");
      super.new(name);
      $display($sformatf("%s is created", name));
    endfunction: new
  endclass

  comp1 c1, c2;
  obj1 o1, o2;

  initial begin
    c1 = new("c1");
    o1 = new("o1");
    c2 = comp1::type_id::create("c2", null);
    o2 = obj1::type_id::create("o2");
  end

endmodule
