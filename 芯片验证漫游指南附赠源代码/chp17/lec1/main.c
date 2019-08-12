
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
