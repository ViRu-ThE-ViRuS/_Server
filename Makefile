INC_DIR=-Iinclude -Ilibuv-1.27.0/include
SRC_DIR=src
OBJ_DIR=obj
LIB_DIR=lib
_INC_DIR=include

LIBS=-luv
LDPATH=-Llibuv-1.27.0/build/Release -L$(LIB_DIR)

SRC_FILES=$(wildcard $(SRC_DIR)/*.c)
HEADER_FILES=$(wildcard $(_INC_DIR)/*.h)
OBJ_FILES=$(patsubst $(SRC_DIR)/%.c,$(OBJ_DIR)/%.o,$(SRC_FILES))

DEPS=$(HEADER_FILES)

CC=gcc
CFLAGS=$(INC_DIR) -Wall -Wno-unused-command-line-argument $(LDPATH) $(LIBS) $(MAC_SHIT)

main: $(OBJ_FILES)
	$(CC) -o $@ $^ $(CFLAGS)

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c $(DEPS)
	$(CC) -c -o $@ $< $(CFLAGS)

.PHONY: clean
clean:
	rm -rf $(OBJ_DIR)/*.o *~ core $(INC_DIR)/*~
	rm -rf main

echo_paths:
	@echo $(SRC_FILES)
	@echo $(HEADER_FILES)
	@echo $(OBJ_FILES)

default: main
