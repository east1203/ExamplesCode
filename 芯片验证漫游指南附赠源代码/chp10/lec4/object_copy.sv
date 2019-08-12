

module object_copy;
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
    b2 = new();
    b2.copy(b1);
    b2.name = "box2";
    $display("%s", b1.sprint());
    $display("%s", b2.sprint());
  end

endmodule



module object_copy2;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  typedef enum {RED, WHITE, BLACK} color_t;

  class ball extends uvm_object;
    int diameter = 10;
    color_t color = RED;
    `uvm_object_utils_begin(ball)
      `uvm_field_int(diameter, UVM_DEFAULT)
      `uvm_field_enum(color_t, color, UVM_NOCOPY)
    `uvm_object_utils_end
    function new(string name="ball");
      super.new(name);
    endfunction

    function void do_copy(uvm_object rhs);
      ball b;
      $cast(b, rhs);
      $display("ball::do_copy entered..");
      if(b.diameter <= 20) begin
        diameter = 20;
      end
    endfunction
  endclass

  class box extends uvm_object;
    int volume = 120;
    color_t color = WHITE;
    string name = "box";
    ball b;
    `uvm_object_utils_begin(box)
      `uvm_field_int(volume, UVM_ALL_ON)
      `uvm_field_enum(color_t, color, UVM_ALL_ON)
      `uvm_field_string(name, UVM_ALL_ON)
      `uvm_field_object(b, UVM_SHALLOW)
    `uvm_object_utils_end
    function new(string name="box");
      super.new(name);
      this.name = name;
      b = new();
    endfunction
  endclass

  box b1, b2;
  initial begin
    b1 = new("box1");
    b1.volume = 80;
    b1.color = BLACK;
    b1.b.color = WHITE;
    b2 = new();
    b2.copy(b1);
    b2.name = "box2";
    $display("%s", b1.sprint());
    $display("%s", b2.sprint());
  end

endmodule
