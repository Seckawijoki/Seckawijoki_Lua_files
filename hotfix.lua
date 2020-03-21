local useAccountItem = function(self, id, num)
	local tonumber = _G.tonumber
	local tostring = _G.tostring
	if not id or not num then 
		return
	end

	local itemId = id
	if itemId == 10000
	or itemId == 10002
	then
		local showlist = {
			[1] = {
				id = itemId,
				num = num,
			}
		}
		SetGameRewardFrameInfo(GetS(3160), showlist, "");
		return
	end

	if self:isAvatarSkin(itemId) then
		local theOtherDuduBoboItemId = 
		itemId == 20412
		and 20413
		or 20412
		self.ShowQRActiveNewSkin = self:checkWhetherHasOwnedTheSkin(theOtherDuduBoboItemId) and 34 or 0
		local skinId = _G.ITEM_ID_TO_SKIN_ID[itemId]
		if skinId then 
			self:UpdateQRSuccessSkinInfo(skinId)
		end
		getglobal("ActivityFrame"):Hide();
		return
	end

	local code, list, cfg;
	if self:isAvatarItem(itemId) then
		code = ErrorCode.OK
		list = {}
		list[1] = {
			id = tonumber(itemId),
			num = tonumber(num),
		}
	elseif self:isPermanentSkin(itemId) then
		code, list, cfg = AccountManager:getAccountData():notifyServerUseAccountItem(id, num);
	else
		local showlist = {
			[1] = {
				id = itemId,
				num = num,
			}
		}
		SetGameRewardFrameInfo(GetS(3160), showlist, "");
		return
	end

	if code == ErrorCode.OK then
		StatisticsStashUseItem(id, "使用成功");
		if list and next(list) ~= nil then
			SetGameRewardFrameInfo(GetS(3160), list, "");
		elseif cfg and next(cfg) ~= nil then
			if cfg.Tag and cfg.Tag == 5 then 
				ShowGameTips(GetS(9252), 3);
			else
				GetInst("UIManager"):Open("ShopGain",{gainType = 3, id = cfg.SkinID, days = cfg.ExpireTimeType});
			end 
		end
	else
		ShowGameTips(GetS(t_ErrorCodeToString[code]));
	end
end

local onReceive = function(self)
	local tonumber = _G.tonumber
	local tostring = _G.tostring
	local ret = self.m_tBindRedeemCodeResult
	local UNAVAILABLE = 0
	-- an upvalue
	local cdkey = ret.data.cdk_id or self.m_szCDKey
	local env =  ClientMgr:getGameData("game_env");
	local apiId = ClientMgr:getApiId();
	local strVersion = ClientMgr:clientVersionStr();
	local baseUrl = "s4_http://cdk.mini1.cn/api/receive";
	if IsOverseasVer() or env == 10 or env == 12 then 
		baseUrl = "s4_https://cdk.miniworldgame.com/api/receive";
	end
	baseUrl = baseUrl .. "?cdk_id=" .. cdkey;
	baseUrl = baseUrl .. "&channel=" .. apiId;
	baseUrl = baseUrl .. "&version=" .. strVersion;
	baseUrl = baseUrl .. "&denv=" .. env;
	baseUrl = url_addParams(baseUrl);
	local rpc_string = ns_http.func.rpc_string
	self:clearProps();
	local function callback(json)
		self:onResponseReceive(json)
	end

	local cdk_prop_m = ret.data.cdk_prop_m
	if cdk_prop_m and #cdk_prop_m > 0 then 
		for i=1, #cdk_prop_m do 
			local is_receive = cdk_prop_m[i].is_receive
			if is_receive and is_receive ~= UNAVAILABLE then 
				local mainPropUrl = baseUrl .. "&cdk_prop_id=" .. cdk_prop_m[i].m_cdk_prop_id;
				mainPropUrl = mainPropUrl .. "&" .. "central=1";
				self:offerProp(cdk_prop_m[i].prop_id, cdk_prop_m[i].p_number)
				threadpool:work(rpc_string, mainPropUrl, callback)
			else
				ShowGameTips(GetS(20302));
			end
		end
	end

	local cdk_prop_f = ret.data.cdk_prop_f
	if cdk_prop_f and #cdk_prop_f > 0 then 
		for i=1, #cdk_prop_f do 
			local is_receive = cdk_prop_f[i].is_receive
			if is_receive and is_receive ~= UNAVAILABLE then 
				local subPropUrl = baseUrl .. "&cdk_prop_id=" .. cdk_prop_f[i].m_cdk_prop_id;
				subPropUrl = subPropUrl .. "&" .. "central=2";
				self:offerProp(cdk_prop_f[i].prop_id, cdk_prop_f[i].p_number)
				threadpool:work(rpc_string, subPropUrl, callback)
			else
				ShowGameTips(GetS(20302));
			end
		end
	end
end

AbsRedeemCodeParser =_G.getmetatable(_G.QRCodeScanner.RedeemCodeParser)
if AbsRedeemCodeParser then
	AbsRedeemCodeParser.useAccountItem = useAccountItem
	AbsRedeemCodeParser.onReceive = onReceive
end

function QRCodeScanner:parseRedeemCode(qrCode)
	if not qrCode or #qrCode <= 0 then return false end
	self.m_szQRCode = qrCode;
	local cdkey;
	if is_https_url(qrCode) then
		local http_url = qrCode;
		local index = string.find(http_url, "cdkey=");
		cdkey = string.sub(http_url, index+6);
	else
		cdkey = qrCode;
	end
	self.RedeemCodeParser.m_szCDKey = cdkey;
	
	local env =  ClientMgr:getGameData("game_env");
	local http_request_url = "s4_http://cdk.mini1.cn/api/config?cdk_id=";
	if IsOverseasVer() or env == 10 or env == 12 then 
		http_request_url = "s4_https://cdk.miniworldgame.com/api/config?cdk_id=";
	end
	http_request_url = http_request_url .. cdkey;
	http_request_url = http_request_url .. "&denv=" .. env;
	http_request_url = url_addParams(http_request_url)
	local function callback(json)
		self.RedeemCodeParser:onResponseCheckBindingEnabled(json)
	end
	ns_http.func.rpc_string(http_request_url, callback);
    return true;
end

_G.QRCodeScanner:registerChainFunction(_G.QRCodeScanner.parseRedeemCode, _G.QRCodeScanner.RedeemCodeParser);