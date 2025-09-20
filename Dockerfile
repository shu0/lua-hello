FROM lua:5.4

WORKDIR /app
COPY . .
CMD ["lua", "main.lua"]
