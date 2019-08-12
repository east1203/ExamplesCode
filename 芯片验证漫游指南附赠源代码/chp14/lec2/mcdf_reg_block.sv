
`timescale 1ps/1ps

`define  IDLE  2'b00
`define  WRITE 2'b01
`define  READ  2'b10

`define SLV0_RW_ADDR 8'h00
`define SLV1_RW_ADDR 8'h04
`define SLV2_RW_ADDR 8'h08
`define SLV0_R_ADDR  8'h10
`define SLV1_R_ADDR  8'h14
`define SLV2_R_ADDR  8'h18

`define SLV0_RW_REG 0
`define SLV1_RW_REG 1
`define SLV2_RW_REG 2
`define SLV0_R_REG  3
`define SLV1_R_REG  4
`define SLV2_R_REG  5

module ctrl_regs(clk_i,rstn_i,
                cmd_i,cmd_addr_i,cmd_data_i,cmd_data_o,
			        	slv0_len_o,slv1_len_o,slv2_len_o,
			        	slv0_prio_o,slv1_prio_o,slv2_prio_o,		
                slv0_margin_i,slv1_margin_i,slv2_margin_i,
					 			slv0_en_o,slv1_en_o,slv2_en_o);
input clk_i,rstn_i;
input [1:0] cmd_i;
input [7:0]  cmd_addr_i; 
input [31:0]  cmd_data_i;
input [7:0] slv0_margin_i;
input [7:0] slv1_margin_i;
input [7:0] slv2_margin_i;

reg [31:0] mem [5:0];
reg [31:0] cmd_data_reg;

output  [31:0] cmd_data_o;
output  [2:0]  slv0_len_o;
output  [2:0]  slv1_len_o;
output  [2:0]  slv2_len_o;
output  [1:0]  slv0_prio_o;
output  [1:0]  slv1_prio_o;
output  [1:0]  slv2_prio_o;
output   slv0_en_o;
output   slv1_en_o;
output   slv2_en_o;

always@ (posedge clk_i or negedge rstn_i)
  if(!rstn_i)
  begin 
    mem [`SLV0_RW_REG]=32'h00000007;
    mem [`SLV1_RW_REG]=32'h00000007;
    mem [`SLV2_RW_REG]=32'h00000007;
    mem [`SLV0_R_REG]=32'h00000010;
    mem [`SLV1_R_REG]=32'h00000010;
    mem [`SLV2_R_REG]=32'h00000010;
  end
else
  begin 
	  if (cmd_i== `WRITE)
      begin
				case(cmd_addr_i)
				`SLV0_RW_ADDR: mem[`SLV0_RW_REG]<= cmd_data_i;				
				`SLV1_RW_ADDR: mem[`SLV1_RW_REG]<= cmd_data_i;			
				`SLV2_RW_ADDR: mem[`SLV2_RW_REG]<= cmd_data_i;           				
				endcase 
			end	
		else if(cmd_i == `READ)
      begin       
				case(cmd_addr_i)
				`SLV0_RW_ADDR:		cmd_data_reg  <= mem[`SLV0_RW_REG];
				`SLV1_RW_ADDR:		cmd_data_reg  <= mem[`SLV1_RW_REG];
				`SLV2_RW_ADDR:	  cmd_data_reg  <= mem[`SLV2_RW_REG];					
			  `SLV0_R_ADDR: 	cmd_data_reg  <=  mem[`SLV0_R_REG];
				`SLV1_R_ADDR: 	cmd_data_reg  <=  mem[`SLV1_R_REG];
			  `SLV2_R_ADDR: 	cmd_data_reg  <=  mem[`SLV2_R_REG];
				endcase
     end
	end
  
always@(slv0_margin_i)
  mem[`SLV0_R_REG][7:0]  <= slv0_margin_i ;
always@(slv1_margin_i)
	mem[`SLV1_R_REG][7:0]  <= slv1_margin_i ;
always@(slv2_margin_i)
	mem[`SLV2_R_REG][7:0]  <= slv2_margin_i ;

assign  cmd_data_o  = cmd_data_reg;
assign  slv0_len_o  = mem[`SLV0_RW_REG][5:3];
assign  slv1_len_o  = mem[`SLV1_RW_REG][5:3];
assign  slv2_len_o  = mem[`SLV2_RW_REG][5:3];

assign  slv0_prio_o  = mem[`SLV0_RW_REG][2:1];
assign  slv1_prio_o  = mem[`SLV1_RW_REG][2:1];
assign  slv2_prio_o  = mem[`SLV2_RW_REG][2:1];
  
assign  slv0_en_o = mem[`SLV0_RW_REG][0];
assign  slv1_en_o = mem[`SLV1_RW_REG][0];
assign  slv2_en_o = mem[`SLV2_RW_REG][0];

