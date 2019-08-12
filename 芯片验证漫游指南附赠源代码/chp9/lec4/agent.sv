
interface arb_ini_if;
endinterface


class arb_ini_stm;
  virtual interface arb_ini_if vif;
endclass

class arb_ini_mon;
  virtual interface arb_ini_if vif;
endclass

class arb_ini_agent;
  bit active;
  arb_ini_stm stm;
  arb_ini_mon mon;

  function new(bit mod = 1);
    active = mod;
    mon = new();
    if(active)
      stm = new();
  endfunction

  function void connect(virtual interface arb_ini_if intf);
    mon.vif = intf;
    if(active)
      stm.vif = intf;
  endfunction
endclass


