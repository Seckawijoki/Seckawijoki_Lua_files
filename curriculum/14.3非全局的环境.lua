-- a1 = 1
-- setfenv(1, {_G = _G})
-- _G.print(a1)
-- _G.print(_G.a1)

a2 = 2
local newgt = {}
setmetatable(newgt, {__index = _G})
setfenv(1, newgt)
print(a2)

a2 = 20
print(a2)
print(_G.a2)
_G.a2 = 200
print(_G.a2)