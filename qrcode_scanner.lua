_G.QRCodeScanner = {
	-- It will be used in other day.
	REQUEST_CODES = {
		UNKNOWN = 65472,
		-- 扫码加好友
		ADD_FRIEND = 14643,
		-- 扫码加入链接房间
		JOIN_ROOM = 16126,
		-- 获取CDKEY领取皮肤
		SKIN = 14637,
		-- 获取兑换码
		REDEEM_CODE = 17532,
	},

	FUNC_NAME_PARSE_QR_CODE = "ParseQRCode",

	IParser = {},
	AddFriendParser = {},
	JoinRoomParser = {},
	SkinParser = {},
    RedeemCodeParser = {},
    UnknownParser = {},
}
--[[
	1,2,4,3
]]
function QRCodeScanner:Init()
	local szFuncNameParseQRCode = self.FUNC_NAME_PARSE_QR_CODE;
	local IParser = self.IParser;
	local AddFriendParser = self.AddFriendParser;
	local JoinRoomParser = self.JoinRoomParser;
	local SkinParser = self.SkinParser;
    local RedeemCodeParser = self.RedeemCodeParser;
    local TailParser = IParser;

    setmetatable(self, AddFriendParser);
	setmetatable(AddFriendParser, JoinRoomParser);
	setmetatable(JoinRoomParser, RedeemCodeParser);
	setmetatable(RedeemCodeParser, SkinParser);
	setmetatable(SkinParser, TailParser);

    self:RegisterChainFunctions(self.ParseQRCodeEntrance, self);
    self:RegisterChainFunctions(self.ParseAddFriendCode, AddFriendParser);
    self:RegisterChainFunctions(self.ParseJoinRoomCode, JoinRoomParser);
    self:RegisterChainFunctions(self.ParseSkinCode, SkinParser);
    self:RegisterChainFunctions(self.ParseRedeemCode, RedeemCodeParser);
    self:RegisterChainFunctions(self.ParseUnknownCode, TailParser);
end

function QRCodeScanner:RegisterChainFunctions(funcParseQRCode, tClassParser)
    local QRCodeScanner = self;
    tClassParser[self.FUNC_NAME_PARSE_QR_CODE] = function(self, qrCode)
        print(self, qrCode);
        if funcParseQRCode(QRCodeScanner, qrCode) then
            return true;
        end
        local tNextParser = getmetatable(self);
        return tNextParser and tNextParser[QRCodeScanner.FUNC_NAME_PARSE_QR_CODE](tNextParser, qrCode);
    end
    return self;
end

function QRCodeScanner:ParseQRCodeEntrance(qrCode)
    print("ParseQRCodeEntrance")
    return false;
end

function QRCodeScanner:ParseAddFriendCode(qrCode)
    print("ParseAddFriendCode:")
    return false;
end

function QRCodeScanner:ParseJoinRoomCode(qrCode)
    print("ParseJoinRoomCode:")
    return false;
end

function QRCodeScanner:ParseSkinCode(qrCode)
    print("ParseSkinCode:")
    return false;
end

function QRCodeScanner:ParseRedeemCode(qrCode)
    print("ParseRedeemCode:")
    return false;
end

function QRCodeScanner:ParseUnknownCode(qrCode)
    print("ParseUnknownCode")
    return true;
end

QRCodeScanner:Init();
print(QRCodeScanner);
print(QRCodeScanner.IParser)
print(QRCodeScanner.AddFriendParser)
print(QRCodeScanner.JoinRoomParser)
print(QRCodeScanner.SkinParser)
print(QRCodeScanner.RedeemCodeParser)
print("\n")
QRCodeScanner:ParseQRCode("qrcode");