-- Lua web server with Redis integration

local socket = require("socket")
print("socket:", socket)
local http = require("socket.http")
local ltn12 = require("ltn12")

print("Hello from Lua on Docker!!!!")

local port = tonumber(os.getenv("PORT") or "8080")
local server = assert(socket.bind("*", port))

print("Listening on http://*******:" .. port)

while true do
    local client = server:accept()

    -- Make HTTP request to Redis
    local resp = {}
    local result, status = http.request {
        url = "http://fly-lua-fly-redis.upstash.io:6379/get/foo",
        method = "GET",
        headers = {
            ["Authorization"] = "Bearer AZTqACQgZDg4ZjQyZmQtM2I4My00Mjk4LWIzYTYtNmFjYzVhMzAyMGY4ZWIyYjdlZDllMWE5NDA2MmE0OTQzYTc2YjI3MDllZmU="
        },
        sink = ltn12.sink.table(resp)
    }

    local redis_response = result and table.concat(resp) or "Error connecting to Redis"
    local response_body = "Hello from Lua! Redis says: " .. redis_response .. "\n"
    local response = "HTTP/1.1 200 OK\r\n" ..
        "Content-Type: text/plain\r\n" ..
        "Content-Length: " .. #response_body .. "\r\n\r\n" ..
        response_body

    client:send(response)
    client:close()
end
