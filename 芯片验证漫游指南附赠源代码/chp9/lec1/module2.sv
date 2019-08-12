
package a_pkg;
  class mon;
  endclass
endpackage

module module1;
class mon;
endclass
import a_pkg::mon;
mon mon1 = new();
endmodule
