function table.getn(t)
	n = 0
	for i,v in ipairs(t) do
		n = n + i
	end
	return n
end

function list_iter (t)
	local i = 0
	local n = table.getn(t)
		return function ()
			i = i + 1
			if i <= n then return t[i] end
		end
end

t = {10, 20, 30}
iter = list_iter(t) -- creates the iterator
while true do
	local element = iter() -- calls the iterator
	if element == nil then break end
	print(element)
end

for element in list_iter(t) do
	print(element)
end

function allwords()
	local line = io.read()
	local pos = 1
	return function()
		while line do 
			local s, e = string.find(line, "%w+", pos)
			if s then
				pos = e + 1
				return string.sub(line, s, e)
			else
				line = io.read()
				pos = 1
			end
		end
		return nill
	end
end

-- word = 'Ladies and gentlemen, welcome to ...'
for word in allwords() do
	print(word)
end