endmodule

interface mcdf_if(input clk, input rstn);
  logic [7:0] addr;
  logic [31:0] wdata;
  logic [31:0] rdata;
  logic [1:0] cmd;

  logic [7:0] chnl0_fifo_avail;
  logic [7:0] chnl1_fifo_avail;
  logic [7:0] chnl2_fifo_avail;
endinterface

module mcdf_reg_block;

  import uvm_pkg::*;
  `include "uvm_macros.svh"

  class mcdf_bus_trans extends uvm_sequence_item;
    rand bit[1:0] cmd;
    rand bit[7:0] addr;
    rand bit[31:0] wdata;
    bit[31:0] rdata;
    `uvm_object_utils_begin(mcdf_bus_trans)
      `uvm_field_int(cmd, UVM_ALL_ON)
      `uvm_field_int(addr, UVM_ALL_ON)
      `uvm_field_int(wdata, UVM_ALL_ON)
      `uvm_field_int(rdata, UVM_ALL_ON)
    `uvm_object_utils_end
    function new(string name = "mcdf_bus_trans");
      super.new(name);
    endfunction
  endclass

  class mcdf_bus_sequencer extends uvm_sequencer;
    virtual mcdf_if vif;
    `uvm_component_utils(mcdf_bus_sequencer)
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction
    function void build_phase(uvm_phase phase);
      if(!uvm_config_db#(virtual mcdf_if)::get(this, "", "vif", vif)) begin
        `uvm_error("GETVIF", "no virtual interface is assigned")
      end
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
        `WRITE: drive_write(t);
        `READ: drive_read(t);
        `IDLE: drive_idle(1);
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
    `uvm_declare_p_sequencer(mcdf_bus_sequencer)
    function new(string name = "mcdf_example_seq");
      super.new(name);
    endfunction
    task body();
      mcdf_bus_trans t;
      `uvm_do_with(t, {cmd == `IDLE;})
      `uvm_do_with(t, {cmd == `READ; addr == `SLV0_RW_ADDR;})
      `uvm_do_with(t, {cmd == `READ; addr == `SLV1_RW_ADDR;})
      `uvm_do_with(t, {cmd == `READ; addr == `SLV2_RW_ADDR;})
      `uvm_do_with(t, {cmd == `WRITE; addr == `SLV0_RW_ADDR; wdata == 'h11;})
      `uvm_do_with(t, {cmd == `READ; addr == `SLV0_RW_ADDR;})
      `uvm_do_with(t, {cmd == `WRITE; addr == `SLV1_RW_ADDR; wdata == 'h22;})
      `uvm_do_with(t, {cmd == `READ; addr == `SLV1_RW_ADDR;})
      `uvm_do_with(t, {cmd == `WRITE; addr == `SLV2_RW_ADDR; wdata == 'h33;})
      `uvm_do_with(t, {cmd == `READ; addr == `SLV2_RW_ADDR;})
      p_sequencer.vif.chnl0_fifo_avail <= 'h11;
      p_sequencer.vif.chnl1_fifo_avail <= 'h22;
      p_sequencer.vif.chnl2_fifo_avail <= 'h33;
      `uvm_do_with(t, {cmd == `READ; addr == `SLV0_R_ADDR;})
      `uvm_do_with(t, {cmd == `READ; addr == `SLV1_R_ADDR;})
      `uvm_do_with(t, {cmd == `READ; addr == `SLV2_R_ADDR;})
      `uvm_do_with(t, {cmd == `IDLE;})
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

  ctrl_regs dut(
    .clk_i(clk),
    .rstn_i(rstn),
    .cmd_i(intf.cmd),
    .cmd_addr_i(intf.addr),
    .cmd_data_i(intf.wdata),
    .cmd_data_o(intf.rdata),
    .slv0_margin_i(intf.chnl0_fifo_avail),
    .slv1_margin_i(intf.chnl1_fifo_avail),
    .slv2_margin_i(intf.chnl2_fifo_avail),
    .slv0_len_o(),
    .slv1_len_o(),
    .slv2_len_o(),
    .slv0_prio_o(),
    .slv1_prio_o(),
    .slv2_prio_o(),		
		.slv0_en_o(),
    .slv1_en_o(),
    .slv2_en_o());

  initial begin
    uvm_config_db#(virtual mcdf_if)::set(uvm_root::get(), "uvm_test_top.env.agent.*", "vif", intf);
    run_test("test1");
  end

endmodule
