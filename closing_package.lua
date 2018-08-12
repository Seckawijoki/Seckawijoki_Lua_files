names = {"Peter", "Paul", "Mary"}
grades = {Mary = 10, Paul = 7, Peter = 8}
for k, v in pairs(names) do
	print(k,v)
end
print("\r")
function sortbygrade (names, grades)
	table.sort(names, 
		function (n1, n2)
			return grades[n1] > grades[n2] -- compare the grades
		end
	)
end
sortbygrade(names, grades)
for k, v in pairs(names) do
	print(k,v)
end

function newCounter()
	local i = 0
	return function()
		i = i + 1
		return i
	end
end

c1 = newCounter()
c2 = newCounter()
print("\r")
print(c2())
print(c1())
print(c2())

do
	local oldSin = math.sin
	local k = math.pi/180
	math.sin = function(x)
		return oldSin(x*k)
	end
end

print("\r")
print(math.sin(30))
print(math.sin(180))