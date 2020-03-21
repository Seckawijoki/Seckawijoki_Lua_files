local tostring = _G.tostring
local type = _G.type
local debug = _G.debug
local type = _G.type
local string = _G.string
local tostring = _G.tostring
local pairs = _G.pairs
local PerformanceTest = {
    WRITTEN_FILE_NAME = "GlobalFunctionCallCount.lua",
    WRITE_FILE_CALLS_INTERVAL = 10000,
    m_iCurCallCount = 0,
    m_mGlobalFunctionCallCount = {

    },

    m_mGlobalElementCount = {
		["function"] = 0,
		["table"] = 0,
		["userdata"] = 0,
		["number"] = 0,
		["string"] = 0,
		["boolean"] = 0,
    },

    m_mGlobalElementNameTotalLength = {
		["function"] = 0,
		["table"] = 0,
		["userdata"] = 0,
		["number"] = 0,
		["string"] = 0,
		["boolean"] = 0,
    },
}
_G.PerformanceTest = PerformanceTest

function PerformanceTest:howManyElementsDoesGlobalHave(t)
	print("howManyElementsDoesGlobalHave(): ");
	if not t then
		return
	end
	local type = type
	local tostring = tostring
	local mCounts = self.m_mGlobalElementCount
	local mNameTotalLength = self.m_mGlobalElementNameTotalLength
	for k, v in pairs(t) do
		local szType = type(v)
		local szKey = tostring(k)
		-- print(szKey, szType)
		mCounts[szType] = mCounts[szType] + 1
		mNameTotalLength[szType] = mNameTotalLength[szType] + #szKey
	end
	
	for k, v in pairs(mCounts) do 
		print("howManyElementsDoesGlobalHave(): " .. k .. " : count = " .. v .. " | names' total length = " .. mNameTotalLength[k]);
		if v ~= 0 then
			print("howManyElementsDoesGlobalHave(): " .. k .. " names' average length = " .. (mNameTotalLength[k] / v));
		end
	end
end

function PerformanceTest:initStatisticGlobalFunctionCallCount()
	for k, v in pairs(_G) do 
		if type(v) == "function" then
			self.m_mGlobalFunctionCallCount[k] = 0
		end
    end
    table.sort(self.m_mGlobalFunctionCallCount)
end

function PerformanceTest.TableToString(t)
	local mark={}
	local assign={}
	local function ser_table(tbl,parent)
		mark[tbl]=parent
		local tmp={}
        local type = type
        local string = string
        local tostring = tostring
        local table = table
		for k,v in pairs(tbl) do
			local key = type(k)=="number" and "["..k.."]" or "[".. string.format("%q", k) .."]"
			if type(v)=="table" then
				local dotkey= parent .. key
				if mark[v] then
					table.insert(assign,dotkey .. "=" .. mark[v] .. "")
				else
					table.insert(tmp, key .. "=" .. ser_table(v,dotkey))
				end
			elseif type(v) == "string" then
				table.insert(tmp, key .. "=" .. string.format('%q', v))
			elseif type(v) == "number" or type(v) == "boolean" then
				table.insert(tmp, key .. "=" .. tostring(v))
			end
		end
		return "{" .. table.concat(tmp,",\n") .. "}\n"
	end
	return ser_table(t,"ret") .. table.concat(assign,"")
end

function PerformanceTest.StringNumberMapToString(t)
	local mark={}
	local assign={}
	local function ser_table(tbl,parent)
		mark[tbl]=parent
		local tmp={}
        local type = type
        local string = string
		local tostring = tostring
		local count = 0
		for k,v in pairs(t) do
			count = count + 1
            if type(k) == "string" and type(v) == "number" and v > 10000 and k ~= "type" and k ~= "tostring" then
                local kv = "[".. string.format("%q", k) .."]=" .. tostring(v)
                tmp[#tmp + 1] = kv
            end
		end
		t["type"] = t["type"] - count
		t["tostring"] = t["tostring"] - count - 2
		tmp[#tmp + 1] = "[".. string.format("%q", "type") .."]=" .. tostring(t["type"])
		tmp[#tmp + 1] = "[".. string.format("%q", "tostring") .."]=" .. tostring(t["tostring"])
        return "{" .. table.concat(tmp,",\n") .. "}\n"
	end
	return ser_table(t,"ret") .. table.concat(assign,"")
end

function PerformanceTest:writeGlobalFunctionCallCountInfoFiles()
    if gFunc_writeTxtFile then
        local sz = self.StringNumberMapToString(self.m_mGlobalFunctionCallCount)
        gFunc_writeTxtFile(self.WRITTEN_FILE_NAME, sz)
    end
end

function PerformanceTest.HookGlobalFunctionCallCount()
    local PerformanceTest = PerformanceTest
	local name = debug.getinfo(2, "n").name
	if not name then return end
	if not PerformanceTest.m_mGlobalFunctionCallCount[name] then return end
    PerformanceTest.m_mGlobalFunctionCallCount[name] = PerformanceTest.m_mGlobalFunctionCallCount[name] + 1
    PerformanceTest.m_iCurCallCount = PerformanceTest.m_iCurCallCount + 1
    if PerformanceTest.m_iCurCallCount > PerformanceTest.WRITE_FILE_CALLS_INTERVAL then
        PerformanceTest.m_iCurCallCount = 0
        PerformanceTest:writeGlobalFunctionCallCountInfoFiles()
    end
end

function PerformanceTest:printGlobalFunctionCallCount()
    for k, v in pairs(self.m_mGlobalFunctionCallCount) do
        if v > 0 then
            print("printGlobalFunctionCallCount(): ", k, v);
        end
	end
end

PerformanceTest:howManyElementsDoesGlobalHave(_G);



-- if PerformanceTest then
--     if PerformanceTest.initStatisticGlobalFunctionCallCount then
--         PerformanceTest:initStatisticGlobalFunctionCallCount()
--         PerformanceTest.initStatisticGlobalFunctionCallCount = nil
--     end
--     debug.sethook(PerformanceTest.HookGlobalFunctionCallCount, "c")
-- end

-- PerformanceTest:printGlobalFunctionCallCount()