module flat_sequence2;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  class bus_trans extends uvm_sequence_item;
    rand bit write;
    rand int data[];
    rand int length;
    rand int addr;
    rand int delay;
    static int id_num; 
    constraint cstr {
      data.size() == length;
      foreach(data[i]) soft data[i] == i;
      soft addr == 'h100;
      soft write == 1;
      delay inside {[1:5]};
    }
    `uvm_object_utils_begin(bus_trans)
      `uvm_field_int(write, UVM_ALL_ON)
      `uvm_field_int(length, UVM_ALL_ON)
      `uvm_field_array_int(data, UVM_ALL_ON)
      `uvm_field_int(addr, UVM_ALL_ON)
      `uvm_field_int(delay, UVM_ALL_ON)
      `uvm_field_int(id_num, UVM_ALL_ON)
    `uvm_object_utils_end
    function new(string name = "bus_trans");
      super.new(name);
      id_num++;
    endfunction
  endclass

  class flat_seq extends uvm_sequence;
    rand int length;
    rand int addr;
    `uvm_object_utils(flat_seq)
    function new(string name = "flat_seq");
      super.new(name);
    endfunction
    task body();
      bus_trans tmp;
      tmp = new();
      tmp.randomize() with {length == local::length;
                            addr == local::addr;};
      tmp.print();
    endtask
  endclass

  class test1 extends uvm_test;
    `uvm_component_utils(test1)
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction
    task run_phase(uvm_phase phase);
      flat_seq seq;
      phase.raise_objection(phase);
      seq = new();
      seq.randomize() with {addr == 'h200; length == 3;};
      seq.body();
      phase.drop_objection(phase);
    endtask
  endclass

  initial begin
    run_test("test1");
  end
endmodule




// ------------------------------------
// Name       Type          Size  Value
// ------------------------------------
// bus_trans  bus_trans     -     @363 
//   write    integral      1     'h1  
//   length   integral      32    'h3  
//   data     da(integral)  3     -    
//     [0]    integral      32    'h0  
//     [1]    integral      32    'h1  
//     [2]    integral      32    'h2  
//   addr     integral      32    'h200
//   delay    integral      32    'h3  
//   id_num   integral      32    'h1  
// ------------------------------------
