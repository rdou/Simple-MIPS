########################
# HARDWARE RESOURCE
########################
QUEUE := short
MEM := 2
CORE := 1
HW_SOURCE := -sgq $(QUEUE) -sgm $(MEM) -sgc $(CORE)

########################
# APP ARGUMENTS
########################
VCS_ARGS := +define+DUMP_FSDB \
	    	+v2k \
	    	+lint=all \
	    	-Mupdate \
			-debug \
			-fsdb

########################
# RUN ARGUMENTS
########################
RUN_BUILD := run -qopt '$(HW_SOURCE)' \
       	     -build \
       	     -design . \
       	     -l srclist \
       	     -work rtl_output \
       	     -m mips \
       	     -pass '' 

RUN_SIM := run -qopt '$(HW_SOURCE)' \
       	   -work rtl_output \
       	   -m mips \
		   -run \
		   -t test \
       	   -test . \
	   	   -pass '' \
		   -verdi

RUNVCS := $(RUN_BUILD) \
	  -buildopt \
	  '$(VCS_ARGS)'
 

########################
# APP OPERATIONS
########################
compile:
	$(RUNVCS)

sim: compile
	$(RUN_SIM)

post_sim: 
	$(RUN_SIM) -verdi -post

test:
	@echo runing test

.PHONY:
clean:
	-rm -rf rtl_output/*

