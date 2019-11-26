-- function producer()
--     while true do 
--         local x = io.read()
--         send(x)
--     end
-- end

-- function consumer()
--     while true do 
--         local x = receive()
--         io.write(x, "\n")
--     end 
-- end

function receive(prod)
    local status, value = coroutine.resume(prod)
    print("receive(): value = " .. tostring(value) .. " | status = " .. tostring(status))
    return value
end

function send(x)
    print("send(): x = " .. tostring(x))
    coroutine.yield(x)
end

function producer()
    return coroutine.create(function()
        while true do 
            print("producer(): while start")
            local x = io.read()
            print("producer : x = io.read() = " .. tostring(x))
            send(x)
        end
    end)
end

function filter(prod) 
    return coroutine.create(function()
        local line = 1
        while true do 
            print("filter(): while start")
            local x = receive(prod)
            print("filter(): x = receive(prod) = " .. tostring(x))
            x = string.format("%5d %s", line, x)
            send(x)
            line = line + 1
        end
    end)
end

function consumer(prod)
    while true do 
        print("consumer(): while start")
        local x = receive(prod)
        print("consumer(): x = receive(prod) = " .. tostring(x))
        io.write("consumer(): io.write(): " .. x, "\n")
    end
end

p = producer()
f = filter(p)
-- consumer(f)

consumer(p)

-- consumer(filter(producer()))