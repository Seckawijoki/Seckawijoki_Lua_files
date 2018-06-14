s, e = string.find("hello Lua users", "Lua")
print(s, e)

function maximum (a)
local mi = 1 -- maximum index
local m = a[mi] -- maximum value
for i,val in ipairs(a) do
if val > m then
mi = i
m = val
end
end
return m, mi
end
print(maximum({8,10,23,12,5}))

function foo0 () end -- returns no results
function foo1 () return 'a' end -- returns 1 result
function foo2 () return 'a','b' end -- returns 2 results

x,y = foo2() -- x='a', y='b'
print(x,y)
x = foo2() -- x='a', 'b' is discarded
print(x)
x,y,z = 10,foo2() -- x=10, y='a', z='b'
print(x,y,z)
x,y = foo0() -- x=nil, y=nil
print(x,y)
x,y = foo1() -- x='a', y=nil
print(x,y)
x,y,z = foo2() -- x='a', y='b', z=nil
print(x,y,z)
x,y = foo2(), 20 -- x='a', y=20
print(x,y)
x,y = foo0(), 20, 30 -- x='nil', y=20, 30 is discarded
print(x,y)
print("\r")

print(foo0()) -->
print(foo1()) --> a
print(foo2()) --> a b
print(foo2(), 1) --> a 1
print(foo2() .. "x") --> ax
print("\r")

a = {foo0()} -- a = {} (an empty table)
a = {foo1()} -- a = {'a'}
a = {foo2()} -- a = {'a', 'b'}
a = {foo0(), foo2(), 4} -- a[1] = nil, a[2] = 'a', a[3] = 4

function foo (i)
if i == 0 then return foo0()
elseif i == 1 then return foo1()
elseif i == 2 then return foo2()
end
end
print(foo(0)) -- (no results)
print(foo(1)) --> a
print(foo(2)) --> a b
print(foo(3)) -- (no results)
print("\r")