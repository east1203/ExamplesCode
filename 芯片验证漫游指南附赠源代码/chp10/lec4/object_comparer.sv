module object_compare1;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  typedef enum {RED, WHITE, BLACK} color_t;

  class box extends uvm_object;
    int volume = 120;
    color_t color = WHITE;
    string name = "box";
    `uvm_object_utils_begin(box)
      `uvm_field_int(volume, UVM_ALL_ON)
      `uvm_field_enum(color_t, color, UVM_ALL_ON)
      `uvm_field_string(name, UVM_ALL_ON)
    `uvm_object_utils_end
    function new(string name="box");
      super.new(name);
      this.name = name;
    endfunction
  endclass

  box b1, b2;
  initial begin
    b1 = new("box1");
    b1.volume = 80;
    b1.color = BLACK;
    b2 = new("box2");
    b2.volume = 90;
    if(!b2.compare(b1)) begin
      `uvm_info("COMPARE", "b2 comapred with b1 failure", UVM_LOW)
    end 
    else begin
      `uvm_info("COMPARE", "b2 comapred with b1 succes", UVM_LOW)
    end
  end
endmodule



module object_compare2;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  typedef enum {RED, WHITE, BLACK} color_t;

  class box extends uvm_object;
    int volume = 120;
    color_t color = WHITE;
    string name = "box";
    `uvm_object_utils_begin(box)
      `uvm_field_int(volume, UVM_ALL_ON)
      `uvm_field_enum(color_t, color, UVM_ALL_ON)
      `uvm_field_string(name, UVM_ALL_ON)
    `uvm_object_utils_end
    function new(string name="box");
      super.new(name);
      this.name = name;
    endfunction
  endclass

  box b1, b2;
  uvm_comparer cmpr;
  initial begin
    b1 = new("box1");
    b1.volume = 80;
    b1.color = BLACK;
    b2 = new("box2");
    b2.volume = 90;
    cmpr = new();
    cmpr.show_max = 10; 
    if(!b2.compare(b1, cmpr)) begin
      `uvm_info("COMPARE", "b2 comapred with b1 failure", UVM_LOW)
    end 
    else begin
      `uvm_info("COMPARE", "b2 comapred with b1 succes", UVM_LOW)
    end
  end
endmodule
