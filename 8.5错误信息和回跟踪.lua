local status, err = pcall(function() a = 'a'+1 end)
print(err)

local status, err = pcall(function() error("my error") end)
print(err)

function foo(str)
    if type(str) ~= "string" then
        -- error("string expected")
        error("string expected", 2)
    end
end

foo({x=1})
print(debug.debug())
print(debug.traceback())