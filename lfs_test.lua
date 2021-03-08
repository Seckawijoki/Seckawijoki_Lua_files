require "lfs"
require "utils/LuaUtils"

LuaUtils:setPrintToConsole();

print(lfs.currentdir("..\\"))
print(lfs.chdir("..\\"))
print(lfs.currentdir("..\\"))

print(debug.getinfo(1).short_src)
print(debug.getinfo(1).source)
print(table.tostring(debug.getinfo(2)))

print(arg[1])
print(arg[0])
print(arg[-1])
print(arg[-2])
-- local attr = lfs.attributes(".")
-- for k,v in pairs(attr) do 
--     print(k, v)
-- end