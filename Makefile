INC_DIR=-Iinclude -Ilibuv/include -Ihttp-parser
SRC_DIR=src
OBJ_DIR=obj
LIB_DIR=lib
_INC_DIR=include

LIBS=-luv
_LIBS=libuv/out/cmake/libuv.so
LDPATH=-Llibuv/out/cmake -L$(LIB_DIR)

SRC_FILES=$(wildcard $(SRC_DIR)/*.c)
HEADER_FILES=$(wildcard $(_INC_DIR)/*.h)
OBJ_FILES=$(patsubst $(SRC_DIR)/%.c,$(OBJ_DIR)/%.o,$(SRC_FILES))

_DEPS = http-parser/http_parser.o
DEPS=$(HEADER_FILES) http-parser/http_parser.o

CC=gcc
CFLAGS=$(INC_DIR) -Wall -Wno-unused-command-line-argument $(LDPATH) $(LIBS) $(MAC_SHIT)

webserver: $(OBJ_FILES) $(_LIBS)
	$(CC) -o $@ $^ $(CFLAGS) $(_DEPS)

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c $(DEPS)
	$(CC) -c -o $@ $< $(CFLAGS)

http-parser/http_parser.o:
	$(MAKE) -C http-parser http_parser.o

libuv/out/cmake/libuv_a.a:
	cd libuv; mkdir -p out/cmake; cd out/cmake; cmake -DBUILD_TESTING=ON ../..; make all
	cd libuv/out/cmake; ./uv_run_tests ; ./uv_run_tests_a

.PHONY: clean
clean:
	rm -rf $(OBJ_DIR)/*.o 
	rm -rf webserver

echo_paths:
	@echo $(SRC_FILES)
	@echo $(HEADER_FILES)
	@echo $(OBJ_FILES)

default: webserver
