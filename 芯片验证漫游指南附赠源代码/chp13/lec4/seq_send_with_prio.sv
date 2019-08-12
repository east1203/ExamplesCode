module seq_send_with_prio;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  typedef class sequencer;

  class bus_trans extends uvm_sequence_item;
    rand int data;
    `uvm_object_utils_begin(bus_trans)
      `uvm_field_int(data, UVM_ALL_ON)
    `uvm_object_utils_end
    function new(string name = "bus_trans");
      super.new(name);
    endfunction
  endclass

  class child_seq extends uvm_sequence;
    rand int base;
    `uvm_object_utils(child_seq)
    function new(string name = "child_seq");
      super.new(name);
    endfunction
    task body();
      bus_trans req;
      repeat(5) `uvm_do_with(req, {data inside {[base: base+9]};})
    endtask
  endclass

  class top_seq extends uvm_sequence;
    `uvm_object_utils(top_seq)
    function new(string name = "top_seq");
      super.new(name);
    endfunction
    task body();
      child_seq seq1, seq2, seq3;
      m_sequencer.set_arbitration(UVM_SEQ_ARB_STRICT_FIFO);
      fork
        `uvm_do_pri_with(seq1, 500, {base == 10;})
        `uvm_do_pri_with(seq2, 500, {base == 20;})
        `uvm_do_pri_with(seq3, 300, {base == 30;})
      join
    endtask
  endclass

  class sequencer extends uvm_sequencer;
    `uvm_component_utils(sequencer)
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction
  endclass

  class driver extends uvm_driver;
    `uvm_component_utils(driver)
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction
    task run_phase(uvm_phase phase);
      REQ tmp;
      bus_trans req;
      forever begin
        seq_item_port.get_next_item(tmp);
        void'($cast(req, tmp));
        `uvm_info("DRV", $sformatf("got a item %0d from parent sequence %s", 
                         req.data, req.get_parent_sequence().get_name()), UVM_LOW)
        seq_item_port.item_done();
      end
    endtask
  endclass

  class env extends uvm_env;
    sequencer sqr;
    driver drv;
    `uvm_component_utils(env)
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction
    function void build_phase(uvm_phase phase);
      sqr = sequencer::type_id::create("sqr", this);
      drv = driver::type_id::create("drv", this);
    endfunction
    function void connect_phase(uvm_phase phase);
      drv.seq_item_port.connect(sqr.seq_item_export);
    endfunction
  endclass

  class test1 extends uvm_test;
    env e;
    `uvm_component_utils(test1)
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction
    function void build_phase(uvm_phase phase);
      e = env::type_id::create("e", this);
    endfunction
    task run_phase(uvm_phase phase);
      top_seq seq;
      phase.raise_objection(phase);
      seq = new();
      seq.start(e.sqr);
      phase.drop_objection(phase);
    endtask
  endclass

  initial begin
    run_test("test1");
  end
endmodule


// UVM_INFO @ 0: uvm_test_top.e.drv [DRV] got a item 16 from parent sequence seq1
// UVM_INFO @ 0: uvm_test_top.e.drv [DRV] got a item 22 from parent sequence seq2
// UVM_INFO @ 0: uvm_test_top.e.drv [DRV] got a item 19 from parent sequence seq1
// UVM_INFO @ 0: uvm_test_top.e.drv [DRV] got a item 23 from parent sequence seq2
// UVM_INFO @ 0: uvm_test_top.e.drv [DRV] got a item 14 from parent sequence seq1
// UVM_INFO @ 0: uvm_test_top.e.drv [DRV] got a item 29 from parent sequence seq2
// UVM_INFO @ 0: uvm_test_top.e.drv [DRV] got a item 14 from parent sequence seq1
// UVM_INFO @ 0: uvm_test_top.e.drv [DRV] got a item 24 from parent sequence seq2
// UVM_INFO @ 0: uvm_test_top.e.drv [DRV] got a item 12 from parent sequence seq1
// UVM_INFO @ 0: uvm_test_top.e.drv [DRV] got a item 27 from parent sequence seq2
// UVM_INFO @ 0: uvm_test_top.e.drv [DRV] got a item 33 from parent sequence seq3
// UVM_INFO @ 0: uvm_test_top.e.drv [DRV] got a item 32 from parent sequence seq3
// UVM_INFO @ 0: uvm_test_top.e.drv [DRV] got a item 36 from parent sequence seq3
// UVM_INFO @ 0: uvm_test_top.e.drv [DRV] got a item 34 from parent sequence seq3
// UVM_INFO @ 0: uvm_test_top.e.drv [DRV] got a item 37 from parent sequence seq3
