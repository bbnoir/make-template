# tool macros
CXXFLAGS += -std=c++17 -O3
DBGFLAGS := -g
CCOBJFLAGS := $(CXXFLAGS) -c
# LIBS = -I ./eigen

# path macros
BIN_PATH := bin
OBJ_PATH := obj
SRC_PATH := src

# compile macros
TARGET_NAMES := main # only modify this line to add new target
ifeq ($(OS),Windows_NT)
	TARGET_NAMES := $(addsuffix .exe,$(TARGET_NAMES))
endif
TARGETS := $(foreach target, $(TARGET_NAMES), $(BIN_PATH)/$(target))
TARGETS_OBJ := $(addsuffix .o, $(foreach target, $(TARGET_NAMES), $(OBJ_PATH)/$(target)))

# src files & obj files
SRC := $(foreach x, $(SRC_PATH), $(wildcard $(addprefix $(x)/*,.c*)))
OBJ := $(addprefix $(OBJ_PATH)/, $(addsuffix .o, $(notdir $(basename $(SRC)))))
OBJ := $(filter-out $(TARGETS_OBJ), $(OBJ))

# clean files list
DISTCLEAN_LIST := $(OBJ) \
                  $(OBJ_DEBUG)
CLEAN_LIST := $(TARGETS) \
			  $(TARGET_DEBUG) \
			  $(TARGETS_OBJ) \
			  $(DISTCLEAN_LIST)

# default rule
default: makedir all
.SECONDARY: $(OBJ) $(TARGETS_OBJ)

# non-phony targets
$(BIN_PATH)/%: $(OBJ) $(OBJ_PATH)/%.o
	$(CXX) $(CXXFLAGS) -o $@ $^ $(LIBS)

$(OBJ_PATH)/%.o: $(SRC_PATH)/%.c*
	$(CXX) $(CCOBJFLAGS) -o $@ $< $(LIBS)

$(TARGET_DEBUG): $(OBJ_DEBUG)
	$(CXX) $(CXXFLAGS) $(DBGFLAGS) $(OBJ_DEBUG) -o $@ $(LIBS)

# phony rules
.PHONY: makedir
makedir:
	@mkdir -p $(BIN_PATH) $(OBJ_PATH)

.PHONY: all
all: $(TARGETS)

.PHONY: debug
debug: $(TARGET_DEBUG)

.PHONY: clean
clean:
	@echo CLEAN $(CLEAN_LIST)
	@rm -f $(CLEAN_LIST)

.PHONY: distclean
distclean:
	@echo CLEAN $(DISTCLEAN_LIST)
	@rm -f $(DISTCLEAN_LIST)
