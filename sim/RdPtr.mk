
VIVADO_DIR = /tools/Xilinx/Vivado/2023.2


IF_DIR := ../interfaces
RTL_DIR := ../rtl
SIM_DIR := ./src
TCL_DIR := ../tcl

DEFINES := 

SOURCES += $(RTL_DIR)/RdPtr.sv
SOURCES += $(SIM_DIR)/TbRdPtr.sv


TOP = TbRdPtr

COMP_ARGS := --incr --relax

.PHONY: simulate
simulate: $(TOP)_snapshot.wdb

.PHONY: elaborate
elaborate: .elab.timestamp

.PHONY: compile
compile: .comp.timestamp

.PHONY: waves
waves:
	gtkwave dump.vcd

$(TOP)_snapshot.wdb: .elab.timestamp
	@echo
	@echo "### SIMULATING ###"
	xsim $(TOP)_snapshot -tclbatch $(TCL_DIR)/xsim_cfg.tcl

.elab.timestamp: .comp.timestamp
	@echo
	@echo "### ELABORATING ###"
	xelab -debug all -top $(TOP) -snapshot $(TOP)_snapshot
	touch .elab.timestamp

.comp.timestamp: $(SOURCES)
	@echo
	@echo "### COMPILING ###"
	xvlog --sv $(COMP_ARGS) $(DEFINES) $(SOURCES)
	touch .comp.timestamp

.PHONY: lint
lint:
	verilator -Wall --timing --lint-only $(SOURCES)

.PHONY: clean
clean:
	rm -rf *.jou *.log *.pb *.wdb xsim.dir .Xil dump.vcd
	rm -rf .*.timestamp
