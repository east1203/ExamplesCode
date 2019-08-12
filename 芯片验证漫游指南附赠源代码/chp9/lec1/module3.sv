
package b_pkg;
  class b_mon;
  endclass
endpackage

package a_pkg;
  import b_pkg::b_mon;
  class a_mon;
  endclass
endpackage

module module1;
import a_pkg::*;
a_mon mon1 = new();
b_mon mon2 = new();
endmodule



