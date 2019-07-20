require("deep_copy_table");

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

_G.Trigger = {
  Block = {
    method = function(self)
      print("Trigger.Block:print()")
    end
  },
  Area = {
    method = function(self)
      print("Trigger.Area:print()")
    end
  },
}

local class = _G["Trigger.Block"]
print(class["method"](class))

