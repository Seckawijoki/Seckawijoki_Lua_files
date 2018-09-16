local function sum(a, b)
    return a + b 
end
local info = debug.getinfo(sum)
for k,v in pairs(info) do 
    print(k, ':', info[k])
end

local info = debug.getinfo(1, "S")
for k, v in pairs(info) do 
    print(k, ':', v)
end

local path = info.source
print(path)
