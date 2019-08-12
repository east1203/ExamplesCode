
module data_type;

  logic [7:0] logic_vec = 8'b1000_0000;
  bit [7:0] bit_vec = 8'b1000_0000; 
  byte signed_vec = 8'b1000_0000;

  bit [8:0] result_vec;

  // 
  initial begin
    #10;
    result_vec = signed_vec;
    $display("@1 result_vec = 'h%x", result_vec);
    result_vec = unsigned'(signed_vec);
    $display("@2 result_vec = 'h%x", result_vec);
  end

  // 
  initial begin
    #10;
    $display("logic_vec = %d", logic_vec);
    $display("bit_vec = %d", bit_vec);
    $display("signed_vec = %d", signed_vec);
  end

  logic [3:0] x_vec = 'b111x;
  bit [2:0] b_vec;


  // static conversion
  initial begin
#10;
    $display("@1 x_vec = 'b%b", x_vec);
    b_vec = int'(x_vec);
    $display("@2 b_vec = 'h%x", b_vec);
  end

  // dynamic conversion
  initial begin
#10;
    $display("@1 x_vec = 'b%b", x_vec);
    if(!$cast(b_vec, x_vec))
      $display("Failed for type casting");
    $display("@2 b_vec = 'h%x", b_vec);
  end

  // implicit conversion
  initial begin
    $display("@1 x_vec = 'b%b", x_vec);
    b_vec = x_vec;
    $display("@2 b_vec = 'b%b", b_vec);
  end



endmodule: data_type
