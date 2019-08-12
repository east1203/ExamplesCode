module hier_seq;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  typedef class reg_master_sequencer;
  typedef enum {CLKON, CLKOFF, RESET, WRREG, RDREG} cmd_t;

  class bus_trans extends uvm_sequence_item;
    rand cmd_t cmd;
    rand int addr;
    rand int data;
    constraint cstr{
      soft addr == 'h0;
      soft data == 'h0;
    }
    `uvm_object_utils_begin(bus_trans)
      `uvm_field_enum(cmd_t, cmd, UVM_ALL_ON)
      `uvm_field_int(addr, UVM_ALL_ON)
      `uvm_field_int(data, UVM_ALL_ON)
    `uvm_object_utils_end
    function new(string name = "bus_trans");
      super.new(name);
    endfunction
  endclass

  class clk_rst_seq extends uvm_sequence;
    rand int freq;
    `uvm_object_utils(clk_rst_seq)
    function new(string name = "clk_rst_seq");
      super.new(name);
    endfunction
    task body();
      bus_trans req;
      `uvm_do_with(req, {cmd == CLKON; data == freq;})
      `uvm_do_with(req, {cmd == RESET;})
    endtask
  endclass

  class reg_test_seq extends uvm_sequence;
    rand int chnl;
    `uvm_object_utils(reg_test_seq)
    function new(string name = "reg_test_seq");
      super.new(name);
    endfunction
    task body();
      bus_trans req;
      // write and read test for WR register
      `uvm_do_with(req, {cmd == WRREG; addr == chnl*'h4;})
      `uvm_do_with(req, {cmd == RDREG; addr == chnl*'h4;})
      // read for the RD register
      `uvm_do_with(req, {cmd == RDREG; addr == chnl*'h4 + 'h10;})
    endtask
  endclass

  class top_seq extends uvm_sequence;
    `uvm_object_utils(top_seq)
    function new(string name = "top_seq");
      super.new(name);
    endfunction
    task body();
      clk_rst_seq clkseq;
      reg_test_seq regseq0, regseq1, regseq2;
      // turn on clock with 150Mhz and assert reset
      `uvm_do_with(clkseq, {freq == 150;})
      // test the registers of channel0
      `uvm_do_with(regseq0, {chnl == 0;})
      // test the registers of channel1
      `uvm_do_with(regseq1, {chnl == 1;})
      // test the registers of channel2
      `uvm_do_with(regseq2, {chnl == 2;})
    endtask
  endclass

  class reg_master_sequencer extends uvm_sequencer;
    `uvm_component_utils(reg_master_sequencer)
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction
  endclass

  class reg_master_driver extends uvm_driver;
    `uvm_component_utils(reg_master_driver)
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

  class reg_master_agent extends uvm_agent;
    reg_master_sequencer sqr;
    reg_master_driver drv;
    `uvm_component_utils(reg_master_agent)
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction
    function void build_phase(uvm_phase phase);
      sqr = reg_master_sequencer::type_id::create("sqr", this);
      drv = reg_master_driver::type_id::create("drv", this);
    endfunction
    function void connect_phase(uvm_phase phase);
      drv.seq_item_port.connect(sqr.seq_item_export);
    endfunction
  endclass

  class test1 extends uvm_test;
    reg_master_agent reg_agt;
    `uvm_component_utils(test1)
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction
    function void build_phase(uvm_phase phase);
      reg_agt = reg_master_agent::type_id::create("reg_agt", this);
    endfunction
    task run_phase(uvm_phase phase);
      top_seq seq;
      phase.raise_objection(phase);
      seq = new();
      seq.start(reg_agt.sqr);
      phase.drop_objection(phase);
    endtask
  endclass

  initial begin
    run_test("test1");
  end
endmodule



// UVM_INFO @ 0: uvm_test_top.reg_agt.drv [DRV] got a item 
//  ---------------------------------------------------------------------------------------
// Name                           Type       Size  Value                                  
// ---------------------------------------------------------------------------------------
// req                            bus_trans  -     @550                                   
//   cmd                          cmd_t      32    CLKON                                  
//   addr                         integral   32    'h0                                    
//   data                         integral   32    'h96                                   
//   depth                        int        32    'd3                                    
//   parent sequence (name)       string     6     clkseq                                 
//   parent sequence (full name)  string     39    uvm_test_top.reg_agt.sqr.top_seq.clkseq
//   sequencer                    string     24    uvm_test_top.reg_agt.sqr               
// ---------------------------------------------------------------------------------------
// 
// UVM_INFO @ 0: uvm_test_top.reg_agt.drv [DRV] got a item 
//  ---------------------------------------------------------------------------------------
// Name                           Type       Size  Value                                  
// ---------------------------------------------------------------------------------------
// req                            bus_trans  -     @559                                   
//   cmd                          cmd_t      32    RESET                                  
//   addr                         integral   32    'h0                                    
//   data                         integral   32    'h0                                    
//   depth                        int        32    'd3                                    
//   parent sequence (name)       string     6     clkseq                                 
//   parent sequence (full name)  string     39    uvm_test_top.reg_agt.sqr.top_seq.clkseq
//   sequencer                    string     24    uvm_test_top.reg_agt.sqr               
// ---------------------------------------------------------------------------------------
// 
// UVM_INFO @ 0: uvm_test_top.reg_agt.drv [DRV] got a item 
//  ----------------------------------------------------------------------------------------
// Name                           Type       Size  Value                                   
// ----------------------------------------------------------------------------------------
// req                            bus_trans  -     @574                                    
//   cmd                          cmd_t      32    WRREG                                   
//   addr                         integral   32    'h0                                     
//   data                         integral   32    'h0                                     
//   depth                        int        32    'd3                                     
//   parent sequence (name)       string     7     regseq0                                 
//   parent sequence (full name)  string     40    uvm_test_top.reg_agt.sqr.top_seq.regseq0
//   sequencer                    string     24    uvm_test_top.reg_agt.sqr                
// ----------------------------------------------------------------------------------------
// 
// UVM_INFO @ 0: uvm_test_top.reg_agt.drv [DRV] got a item 
//  ----------------------------------------------------------------------------------------
// Name                           Type       Size  Value                                   
// ----------------------------------------------------------------------------------------
// req                            bus_trans  -     @580                                    
//   cmd                          cmd_t      32    RDREG                                   
//   addr                         integral   32    'h0                                     
//   data                         integral   32    'h0                                     
//   depth                        int        32    'd3                                     
//   parent sequence (name)       string     7     regseq0                                 
//   parent sequence (full name)  string     40    uvm_test_top.reg_agt.sqr.top_seq.regseq0
//   sequencer                    string     24    uvm_test_top.reg_agt.sqr                
// ----------------------------------------------------------------------------------------
// 
// UVM_INFO @ 0: uvm_test_top.reg_agt.drv [DRV] got a item 
//  ----------------------------------------------------------------------------------------
// Name                           Type       Size  Value                                   
// ----------------------------------------------------------------------------------------
// req                            bus_trans  -     @588                                    
//   cmd                          cmd_t      32    RDREG                                   
//   addr                         integral   32    'h10                                    
//   data                         integral   32    'h0                                     
//   depth                        int        32    'd3                                     
//   parent sequence (name)       string     7     regseq0                                 
//   parent sequence (full name)  string     40    uvm_test_top.reg_agt.sqr.top_seq.regseq0
//   sequencer                    string     24    uvm_test_top.reg_agt.sqr                
// ----------------------------------------------------------------------------------------
// 
// UVM_INFO @ 0: uvm_test_top.reg_agt.drv [DRV] got a item 
//  ----------------------------------------------------------------------------------------
// Name                           Type       Size  Value                                   
// ----------------------------------------------------------------------------------------
// req                            bus_trans  -     @602                                    
//   cmd                          cmd_t      32    WRREG                                   
//   addr                         integral   32    'h4                                     
//   data                         integral   32    'h0                                     
//   depth                        int        32    'd3                                     
//   parent sequence (name)       string     7     regseq1                                 
//   parent sequence (full name)  string     40    uvm_test_top.reg_agt.sqr.top_seq.regseq1
//   sequencer                    string     24    uvm_test_top.reg_agt.sqr                
// ----------------------------------------------------------------------------------------
// 
// UVM_INFO @ 0: uvm_test_top.reg_agt.drv [DRV] got a item 
//  ----------------------------------------------------------------------------------------
// Name                           Type       Size  Value                                   
// ----------------------------------------------------------------------------------------
// req                            bus_trans  -     @608                                    
//   cmd                          cmd_t      32    RDREG                                   
//   addr                         integral   32    'h4                                     
//   data                         integral   32    'h0                                     
//   depth                        int        32    'd3                                     
//   parent sequence (name)       string     7     regseq1                                 
//   parent sequence (full name)  string     40    uvm_test_top.reg_agt.sqr.top_seq.regseq1
//   sequencer                    string     24    uvm_test_top.reg_agt.sqr                
// ----------------------------------------------------------------------------------------
// 
// UVM_INFO @ 0: uvm_test_top.reg_agt.drv [DRV] got a item 
//  ----------------------------------------------------------------------------------------
// Name                           Type       Size  Value                                   
// ----------------------------------------------------------------------------------------
// req                            bus_trans  -     @616                                    
//   cmd                          cmd_t      32    RDREG                                   
//   addr                         integral   32    'h14                                    
//   data                         integral   32    'h0                                     
//   depth                        int        32    'd3                                     
//   parent sequence (name)       string     7     regseq1                                 
//   parent sequence (full name)  string     40    uvm_test_top.reg_agt.sqr.top_seq.regseq1
//   sequencer                    string     24    uvm_test_top.reg_agt.sqr                
// ----------------------------------------------------------------------------------------
// 
// UVM_INFO @ 0: uvm_test_top.reg_agt.drv [DRV] got a item 
//  ----------------------------------------------------------------------------------------
// Name                           Type       Size  Value                                   
// ----------------------------------------------------------------------------------------
// req                            bus_trans  -     @630                                    
//   cmd                          cmd_t      32    WRREG                                   
//   addr                         integral   32    'h8                                     
//   data                         integral   32    'h0                                     
//   depth                        int        32    'd3                                     
//   parent sequence (name)       string     7     regseq2                                 
//   parent sequence (full name)  string     40    uvm_test_top.reg_agt.sqr.top_seq.regseq2
//   sequencer                    string     24    uvm_test_top.reg_agt.sqr                
// ----------------------------------------------------------------------------------------
// 
// UVM_INFO @ 0: uvm_test_top.reg_agt.drv [DRV] got a item 
//  ----------------------------------------------------------------------------------------
// Name                           Type       Size  Value                                   
// ----------------------------------------------------------------------------------------
// req                            bus_trans  -     @636                                    
//   cmd                          cmd_t      32    RDREG                                   
//   addr                         integral   32    'h8                                     
//   data                         integral   32    'h0                                     
//   depth                        int        32    'd3                                     
//   parent sequence (name)       string     7     regseq2                                 
//   parent sequence (full name)  string     40    uvm_test_top.reg_agt.sqr.top_seq.regseq2
//   sequencer                    string     24    uvm_test_top.reg_agt.sqr                
// ----------------------------------------------------------------------------------------
// 
// UVM_INFO @ 0: uvm_test_top.reg_agt.drv [DRV] got a item 
//  ----------------------------------------------------------------------------------------
// Name                           Type       Size  Value                                   
// ----------------------------------------------------------------------------------------
// req                            bus_trans  -     @644                                    
//   cmd                          cmd_t      32    RDREG                                   
//   addr                         integral   32    'h18                                    
//   data                         integral   32    'h0                                     
//   depth                        int        32    'd3                                     
//   parent sequence (name)       string     7     regseq2                                 
//   parent sequence (full name)  string     40    uvm_test_top.reg_agt.sqr.top_seq.regseq2
//   sequencer                    string     24    uvm_test_top.reg_agt.sqr                
// ----------------------------------------------------------------------------------------
