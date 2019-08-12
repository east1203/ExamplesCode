module tlm_connect;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  class request extends uvm_transaction;
    byte cmd;
    int addr;
    int req;
  endclass

  class response extends uvm_transaction;
    byte cmd;
    int addr;
    int rsp;
    int status;
  endclass

  class comp1 extends uvm_agent;
    uvm_blocking_get_port #(request) bg_port;
    `uvm_component_utils(comp1)
    function new(string name, uvm_component parent);
      super.new(name, parent);
      bg_port = new("bg_port", this);
    endfunction
  endclass

  class comp2 extends uvm_agent;
    uvm_blocking_get_port #(request) bg_port;
    uvm_nonblocking_put_imp #(request, comp2) nbp_imp;
    `uvm_component_utils(comp2)
    function new(string name, uvm_component parent);
      super.new(name, parent);
      bg_port = new("bg_port", this);
      nbp_imp = new("nbp_imp", this);
    endfunction
    function bit try_put (request req); 
      // ...
    endfunction 
    function bit can_put(); 
      // ...
    endfunction
  endclass

  class comp3 extends uvm_agent;
    uvm_blocking_transport_port #(request, response) bt_port;
    `uvm_component_utils(comp3)
    function new(string name, uvm_component parent);
      super.new(name, parent);
      bt_port = new("bt_port", this);
    endfunction
  endclass

  class comp4 extends uvm_agent;
    uvm_blocking_get_imp #(request, comp4) bg_imp;
    uvm_nonblocking_put_port #(request) nbp_port;
    `uvm_component_utils(comp4)
    function new(string name, uvm_component parent);
      super.new(name, parent);
      bg_imp = new("bg_imp", this);
      nbp_port = new("nbp_port", this);
    endfunction

    task get (output request req); 
      // ...
    endtask
  endclass

  class comp5 extends uvm_agent;
    uvm_blocking_transport_imp #(request, response, comp5) bt_imp;
    `uvm_component_utils(comp5)
    function new(string name, uvm_component parent);
      super.new(name, parent);
      bt_imp = new("bt_imp", this);
    endfunction
    task transport (request req, output response rsp); 
      // ...
    endtask
  endclass

  class agent1 extends uvm_agent;
    uvm_blocking_get_port #(request) bg_port;
    uvm_nonblocking_put_export #(request) nbp_exp;
    uvm_blocking_transport_port #(request, response) bt_port;

    comp1 c1;
    comp2 c2;
    comp3 c3;
    `uvm_component_utils(agent1)
    function new(string name, uvm_component parent);
      super.new(name, parent);
      bg_port = new("bg_port", this);
      nbp_exp = new("nbp_exp", this);
      bt_port = new("bt_port", this);
    endfunction

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      c1 = comp1::type_id::create("c1", this);
      c2 = comp2::type_id::create("c2", this);
      c3 = comp3::type_id::create("c3", this);
    endfunction

    function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      c1.bg_port.connect(this.bg_port);
      c2.bg_port.connect(this.bg_port);
      this.nbp_exp.connect(c2.nbp_imp);
      c3.bt_port.connect(this.bt_port);
    endfunction
  endclass

  class env1 extends uvm_env;
    agent1 a1;
    comp4 c4;
    comp5 c5;
    `uvm_component_utils(env1)

    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      a1 = agent1::type_id::create("a1", this);
      c4 = comp4::type_id::create("c4", this);
      c5 = comp5::type_id::create("c5", this);
    endfunction: build_phase


    function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      a1.bg_port.connect(c4.bg_imp);
      c4.nbp_port.connect(a1.nbp_exp);
      a1.bt_port.connect(c5.bt_imp);
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
  endclass

  initial begin
    run_test("test1");
  end
endmodule


