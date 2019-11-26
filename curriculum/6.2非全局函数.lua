Lib = {}
Lib.foo = function(x, y) return x + y end
Lib.goo = function(x, y) return x - y end
print(Lib.foo(1,2), Lib.goo(3,4))

Lib = {
    foo2 = function(x, y) return x + y end,
    goo2 = function(x, y) return x - y end
}
print(Lib.foo2(5,6), Lib.goo2(7,8))

Lib = {}
function Lib.foo3(x, y)
    return x + y
end
function Lib.goo3(x,y)
    return x - y
end
print(Lib.foo3(9,10), Lib.goo3(11,12))

local fact
fact = function(n)
    if n == 0 then 
        return 1
    else 
        return n * fact(n-1)
    end
end
print(fact(6))

local f, g
function f()
    print("f():")
    g()
end
function g()
    print("g():")
    f()
end
