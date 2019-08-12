

package report_pkg;
  typedef enum {INFO, WARNING, ERROR, FATAL} report_t;
  typedef enum {LOW, MEDIUM, HIGH, TOP} severity_t;
  typedef enum {LOG, STOP, EXIT} action_t;

  static severity_t svrt = LOW;
  static string logname = "report.log";

  function void rpt_msg(string src, string i, report_t r=INFO, severity_t s=LOW, action_t a=LOG);
    integer logf;
    string msg;
    if(s >= svrt) begin
      msg = $sformatf("@%0t [%s] %s : %s", $time, r, src, i);
      logf = $fopen(logname, "a+");
      $display(msg);
      $fwrite(logf, $sformatf("%s\n", msg));
      $fclose(logf);
      if(a == STOP) begin
        $stop();
      end
      else if(a == EXIT) begin
        $finish();
      end
    end
  endfunction

  function void clean_log();
    integer logf;
    logf = $fopen(logname, "w");
    $fclose(logf);
  endfunction
endpackage
