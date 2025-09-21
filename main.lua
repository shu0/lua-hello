-- local socket = require("socket")
-- print("Hello from Lua on Docker!!!!")

-- -- Railway の環境変数 PORT を利用（無ければ8080）
-- local port = tonumber(os.getenv("PORT") or "8080")
-- local server = assert(socket.bind("*", port))

-- print("Listening on http://0.0.0.0:" .. port)

-- while true do
--     local client = server:accept()
--     client:send("HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\n\r\nHello World from Lua!From Github Action Test OK!!\n")
--     client:close()
-- end

local http = require("socket.http")
local ltn12 = require("ltn12")

local port = tonumber(os.getenv("PORT") or "8080")
local server = assert(socket.bind("*", port))

print("Listening on http://0.0.0.0:" .. port)

while true do
    local client = server:accept()

    local resp = {}
    http.request {
        url = "http://fly-lua-fly-redis.upstash.io:6379/get/foo",
        method = "GET",
        headers = {
            ["Authorization"] = "Bearer AZTqACQgZDg4ZjQyZmQtM2I4My00Mjk4LWIzYTYtNmFjYzVhMzAyMGY4ZWIyYjdlZDllMWE5NDA2MmE0OTQzYTc2YjI3MDllZmU="
        },
        sink = ltn12.sink.table(resp)
    }

    local response_body = "Hello from Lua! Redis says: " .. table.concat(resp) .. "\n"
    local response = "HTTP/1.1 200 OK\r\n" ..
        "Content-Type: text/plain\r\n" ..
        "Content-Length: " .. #response_body .. "\r\n\r\n" ..
        response_body

    client:send(response)
    client:close()
end
-- local t = { "Hello", "World", "Lua" }
-- print(table.concat(t, " ")) --> Hello World Lua
-- print(table.concat(t, "-")) --> Hello-World-Lua

-- local s = "Hello"
-- print(#s)                   --> 5
