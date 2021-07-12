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
		CHANNEL_REWARD = 1,		ADVERTISEMENT_9 = 2,		MULTIEDITBOX = 3,		PAYMENT = 4,		QRCODE_SCANNER = 5,		
		BROWSER = 6,		JS_BRIDGE = 7,		UI_THEME = 8,		CHANNEL = 9,		LAYOUT_MANAGER = 10,
		REDEEM_CODE = 11,		DEVELOPER = 12,		SPAM_PREVENTION = 13,		HUAWEI_AR_ENGINE = 14,		JAVA2LUA = 15,
		REAL_NAME_AUTH = 16,		SELECT_ROLE = 17,		ADVERTISEMENT_101 = 18,		_4399 = 19,		LOADING = 20,
		AR_CAMERA = 21,		AVATAR = 22,		SHARE = 23,		HTTP = 24,		DEEP_LINK = 25,
		AR_MOTION_CAPTURE = 26,		ROOM = 27,		TEXTURE = 28,		LUA_API = 29, MODEL_ROTATE = 30, 
		MODEL_DRAG = 31,	FCM = 32,		LOGIN = 33,		UI = 34,	HEAD_FRAME = 35,	ANIMATOR = 36,	CSVDEF = 37, ANTIFRAUD = 38,
	}

	--[==[
		@element switch :  开关
		@element tag :  日志标签
		Created on 2020-08-26 at 14:47:43
	]==]
	self.LOG_CONFIG = {
		[SITUATION.CHANNEL_REWARD] = {switch = true, tag = "CHANNEL_REWARD",},
		[SITUATION.ADVERTISEMENT_9] = {switch = false, tag = "ADVERTISEMENT_9",},
		[SITUATION.MULTIEDITBOX] = {switch = false, tag = "MULTIEDITBOX",},
		[SITUATION.PAYMENT] = {switch = false, tag = "PAYMENT",},
		[SITUATION.QRCODE_SCANNER] = {switch = false, tag = "QRCODE_SCANNER",},
		[SITUATION.BROWSER] = {switch = false, tag = "BROWSER",},
		[SITUATION.JS_BRIDGE] = {switch = false, tag = "Browser",},
		[SITUATION.UI_THEME] = {switch = false, tag = "UI_THEME",},
		[SITUATION.CHANNEL] = {switch = false, tag = "CHANNEL",},
		[SITUATION.LAYOUT_MANAGER] = {switch = false, tag = "LayoutManagerFactory",},
		[SITUATION.REDEEM_CODE] = {switch = false, tag = "REDEEM_CODE",},
		[SITUATION.DEVELOPER] = {switch = false, tag = "DEVELOPER",},
		[SITUATION.SPAM_PREVENTION] = {switch = false, tag = "SPAM_PREVENTION",},
		[SITUATION.HUAWEI_AR_ENGINE] = {switch = false, tag = "HUAWEI_AR_ENGINE",},
		[SITUATION.JAVA2LUA] = {switch = false, tag = "JAVA2LUA",},
		[SITUATION.REAL_NAME_AUTH] = {switch = false, tag = "REAL_NAME_AUTH",},
		[SITUATION.SELECT_ROLE] = {switch = false, tag = "SELECT_ROLE",},
		[SITUATION.ADVERTISEMENT_101] = {switch = false, tag = "ADVERTISEMENT_101",},
		[SITUATION._4399] = {switch = false, tag = "_4399",},
		[SITUATION.LOADING] = {switch = false, tag = "LOADING",},
		[SITUATION.AR_CAMERA] = {switch = false, tag = "CameraActivity",},
		[SITUATION.AVATAR] = {switch = false, tag = "AVATAR",},
		[SITUATION.SHARE] = {switch = false, tag = "SHARE",},
		[SITUATION.HTTP] = {switch = false, tag = "HTTP",},
		[SITUATION.DEEP_LINK] = {switch = true, tag = "DEEP_LINK",},
		[SITUATION.AR_MOTION_CAPTURE] = {switch = false, tag = "AR_MOTION_CAPTURE",},
		[SITUATION.ROOM] = {switch = false, tag = "ROOM",},
		[SITUATION.TEXTURE] = {switch = false, tag = "TEXTURE",},
		[SITUATION.LUA_API] = {switch = false, tag = "LUA_API",},
		[SITUATION.MODEL_ROTATE] = {switch = false, tag = "ModelOperation",},
		[SITUATION.MODEL_DRAG] = {switch = false, tag = "ModelOperation",},
		[SITUATION.FCM] = {switch = false, tag = "FCM",},
		[SITUATION.LOGIN] = {switch = false, tag = "LOGIN",},
		[SITUATION.UI] = {switch = false, tag = "UI",},
		[SITUATION.HEAD_FRAME] = {switch = false, tag = "HEAD_FRAME",},
		[SITUATION.ANIMATOR] = {switch = false, tag = "ANIMATOR",},
		[SITUATION.CSVDEF] = {switch = false, tag = "CSVDEF",},
		[SITUATION.ANTIFRAUD] = {switch = true, tag = "ANTIFRAUD",},
	}

	self.SITUATION = SITUATION
