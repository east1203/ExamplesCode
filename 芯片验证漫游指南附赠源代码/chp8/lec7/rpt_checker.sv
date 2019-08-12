

class rpt_chk;
  string id;
  function new(string name = "rpt_chk");
    id = name;
    rpt_msg(id, "build phase");
  endfunction
  task run();
    int i=1;
    bit cmp;
    rpt_msg(id, "run phase");
    #40;
    forever begin
      #100;
      std::randomize(cmp) with {cmp dist {1 :=3, 0:= 1};};
      if(cmp)
        rpt_msg(id, $sformatf("NO.%0d trans was compared with success",i), , HIGH);
      else
        rpt_msg(id, $sformatf("NO.%0d trans was compared with failure",i), ERROR, HIGH, STOP);
      i++;
    end
  endtask
endclass
