
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
  
  reg [31:0] regs [5:0];
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
  
  always@ (posedge clk_i or negedge rstn_i) begin
    if(!rstn_i) begin 
      regs [`SLV0_RW_REG] <= 32'h00000007;
      regs [`SLV1_RW_REG] <= 32'h00000007;
      regs [`SLV2_RW_REG] <= 32'h00000007;
      regs [`SLV0_R_REG]  <= 32'h00000010;
      regs [`SLV1_R_REG]  <= 32'h00000010;
      regs [`SLV2_R_REG]  <= 32'h00000010;
    end
    else begin 
  	  if (cmd_i== `WRITE) begin
        case(cmd_addr_i)
        `SLV0_RW_ADDR: regs[`SLV0_RW_REG] <= cmd_data_i;				
        `SLV1_RW_ADDR: regs[`SLV1_RW_REG] <= cmd_data_i;			
        `SLV2_RW_ADDR: regs[`SLV2_RW_REG] <= cmd_data_i;           				
        endcase 
  	  end	
  		else if(cmd_i == `READ) begin       
        case(cmd_addr_i)
        `SLV0_RW_ADDR: cmd_data_reg  <= regs[`SLV0_RW_REG];
        `SLV1_RW_ADDR: cmd_data_reg  <= regs[`SLV1_RW_REG];
        `SLV2_RW_ADDR: cmd_data_reg  <= regs[`SLV2_RW_REG];					
        `SLV0_R_ADDR:  cmd_data_reg  <= regs[`SLV0_R_REG];
        `SLV1_R_ADDR:  cmd_data_reg  <= regs[`SLV1_R_REG];
        `SLV2_R_ADDR:  cmd_data_reg  <= regs[`SLV2_R_REG];
        endcase
      end
      regs[`SLV0_R_REG][7:0] <= slv0_margin_i ;
      regs[`SLV1_R_REG][7:0] <= slv1_margin_i ;
      regs[`SLV2_R_REG][7:0] <= slv2_margin_i ;
  	end
  end
    
  assign cmd_data_o = cmd_data_reg;
  assign slv0_len_o = regs[`SLV0_RW_REG][5:3];
  assign slv1_len_o = regs[`SLV1_RW_REG][5:3];
  assign slv2_len_o = regs[`SLV2_RW_REG][5:3];
  assign slv0_prio_o = regs[`SLV0_RW_REG][2:1];
  assign slv1_prio_o = regs[`SLV1_RW_REG][2:1];
  assign slv2_prio_o = regs[`SLV2_RW_REG][2:1];
  assign slv0_en_o = regs[`SLV0_RW_REG][0];
  assign slv1_en_o = regs[`SLV1_RW_REG][0];
  assign slv2_en_o = regs[`SLV2_RW_REG][0];

endmodule: ctrl_regs

interface mcdf_if(input clk, input rstn);
  logic [7:0] addr;
  logic [31:0] wdata;
  logic [31:0] rdata;
  logic [1:0] cmd;

  logic [7:0] chnl0_fifo_avail;
  logic [7:0] chnl1_fifo_avail;
  logic [7:0] chnl2_fifo_avail;
endinterface: mcdf_if

