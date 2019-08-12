module layer_seq;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  typedef class phy_master_sequencer;
  typedef enum {CLKON, CLKOFF, RESET, WRREG, RDREG} phy_cmd_t;
  typedef enum {FREQ_LOW_TRANS, FREQ_MED_TRANS, FREQ_HIGH_TRANS} layer_cmd_t;

  class bus_trans extends uvm_sequence_item;
    rand phy_cmd_t cmd;
    rand int addr;
    rand int data;
    constraint cstr{
      soft addr == 'h0;
      soft data == 'h0;
    }
    `uvm_object_utils_begin(bus_trans)
      `uvm_field_enum(phy_cmd_t, cmd, UVM_ALL_ON)
      `uvm_field_int(addr, UVM_ALL_ON)
      `uvm_field_int(data, UVM_ALL_ON)
    `uvm_object_utils_end
    function new(string name = "bus_trans");
      super.new(name);
    endfunction
  endclass

  class packet_seq extends uvm_sequence;
    rand int len;
    rand int addr;
    rand int data[];
    rand phy_cmd_t cmd;
    constraint cstr{
      soft len inside {[30:50]};
      soft addr[31:16] == 'hFF00;
      data.size() == len;
    }
    `uvm_object_utils(packet_seq)
    function new(string name = "reg_test_seq");
      super.new(name);
    endfunction
    task body();
      bus_trans req;
      foreach(data[i])
        `uvm_do_with(req, {cmd == local::cmd; 
                           addr == local::addr;
                           data == local::data[i];})
    endtask
  endclass

  class layer_trans extends uvm_sequence_item;
    rand layer_cmd_t layer_cmd;
    rand int pkt_len;
    rand int pkt_idle;
    constraint cstr {
      soft pkt_len inside {[10: 20]};
      layer_cmd == FREQ_LOW_TRANS -> pkt_idle inside {[300:400]};
      layer_cmd == FREQ_MED_TRANS -> pkt_idle inside {[100:200]};
      layer_cmd == FREQ_HIGH_TRANS -> pkt_idle inside {[20:40]};
    }
    `uvm_object_utils(layer_trans)
    function new(string name = "layer_trans");
      super.new(name);
    endfunction
  endclass

  class adapter_seq extends uvm_sequence;
    `uvm_object_utils(adapter_seq)
    `uvm_declare_p_sequencer(phy_master_sequencer)
    function new(string name = "adapter_seq");
      super.new(name);
    endfunction
    task body();
      layer_trans trans;
      packet_seq pkt;
      forever begin
        p_sequencer.up_sqr.get_next_item(req);
        void'($cast(trans, req));
        repeat(trans.pkt_len) begin
          `uvm_do(pkt)
          delay(trans.pkt_idle);
        end
        p_sequencer.up_sqr.item_done();
      end
    endtask
    virtual task delay(int delay);
    endtask
  endclass

  class top_seq extends uvm_sequence;
    `uvm_object_utils(top_seq)
    function new(string name = "top_seq");
      super.new(name);
    endfunction
    task body();
      layer_trans trans;
      `uvm_do_with(trans, {layer_cmd == FREQ_LOW_TRANS;})
      `uvm_do_with(trans, {layer_cmd == FREQ_HIGH_TRANS;})
    endtask
  endclass

  class layering_sequencer extends uvm_sequencer;
    `uvm_component_utils(layering_sequencer)
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction
  endclass

  class phy_master_sequencer extends uvm_sequencer;
    layering_sequencer up_sqr;
    `uvm_component_utils(phy_master_sequencer)
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction
  endclass

  class phy_master_driver extends uvm_driver;
    `uvm_component_utils(phy_master_driver)
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

  class phy_master_agent extends uvm_agent;
    phy_master_sequencer sqr;
    phy_master_driver drv;
    `uvm_component_utils(phy_master_agent)
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction
    function void build_phase(uvm_phase phase);
      sqr = phy_master_sequencer::type_id::create("sqr", this);
      drv = phy_master_driver::type_id::create("drv", this);
    endfunction
    function void connect_phase(uvm_phase phase);
      drv.seq_item_port.connect(sqr.seq_item_export);
    endfunction
  endclass

  class test1 extends uvm_test;
    layering_sequencer layer_sqr;
    phy_master_agent phy_agt;
    `uvm_component_utils(test1)
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction
    function void build_phase(uvm_phase phase);
      layer_sqr = layering_sequencer::type_id::create("layer_sqr", this);
      phy_agt = phy_master_agent::type_id::create("phy_agt", this);
    endfunction
    function void connect_phase(uvm_phase phase);
      phy_agt.sqr.up_sqr = layer_sqr;
    endfunction
    task run_phase(uvm_phase phase);
      top_seq seq;
      adapter_seq adapter;
      phase.raise_objection(phase);
      seq = new();
      adapter = new();
      fork
        adapter.start(phy_agt.sqr);
      join_none
      seq.start(layer_sqr);
      phase.drop_objection(phase);
    endtask
  endclass

  initial begin
    run_test("test1");
  end
endmodule


