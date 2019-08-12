
#include "vc_hdrs.h"

void core0_thread() {
  unsigned addr;
  unsigned val;
  dpi_print("core0_thread entered", 0);
  dpi_delay(100, 0);
  addr = 0x1000;
  val = 0x1234;
  dpi_writew(addr, val, 0);
  dpi_print("core0_thread exited", 0);
}

