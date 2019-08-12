module seq_send_methods;
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
    `uvm_object_utils(child_seq)
    function new(string name = "child_seq");
      super.new(name);
    endfunction
    task body();
      uvm_sequence_item tmp;
      bus_trans req;
      tmp = create_item(bus_trans::get_type(), m_sequencer, "req");
      void'($cast(req, tmp));
      start_item(req);
      req.randomize with {data == 10;};
      finish_item(req);
    endtask
  endclass

  class top_seq extends uvm_sequence;
    `uvm_object_utils(top_seq)
    function new(string name = "top_seq");
      super.new(name);
    endfunction
    task body();
      uvm_sequence_item tmp;
      child_seq cseq;
      bus_trans req;
      // create child sequence and items
      cseq = child_seq::type_id::create("cseq");
      tmp = create_item(bus_trans::get_type(), m_sequencer, "req");
      // send child sequence via start()
      cseq.start(m_sequencer, this);
      // send sequence item 
      void'($cast(req, tmp));
      start_item(req);
      req.randomize with {data == 20;};
      finish_item(req);
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
        `uvm_info("DRV", $sformatf("got a item \n %s", req.sprint()), UVM_LOW)
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

// ****sequence excution order

// sub_seq.pre_start()        (task)
// sub_seq.pre_body()         (task)  if call_pre_post==1
//   parent_seq.pre_do(0)     (task)  if parent_sequence!=null
//   parent_seq.mid_do(this)  (func)  if parent_sequence!=null
// sub_seq.body               (task)  YOUR STIMULUS CODE
//   parent_seq.post_do(this) (func)  if parent_sequence!=null
// sub_seq.post_body()        (task)  if call_pre_post==1
// sub_seq.post_start()       (task)

// ****item excution order
// sequencer.wait_for_grant(prior) (task) \ start_item  \
// parent_seq.pre_do(1)            (task) /              \
//                                                    `uvm_do* macros
// parent_seq.mid_do(item)         (func) \              /
// sequencer.send_request(item)    (func)  \finish_item /
// sequencer.wait_for_item_done()  (task)  /
// parent_seq.post_do(item)        (func) /

// UVM_INFO @ 0: uvm_test_top.e.drv [DRV] got a item 
//  -------------------------------------------------------------------------------
// Name                           Type       Size  Value                          
// -------------------------------------------------------------------------------
// req                            bus_trans  -     @575                           
//   data                         integral   32    'ha                            
//   depth                        int        32    'd3                            
//   parent sequence (name)       string     4     cseq                           
//   parent sequence (full name)  string     31    uvm_test_top.e.sqr.top_seq.cseq
//   sequencer                    string     18    uvm_test_top.e.sqr             
// -------------------------------------------------------------------------------
// 
// UVM_INFO @ 0: uvm_test_top.e.drv [DRV] got a item 
//  --------------------------------------------------------------------------
// Name                           Type       Size  Value                     
// --------------------------------------------------------------------------
// req                            bus_trans  -     @570                      
//   data                         integral   32    'h14                      
//   depth                        int        32    'd2                       
//   parent sequence (name)       string     7     top_seq                   
//   parent sequence (full name)  string     26    uvm_test_top.e.sqr.top_seq
//   sequencer                    string     18    uvm_test_top.e.sqr        
// --------------------------------------------------------------------------
