function permgen(a, n)
    -- printResult(a)
    if n <= 1 then 
        -- printResult(a)
        coroutine.yield(a)
    else 
        for i=1, n do 
            a[n], a[i] = a[i], a[n]
            permgen(a, n-1)
            a[n], a[i] = a[i], a[n]
        end
    end 
end

function perm(a)
    local n = table.getn(a)
    return coroutine.wrap(function() permgen(a, n)end)
end

function printResult(a)
    for i, v in ipairs(a) do 
        io.write(v, " ")
    end
    io.write("\n")
end

permgen({1,2,3,4},4)

for p in perm{"a", "b", "c"} do 
    printResult(p)
end