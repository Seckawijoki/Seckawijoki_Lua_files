-- require("deep_copy_table");
require("utils/Android")
require("utils/override_string___add")
require("utils/override_table___tostring")
require("utils/ResponsibilityChainPattern")
local blMapInfo = {
  wids = {
      [3] = 102, 
      [4] = 101, 
  }, 
  version = 210722876, 
  result = 0, 
  checking = {
      [1] = 101, 
      [2] = 101, 
  },
}

local fromowid = 3;

function verify(fromowid)
  return fromowid  
			and (blMapInfo.wids and blMapInfo.wids[fromowid] and 2)
			or (blMapInfo.checking and blMapInfo.checking[fromowid] and 1)
      or 0;
end

print(verify(3))
print(verify(5))
print(0 == nil)
if 0 then 
  print("0 goto if")
end

if "" then
  print("empty string")
  print(#"123")
end

local nullpointer = nil;
print(#tostring(nullpointer))
print(string.sub("https://activity.mini1.cn/?type=open_SkinARCamera&cdkey=", -7))

ARClass = {
  OnAnimationClick = function()
    
  end,
}

AvatarClass = {
  OnAnimationClick = function()
    
  end,
}

ModificationClass = {
  OnAnimationClick = function()
    AvatarClass:OnAnimationClick();
  end,
}


-- function AvatarControl:Tab_OnClick()
--   self.m_clsCurrent = self.AvatarClass;
-- end

-- AvatarControl:m_clsCurrent:OnAnimationClick();

local commentData = {
  list = {
    1,
  }
};
if not commentData or not commentData.list or #(commentData.list) <= 0 then
  print("if")
  return;
end

local apiid = 310;
if not apiid == 303 then
  print("logfabric")
end

qq_share = {
  inside_game = {
    action_url = "",
    pic_url = "",
    title = "",
    content = "",
  },
  outer_game = {
    action_url = "",
    pic_url = "",
    title = "",
    content = "",
  }
}

print(#{[1]=1, [2]=2, [5]=5})


for i=1 ,10 do
  print(math.random(10))
end

curPlayerX = 5
curPlayerZ = 0
lastPlayerX = 4
lastPlayerZ = 0
curPlayerXInt = math.floor(curPlayerX)
curPlayerZInt = math.floor(curPlayerZ)
lastPlayerXInt = math.floor(lastPlayerX)
lastPlayerZInt = math.floor(lastPlayerZ)
selectBlockX = 6
selectBlockZ = 0

print(curPlayerZInt == lastPlayerZInt and curPlayerZInt == selectBlockZ)
print(curPlayerX > lastPlayerX and curPlayerX < selectBlockX)
print(curPlayerX < lastPlayerX and curPlayerX > selectBlockX)
print(math.abs(curPlayerX - selectBlockX) >= 2)
print(
  (
    curPlayerX > lastPlayerX and curPlayerX < selectBlockX --X轴正方向
    or curPlayerX < lastPlayerX and curPlayerX > selectBlockX --或，X轴负方向
  ) 
)
print(
  (curPlayerZInt == lastPlayerZInt and curPlayerZInt == selectBlockZ) -- Z轴上
  and (
    curPlayerX > lastPlayerX and curPlayerX < selectBlockX --X轴正方向
    or curPlayerX < lastPlayerX and curPlayerX > selectBlockX --或，X轴负方向
  ) 
)
if not (
  (curPlayerZInt == lastPlayerZInt and curPlayerZInt == selectBlockZ) -- Z轴上
  and (
    curPlayerX > lastPlayerX and curPlayerX < selectBlockX --X轴正方向
    or curPlayerX < lastPlayerX and curPlayerX > selectBlockX --或，X轴负方向
  ) 
  and math.abs(curPlayerX - selectBlockX) >= 2
  ) 
  or not ( -- 类上
  (curPlayerXInt == lastPlayerXInt and curPlayerXInt == selectBlockX) -- X轴上
  and ( 
    curPlayerZ - lastPlayerZ > 0 and curPlayerZ - selectBlockZ > 0
    or curPlayerZ - lastPlayerZ < 0 and curPlayerZ - selectBlockZ < 0
  )
  and math.abs(curPlayerZ - selectBlockZ) >= 2
  ) then 
  print("cannot")
end

if not 1 and not 2 then 
  print("1 and 2")
end

-- _G.Android = {
--   this = Android,

-- 	SITUATION = {
-- 		ADVERTISEMENT_9 = "ADVERTISEMENT_9",
-- 	},

-- 	m_aSwitches = {
-- 		[this.SITUATION.ADVERTISEMENT_9] = false,
-- 	},

-- }

local t = {
  [""] = 123,
  ["\\"] = "\\\\"
}

print(t[""])
print(t["\\"])

function onRecycle()
  print(self.m_szClassName .. "@" .. tostring(self) .. " has no implementation of onRecycle()")
  for k, v in pairs(self) do
      if type(v) ~= "function" then
          self[k] = nil
      end
  end
end

function newRecyclerClass(szClassName)
  local RecyclerClass = {}
  if not szClassName then
    szClassName = "RecyclerClass"
  end
  RecyclerClass.m_bHasBeenRecycled = false
  RecyclerClass.m_szClassName = szClassName
  szClassName = nil
  function RecyclerClass:recycle()
		self.m_bHasBeenRecycled = true
		return self
  end
  RecyclerClass.onRecycle = _G.onRecycle
    -- function RecyclerClass:onRecycle()
    --     print(self.m_szClassName .. "@" .. tostring(self) .. " has no implementation of onRecycle()")
    --     for k, v in pairs(self) do
    --         if type(v) ~= "function" then
    --             self[k] = nil
    --         end
    --     end
    -- end
  return RecyclerClass
end

local r1 = newRecyclerClass();
local r2 = newRecyclerClass();
print("r1 = ", r1)
for k, v in pairs(r1) do 
  print(k, type(v), v)
end
print("r2 = ", r2)
for k, v in pairs(r2) do 
  print(k, type(v), v)
end

local t = {
  [-1] = -1,
  [0] = 0,
  [1] = 1,
  [2] = 2,
  [3] = 3,
  [4] = 4,
  [5] = 5,
  [6] = nil,
  [7] = 7,
  [8] = 8,
  [9] = 9,
  [10] = 10,
  [11] = 11,
  [12] = 12,
}

for k, v in pairs(t) do 
  print(k, type(v), v)
end
print(t[-1])
print(t[0])
print(#t)

Abstract = {
  m_szClassName = "Abstract",

  getClassName = function(self)
    return self.m_szClassName
  end,

  static = function()
    print(Abstract.m_szClassName, tostring(Abstract))
  end
}
Abstract.__index = Abstract

Concrete = {
  m_szClassName = "Concrete",

  __tostring = function(self)
    return self.m_szClassName .. "@" .. tostring(self) 
  end
}

Concrete = setmetatable(Concrete, Abstract)
-- Concrete.__index = Concrete

for k, v in pairs(Concrete) do 
  print(k, type(v), v)
end
print(getmetatable(Concrete))
print(Abstract)
print(Concrete.static())
print(Concrete:getClassName())
print(Abstract.static)
print(Concrete.static)

print(i)

String = {
  m_szClassName = "String",

  tostring = function()
    return "@" .. tostring(self) 
  end,
}

print(String)

print("hello " + true + " " + 1 )

print(not nil)

-- Days = [[]]
-- print(type(Days))
-- print(Days == nil)
-- print(Days <= 0)

function url_addParams( url_ )

  local uin_ = "12"
	local apiid_ = "nil"	
	local ver_   = "nil"
	local lang_  = "nil"
	local cnty_  = "nil"
	--for minicode
	local channel_id = 0;
	local production_id = 0;
	--local headInd_ = GetHeadIconIndex() or "nil"


	local long_url_;
	if  string.find( url_, '%?' ) then
		long_url_ = url_ .. '&';
	else
		long_url_ = url_ .. '?';
	end
	long_url_ = long_url_ .. "uin="      .. uin_
	                      .. "&ver="     .. ver_
						  .. (((channel_id > 0) and ("&channel_id="..channel_id)) or "")
						  .. (((production_id > 0) and ("&production_id="..production_id)) or "")	                      
						  .. "&apiid="   .. apiid_
	                      .. "&lang="    .. lang_
						  .. "&country=" .. cnty_


	--增加安全
	if  string.sub( long_url_, 1, 1 ) == 's' and string.sub( long_url_, 3, 3 ) == "_" then
		long_url_ =  getUrlSafeInfo( long_url_ );    --增加url安全
	end

	return long_url_;
end

-- print(url_addParams(nil))
print(url_addParams(""))


local JsBridge = {
	m_aFuncParams = {

	}, 
}
function JsBridge:PushFunction(func, ...)
	-- local print = Android:Localize(Android.SITUATION.JS_BRIDGE);
	print("PushFunction(): func = ", func)
	self.m_aFuncParams[#self.m_aFuncParams + 1] = {...};
	self[#self + 1] = func;
end

JsBridge:PushFunction()

print("JsBridge(): JsBridge = " + JsBridge);

local url_ = "hTtPs://activity.mini1.cn/newcdkey/?type=open_SkinARCamera&cdkey=XD52cf7609484398100090";
local header_ = string.lower( string.sub( url_, 1,  6 ) )
print("is_https_url(): header_ = " + header_);

local AbsRedeemCodeParser = {

}

function AbsRedeemCodeParser:useAccountItem()
  print("useAccountItem(): self = " + tostring(self));
end

function AbsRedeemCodeParser:onReceive()
  print("onReceive(): self = " + tostring(self));
  self:useAccountItem();
end
AbsRedeemCodeParser.__index = AbsRedeemCodeParser
local RedeemCodeParser = {}
setmetatable(RedeemCodeParser, AbsRedeemCodeParser)

RedeemCodeParser:onReceive()

local useAccountItem = function(self)
  print("useAccountItem(): self = " + self);
end
RedeemCodeParser.useAccountItem = useAccountItem

RedeemCodeParser:onReceive()

function parseVariableParams2(...)
  local t = {...}
  print("parseVariableParams2(): t = " + t);
  for i=1, #t do 
    print("parseVariableParams2(): t[i] = " + t[i]);
  end
end

function parseVariableParams(...)
  parseVariableParams2(...)
end

parseVariableParams(1, "string", false, {});
parseVariableParams();

local QRCodeScanner = {

}

function QRCodeScanner:init()
  ResponsibilityChainFactory:wrap(self, "parseQRCode")
    :addNode(self.parse3)
    :addDerivativeNode(self.parse2, AbsRedeemCodeParser)
    :addNode(self.parse1)
end

function QRCodeScanner:parse1(qrCode)
    print("parse1(): qrCode = " + qrCode);
    return false
end

function QRCodeScanner:parse2(qrCode)
  print("parse2(): qrCode = " + qrCode);
  self.m_clsCurrentNode:onReceive();
  return qrCode == "123456789"
end

function QRCodeScanner:parse3(qrCode)
  print("parse3(): qrCode = " + qrCode);
  return false
end

QRCodeScanner:init();
QRCodeScanner:parseQRCode("123456789")
print("test.lua(): QRCodeScanner = " + QRCodeScanner);