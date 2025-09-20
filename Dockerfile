FROM debian:bullseye-slim

RUN apt-get update && apt-get install -y lua5.4

WORKDIR /app
COPY . .
CMD ["lua", "main.lua"]
