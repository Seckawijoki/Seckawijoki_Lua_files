
function getglobal(nothing)
  return {
    emptyFunction = function()end,
    Show = emptyFunction,
    Hide = emptyFunction,
    Show = emptyFunction,
    Show = emptyFunction,
  }
end

local function URLShareMsgHandle() 
  local a = 1000000 / 10000 + 4 * 10 + 900000 / 100000;
  -- print("URLShareMsgHandle()")
  return false;
end
local function SkinShareMsgHandle()
  local a = 100 / 1 + 5 * 10;
  -- print("SkinShareMsgHandle()")
  return true;
end
local function RideShareMsgHandle()
  local a = 10000 / 100 + 5 * 10 + 1;
  -- print("RideShareMsgHandle()")
  return false;
end

local shareMsgHandleDispatcher = {};

shareMsgHandleDispatcher[0] = {}
shareMsgHandleDispatcher[0].handle = URLShareMsgHandle;
shareMsgHandleDispatcher[0].callback = function(szUiMsgFrameName)
  local a = 1000000 / 10000 + 4 * 10 + 900000 / 100000;
  textHeight = 149;
  return a;
end;

shareMsgHandleDispatcher[1] = {}
shareMsgHandleDispatcher[1].handle = SkinShareMsgHandle;
shareMsgHandleDispatcher[1].callback = function(szUiMsgFrameName)
  local a = 100 / 1 + 5 * 10;
  return a;
end;

shareMsgHandleDispatcher[2] = {}
shareMsgHandleDispatcher[2].handle = RideShareMsgHandle;
shareMsgHandleDispatcher[2].callback = function(szUiMsgFrameName)
  local a = 10000 / 100 + 5 * 10 + 1;
  return a;
end;

local szUiMsgFrameName = "nothing";
local textHeight = 0;

-- for i=0, #shareMsgHandleDispatcher, 1 do 
--   local result = shareMsgHandleDispatcher[i].handle(msgUi, msgData) and shareMsgHandleDispatcher[i].callback(szUiMsgFrameName);
--   textHeight = type(result) == "number" and result or textHeight;
-- end

local start = os.clock();
local type = type;
for j=1, 10000000, 1 do 
  for i=0, #shareMsgHandleDispatcher, 1 do 
    local result = shareMsgHandleDispatcher[i].handle() and shareMsgHandleDispatcher[i].callback(szUiMsgFrameName);
    textHeight = type(result) == "number" and result or textHeight;
  end
end
print(os.clock() - start);

start = os.clock();
for j=1, 10000000, 1 do 
  if URLShareMsgHandle() then
    local a = 1000000 / 10000 + 4 * 10 + 900000 / 100000;
    textHeight = a;
  elseif SkinShareMsgHandle() then 
    local a = 100 / 1 + 5 * 10;
    textHeight = a;
  elseif RideShareMsgHandle() then 
    local a = 10000 / 100 + 5 * 10 + 1;
    textHeight = a;
  end
end
print(os.clock() - start);