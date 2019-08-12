

class rpt_stm;
  string id;
  function new(string name = "rpt_stm");
    id = name;
    rpt_msg(id, "build phase");
  endfunction
  task run();
    int i=1;
    rpt_msg(id, "run phase");
    forever begin
      #100;
      rpt_msg(id, $sformatf("NO.%0d trans generated!",i));
      i++;
    end
  endtask
endclass
