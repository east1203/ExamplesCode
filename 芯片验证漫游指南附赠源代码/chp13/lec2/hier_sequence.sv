module hier_sequence;
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

  class hier_seq extends uvm_sequence;
    `uvm_object_utils(flat_seq)
    function new(string name = "hier_seq");
      super.new(name);
    endfunction
    task body();
      bus_trans t1, t2;
      flat_seq s1, s2;
      `uvm_do_with(t1, {length == 2;})
      fork
        `uvm_do_with(s1, {length == 5;})
        `uvm_do_with(s2, {length == 8;})
      join
      `uvm_do_with(t2, {length == 3;})
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
      seq.body();
      phase.drop_objection(phase);
    endtask
  endclass

  initial begin
    run_test("test1");
  end
endmodule




