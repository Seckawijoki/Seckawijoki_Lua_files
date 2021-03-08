local LuaUtils = {
    mark = {},
    assign = {},
    m_stTabSpaces = {},
}
_G.LuaUtils = LuaUtils

--[==[
    重载string的加号，使拼接能使用加号，并融入各种类型的转换与判空
    Created on 2020-10-22 at 11:22:52
]==]
function LuaUtils:overrideStringAddtion()
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
end

--[==[
    让print输出到控制台。如jenkins使用文件流去获取cmd的打印信息
    Created on 2020-10-22 at 11:22:21
]==]
function LuaUtils:setPrintToConsole()
    _G.print = function(...)
        local t = {...}
        local a = {}
        for i=1, #t do 
            if type(t[i]) == "table" then
                a[i] = self:table2String(t[i])
            else
                a[i] = tostring(t[i])
            end
        end
        if #a <= 0 then
            io.write("nil\n")
        else
            io.write(unpack(a), "\n");
        end
        -- io.write(..., "\n");
        io.flush();
    end
end

function LuaUtils:printf()
    _G.printf = function(szFormat, ...)
        if not szFormat then return end
        io.write(szFormat:format(...), "\n");
        io.flush();
    end
end

function LuaUtils:ser_table(tbl,parent)
    local mark = self.mark;
    local assign = self.assign;
    mark[tbl] = parent
    local valuestring={}
    local type = type
    local string = string
    local table = table
    local tostring = tostring
    local stTabSpaces = self.m_stTabSpaces;
    stTabSpaces[#stTabSpaces + 1] = "\t";
    local breaklines = table.concat(stTabSpaces);
    for k,v in pairs(tbl) do
        local keystring= type(k)=="number" and "["..k.."]" or "[".. string.format("%q", k) .."]"
        keystring = breaklines .. keystring
        if type(v)=="table" then
            local dotkey= parent .. keystring
            if mark[v] then
                table.insert(assign,dotkey .. "=" .. mark[v] .. "")
            else
                table.insert(valuestring, keystring .. "=" .. self:ser_table(v,dotkey))
            end
        elseif type(v) == "string" then
            table.insert(valuestring, keystring .. " = " .. string.format('%q', v))
        elseif type(v) == "number" or type(v) == "boolean" then
            table.insert(valuestring, keystring .. " = " .. tostring(v))
        end
        table.insert(valuestring, ",\n")
    end
    stTabSpaces[#stTabSpaces] = nil;
    breaklines = table.concat(stTabSpaces);
    -- table.insert(valuestring, "\n")
    return "{\n" .. table.concat(valuestring).. breaklines .. "}"
end

--[==[
	add tostring and loadstring to table
	Created on 2020-01-08 at 17:34:36
]==]
function LuaUtils:table2String(t)
    self.mark = {}
    self.assign = {}
	return self:ser_table(t,"ret") .. table.concat(self.assign,"")
end

--[==[
	将文件中Lua语言形式的table加载到内存中	
	Created on 2020-01-08 at 17:26:17
]==]
function LuaUtils:loadString2Table(sz)
	local f = loadstring("do local ret=" .. sz .. " return ret end")
    if not f then
        return {}
	end
    return f()
end

local function __tostring(value, indent, vmap)
    --{{{
    local str = ''
    indent = indent or ''
    vmap = vmap or {}

    if (type(value) ~= 'table') then
        if (type(value) == 'string') then
            
            if string.byte(value,1) == 91 then 
                str = string.format("'%s'", value)
            else
                if value:match('%[') then 
                    str = string.format('"%s"', value)
                else
                    str = string.format("[[%s]]", value)
                end 
            end 

        else
            str = tostring(value)
        end
    else
        if type(vmap) == 'table' then
            if vmap[value] then return '('..tostring(value)..')' end
            vmap[value] = true
        end
        local auxTable = {}
        local iauxTable = {}
        local iiauxTable = {}
        for i, v in pairs(value) do
            if type(i) == 'number' then
                if i == 0 then
                    table.insert(iiauxTable, i)
                else
                    table.insert(iauxTable, i)
                end
            else
                table.insert(auxTable, i)
            end
        end 

        table.sort(iauxTable)

        str = str..'{\n'
        local separator = ""
        local entry = "\n"
        local barray = true
        local kk,vv
        for i, k in ipairs (iauxTable) do 
            if i == k and barray then
                entry = __tostring(value[k], indent..'    ', vmap)
                str = str..separator..indent..'    '..entry
                separator = ", \n"
            else
                barray = false
                table.insert(iiauxTable, k)
            end
        end 
        for i, fieldName in ipairs (iiauxTable) do 
            kk = tostring(fieldName)
            if type(fieldName) == "number" then kk = '['..kk.."]" end 
            if type(fieldName) == "string" and (fieldName:match("%.") or fieldName:match("-")) then kk = '["'..kk..'"]' end 
            entry = kk .. " = " .. __tostring(value[fieldName],indent..'    ',vmap)

            str = str..separator..indent..'    '..entry
            separator = ", \n"
        end 
        for i, fieldName in ipairs (auxTable) do 
            kk = tostring(fieldName)
            if type(fieldName) == "number" then kk = '['..kk.."]" end 
            if type(fieldName) == "string" and (fieldName:match("%.") or fieldName:match("-"))then kk = '["'..kk..'"]' end 

            vv = value[fieldName]
            entry = kk .. " = " .. __tostring(value[fieldName],indent..'    ',vmap)


            str = str..separator..indent..'    '..entry
            separator = ", \n"
        end 
        str = str..'\n'..indent..'}'
    end
    return str
    --}}}
end
table.tostring =  __tostring

function LuaUtils:deepCopyTable(obj)
	if type(obj) == 'table' then
		local temp = {}
		for k, v in pairs(obj) do
			if not v then
				temp[k] = nil
			else
				temp[k] = deep_copy_table(v)
			end
		end
		return temp
	elseif type(obj) == 'string' or type(obj) == 'number' or type(obj) == 'boolean' then
		return obj
	end
end

LuaUtils:overrideStringAddtion();
LuaUtils:printf();