module reg_backdoor_access;

  import uvm_pkg::*;
  `include "uvm_macros.svh"

  class ctrl_reg extends uvm_reg;
    `uvm_object_utils(ctrl_reg)
    uvm_reg_field reserved;
    rand uvm_reg_field pkt_len;
    rand uvm_reg_field prio_level;
    rand uvm_reg_field chnl_en;

    function new(string name = "ctrl_reg");
      super.new(name, 32, UVM_NO_COVERAGE);
    endfunction
    
    virtual function build();
      reserved = uvm_reg_field::type_id::create("reserved");
      pkt_len = uvm_reg_field::type_id::create("pkt_len");
      prio_level = uvm_reg_field::type_id::create("prio_level");
      chnl_en = uvm_reg_field::type_id::create("chnl_en");
    
      reserved.configure(this, 26, 6, "RO", 0, 26'h0, 1, 0, 0);
      pkt_len.configure(this, 3, 3, "RW", 0, 3'h0, 1, 1, 0);
      prio_level.configure(this, 2, 1, "RW", 0, 2'h3, 1, 1, 0);
      chnl_en.configure(this, 1, 0, "RW", 0, 1'h0, 1, 1, 0);
    endfunction
  endclass

  class stat_reg extends uvm_reg;
    `uvm_object_utils(stat_reg)
    uvm_reg_field reserved;
    rand uvm_reg_field fifo_avail;

    function new(string name = "stat_reg");
      super.new(name, 32, UVM_NO_COVERAGE);
    endfunction

    virtual function build();
      reserved = uvm_reg_field::type_id::create("reserved");
      fifo_avail = uvm_reg_field::type_id::create("fifo_avail");

      reserved.configure(this, 24, 8, "RO", 0, 24'h0, 1, 0, 0);
      fifo_avail.configure(this, 8, 0, "RO", 0, 8'h0, 1, 1, 0);
    endfunction
  endclass

  class mcdf_rgm extends uvm_reg_block;
    `uvm_object_utils(mcdf_rgm)
    rand ctrl_reg chnl0_ctrl_reg;
    rand ctrl_reg chnl1_ctrl_reg;
    rand ctrl_reg chnl2_ctrl_reg;
    rand stat_reg chnl0_stat_reg;
    rand stat_reg chnl1_stat_reg;
    rand stat_reg chnl2_stat_reg;

    uvm_reg_map map;

    function new(string name = "mcdf_rgm");
      super.new(name, UVM_NO_COVERAGE);
    endfunction

    virtual function build();
      chnl0_ctrl_reg = ctrl_reg::type_id::create("chnl0_ctrl_reg");
      chnl0_ctrl_reg.configure(this);
      chnl0_ctrl_reg.build();

      chnl1_ctrl_reg = ctrl_reg::type_id::create("chnl1_ctrl_reg");
      chnl1_ctrl_reg.configure(this);
      chnl1_ctrl_reg.build();

      chnl2_ctrl_reg = ctrl_reg::type_id::create("chnl2_ctrl_reg");
      chnl2_ctrl_reg.configure(this);
      chnl2_ctrl_reg.build();

      chnl0_stat_reg = stat_reg::type_id::create("chnl0_stat_reg");
      chnl0_stat_reg.configure(this);
      chnl0_stat_reg.build();

      chnl1_stat_reg = stat_reg::type_id::create("chnl1_stat_reg");
      chnl1_stat_reg.configure(this);
      chnl1_stat_reg.build();

      chnl2_stat_reg = stat_reg::type_id::create("chnl2_stat_reg");
      chnl2_stat_reg.configure(this);
      chnl2_stat_reg.build();

      // map name, offset, number of bytes, endianess
      map = create_map("map", 'h0, 4, UVM_LITTLE_ENDIAN);

      map.add_reg(chnl0_ctrl_reg, 32'h00000000, "RW");
      map.add_reg(chnl1_ctrl_reg, 32'h00000004, "RW");
      map.add_reg(chnl2_ctrl_reg, 32'h00000008, "RW");
      map.add_reg(chnl0_stat_reg, 32'h00000010, "RO");
      map.add_reg(chnl1_stat_reg, 32'h00000014, "RO");
      map.add_reg(chnl2_stat_reg, 32'h00000018, "RO");

      // specify HDL path
      chnl0_ctrl_reg.add_hdl_path_slice($sformatf("regs[%0d]", `SLV0_RW_REG), 0, 32);
      chnl1_ctrl_reg.add_hdl_path_slice($sformatf("regs[%0d]", `SLV1_RW_REG), 0, 32);
      chnl2_ctrl_reg.add_hdl_path_slice($sformatf("regs[%0d]", `SLV2_RW_REG), 0, 32);
      chnl0_stat_reg.add_hdl_path_slice($sformatf("regs[%0d]", `SLV0_R_REG ), 0, 32);
      chnl1_stat_reg.add_hdl_path_slice($sformatf("regs[%0d]", `SLV1_R_REG ), 0, 32);
      chnl2_stat_reg.add_hdl_path_slice($sformatf("regs[%0d]", `SLV2_R_REG ), 0, 32);

      add_hdl_path("reg_backdoor_access.dut");

      lock_model();
    endfunction
  endclass


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
    virtual mcdf_if vif;
    uvm_analysis_port #(mcdf_bus_trans) ap;
    `uvm_component_utils(mcdf_bus_monitor)
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction
    function void build_phase(uvm_phase phase);
      if(!uvm_config_db#(virtual mcdf_if)::get(this, "", "vif", vif)) begin
        `uvm_error("GETVIF", "no virtual interface is assigned")
      end
      ap = new("ap", this);
    endfunction
    task run_phase(uvm_phase phase);
      forever begin
        mon_trans();
      end
    endtask
    task mon_trans();
      mcdf_bus_trans t;
      @(posedge vif.clk);
      if(vif.cmd == `WRITE) begin
        t = new();
        t.cmd = `WRITE;
        t.addr = vif.addr;
        t.wdata = vif.wdata;
        ap.write(t);
      end
      else if(vif.cmd == `READ) begin
        t = new();
        t.cmd = `READ;
        t.addr = vif.addr;
        fork
          @(posedge vif.clk);
          #10ps;
          t.rdata = vif.rdata;
          ap.write(t);
        join_none
      end
    endtask
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
      reset_listener();
      forever begin
        seq_item_port.get_next_item(tmp);
        void'($cast(req, tmp));
        `uvm_info("DRV", $sformatf("got a item \n %s", req.sprint()), UVM_LOW)
        void'($cast(rsp, req.clone()));
        rsp.set_sequence_id(req.get_sequence_id());
        rsp.set_transaction_id(req.get_transaction_id());
        drive_bus(rsp);
        seq_item_port.item_done(rsp);
        `uvm_info("DRV", $sformatf("sent a item \n %s", rsp.sprint()), UVM_LOW)
      end
    endtask
    task reset_listener();
      fork
        forever begin
          @(negedge vif.rstn) drive_idle();
        end
      join_none
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
      #10ps;
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

  class reg2mcdf_adapter extends uvm_reg_adapter;
    `uvm_object_utils(reg2mcdf_adapter)
    function new(string name = "mcdf_bus_trans");
      super.new(name);
      provides_responses = 1;
    endfunction
    function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
      mcdf_bus_trans t = mcdf_bus_trans::type_id::create("t");
      t.cmd = (rw.kind == UVM_WRITE) ? `WRITE : `READ;
      t.addr = rw.addr;
      t.wdata = rw.data;
      return t;
    endfunction
    function void bus2reg(uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);
      mcdf_bus_trans t;
      if (!$cast(t, bus_item)) begin
        `uvm_fatal("NOT_MCDF_BUS_TYPE","Provided bus_item is not of the correct type")
        return;
      end
      rw.kind = (t.cmd == `WRITE) ? UVM_WRITE : UVM_READ;
      rw.addr = t.addr;
      rw.data = (t.cmd == `WRITE) ? t.wdata : t.rdata;
      rw.status = UVM_IS_OK;
    endfunction
  endclass

  class mcdf_bus_env extends uvm_env;
    mcdf_bus_agent agent;
    mcdf_rgm rgm;
    reg2mcdf_adapter reg2mcdf;
    uvm_reg_predictor #(mcdf_bus_trans) mcdf2reg_preditor;
    `uvm_component_utils(mcdf_bus_env)
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction
    function void build_phase(uvm_phase phase);
      agent = mcdf_bus_agent::type_id::create("agent", this);
      if(!uvm_config_db#(mcdf_rgm)::get(this, "", "rgm", rgm)) begin
        `uvm_info("GETRGM", "no top-down RGM hangle is assigned", UVM_LOW)
        rgm = mcdf_rgm::type_id::create("rgm", this);
        `uvm_info("NEWRGM", "created rgm instance locally", UVM_LOW)
      end
      rgm.build();
      reg2mcdf = reg2mcdf_adapter::type_id::create("reg2mcdf");
      mcdf2reg_preditor = uvm_reg_predictor#(mcdf_bus_trans)::type_id::create("mcdf2reg_preditor", this);
      mcdf2reg_preditor.map = rgm.map;
      mcdf2reg_preditor.adapter = reg2mcdf;
    endfunction
    function void connect_phase(uvm_phase phase);
      rgm.map.set_sequencer(agent.sequencer, reg2mcdf);
      agent.monitor.ap.connect(mcdf2reg_preditor.bus_in);
    endfunction
  endclass

  class mcdf_example_seq extends uvm_reg_sequence;
    mcdf_rgm rgm;
    `uvm_object_utils(mcdf_example_seq)
    `uvm_declare_p_sequencer(mcdf_bus_sequencer)
    function new(string name = "mcdf_example_seq");
      super.new(name);
    endfunction
    task body();
      uvm_status_e status;
      uvm_reg_data_t data;
      if(!uvm_config_db#(mcdf_rgm)::get(null, get_full_name(), "rgm", rgm)) begin
        `uvm_error("GETRGM", "no top-down RGM hangle is assigned")
      end
      #1us;
      // register model access write()/read()
      rgm.chnl0_ctrl_reg.read (status, data, UVM_BACKDOOR, .parent(this));
      rgm.chnl0_ctrl_reg.write(status, 'h11, UVM_BACKDOOR, .parent(this));
      rgm.chnl0_ctrl_reg.read (status, data, UVM_BACKDOOR, .parent(this));
      // register model access poke()/peed()
      rgm.chnl1_ctrl_reg.peek (status, data, .parent(this));
      rgm.chnl1_ctrl_reg.poke (status, 'h22, .parent(this));
      rgm.chnl1_ctrl_reg.peek (status, data, .parent(this));
      // pre-defined methods read_reg()/write_reg()
      read_reg (rgm.chnl2_ctrl_reg, status, data, UVM_BACKDOOR);
      write_reg(rgm.chnl2_ctrl_reg, status, 'h22, UVM_BACKDOOR);
      read_reg (rgm.chnl2_ctrl_reg, status, data, UVM_BACKDOOR);
      // pre-defined methods peek_reg()/poke_reg()
      peek_reg (rgm.chnl2_ctrl_reg, status, data);
      poke_reg (rgm.chnl2_ctrl_reg, status, 'h33);
      peek_reg (rgm.chnl2_ctrl_reg, status, data);
      #1us;
    endtask
  endclass

  class test1 extends uvm_test;
    mcdf_rgm rgm;
    mcdf_bus_env env;
    `uvm_component_utils(test1)
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction
    function void build_phase(uvm_phase phase);
      rgm = mcdf_rgm::type_id::create("rgm", this);
      uvm_config_db#(mcdf_rgm)::set(this, "env*", "rgm", rgm);
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

endmodule: reg_backdoor_access
