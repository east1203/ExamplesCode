
module rpt_tb;
  import report_pkg::*;
  import rpt_pkg::*;
  rpt_env env;
  initial begin: build
    report_pkg::svrt = HIGH;
    report_pkg::logname = "test.log";
    rpt_msg("tb", "build phase");
    env = new("env");
    
    clean_log();
  end
  initial begin: run
    #0;
    rpt_msg("tb", "run phase");
    env.run();
  end
endmodule
