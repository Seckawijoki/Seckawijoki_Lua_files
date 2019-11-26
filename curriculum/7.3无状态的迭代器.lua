function iter (a, i)
    i = i + 1
    local v = a[i]
    if v then
        return i, v
    end
end

function ipairs (a)
    return iter, a, 0
end

array = {"one", "two", "three"}

for k, v in ipairs(array) do
    print(k, v)
end

function pairs(t)
    return next, t, nil
end

-- for k, v in next, t do
--     print(k, v)
-- end

for k, v in pairs(array) do
    print (k,v)
end