end

function Android:__getLogMethodInvokerBuilder__()
	local javaMethodInvoker = JavaMethodInvokerFactory:obtain()
		:debug(false);
	if ClientMgr.isHarmony and ClientMgr:isHarmony() then
		javaMethodInvoker:setSignature("(Ljava/lang/String;Ljava/lang/String;)V")
		javaMethodInvoker:setClassName("com/minitech/miniworld/harmony/miniworld/MiniWorldEventHandler");
	else
		javaMethodInvoker:setSignature("(Ljava/lang/String;Ljava/lang/String;)V")
		javaMethodInvoker:setClassName("org/appplay/lib/GameBaseActivity");
	end
	return javaMethodInvoker
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
	if ClientMgr:isAndroid() then
		local logBuilder = self:__getLogMethodInvokerBuilder__()
			:addString(tag)
			:addString(logcat)
		if #arguments > 1 then
			logBuilder:setMethodName("postLogDebug")
		else
			logBuilder:setMethodName("postLogInfo")
		end
		logBuilder:call();
	else
		print(tag .. " " .. logcat);
	end
end

function Android:Localize(situation)
	local apiId = ClientMgr:getApiId()
	if apiId == 45 or apiId == 345 or apiId == 346 then
		return _G.print, _G.print
	end
	--situation为nil
	if self.ALLOW_NIL_TAG == false and not situation then
		return self.EmptyPrint, self.EmptyPrint
	end
	local logConfig = self.LOG_CONFIG[situation];
	--situation非nil时，开关未打开
	if situation and logConfig.switch == false then
		return self.EmptyPrint, self.EmptyPrint
	end
	--记录打印模块
	self.m_CurrentSituation = situation;
	--设置打印日志的tag
	self.m_szCurrentTag = situation and logConfig.tag or nil
	return self.Logcat, self.Logcat;
end

-- 判断是否为安卓海外渠道
function Android:IsBlockArt(apiId)
	local apiId = ClientMgr:getApiId();
	return apiId >= 300 and apiId <= 399 and apiId ~= 345 and apiId ~= 346;
end

-- 判断是否为安卓国内渠道
function Android:IsMainland(apiId)
	return Android:IsAndroidChannel(apiId) and not Android:IsBlockArt(apiId);
end

-- 判断是否为安卓渠道
function Android:IsAndroidChannel(apiId)
	return ClientMgr:isAndroid();
end

function Android:LogFabric(szLog)
	-- if ClientMgr:getApiId() ~= 303 then return end
	-- ClientMgr:logFabric(szLog);
end


-- 渠道相关，获取渠道实名结果
function Android:GetRealNameResult(apiId)
	local result = false;
	if apiId == 2 or apiId == 13 then  -- 4399/国内OPPO
		result = JavaMethodInvokerFactory:obtain()
				 -- :debug(true)
				 :setClassName("org/appplay/platformsdk/TMobileSDK")
				 :setMethodName("getRealNameResult")
				 :setSignature("()Z")
				 :call()
				 :getBoolean();
	elseif apiId == 7 then -- 国内华为
		result = JavaMethodInvokerFactory:obtain()
				 -- :debug(true)
				 :setClassName("org/appplay/platformsdk/MobileSDK")
				 :setMethodName("getCertificatonInfo")
				 :setSignature("()Z")
				 :call()
				 :getBoolean();
	end
	return result;
end

-- 渠道相关，获取渠道账号登录结果
function Android:GetLoginFlag(apiId)
	local loginFlag = false;
	if apiId == 2 then -- 4399
		loginFlag = JavaMethodInvokerFactory:obtain()
					-- :debug(true)
					:setClassName("org/appplay/platformsdk/TMobileSDK")
					:setMethodName("getLoginFlag")
					:setSignature("()Z")
					:call()
					:getBoolean();
	end
	return loginFlag;
end

Android:init();