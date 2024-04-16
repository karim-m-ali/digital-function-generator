# Generic Function Generator

GHDL := ghdl
GHDL_FLAGS := -fsynopsys --std=08 -Wall

SRC_DIR := src
SRC_FILES := $(wildcard $(SRC_DIR)/*.vhd)
SRC_OBJ_FILES := $(patsubst $(SRC_DIR)/%.vhd,%.o,$(SRC_FILES))

TEST_DIR := test
TEST_FILES := $(wildcard $(TEST_DIR)/*.vhd)
TEST_OBJ_FILES := $(patsubst $(TEST_DIR)/%.vhd,%.o,$(TEST_FILES))
TEST_BIN_FILES := $(patsubst $(TEST_DIR)/%.vhd,%,$(TEST_FILES))


all: analyze run

analyze: $(SRC_OBJ_FILES) $(TEST_OBJ_FILES) 

run: analyze $(TEST_BIN_FILES)

%.o: $(SRC_DIR)/%.vhd
	$(GHDL) -a $(GHDL_FLAGS) $<

%_tb.o: $(TEST_DIR)/%_tb.vhd %.o
	$(GHDL) -a $(GHDL_FLAGS) $<

%_tb: %_tb.o
	$(GHDL) -e $(GHDL_FLAGS) $@
	$(GHDL) -r $@ --vcd=$@.vcd

clean:
	/bin/rm -f *.cf *.o *_tb *.vcd

.PHONY: all run analyze clean
