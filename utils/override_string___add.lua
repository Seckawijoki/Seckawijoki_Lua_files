getmetatable("").__add = function(a, b) 
	local x
	local y
	if a ~= nil then
		if type(a) == "table" then
			if a.toString then
				x = a:toString();
			else
				x = table.tostring(a)
			end
		else
			x = tostring(a)
		end
	else
		x = "nil"
	end
	
	
	a = b
	y = x
	if a ~= nil then
		if type(a) == "table" then
			if a.toString then
				x = a:toString();
			else
				x = table.tostring(a)
			end
		else
			x = tostring(a)
		end
	else
		x = "nil"
	end
	
	return y .. x 
end