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

local socket        = require("socket")
local http          = require("socket.http")
local ltn12         = require("ltn12")

-- Upstash の接続情報を直書き
local UPSTASH_URL   = "http://fly-lua-fly-redis.upstash.io:6379"
local UPSTASH_TOKEN =
"AZTqACQgZDg4ZjQyZmQtM2I4My00Mjk4LWIzYTYtNmFjYzVhMzAyMGY4ZWIyYjdlZDllMWE5NDA2MmE0OTQzYTc2YjI3MDllZmU="

print("Hello from Lua on Docker!!!!")

local port = tonumber(os.getenv("PORT") or "8080")
local server = assert(socket.bind("*", port))

print("Listening on http://0.0.0.0:" .. port)

while true do
    local client = server:accept()

    -- ==== Redis REST API を叩く (GET foo) ====
    local resp = {}
    local res, code, headers = http.request {
        url = UPSTASH_URL .. "/get/foo",
        method = "GET",
        headers = {
            ["Authorization"] = "Bearer " .. UPSTASH_TOKEN
        },
        sink = ltn12.sink.table(resp)
    }

    local val = table.concat(resp)

    -- ==== HTTP レスポンス ====
    local body = "Hello from Lua! Redis says: " .. val .. "\n"
    local response = "HTTP/1.1 200 OK\r\n" ..
        "Content-Type: text/plain\r\n" ..
        "Content-Length: " .. #body .. "\r\n\r\n" ..
        body

    client:send(response)
    client:close()
end
