
VIVADO_DIR = /tools/Xilinx/Vivado/2023.2


IF_DIR := ../../interfaces
RTL_DIR := ../../rtl
SIM_DIR := .
TCL_DIR := ../../tcl

DEFINES := 

SOURCES += $(IF_DIR)/axi4_stream_if.sv

SOURCES += $(RTL_DIR)/WrPtr.sv
SOURCES += $(RTL_DIR)/RdPtr.sv
SOURCES += $(RTL_DIR)/SdpRam1.sv
SOURCES += $(RTL_DIR)/FifoCore.sv
SOURCES += $(RTL_DIR)/SkidBuffer.sv
SOURCES += $(RTL_DIR)/SAxi4SWr.sv
SOURCES += $(RTL_DIR)/MAxi4SRd.sv
SOURCES += $(RTL_DIR)/Axi4SFifo.sv

SOURCES += $(SIM_DIR)/uvm_axi4_stream_fifo_pkg.sv
SOURCES += $(SIM_DIR)/TbAxi4SFifo.sv

TOP = TbAxi4SFifo

COMP_ARGS := --incr --relax -L uvm
ELAB_ARGS := #-generic_top "TIMEOUT=10000"

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
	xelab -debug all -top $(TOP) -snapshot $(TOP)_snapshot $(ELAB_ARGS)
	touch .elab.timestamp

.comp.timestamp: $(SOURCES)
	@echo
	@echo "### COMPILING ###"
	xvlog --sv $(COMP_ARGS) $(DEFINES) $(SOURCES)
	touch .comp.timestamp


LINT_ARGS :=

.PHONY: lint
lint:
	verible-verilog-lint $(LINT_ARGS) $(SOURCES)

.PHONY: clean
clean:
	rm -rf *.jou *.log *.pb *.wdb xsim.dir .Xil dump.vcd
	rm -rf .*.timestamp
