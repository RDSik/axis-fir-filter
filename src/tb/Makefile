TOP_NAME  := fir_filter
VERILATOR := verilator
GTKWAVE   := gtkwave
SRC_DIR   := ../
TB_DIR    := ./
GTKW_FILE := gtkw.gtkw
SRC_FILES := $(shell find $(SRC_DIR) -name '*.sv') \
			 $(shell find $(TB_DIR) -name '*.sv')

.PHONY: all clean

all: build execute simulate

build:
	$(VERILATOR) --binary $(SRC_FILES) --trace --trace-params --trace-structs -I$(SRC_DIR) -I$(TB_DIR) --top $(TOP_NAME)_tb

execute:
	./obj_dir/V$(TOP_NAME)_tb

simulate: 
	$(GTKWAVE) $(GTKW_FILE)

clean:
	rm -rf obj_dir
	rm $(TOP_NAME)_tb.vcd
