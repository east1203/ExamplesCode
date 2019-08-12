
#include "vc_hdrs.h"

void core0_thread() {
  dpi_print("core0_thread entered", 0);
  dpi_delay(100, 0);
  dpi_writew(0x1000, 0x1234, 0);
  dpi_print("core0_thread exited", 0);
}


void core1_thread() {
  dpi_print("core1_thread entered", 1);
  dpi_delay(200, 1);
  dpi_writew(0x2000, 0x5678, 1);
  dpi_print("core1_thread entered", 1);
}

// UVM_INFO @ 195: uvm_test_top.env.c0 [CORE] core0_thread entered
// UVM_INFO @ 195: uvm_test_top.env.c1 [CORE] core1_thread entered
// UVM_INFO @ 10195: uvm_test_top.env.c0 [CORE] write addr=0x00001000, data=0x00001234
// UVM_INFO @ 10195: uvm_test_top.env.c0 [CORE] core0_thread exited
// UVM_INFO @ 20195: uvm_test_top.env.c1 [CORE] write addr=0x00002000, data=0x00005678
// UVM_INFO @ 20195: uvm_test_top.env.c1 [CORE] core1_thread entered
