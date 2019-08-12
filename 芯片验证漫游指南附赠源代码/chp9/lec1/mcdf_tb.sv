
class monitor;
endclass

module mcdf_tb;
regs_pkg::monitor mon1 = new();
arb_pkg::monitor mon2 = new();
monitor mon3 = new();
endmodule
