

function HowManyElementsDoesTableHave(t)
	print("HowManyElementsDoesTableHave(): ");
	if not t then
		return
	end
	local type = type
	local tostring = tostring
	local mapCounts = {
		["function"] = 0,
		["table"] = 0,
		["userdata"] = 0,
		["number"] = 0,
		["string"] = 0,
		["boolean"] = 0,
	}
	local mapNameTotalLength = {
		["function"] = 0,
		["table"] = 0,
		["userdata"] = 0,
		["number"] = 0,
		["string"] = 0,
		["boolean"] = 0,
	}
	for k, v in pairs(t) do
		local szType = type(v)
		local szKey = tostring(k)
		print(szKey, szType)
		mapCounts[szType] = mapCounts[szType] + 1
		mapNameTotalLength[szType] = mapNameTotalLength[szType] + #szKey
	end
	
	for k, v in pairs(mapCounts) do 
		print("HowManyElementsDoesTableHave(): " .. k .. " : count = " .. v .. " | names' total length = " .. mapNameTotalLength[k]);
		if v ~= 0 then
			print("HowManyElementsDoesTableHave(): " .. k .. " names' average length = " .. (mapNameTotalLength[k] / v));
		end
	end
end

HowManyElementsDoesTableHave(_G)