###
### DEFAULT_TARGET
###

RTL_BUILD_DIR=iverilog_out

all: iverilog

clean:
	rm -rf $(RTL_BUILD_DIR)

###
### IVERILOG
###

IVERILOG_FILES = \
	rtl_sim/iverilog_tb.v \
	rtl_sim/dpb_sim.v

.PHONY: iverilog
iverilog: $(RTL_BUILD_DIR)/top_vvp

$(RTL_BUILD_DIR)/top_vvp: $(VERILOG_FILES) $(IVERILOG_FILES)
	mkdir -p $(RTL_BUILD_DIR)
	iverilog -g2005-sv -DIVERILOG -o $@ $^

.PHONY: run
run: $(RTL_BUILD_DIR)/top_vvp
	vvp $(RTL_BUILD_DIR)/top_vvp

###
### VERILATOR
###

.PHONY: lint
lint:
	verilator --lint-only $(IVERILOG_FILES) --timing --top-module iverilog_tb
