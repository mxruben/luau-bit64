# Definitions
EXE := test-gen
SRC := $(wildcard *.c)
OBJ := $(SRC:.c=.o)
DEP := $(SRC:.c=.d)

# Configuration
CFLAGS := -g -std=c99 -pedantic -Wall -Werror -Wextra

# Phony
.PHONY: all clean test
all: $(EXE)
clean:
	$(RM) $(OBJ) $(DEP) $(EXE)
test: $(EXE)
	./$(EXE) | luajit

# Linker dependencies
$(EXE): $(OBJ)

# Compiler dependencies
CFLAGS += -MMD
-include $(DEP)
