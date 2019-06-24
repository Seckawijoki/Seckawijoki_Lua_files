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