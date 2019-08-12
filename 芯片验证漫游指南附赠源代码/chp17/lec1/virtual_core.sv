


package virtual_core_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

// AHB UVC definition 
// ahb_master_agent
// ahb_master_driver
// ahb_master_monitor
// ahb_master_sequencer
// ahb_transaction (sequence)
// ...



class ahb_transaction extends uvm_sequence;
  rand int unsigned addr;
  rand int unsigned data;
  rand bit wr_rd;
  // ... other fields
  `uvm_object_utils(ahb_transaction)
  function new(string name = "ahb_transaction");
    super.new(name);
  endfunction
endclass

class ahb_master_sequencer extends uvm_sequencer;
  `uvm_component_utils(ahb_master_sequencer)
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
endclass

class ahb_master_driver extends uvm_driver;
  `uvm_component_utils(ahb_master_driver)
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
endclass

class ahb_master_agent extends uvm_component;
  ahb_master_sequencer sequencer;
  ahb_master_driver driver;
  `uvm_component_utils(ahb_master_agent)
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
endclass


typedef class virtual_core;

virtual_core cores[int];


import "DPI-C" context task core0_thread();
import "DPI-C" context task core1_thread();

export "DPI-C" dpi_writew = task writew;
export "DPI-C" dpi_readw  = task readw ;
export "DPI-C" dpi_delay  = task delay ;
export "DPI-C" dpi_print  = task print ;

task writew(int unsigned addr, int unsigned data, int unsigned id = 0);
  cores[id].writew(addr, data);
endtask

task readw(int unsigned addr, output int unsigned data, int unsigned id = 0);
  cores[id].readw(addr, data);
endtask

task delay(input int t, int unsigned id = 0);
  cores[id].delay(t);
endtask

task print(input string message, int unsigned id = 0);
  cores[id].print(message);
endtask


class virtual_core extends uvm_component;

  virtual core_if vif;
  ahb_master_sequencer sqr;
  local int id;

  `uvm_component_utils(virtual_core)
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
    id = cores.size();
    cores[id] = this;
  endfunction

  extern task run_phase(uvm_phase phase);

  extern function void build_phase(uvm_phase phase);
  extern task writew(int unsigned addr, int unsigned data);
  extern task readw(int unsigned addr, output int unsigned data);
  extern task delay(input int t);
  extern task print(input string message);
endclass

function void virtual_core::build_phase(uvm_phase phase);
  uvm_config_db#(virtual core_if)::get(this, "", "vif", vif);
endfunction

task virtual_core::run_phase(uvm_phase phase);
  super.run_phase(phase);
  @(posedge vif.rstn);
  case(id)
    0: core0_thread();
    1: core1_thread();
  endcase
endtask

task virtual_core::writew(int unsigned addr, int unsigned data);
  ahb_transaction t = new();
  t.addr = addr;
  t.data = data;
  t.wr_rd = 1;
  // t.start(sqr);
  `uvm_info("CORE", $sformatf("write addr=0x%32x, data=0x%32x", addr, data), UVM_LOW)
endtask

task virtual_core::readw(int unsigned addr, output int unsigned data);
  ahb_transaction t = new();
  t.addr = addr;
  t.wr_rd = 0;
  // t.start(sqr); 
  // get data from response
  data = t.data;
  `uvm_info("CORE", $sformatf("read addr=0x%32x, data=0x%32x", addr, data), UVM_LOW)
endtask

task virtual_core::delay(input int t);
  repeat(t*10) @(posedge vif.clk);
endtask

task virtual_core::print(input string message);
  `uvm_info("CORE", message, UVM_LOW)
endtask




class virtual_core_subsys extends uvm_env;
  virtual_core c0;
  virtual_core c1;
  ahb_master_agent ahb_mst;
  `uvm_component_utils(virtual_core_subsys)
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    c0 = virtual_core::type_id::create("c0", this);
    c1 = virtual_core::type_id::create("c1", this);
    ahb_mst = ahb_master_agent::type_id::create("ahb_mst", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    c0.sqr = ahb_mst.sequencer;
    c1.sqr = ahb_mst.sequencer;
  endfunction

endclass

class test extends uvm_test;
  virtual_core_subsys env;
  `uvm_component_utils(test)
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  function void build_phase(uvm_phase phase);
    env = virtual_core_subsys::type_id::create("env", this);
  endfunction
  task run_phase(uvm_phase phase);
    phase.raise_objection(phase);
    #10us;
    phase.drop_objection(phase);
  endtask
endclass

endpackage: virtual_core_pkg

interface ahb_if; 
  logic clk;
  logic rstn;
  // ... other signals
endinterface

interface core_if; 
  logic clk;
  logic rstn;
  logic [15:0] irq;
endinterface

module virtual_core_tb;
  logic clk;
  logic rstn;

  import uvm_pkg::*;
  import virtual_core_pkg::*;

  // clock and reset generation
  initial begin
    clk <= 1'b0;
    forever #5 clk <= !clk;
  end

  initial begin
    repeat(10) @(posedge clk);
    rstn <= 1'b0;
    repeat(10) @(posedge clk);
    rstn <= 1'b1;
  end

  // AHB interface instantiation
  ahb_if bus_if();
  assign bus_if.clk = clk;
  assign bus_if.rstn = rstn;

  // Othter sideband signals
  core_if sb_if();
  assign sb_if.clk = clk;
  assign sb_if.rstn = rstn;

  // DUT instantiation and connection
  // ...


  initial begin
    uvm_config_db#(virtual core_if)::set(uvm_root::get(), "uvm_test_top.env.c0", "vif", sb_if);
    uvm_config_db#(virtual core_if)::set(uvm_root::get(), "uvm_test_top.env.c1", "vif", sb_if);
    uvm_config_db#(virtual ahb_if)::set(uvm_root::get(), "uvm_test_top.env.ahb_mst", "vif", bus_if);
    run_test("test");
  end
endmodule
