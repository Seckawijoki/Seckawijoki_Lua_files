
--------------------------------------------------------Android start----------------------------------------------------------
local Android = {
	m_CurrentSituation = "",
	m_szCurrentTag = "",
	--[[
		日志打印总的开关
	]]
	ALLOW_NIL_TAG = false,
	--[[
		PC日志开关
	]]
	PRINT_IN_PC = false,

	SITUATION_SWITCHES = nil,
	SITUATION = nil,
	TAGS = nil,
	
}
_G.Android = Android
function Android:init()
	if self.initLogcat then
		self:initLogcat();
		self.initLogcat = nil
	end

	-- self.A = {
	-- 	BB = {
	-- 		CCC = {
	-- 			DDDD = function(self, boolean, integer, float, double, string)
	-- 				local print = Android:Localize(Android.SITUATION.JAVA2LUA);
	-- 				-- print("DDDD(): boolean = " + boolean);
	-- 				-- print("DDDD(): integer = " + integer);
	-- 				-- print("DDDD(): float = " + float);
	-- 				-- print("DDDD(): double = " + double);
	-- 				-- print("DDDD(): string = " + string);
	-- 				return string .. "|lua self function return", double * 100, float / 2, integer -100, not boolean  
	-- 			end,

	-- 			EEEEE = function(boolean, integer, float, double, string)
	-- 				local print = Android:Localize(Android.SITUATION.JAVA2LUA);
	-- 				-- print("EEEEE(): boolean = " + boolean);
	-- 				-- print("EEEEE(): integer = " + integer);
	-- 				-- print("EEEEE(): float = " + float);
	-- 				-- print("EEEEE(): double = " + double);
	-- 				-- print("EEEEE(): string = " + string);
	-- 				return string .. "|lua function return", double * 100, float / 2, integer -100, not boolean  
	-- 			end
	-- 		},
	-- 	},
	-- }
end
function Android:initLogcat()
	--[[
		同enum
	]]
	local SITUATION = {
		CHANNEL_REWARD = 1,
		ADVERTISEMENT_9 = 2,
		MULTIEDITBOX = 3,
		PAYMENT = 4,
		QRCODE_SCANNER = 5,
		BROWSER = 6,
		JS_BRIDGE = 7,
		UI_THEME = 8,
		CHANNEL = 9,
		LAYOUT_MANAGER = 10,
		REDEEM_CODE = 11,
		DEVELOPER = 12,
		SPAM_PREVENTION = 13,
		HUAWEI_AR_ENGINE = 14,
		JAVA2LUA = 15,
		REAL_NAME_AUTH = 16,
		SELECT_ROLE = 17,
		ADVERTISEMENT_101 = 18,
		_4399 = 19,
		LOADING = 20,
	}

	--[[
		手动改写控制Lua的开关
	]]
	self.SITUATION_SWITCHES = {
		[SITUATION.CHANNEL_REWARD] = false,
		[SITUATION.ADVERTISEMENT_9] = false,
		[SITUATION.MULTIEDITBOX] = false,
		[SITUATION.PAYMENT] = true,
		[SITUATION.QRCODE_SCANNER] = true,
		[SITUATION.BROWSER] = false,
		[SITUATION.JS_BRIDGE] = false,
		[SITUATION.UI_THEME] = false,
		[SITUATION.CHANNEL] = false,
		[SITUATION.LAYOUT_MANAGER] = false,
		[SITUATION.REDEEM_CODE] = true,
		[SITUATION.DEVELOPER] = false,
		[SITUATION.SPAM_PREVENTION] = true,
		[SITUATION.HUAWEI_AR_ENGINE] = true,
		[SITUATION.JAVA2LUA] = true,
		[SITUATION.REAL_NAME_AUTH] = true,
		[SITUATION.SELECT_ROLE] = true,
		[SITUATION.ADVERTISEMENT_101] = true,
		[SITUATION._4399] = true,
		[SITUATION.LOADING] = true,
	}

	--[[
		作为Log的方法调用中的第一个TAG参数，可不定义
	]]
	self.TAGS = {
		[SITUATION.CHANNEL_REWARD] = "CHANNEL_REWARD",
		[SITUATION.ADVERTISEMENT_9] = "ADVERTISEMENT_9",
		[SITUATION.MULTIEDITBOX] = "MULTIEDITBOX",
		[SITUATION.PAYMENT] = "PAYMENT",
		[SITUATION.QRCODE_SCANNER] = "QRCODE_SCANNER",
		[SITUATION.BROWSER] = "BROWSER",
		[SITUATION.JS_BRIDGE] = "JS_BRIDGE",
		[SITUATION.UI_THEME] = "UI_THEME",
		[SITUATION.CHANNEL] = "CHANNEL",
		[SITUATION.LAYOUT_MANAGER] = "LayoutManagerFactory",
		[SITUATION.REDEEM_CODE] = "REDEEM_CODE",
		[SITUATION.DEVELOPER] = "DEVELOPER",
		[SITUATION.SPAM_PREVENTION] = "SPAM_PREVENTION",
		[SITUATION.HUAWEI_AR_ENGINE] = "RendererManager",
		[SITUATION.JAVA2LUA] = "JAVA2LUA",
		[SITUATION.REAL_NAME_AUTH] = "REAL_NAME_AUTH",
		[SITUATION.SELECT_ROLE] = "SELECT_ROLE",
		[SITUATION.ADVERTISEMENT_101] = "ADVERTISEMENT_101",
		[SITUATION._4399] = "_4399",
		[SITUATION.LOADING] = "LOADING",
	}
	
	self.SITUATION = SITUATION
