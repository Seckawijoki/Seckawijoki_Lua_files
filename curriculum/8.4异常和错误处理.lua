function foo()
    local zero = 0
    if zero == 0 then error() end
    print "no errors"
end

if pcall(foo) then
    print "function foo running finished without errors"
else
    print "function foo has errors while running"
end

local status, err = pcall(function() error({code=121}) end)
print (err.code)
