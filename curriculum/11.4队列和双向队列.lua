Queue = {}
function Queue.new()
    return {first=0, last=-1}
end

function Queue.pushLeft(queue, value)
    local first = queue.first - 1
    queue.first = first
    queue[first] = value
end

function Queue.pushRight(queue, value)
    local last = queue.last + 1
    queue.last = last
    queue[last] = value
end

function Queue.popLeft(queue)
    local first = queue.first + 1
    if first > queue.last then error("queue is empty") end
    local value = queue[first]
    queue[first] = nil
    queue.first = first + 1
    return value
end

function Queue.popRight(queue)
    local last = queue.last - 1
    if last < queue.first then error("queue is empty") end
    local value = queue[last]
    queue[last] = nil
    queue.last = last - 1
    return value
end

function Queue.print(queue)
    for k,v in pairs(queue) do 
        io.write("[" .. k .. "](" .. v .. ") -> ")
    end
    print("nil")
end

queue = Queue.new();
Queue.print(queue)
for i=2,20,2 do 
    print(" ----- insert " .. i)
    Queue.pushRight(queue,i);
    Queue.print(queue)
end

for i=2,20,2 do 
    print(" ----- popLeft ")
    Queue.popLeft(queue);
    Queue.print(queue)
end