cov_opt = line+tgl+fsm+cond
run: vcs urg dve
vcs:
	vcs -sverilog	\
		+v2k	\
		 -f filelist	\
		+notimingcheck	\
		-debug_all	\
		-R \
		-cm ${cov_opt}

sim:
	./simv -cm ${cov_opt}
	
urg:
	urg -dir simv.vdb -report both

dve:
	dve -covdir simv.vdb&

.PHONY:clean
clean:
	rm -rf csrc simv ucli.key simv.daidir
	rm -rf simv.vdb vc_hdrs.h
	rm -rf *log
