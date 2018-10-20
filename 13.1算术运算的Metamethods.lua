Set = {}

Set.mt = {}

function Set.new(t)
    local set = {}
    setmetatable(set, Set.mt)
    for _, l in ipairs(t) do set[l] = true end
    return set
end

function Set.union(a, b)
    local res = Set.new{}
    for k in pairs(a) do res[k] = true end
    for k in pairs(b) do res[k] = true end
    return res
end

function Set.intersection(a, b)
    local res = Set.new{}
    for k in pairs(a) do 
        res[k] = b[k]
    end
    return res
end

function Set.tostring(set)
    local left = "{"
    local sep = ""
    for element in pairs(set) do 
        left = left .. sep .. element
        sep = ", "
    end
    return left .. "}"
end

function Set.print(s)
    print(Set.tostring(s))
end

Set.mt.__add = Set.union
Set.mt.__mul = Set.intersection

s1 = Set.new{2, 10, 20, 30, 50}
s2 = Set.new{30, 1}

print(getmetatable(s1))
print(getmetatable(s2))

Set.print((s1 + s2) * s1)
