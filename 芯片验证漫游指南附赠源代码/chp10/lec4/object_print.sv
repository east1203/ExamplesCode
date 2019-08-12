

module object_print;
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

  box b1;
  uvm_table_printer local_printer;
  initial begin
    b1 = new("box1");
    local_printer = new();

    $display("default table printer format");
    b1.print();

    $display("default line printer format");
    uvm_default_printer = uvm_default_line_printer;
    b1.print();

    $display("default tree printer format");
    uvm_default_printer = uvm_default_tree_printer;
    b1.print();

    $display("customized printer format");
    local_printer.knobs.full_name = 1;
    b1.print(local_printer);
  end

endmodule
