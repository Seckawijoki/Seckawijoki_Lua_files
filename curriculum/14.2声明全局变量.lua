local declaredNames = {}
function declare(name, initval)
    rawset(_G, name, initval or false)
    declaredNames[name] =  true
end

setmetatable(
    _G,
    {
        __newindex = function(t, n, v)
            if not declaredNames[n] then 
                error("attempt to write to undeclared variable "..n, 2)
            else
                rawset(t, n, v)
            end
        end,

        __index = function(_, n)
            if not declaredNames[n] then 
                error("attempt to read undeclared variable "..n, 2)
            else
                return nil
            end
        end,
    }
)

declare "a"
a = 1
print(a)

print(b)

