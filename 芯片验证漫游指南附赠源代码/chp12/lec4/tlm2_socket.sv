module tlm2_socket;
  import uvm_pkg::*;
  `include "uvm_macros.svh"



  class comp1 extends uvm_component;
    uvm_tlm_b_initiator_socket b_ini_skt;
    `uvm_component_utils(comp1)
    function new(string name, uvm_component parent);
      super.new(name, parent);
      b_ini_skt = new("b_ini_skt", this);
    endfunction
    task run_phase(uvm_phase phase);
      byte unsigned data[] = {1, 2, 3, 4, 5, 6, 7, 8};
      uvm_tlm_generic_payload pl = new("pl");
      uvm_tlm_time delay = new("delay");
      pl.set_address('h0000F000);
      pl.set_data_length(8);
      pl.set_data(data);
      pl.set_byte_enable_length(8);
      pl.set_write();
      delay.incr(0.3ns, 1ps);
      `uvm_info("INITRSP", $sformatf("initiated a trans at %0d ps", $realtime()), UVM_LOW)
      b_ini_skt.b_transport(pl, delay);
    endtask
  endclass

  class comp2 extends uvm_component;
    uvm_tlm_b_target_socket #(comp2) b_tgt_skt;
    `uvm_component_utils(comp2)
    function new(string name, uvm_component parent);
      super.new(name, parent);
      b_tgt_skt = new("b_tgt_skt", this);
    endfunction
    task b_transport(uvm_tlm_generic_payload pl, uvm_tlm_time delay);
      `uvm_info("TGTTRSP", $sformatf("received a trans at %0d ps", $realtime()), UVM_LOW)
      pl.print();
      #(delay.get_realtime(1ps));
      pl.set_response_status(UVM_TLM_OK_RESPONSE);
      `uvm_info("TGTTRSP", $sformatf("completed a trans at %0d ps", $realtime()), UVM_LOW)
      pl.print();
    endtask
  endclass

  class env1 extends uvm_env;
    comp1 c1;
    comp2 c2;
    `uvm_component_utils(env1)

    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      c1 = comp1::type_id::create("c1", this);
      c2 = comp2::type_id::create("c2", this);
    endfunction: build_phase

    function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      c1.b_ini_skt.connect(c2.b_tgt_skt);
    endfunction: connect_phase
  endclass

  class test1 extends uvm_test;
    `uvm_component_utils(test1)
    env1 env;
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction
    function void build_phase(uvm_phase phase);
      env = env1::type_id::create("env", this);
    endfunction
    task run_phase(uvm_phase phase);
      super.run_phase(phase);
      phase.raise_objection(phase);
      #1us;
      phase.drop_objection(phase);
    endtask
  endclass

  initial begin
    run_test("test1");
  end
endmodule



// UVM_INFO @ 0: uvm_test_top.env.c1 [INITRSP] initiated a trans at 0 ps
// UVM_INFO @ 0: uvm_test_top.env.c2 [TGTTRSP] received a trans at 0 ps
// -------------------------------------------------------------------------------
// Name               Type                       Size  Value                      
// -------------------------------------------------------------------------------
// pl                 uvm_tlm_generic_payload    -     @405                       
//   address          integral                   64    'hf000                     
//   command          uvm_tlm_command_e          32    UVM_TLM_WRITE_COMMAND      
//   response_status  uvm_tlm_response_status_e  32    UVM_TLM_INCOMPLETE_RESPONSE
//   streaming_width  integral                   32    'h0                        
//   data             darray(byte)               8     -                          
//     [0]            byte                       8     'h01 x                     
//     [1]            byte                       8     'h02 x                     
//     [2]            byte                       8     'h03 x                     
//     [3]            byte                       8     'h04 x                     
//     [4]            byte                       8     'h05 x                     
//     [5]            byte                       8     'h06 x                     
//     [6]            byte                       8     'h07 x                     
//     [7]            byte                       8     'h08 x                     
//   extensions       aa(obj,obj)                0     -                          
// -------------------------------------------------------------------------------
// UVM_INFO @ 300: uvm_test_top.env.c2 [TGTTRSP] completed a trans at 300 ps
// -------------------------------------------------------------------------
// Name               Type                       Size  Value                
// -------------------------------------------------------------------------
// pl                 uvm_tlm_generic_payload    -     @405                 
//   address          integral                   64    'hf000               
//   command          uvm_tlm_command_e          32    UVM_TLM_WRITE_COMMAND
//   response_status  uvm_tlm_response_status_e  32    UVM_TLM_OK_RESPONSE  
//   streaming_width  integral                   32    'h0                  
//   data             darray(byte)               8     -                    
//     [0]            byte                       8     'h01 x               
//     [1]            byte                       8     'h02 x               
//     [2]            byte                       8     'h03 x               
//     [3]            byte                       8     'h04 x               
//     [4]            byte                       8     'h05 x               
//     [5]            byte                       8     'h06 x               
//     [6]            byte                       8     'h07 x               
//     [7]            byte                       8     'h08 x               
//   extensions       aa(obj,obj)                0     -                    
// -------------------------------------------------------------------------
