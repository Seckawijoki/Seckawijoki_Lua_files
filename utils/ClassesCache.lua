local tostring = _G.tostring
local pairs = _G.pairs
local type = _G.type
local getmetatable = _G.getmetatable
local setmetatable = _G.setmetatable
local table = _G.table

local AbsRecyclerClass = {
	m_szClassName = "AbsRecyclerClass",
	--[[
		应当由每个类持有该变量	
		Created on 2019-12-19 at 19:18:20
	]]
	-- m_bHasBeenRecycled = true,
}
--[[
	final
	以回收代替附以nil的操作或默认的gc
]]
function AbsRecyclerClass:recycle()
	self.m_bHasBeenRecycled = true
	return self
end
--[[
	Need inherited implementation
	从缓存中获取时，设置初始化状态
]]
function AbsRecyclerClass:onRecycle()
	print(self.m_szClassName .. "@" .. tostring(self) .. " has no implementation of onRecycle()")
	local keys = {}
	for k, v in pairs(self) do
		if type(v) ~= "function" then
			keys[#keys + 1] = k
		end
	end
	for i=1, #keys do
		self[keys[i]] = nil
	end
	return self;
end

--[==[
	过滤不打印的成员。可手动避免无限递归。
	Created on 2020-04-03 at 16:13:29
]==]
function AbsRecyclerClass:filterPrintMembers()
	return nil
end
--[[
	示例输出：
	
]]
function AbsRecyclerClass:toString()
	-- local print = Android:Localize(Android.SITUATION.QRCODE_SCANNER);
	local s = ""
	if self.m_szClassName then
		s = s .. self.m_szClassName .. "@" .. tostring(self) .. " = {\n"
	end
	local pairs = pairs
	local type = type
	local getmetatable = getmetatable
	local m = {}
	local class = self
	-- 1.循环
	-- while class do 
	-- 	for k, v in pairs(class) do 
	-- 		if k ~= "__index" and not m[k] and type(v) ~= "function" and type(v) ~= "userdata" then
	-- 			m[k] = true
	-- 			s = s .. k .. " = " + v .. ", "
	-- 		end
	-- 	end
	-- 	class = getmetatable(class)
	-- end
	-- 2.递归
	local filterPrintMembers = self:filterPrintMembers();
	-- print("toString(): self =", tostring(self));
	-- print("toString(): filterPrintMembers =", filterPrintMembers);
	for k, v in pairs(class) do 
		if k ~= "__index" and type(v) ~= "function" and type(v) ~= "userdata" then
			if filterPrintMembers and filterPrintMembers[k] then
				s = s .. "    " .. k .. " = " .. tostring(v) .. ",\n"
			else
				s = s .. "    " .. k .. " = " + v .. ",\n"
			end
		end
	end
	s = s .. "},\n"
	class = getmetatable(class)
	if class then
		s = s .. "\n" + class
	end
	return s
end
--------------------------------------------------------ClassesCache start----------------------------------------------------------
local ClassesCache = {
    --[[
        根据类名映射【类名】到【类的数组】的缓存表
    ]]
    m_mClassArrayMap = {

	},
	AbsRecyclerClass = AbsRecyclerClass,
}
_G.ClassesCache = ClassesCache

--[[
    内部接口：缓存，并初始化缓存相关函数
]]
function ClassesCache:__newRecyclerClass(szClassName)
    local RecyclerClass = {}
    if not szClassName then
        szClassName = "RecyclerClass"
	end
	local AbsRecyclerClass = self.AbsRecyclerClass
	AbsRecyclerClass.__index = AbsRecyclerClass
    RecyclerClass.m_bHasBeenRecycled = false
    RecyclerClass.m_szClassName = szClassName
	setmetatable(RecyclerClass, AbsRecyclerClass)
    return RecyclerClass
end

--[[
    内部接口：获取缓存
    无，则返回nil
    @return class {@link table}
]]
function ClassesCache:getCache(szClassName)
    if not szClassName then 
        return nil
    end
    local class = nil
    local classArray = self.m_mClassArrayMap[szClassName]
    if not classArray then 
        classArray = {}
        self.m_mClassArrayMap[szClassName] = classArray
    end
    local length = #classArray
    for i=1, length do 
        if classArray[i].m_bHasBeenRecycled then 
            class = classArray[i]
            class.m_bHasBeenRecycled = false
            class:onRecycle();
            break
        end
	end
	if class and class.m_szClassName == "RecyclerClass" then 
		print("warning: it is a class cache named \"RecyclerClass\", perhaps some functions conflict.");
	end
    return class
end

--[[
    尝试获取缓存
    找不到缓存，则返回新table，并赋予可回收类的函数
    @szClassName 类名字
    @clsParent 如果是新类，需要继承的父类
    @return class {@link table}
    @return {@link boolean} 是否存在于缓存中
]]
function ClassesCache:obtain(szClassName, clsParent)
    if not szClassName then 
        print("warning: creating a class that has no names")
        return {}, false
    end
    local class = self:getCache(szClassName)
	if class then
		-- getCache中已经调用一次onRecycle
        return class, true
    end
    class = self:__newRecyclerClass(szClassName)
	class.m_szClassName = szClassName
    local classArray = self.m_mClassArrayMap[szClassName]
    if not classArray then 
        classArray = {}
        self.m_mClassArrayMap[szClassName] = classArray
    end
	classArray[#classArray + 1] = class
	if clsParent then
		clsParent.__index = clsParent;
		self:insertSuperClass(class, clsParent);
		class:onRecycle();
	end
    return class, false
end

--[==[
	重新继承：将parentClass插入继承关系到childClass与childClass的现有父类
]==]
function ClassesCache:insertSuperClass(childClass, parentClass)
	if not parentClass then return end
	local getmetatable = _G.getmetatable
	if getmetatable(childClass) then
		local childSuperClass = getmetatable(childClass)
		if childSuperClass == parentClass then
			childClass.super = parentClass
			parentClass.__index = parentClass
			setmetatable(childClass, parentClass)
			return
		end
		local parentSuperClass = parentClass
		while getmetatable(parentSuperClass) do 
			parentSuperClass = getmetatable(parentSuperClass)
		end
		if parentSuperClass ~= childSuperClass then
			parentSuperClass.super = childSuperClass
			childSuperClass.__index = childSuperClass
			setmetatable(parentSuperClass, childSuperClass)
		end
	end
	childClass.super = parentClass
	parentClass.__index = parentClass
	setmetatable(childClass, parentClass)
end
--------------------------------------------------------ClassesCache end----------------------------------------------------------