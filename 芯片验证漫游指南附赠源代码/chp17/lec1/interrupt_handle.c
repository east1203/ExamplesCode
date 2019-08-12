
#include "vc_hdrs.h"

// interupt server routine function type
typedef void (*isr_t)(void);

static isr_t irq_table[16];

void register_irq (int index, isr_t routine) {
    irq_table[index] = routine;
}

void serve_irq (int index) {
    (*(irq_table[index]))();
}

// install interrupt routine 
void install_irq (unsigned long irq_routine, unsigned long irq_num, unsigned long id) {
    dpi_install_irq (irq_routine, irq_num, id);
    register_irq ((int) irq_num, (isr_t) irq_routine);
}

void irq_service() {
  dpi_print("core0 entered irq_service", 0);
  dpi_writew(0x2000, 0x5678, 0);
  dpi_delay(100, 0);
  dpi_print("core0 exited irq_service", 0);
}


void core0_thread() {
  dpi_print("core0_thread entered", 0);
  install_irq(irq_service, 1, 0);
  dpi_delay(100, 0);
  dpi_writew(0x1000, 0x1234, 0);
  dpi_delay(1000, 0);
  dpi_print("core0_thread exited", 0);
}

// UVM_INFO @ 0: reporter [RNTST] Running test test...
// UVM_INFO @ 195: uvm_test_top.env.c0 [CORE] core0_thread entered
// UVM_INFO @ 1495: uvm_test_top.env.c0 [IRQSERVICE] IRQ triggerred
// UVM_INFO @ 1495: uvm_test_top.env.c0 [PROCESS] Suspending main process
// UVM_INFO @ 1495: uvm_test_top.env.c0 [CORE] core0 entered irq_service
// UVM_INFO @ 1495: uvm_test_top.env.c0 [CORE] write addr=0x00002000, data=0x00005678
// UVM_INFO @ 11495: uvm_test_top.env.c0 [CORE] core0 exited irq_service
// UVM_INFO @ 11505: uvm_test_top.env.c0 [PROCESS] Resuming main process
// UVM_INFO @ 20195: uvm_test_top.env.c0 [CORE] write addr=0x00001000, data=0x00001234
// UVM_INFO @ 120195: uvm_test_top.env.c0 [CORE] core0_thread exited
