x = 10
local i = 1 -- local to the chunk
while i<=x do
local x = i*2 -- local to the while body
print(x) --> 2, 4, 6, 8, ...
i = i + 1
end
if i > 20 then
local x -- local to the "then" body
x = 20
print(x + 2)
else
print(x) --> 10 (the global one)
end
print(x) --> 10 (the global one)

sqrt=math.sqrt
a=1
b=5
c=-6
do
local a2 = 2*a
local d = sqrt(b^2 - 4*a*c)
x1 = (-b + d)/a2
x2 = (-b - d)/a2
end -- scope of 'a2' and 'd' ends here
print(a2,d)
print(x1, x2)
