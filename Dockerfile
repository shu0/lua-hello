FROM debian:bullseye-slim

# Install Lua 5.4 and build dependencies
RUN apt-get update && \
    apt-get remove -y lua5.1 lua5.3 || true && \
    apt-get install -y lua5.4 lua5.4-dev build-essential libssl-dev wget unzip && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

# Install luarocks from source to ensure Lua 5.4 compatibility
RUN cd /tmp && \
    wget https://luarocks.org/releases/luarocks-3.9.2.tar.gz && \
    tar zxpf luarocks-3.9.2.tar.gz && \
    cd luarocks-3.9.2 && \
    ./configure --lua-version=5.4 --with-lua-include=/usr/include/lua5.4 && \
    make && \
    make install && \
    cd / && \
    rm -rf /tmp/luarocks-3.9.2*

# Install luasocket
RUN luarocks install luasocket

WORKDIR /app
COPY . .

CMD ["lua5.4", "main.lua"]
