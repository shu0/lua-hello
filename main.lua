local socket = require("socket")
print("Hello from Lua on Docker!!!!")

-- Railway の環境変数 PORT を利用（無ければ8080）
local port = tonumber(os.getenv("PORT") or "8080")
local server = assert(socket.bind("*", port))

print("Listening on http://0.0.0.0:" .. port)

while true do
    local client = server:accept()
    client:send("HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\n\r\nHello World from Lua!From Github Action Test OK!!\n")
    client:close()
end
