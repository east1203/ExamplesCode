
module object_handle_copy;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  typedef enum {RED, WHITE, BLACK} color_t;

  class box extends uvm_object;
    int volume = 120;
    color_t color = WHITE;
    string name = "box";
    `uvm_object_utils(box)
    function new(string name="box");
      super.new(name);
      this.name = name;
    endfunction
  endclass

  box b1, b2;
  initial begin
    b1 = new("box1");
    b2 = b1;
    b2.name = "box2";
    $display("b1 box name is %s", b1.name);
    $display("b2 box name is %s", b2.name);
  end

endmodule
