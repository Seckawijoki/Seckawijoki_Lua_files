
---------------------------------------
-- 例一
-- 使用table的下标和#取长运算，设置字符，最后使用table.concat合成字符串

a1 = os.clock()
local s1 = ''
for i1 = 1,300000 do
    s1 = s1 .. 'a'
end
b1 = os.clock()
print(b1-a1)  --本地电脑：4.649481

a2 = os.clock()
local s2 = ''
local t2 = {}
for i2 = 1,300000 do
    t2[#t2 + 1] = 'a'
end
s2 = table.concat(t2, '')
b2 = os.clock()
print(b2-a2)  --本地电脑：0.07178

---------------------------------------
-- 例二
-- 初始化表
a3 = os.clock()
for i3 = 1,2000000 do
    local a3 = {}
    a3[1] = 1; a3[2] = 2; a3[3] = 3
end
b3 = os.clock()
print(b3-a3)  --本地电脑：1.528293

a4 = os.clock()
for i4 = 1,2000000 do
    local a4 = {1,1,1}
    a4[1] = 1; a4[2] = 2; a4[3] = 3
end
b4 = os.clock()
print(b4-a4)  --本地电脑：0.746453

---------------------------------------
-- 例三
-- 使用本地变量暂存全局变量
a5 = os.clock()
for i5 = 1,10000000 do
  local x5 = math.sin(i5)
end
b5 = os.clock()
print(b5-a5) --本地电脑：1.113454

a6 = os.clock()
local sin = math.sin
for i6 = 1,10000000 do
  local x6 = sin(i6)
end
b6 = os.clock()
print(b6-a6) --本地电脑：0.75951