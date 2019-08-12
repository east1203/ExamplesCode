


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

typedef struct packed{
  longint irq_routine;
  longint irq_num;
} irq_info_t;

virtual_core cores[int];


import "DPI-C" context task core0_thread();
import "DPI-C" context task core1_thread();
import "DPI-C" context task serve_irq(int index);

export "DPI-C" dpi_writew = task writew;
export "DPI-C" dpi_readw  = task readw ;
export "DPI-C" dpi_delay  = task delay ;
export "DPI-C" dpi_print  = task print ;
export "DPI-C" dpi_install_irq = task install_irq;

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

task install_irq(input longint irq_routine, input int unsigned irq_num, int unsigned id=0);
  irq_info_t irq;
  irq.irq_routine = irq_routine;
  irq.irq_num = irq_num;
  cores[id].irq_queue_add_item(irq);
endtask


class virtual_core extends uvm_component;

  virtual core_if vif;
  ahb_master_sequencer sqr;
  local int id;
  local irq_info_t irq_info_queue[$];
  local process main_proc;

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
  extern function void irq_queue_add_item(irq_info_t irq);
  extern function int get_triggerred_irq_routine();
  extern task pooling_irq();
  extern task suspend();
  extern task resume();
endclass

function void virtual_core::build_phase(uvm_phase phase);
  uvm_config_db#(virtual core_if)::get(this, "", "vif", vif);
endfunction

task virtual_core::run_phase(uvm_phase phase);
  super.run_phase(phase);
  @(posedge vif.rstn);
  fork
    pooling_irq();
  join_none
  case(id)
    0: begin main_proc = process::self(); core0_thread(); end
    1: begin main_proc = process::self(); core1_thread(); end
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


// put interrupt info
function void virtual_core::irq_queue_add_item(irq_info_t irq);
  irq_info_queue.push_back(irq);
endfunction

// get interupt index
function int virtual_core::get_triggerred_irq_routine();
  int idx[$]; 
  for(int i=0; i<16; i++) begin
    idx = irq_info_queue.find_index with (item.irq_num == i);
    if(vif.irq[i] == 1 && idx.size() > 0) begin
      return i;
    end
  end
  return -1;
endfunction: get_triggerred_irq_routine

// pooling service which monitors interrupt and process handlers
task virtual_core::pooling_irq();
  int triggerred_irq_num;
  forever begin
    // Wait for the IRQ
    wait($countones(vif.irq) > 0  && irq_info_queue.size() > 0 && get_triggerred_irq_routine() >= 0 ); 
    `uvm_info("IRQSERVICE", "IRQ triggerred", UVM_LOW)
    // Get the ISR 
    triggerred_irq_num = get_triggerred_irq_routine();
    if (main_proc != null && main_proc.status != process::FINISHED) begin
      // Suspend main c-code execution
      suspend();
      // Execute ISR
      serve_irq(triggerred_irq_num);
      // Resume main c-code execution
      resume();
    end else
      serve_irq(triggerred_irq_num);
  end
endtask: pooling_irq


// Task that suspends main process execution
task virtual_core::suspend();
  if (main_proc != null && main_proc.status != process::FINISHED && main_proc.status != process::SUSPENDED) begin
    // Suspending main process
    main_proc.suspend();
    // Waiting for the process status to be updated
    wait (main_proc.status == process::SUSPENDED);
    `uvm_info("PROCESS", "Suspending main process", UVM_LOW)
  end
endtask: suspend

// Task that resumes main process execution
task virtual_core::resume();
  if (main_proc != null && main_proc.status != process::FINISHED) begin
    // resuming main process
    main_proc.resume();
    // Waiting for the process status to be updated
    wait (main_proc.status == process::RUNNING);
    `uvm_info("PROCESS", "Resuming main process", UVM_LOW)
  end
endtask: resume


class virtual_core_subsys extends uvm_env;
  virtual_core c0;
  ahb_master_agent ahb_mst;
  `uvm_component_utils(virtual_core_subsys)
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    c0 = virtual_core::type_id::create("c0", this);
    ahb_mst = ahb_master_agent::type_id::create("ahb_mst", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    c0.sqr = ahb_mst.sequencer;
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
    repeat(150) @(posedge env.c0.vif.clk);
    env.c0.vif.irq[1] <= 1;
    repeat(10) @(posedge env.c0.vif.clk);
    env.c0.vif.irq[1] <= 0;
    #1ms;
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
    uvm_config_db#(virtual ahb_if)::set(uvm_root::get(), "uvm_test_top.env.ahb_mst", "vif", bus_if);
    run_test("test");
  end
endmodule
