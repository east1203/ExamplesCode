`timescale 1ps/1ps

interface mcdf_if(input clk, input rstn);
  logic [7:0] addr;
  logic [31:0] wdata;
  logic [31:0] rdata;
  logic [1:0] cmd;
endinterface

module mcdf_bus_uvc;

  import uvm_pkg::*;
  `include "uvm_macros.svh"

  typedef enum {IDLE, WRITE, READ} mcdf_cmd_t;

  class mcdf_bus_trans extends uvm_sequence_item;
    rand mcdf_cmd_t cmd;
    rand bit[7:0] addr;
    rand bit[31:0] wdata;
    bit[31:0] rdata;
    `uvm_object_utils_begin(mcdf_bus_trans)
      `uvm_field_enum(mcdf_cmd_t, cmd, UVM_ALL_ON)
      `uvm_field_int(addr, UVM_ALL_ON)
      `uvm_field_int(wdata, UVM_ALL_ON)
      `uvm_field_int(rdata, UVM_ALL_ON)
    `uvm_object_utils_end
    function new(string name = "mcdf_bus_trans");
      super.new(name);
    endfunction
  endclass

  class mcdf_bus_sequencer extends uvm_sequencer;
    `uvm_component_utils(mcdf_bus_sequencer)
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction
  endclass

  class mcdf_bus_monitor extends uvm_monitor;
    `uvm_component_utils(mcdf_bus_monitor)
    //...
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction
  endclass

  class mcdf_bus_driver extends uvm_driver;
    virtual mcdf_if vif;
    `uvm_component_utils(mcdf_bus_driver)
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction
    function void build_phase(uvm_phase phase);
      if(!uvm_config_db#(virtual mcdf_if)::get(this, "", "vif", vif)) begin
        `uvm_error("GETVIF", "no virtual interface is assigned")
      end
    endfunction
    task run_phase(uvm_phase phase);
      REQ tmp;
      mcdf_bus_trans req, rsp;
      @(negedge vif.rstn) drive_idle();
      forever begin
        seq_item_port.get_next_item(tmp);
        void'($cast(req, tmp));
        `uvm_info("DRV", $sformatf("got a item \n %s", req.sprint()), UVM_LOW)
        void'($cast(rsp, req.clone()));
        rsp.set_sequence_id(req.get_sequence_id());
        drive_bus(rsp);
        seq_item_port.item_done(rsp);
        `uvm_info("DRV", $sformatf("sent a item \n %s", rsp.sprint()), UVM_LOW)
      end
    endtask
    task drive_bus(mcdf_bus_trans t);
      case(t.cmd)
        WRITE: drive_write(t);
        READ: drive_read(t);
        IDLE: drive_idle(1);
        default: `uvm_error("DRIVE", "invalid mcdf command type received!")
      endcase
    endtask
    task drive_write(mcdf_bus_trans t);
      @(posedge vif.clk);
      vif.cmd <= t.cmd;
      vif.addr <= t.addr;
      vif.wdata <= t.wdata;
    endtask
    task drive_read(mcdf_bus_trans t);
      @(posedge vif.clk);
      vif.cmd <= t.cmd;
      vif.addr <= t.addr;
      @(posedge vif.clk);
      t.rdata = vif.rdata;
    endtask
    task drive_idle(bit is_sync = 0);
      if(is_sync) @(posedge vif.clk);
      vif.cmd <= 'h0;
      vif.addr <= 'h0;
      vif.wdata <= 'h0;
    endtask
  endclass

  class mcdf_bus_agent extends uvm_agent;
    mcdf_bus_driver driver;
    mcdf_bus_sequencer sequencer;
    mcdf_bus_monitor monitor;
    `uvm_component_utils(mcdf_bus_agent)
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction
    function void build_phase(uvm_phase phase);
      driver = mcdf_bus_driver::type_id::create("driver", this);
      sequencer = mcdf_bus_sequencer::type_id::create("sequencer", this);
      monitor = mcdf_bus_monitor::type_id::create("monitor", this);
    endfunction
    function void connect_phase(uvm_phase phase);
      driver.seq_item_port.connect(sequencer.seq_item_export);
    endfunction
  endclass

  class mcdf_bus_env extends uvm_env;
    mcdf_bus_agent agent;
    `uvm_component_utils(mcdf_bus_env)
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction
    function void build_phase(uvm_phase phase);
      agent = mcdf_bus_agent::type_id::create("agent", this);
    endfunction
  endclass

  class mcdf_example_seq extends uvm_sequence;
    `uvm_object_utils(mcdf_example_seq)
    function new(string name = "mcdf_example_seq");
      super.new(name);
    endfunction
    task body();
      mcdf_bus_trans t;
      `uvm_do_with(t, {cmd == IDLE;})
      `uvm_do_with(t, {cmd == WRITE; addr == 'h00; wdata == 'h11;})
      `uvm_do_with(t, {cmd == IDLE;})
      `uvm_do_with(t, {cmd == READ; addr == 'h10;})
      `uvm_do_with(t, {cmd == IDLE;})
    endtask
  endclass

  class test1 extends uvm_test;
    mcdf_bus_env env;
    `uvm_component_utils(test1)
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction
    function void build_phase(uvm_phase phase);
      env = mcdf_bus_env::type_id::create("env", this);
    endfunction
    task run_phase(uvm_phase phase);
      mcdf_example_seq seq;
      phase.raise_objection(phase);
      seq = new();
      seq.start(env.agent.sequencer);
      phase.drop_objection(phase);
    endtask
  endclass

  logic clk; 
  logic rstn;

  initial begin
    clk <= 0;
    forever begin
      #10ns;
      clk = !clk;
    end
  end
  
  initial begin
    #50ns; 
    rstn <= 'b0;
    #50ns; 
    rstn <= 'b1;
  end

  mcdf_if intf(clk, rstn);

  initial begin
    uvm_config_db#(virtual mcdf_if)::set(uvm_root::get(), "uvm_test_top.env.agent.*", "vif", intf);
    run_test("test1");
  end

endmodule
