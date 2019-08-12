module slave_tb;
  reg CLK,RSTN;
  reg [31:0] CHx_DATA;
  reg CHx_VALID;
  reg slvx_en;
  reg ack;
  wire slave_req;
  wire [31:0] data_out;
  wire CHx_READY;
  wire req;
  wire [4:0] margin;

  import slv_pkg::*;
  
  slave slave_x(.clk_i(CLK),
                .rstn_i(RSTN),
                .chx_data_i(CHx_DATA),
                .chx_valid_i(CHx_VALID),
                .chx_ready_o(CHx_READY),
                .slvx_en_i(slvx_en),
                .margin_o(margin),
                .a2sX_ack_i(ack),
                .slvx_val_o(req),
                .slvx_dat_o(data_out));

  slv_ini_if ini_if(.rstn(RSTN), .clk(CLK));
  slv_rsp_if rsp_if(.rstn(RSTN), .clk(CLK));

  slv_ini_mon ini_mon;
  slv_rsp_mon rsp_mon;

  assign ini_if.valid = CHx_VALID;
  assign ini_if.data = CHx_DATA;
  assign ini_if.ready = CHx_READY;

  assign rsp_if.req = req;
  assign rsp_if.ack = ack;
  assign rsp_if.data = data_out;


  initial begin
    ini_mon = new();
    rsp_mon = new();
    ini_mon.vif = ini_if;
    rsp_mon.vif = rsp_if;
    fork
      ini_mon.run();
      rsp_mon.run();
    join
  end
  
  always #10 CLK=~CLK;
  
  initial begin
    CLK  =0;
    RSTN=1;
    test1;
    //test2;
  end
  
  task test1;
    begin
      CHx_DATA =32'hzzzz_zzzz;
      CHx_VALID=0;
      slvx_en  =1;
      ack      =0;
      #20 RSTN=0;
      #30 RSTN=1;
      suc_save_word(32'h0000_0001);
      suc_save_word(32'h0000_0002);
      fail_save_word(32'h0000_0003);
      suc_save_word(32'h0000_0004);
      suc_save_word(32'h0000_0005);
      suc_save_word(32'h0000_0006);
      suc_save_word(32'h0000_0007);
      suc_save_word(32'h0000_0008);
      suc_save_word(32'h0000_000a);
      suc_save_word(32'h0000_000b);
      suc_save_word(32'h0000_000c);
      suc_save_word(32'h0000_000d);
      suc_save_word(32'h0000_000e);
      suc_save_word(32'h0000_000f);
      suc_save_word(32'h0000_0010);
      suc_save_word(32'h0000_0011);
      suc_save_word(32'h0000_0012);
      suc_save_word(32'h0000_0013);
      fail_save_word(32'h0000_0014);
      suc_save_word(32'h0000_0017);
      @(posedge CLK);
      ack =1;
      @(posedge CLK);
      @(posedge CLK);
      fail_save_word(32'h0000_0018);
      suc_save_word(32'h0000_0019);
      fail_save_word(32'h0000_0020);
      @(negedge req);
      @(posedge CLK);
      ack=0;
      suc_save_word(32'h0000_0030);
      suc_save_word(32'h0000_0031);
      fail_save_word(32'h0000_0034);
    end
  endtask
      
      
      
      
  task test2;
    begin      
      CHx_DATA =32'hzzzz_zzzz;
      CHx_VALID=0;
      slvx_en  =1;
      ack      =0;
      #20 RSTN=0;
      #30 RSTN=1;
      @(negedge CLK);   
      @(posedge CLK);
      CHx_VALID=1;
      save_word(32'h0000_0001);
      @(posedge CLK);
      save_word(32'h0000_0010);
      @(posedge CLK);
      CHx_VALID=0;
      save_word(32'h0000_0100);
      @(posedge CLK);
      CHx_VALID=1;
      save_word(32'h0000_1000);
      @(posedge CLK);
      CHx_VALID=0;
      save_word(32'h0001_0000);
      @(posedge CLK);
      CHx_VALID=1;
      save_word(32'h0010_0000);
      @(posedge CLK);
      ack =1; 
      CHx_VALID=0;      
    end
  endtask
        
  task save_word;
    input [31:0] data_in;
    begin
      //@(negedge CLK);
      CHx_DATA <= data_in;
      //@(posedge CLK);
      //#5 CHx_DATA=32'hzzzz_zzzz;
    end
  endtask
  
  task suc_save_word;
    input [31:0] data_in;
    begin
      @(posedge CLK);
      CHx_VALID=1;
      CHx_DATA <= data_in;
    end
  endtask
  
  task fail_save_word;
    input [31:0] data_in;
    begin
      @(posedge CLK);
      CHx_VALID=0;
      CHx_DATA <= data_in;
    end
  endtask

      
  
endmodule


