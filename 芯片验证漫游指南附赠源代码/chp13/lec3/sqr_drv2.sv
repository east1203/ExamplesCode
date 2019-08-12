module sqr_drv;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  class bus_trans extends uvm_sequence_item;
    rand int data;
    `uvm_object_utils_begin(bus_trans)
      `uvm_field_int(data, UVM_ALL_ON)
    `uvm_object_utils_end
    function new(string name = "bus_trans");
      super.new(name);
    endfunction
  endclass

  class flat_seq extends uvm_sequence;
    `uvm_object_utils(flat_seq)
    function new(string name = "flat_seq");
      super.new(name);
    endfunction
    task body();
      uvm_sequence_item tmp;
      bus_trans req, rsp;
      tmp = create_item(bus_trans::get_type(), m_sequencer, "req");
      void'($cast(req, tmp));
      start_item(req);
      req.randomize with {data == 10;};
      `uvm_info("SEQ", $sformatf("sent a item \n %s", req.sprint()), UVM_LOW)
      finish_item(req);
      get_response(tmp);
      void'($cast(rsp, tmp));
      `uvm_info("SEQ", $sformatf("got a item \n %s", rsp.sprint()), UVM_LOW)
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
      bus_trans req, rsp;
      seq_item_port.get_next_item(tmp);
      void'($cast(req, tmp));
      `uvm_info("DRV", $sformatf("got a item \n %s", req.sprint()), UVM_LOW)
      void'($cast(rsp, req.clone()));
      rsp.set_sequence_id(req.get_sequence_id());
      rsp.data += 100;
      seq_item_port.item_done(rsp);
      `uvm_info("DRV", $sformatf("sent a item \n %s", rsp.sprint()), UVM_LOW)
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
      flat_seq seq;
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




// UVM_INFO @ 0: uvm_test_top.e.sqr@@flat_seq [SEQ] sent a item 
//  ---------------------------------------------------------------------------
// Name                           Type       Size  Value                      
// ---------------------------------------------------------------------------
// req                            bus_trans  -     @564                       
//   data                         integral   32    'ha                        
//   depth                        int        32    'd2                        
//   parent sequence (name)       string     8     flat_seq                   
//   parent sequence (full name)  string     27    uvm_test_top.e.sqr.flat_seq
//   sequencer                    string     18    uvm_test_top.e.sqr         
// ---------------------------------------------------------------------------
// 
// UVM_INFO @ 0: uvm_test_top.e.drv [DRV] got a item 
//  ---------------------------------------------------------------------------
// Name                           Type       Size  Value                      
// ---------------------------------------------------------------------------
// req                            bus_trans  -     @564                       
//   data                         integral   32    'ha                        
//   depth                        int        32    'd2                        
//   parent sequence (name)       string     8     flat_seq                   
//   parent sequence (full name)  string     27    uvm_test_top.e.sqr.flat_seq
//   sequencer                    string     18    uvm_test_top.e.sqr         
// ---------------------------------------------------------------------------
// 
// UVM_INFO @ 0: uvm_test_top.e.drv [DRV] sent a item 
//  ------------------------------
// Name    Type       Size  Value
// ------------------------------
// req     bus_trans  -     @575 
//   data  integral   32    'h6e 
// ------------------------------
// 
// UVM_INFO @ 0: uvm_test_top.e.sqr@@flat_seq [SEQ] got a item 
//  ------------------------------
// Name    Type       Size  Value
// ------------------------------
// req     bus_trans  -     @575 
//   data  integral   32    'h6e 
// ------------------------------
