

class fmt_ini_trans;
  bit [ 1:0] id;
  bit [31:0] data;
  int        length;

  static function int dec_length(int l);
    int len;
    case(l)
      0: len = 4;
      1: len = 8;
      2: len = 16;
      3: len = 32;
      default len = 32;
    endcase
    return len;
  endfunction
endclass
