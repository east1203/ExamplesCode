

class rpt_mon;
  string id;
  function new(string name = "rpt_mon");
    id = name;
    rpt_msg(id, "build phase");
  endfunction
  task run();
    int i=1;
    rpt_msg(id, "run phase");
    #30;
    forever begin
      #80;
      rpt_msg(id, $sformatf("NO.%0d input trans monitored!",i));
      #20;
      rpt_msg(id, $sformatf("NO.%0d ouput trans monitored!",i));
      i++;
    end
  endtask
endclass