end

function Android:__getLogMethodInvokerBuilder__()
	return JavaMethodInvokerFactory:obtain()
		:debug(false)
		-- :setSignature("(Ljava/lang/String;Ljava/lang/String;)V")
		-- :setClassName("org/appplay/lib/GameBaseActivity");
		:setSignature("(Ljava/lang/String;Ljava/lang/String;)I")
		:setClassName("android/util/Log");
end

function Android.EmptyPrint()
end

-- 类静态
function Android.Logcat(...)
	Android:Logd(...);
end

function Android:Logd(...)
	local arguments = {...}
	if #arguments <= 0 then return end
	local tag = self.m_szCurrentTag
	if not tag or #tag <= 0 then
		tag = "lua2android"
	end
	if #tag >= 23 then 
		tag = string.sub(tag, 0, 22);
	end
	local logcat = ""
	for i=1, #arguments do 
		if type(arguments[i]) == "table" then 
			logcat = logcat .. table.tostring(arguments[i]) .. " ";
		else
			logcat = logcat .. tostring(arguments[i]) .. " ";
		end
	end
	local logBuilder = self:__getLogMethodInvokerBuilder__()
		:addString(tag)
		:addString(logcat)
	if #arguments > 1 then
		logBuilder:setMethodName("d")
	else
		logBuilder:setMethodName("i")
	end
	logBuilder:call();
end

function Android:Localize(situation)
	local apiId = ClientMgr:getApiId()
	if self.PRINT_IN_PC or apiId == 45 or apiId == 345 or apiId == 999 then 
		return _G.print, _G.print
	end
	--situation为nil
	if self.ALLOW_NIL_TAG == false and not situation then
		return self.EmptyPrint, self.EmptyPrint
	end
	--situation非nil时，开关未打开
	if situation and self.SITUATION_SWITCHES[situation] == false then
		return self.EmptyPrint, self.EmptyPrint
	end
	--记录打印模块
	self.m_CurrentSituation = situation;
	--设置打印日志的tag
	self.m_szCurrentTag = situation and self.TAGS[situation] or nil
	return self.Logcat, self.Logcat;
end

function Android:IsBlockArt(apiId)
	local apiId = ClientMgr:getApiId();
	return apiId >= 300 and apiId <= 399 and apiId ~= 345;
end

function Android:LogFabric(szLog)
	-- if ClientMgr:getApiId() ~= 303 then return end
	-- ClientMgr:logFabric(szLog);
end

function Android:HowManyElementsDoesTableHave(t)
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
Android:init();
--------------------------------------------------------Android end----------------------------------------------------------
