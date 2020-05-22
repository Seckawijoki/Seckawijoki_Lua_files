function QRCodeScanner:parseRedeemCode(qrCode)
	if not qrCode or #qrCode <= 0 then return false end
	self.m_szQRCode = qrCode;
	local cdkey;
	if is_https_url(qrCode) then
		local http_url = qrCode;
		local index = string.find(http_url, "cdkey=");
		print("parseRedeemCode(): index = ", index);
		cdkey = string.sub(http_url, index+6);
	else
		cdkey = qrCode;
	end
	print("parseRedeemCode(): cdkey = ", cdkey);
	self.RedeemCodeParser.m_szCDKey = cdkey;
	
	local env =  ClientMgr:getGameData("game_env");
	local http_request_url = "s4_http://cdk.mini1.cn/api/config?cdk_id=";
	if IsOverseasVer() or env == 10 or env == 12 then 
		http_request_url = "s4_https://cdk.miniworldgame.com/api/config?cdk_id=";
	end
	http_request_url = http_request_url .. cdkey;
	http_request_url = http_request_url .. "&denv=" .. env;
	http_request_url = url_addParams(http_request_url)
	print("parseRedeemCode(): http_request_url = ", http_request_url);
	local function callback(json)
		self.RedeemCodeParser:onResponseCheckBindingEnabled(json)
	end
	ns_http.func.rpc_string(http_request_url, callback);
    return true;
end

QRCodeScanner:registerChainFunctions(QRCodeScanner.parseRedeemCode, QRCodeScanner.RedeemCodeParser)