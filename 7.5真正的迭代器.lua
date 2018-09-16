function allwords(f)
    for line in io.lines() do
        for word in string.gfind(line, "%w+") do
            f(word)
        end
    end
end

-- allwords(print)

local count = 0
allwords(function (word)
    if word == "hello" then count = count + 1 end
    print("count = " .. tostring(count))
end)

-- for word in allwords() do
--     if word == "hello" then count = count + 1 end
--     print ("count = " .. tostring(count))
-- end