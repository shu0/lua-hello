FROM debian:bullseye-slim

# Lua5.4以外を削除して、Lua5.4 + luarocks をセットアップ
RUN apt-get update && \
    apt-get remove -y lua5.1 lua5.3 || true && \
    apt-get install -y lua5.4 luarocks && \
    luarocks install luasocket && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY . .

CMD ["lua5.4", "main.lua"]
