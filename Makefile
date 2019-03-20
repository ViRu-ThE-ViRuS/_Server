INC_DIR=-Iinclude -Ilibuv/include -Ihttp-parser
SRC_DIR=src
OBJ_DIR=obj
LIB_DIR=lib
_INC_DIR=include

LIBS=-luv_a
_LIBS=libuv/out/cmake/libuv_a.a
LDPATH=-Llibuv/out/cmake -L$(LIB_DIR)

SRC_FILES=$(wildcard $(SRC_DIR)/*.c)
HEADER_FILES=$(wildcard $(_INC_DIR)/*.h)
OBJ_FILES=$(patsubst $(SRC_DIR)/%.c,$(OBJ_DIR)/%.o,$(SRC_FILES))

DEPS=$(HEADER_FILES) http-parser/http_parser.o

CC=gcc
CFLAGS=$(INC_DIR) -Wall -Wno-unused-command-line-argument $(LDPATH) $(LIBS) $(MAC_SHIT)

main: $(OBJ_FILES) $(_LIBS)
	$(CC) -o $@ $^ $(CFLAGS)

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c $(DEPS)
	$(CC) -c -o $@ $< $(CFLAGS)

http-parser/http_parser.o:
	$(MAKE) -C http-parser http_parser.o

libuv/out/cmake/libuv_a.a:
	cd libuv; mkdir -p out/cmake; cd out/cmake; cmake -DBUILD_TESTING=ON ../..; make all

.PHONY: clean
clean:
	rm -rf $(OBJ_DIR)/*.o *~ core $(INC_DIR)/*~
	rm -rf main

echo_paths:
	@echo $(SRC_FILES)
	@echo $(HEADER_FILES)
	@echo $(OBJ_FILES)

default: main
