local socket = require("socket")
local json = require("libraries.json")

local address, port = "", 12345
UDP = socket.udp()
UDP:setsockname("10.65.14.102", 12345)
UDP:settimeout(0)

----------------------------------------
--              GENERAL               --
----------------------------------------

REQUEST = {
    CONNECT = "connect",
    DISCONNECT = "disconnect",
    UPDATE = "update",
    START = "start",
    END = "end"
}

----------------------------------------
--              CLIENT                --
----------------------------------------

function client_send(data)
    UDP:send(data)
end

function client_receive()
    local data = UDP:receive()
    if data then
        return json.decode(data)
    end
end

----------------------------------------
--              SERVER                --
----------------------------------------

function server_send(data, ip, port)
    UDP:sendto(data, ip, port)
end

function server_receive()
    local data, ip, port = UDP:receivefrom()
    if data then
        return json.decode(data), ip, port
    end
end




