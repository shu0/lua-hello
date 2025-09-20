print("Hello from Lua on Docker!!!!")


local socket = require("socket")

-- Railway の環境変数 PORT を利用（無ければ8080）
local port = tonumber(os.getenv("PORT") or "8080")
local server = assert(socket.bind("*", port))

print("Listening on http://0.0.0.0:" .. port)

while true do
    local client = server:accept()
    client:send("HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\n\r\nHello World from Lua!\n")
    client:close()
end

