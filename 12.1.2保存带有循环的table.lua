function basicSerialize(object)
    if type(object) == "number" then
        return tostring(object)
    else
        return string.format("%q", object)
    end
end

function save(name, value, saved)
    saved = saved or {}
    io.write(name, " = ")
    if type(value) == "number" or type(value) == "string" then
        io.write(basicSerialize(value), '\n')
    elseif type(value) == "table" then
        if saved[value] then 
            io.write(saved[value])
        else
            saved[value] = name
            io.write("{}\n")
            for k, v in pairs(value) do 
                local fieldname = string.format("%s[%s]", name, basicSerialize(k))
                save(fieldname, v, saved)
            end
        end
    else
        error("cannot save a " .. type(value))
    end
end

a = {x=1, y=2; {3,4,5}}
a[2] = a      -- cycle
a.z = a[1]    -- shared sub-table

save('a', a);

a1 = {{"one", "two"}, 3}
b1 = {k = a1[1]}
save('a1', a1)
save('b1', b1)

local t = {}
save('a2', a1, t)
save('b2', b1, t)