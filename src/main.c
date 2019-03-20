#include <http_parser.h>
#include <server.h>
#include <stdio.h>
#include <stdlib.h>
#include <uv.h>

#define DEFAULT_PORT 8000
#define DEFAULT_BACKLOG 128

void alloc_buffer(uv_handle_t *handle, size_t suggested_size, uv_buf_t *buf) {
    buf->base = (char *)malloc(suggested_size);
    buf->len = suggested_size;
}

void on_client_read(uv_stream_t *stream, ssize_t nread, const uv_buf_t *buf) {
    printf("%s\n", buf->base);
}

void on_new_connection(uv_stream_t *server, int status) {
    printf("on_new_connection\n");

    uv_tcp_t *client = (uv_tcp_t *)malloc(sizeof(uv_tcp_t));
    uv_tcp_init(uv_default_loop(), client);
    int r = uv_accept(server, (uv_stream_t *)client);

    if (r) {
        uv_close((uv_handle_t *)client, NULL);
    } else {
        uv_read_start((uv_stream_t *)client, alloc_buffer, on_client_read);
    }
}

int main() {
    uv_loop_t *loop = uv_default_loop();

    uv_tcp_t server;
    uv_tcp_init(loop, &server);

    struct sockaddr_in addr;
    uv_ip4_addr("0.0.0.0", DEFAULT_PORT, &addr);
    uv_tcp_bind(&server, (const struct sockaddr *)&addr, 0);
    uv_listen((uv_stream_t *)&server, DEFAULT_BACKLOG, on_new_connection);

    uv_run(loop, UV_RUN_DEFAULT);
    uv_loop_close(loop);
    return 0;
}
