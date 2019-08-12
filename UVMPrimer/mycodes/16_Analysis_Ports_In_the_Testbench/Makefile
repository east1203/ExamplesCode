cov_opt = line+tgl+fsm+cond
run: vcs sim
vcs:
	vcs +acc +vpi -sverilog	${UVM_HOME}/src/dpi/uvm_dpi.cc	\
		-CFLAGS -DVCS \
		+v2k	\
		 -f filelist	\
		+notimingcheck	\
		-debug_all	\
		-cm ${cov_opt} 

sim:
	./simv -cm ${cov_opt} +UVM_TESTNAME=random_test
	
urg:
	urg -dir simv.vdb -report both

dve:
	dve -covdir simv.vdb&

.PHONY:clean
clean:
	rm -rf csrc simv ucli.key simv.daidir
	rm -rf simv.vdb vc_hdrs.h
	rm -rf *log
