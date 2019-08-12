

class rpt_env;
  string id;
  rpt_stm stm;
  rpt_mon mon;
  rpt_chk chk;

  function new(string name = "rpt_env");
    id = name;
    rpt_msg(id, "build phase");
    stm = new("stm");
    mon = new("mon");
    chk = new("chk");
  endfunction

  task run();
    rpt_msg(id, "run phase");
    fork
      stm.run();
      mon.run();
      chk.run();
    join_none
  endtask
endclass
