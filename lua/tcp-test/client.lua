local socket = require("socket")
local host, port = "192.168.100.47", 51515
local tcp = assert(socket.tcp())

tcp:connect(host, port);
tcp:send("hello world\n");

while true do
    local s, status, partial = tcp:receive()
    print(s or partial)
    if status == "closed" then
      break
    end
end

tcp:close()