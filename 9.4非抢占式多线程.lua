require "socket"

function download(host, file) 
    print("download(): host = " .. host .. " | file = " .. file)
    local c = assert(socket.connect(host, 80))
    local count = 0
    c:send("GET" .. file .. " HTTP/1.0\r\n\r\n")
    while true do 
        local s, status = receive(c)
        count = count + string.len(s)
        if status == "closed" then break end
    end
    c:close()
    print(file, count)
end

function receive(connection)
    print("receive(): connection = " .. connection)
    connection:timeout(0)
    local s, status = connnection:receive(2^10)
    if status == "timeout" then 
        coroutine.yield(connection)
    end
    return s, status
end

threads = {}

function get(host, file) 
    print("get(): host = " .. host .. " | file = " .. tostring(file))
    local co = coroutine.create(function()
        download(host, file)
    end)
    table.insert(threads, co)
end

function dispatcher()
    print("dispatcher():")
    while true do 
        local n = table.getn(threads)
        if n == 0 then break end
        local connections = {}
        for i = 1, n do 
            local status, res = coroutine.resume(threads[i])
            if not res then 
                table.remove(threads, i)
                break
            else
                table.insert(connections, res)
            end
        end
        if table.getn(connections) == n then 
            socket.select(connections)
        end
    end
end

-- host = "http://10.0.0.155/all_channels/"
-- get(host, "miniworldAnzhi.apk")
-- get(host, "miniworldMini.apk")
-- get(host, "miniworldMini18183.apk")
-- get(host, "miniworldMiniBeta.apk")

host = "www.w3c.org"
get(host, "/TR/html401/html40.txt")
get(host, "/TR/2002/REC-xhtml1-20020801/xhtml1.pdf")
get(host, "/TR/REC-html32.html")
get(host, "/TR/2000/REC-DOM-Level-2-Core-20001113/DOM2-Core.txt")

dispatcher()