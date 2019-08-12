module object_pack_unpack;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  typedef enum {RED, WHITE, BLACK} color_t;

  class box extends uvm_object;
    int volume = 120;
    int height = 20;
    color_t color = WHITE;
    `uvm_object_utils_begin(box)
      `uvm_field_int(volume, UVM_ALL_ON)
      `uvm_field_int(height, UVM_ALL_ON)
      `uvm_field_enum(color_t, color, UVM_ALL_ON)
    `uvm_object_utils_end
    function new(string name="box");
      super.new(name);
    endfunction
  endclass

  box b1, b2;
  bit packed_bits[];
  initial begin
    b1 = new("box1");
    b2 = new("box2");
    b1.volume = 100;
    b1.height = 40;
    b1.color = RED;

    b1.print();
    b1.pack(packed_bits);

    $display("packed bits stream size is %d \n", packed_bits.size());

    b2.unpack(packed_bits);
    b2.print();
  end

endmodule
