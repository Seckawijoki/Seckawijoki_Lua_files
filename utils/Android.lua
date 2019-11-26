
--------------------------------------------------------Android start----------------------------------------------------------
_G.Android = {
	m_CurrentSituation = "",
	m_szCurrentTag = "",
	--[[
		日志打印总的开关
	]]
	DEFAULT_LOG = false,
	--[[
		PC日志开关
	]]
	PRINT_IN_PC = false,

	SITUATION_SWITCHES = nil,
	SITUATION = nil,
	TAGS = nil,
	
}
local Android = _G.Android
function Android:init()
	self:initLogcat();

	-- self.A = {
	-- 	BB = {
	-- 		CCC = {
	-- 			DDDD = function(self, boolean, integer, float, double, string)
	-- 				print("DDDD(): boolean = ", boolean);
	-- 				print("DDDD(): integer = ", integer);
	-- 				print("DDDD(): float = ", float);
	-- 				print("DDDD(): double = ", double);
	-- 				print("DDDD(): string = ", string);
	-- 				return string .. "|lua return", double * 100, float / 2, integer -100, not boolean  
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
	}
	
	self.SITUATION = SITUATION
end

function Android:__getLogMethodInvokerBuilder__()
	return newAndroidMethodInvokerBuilder()
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
	logBuilder:callAndroidMethod();
end

function Android:Localize(situation)
	if self.PRINT_IN_PC then 
		return _G.print, _G.print
	end
	--situation为nil
	if self.DEFAULT_LOG == false and not situation then
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
Android:init();
--------------------------------------------------------Android end----------------------------------------------------------