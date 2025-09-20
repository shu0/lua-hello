FROM lua:5.4.6

WORKDIR /app
COPY . .

CMD ["lua", "main.lua"]
