
local numberList = {}
local tableCount = 200;
local maxRandom = tableCount;
local testLoopCount = 100000;

for i=1, tableCount, 1 do 
  numberList[#numberList + 1] = tostring(math.random(1, maxRandom));
end

local stringKeyMap = {}
for i=1, #numberList, 1 do 
  stringKeyMap[numberList[i]] = true;
end

-- for k, v in pairs(stringKeyMap) do 
--   print(k, v)
-- end

local random = tostring(math.random(1, maxRandom))
print(random);

local starttime = os.clock();
for i=1, testLoopCount, 1 do 
  for i=1, #numberList, 1 do 
    if numberList[i] == random then
      print("Find " .. random .. " with table's iterating.");
      break
    end
  end
end
print(os.clock() - starttime);

starttime = os.clock();
for i=1, testLoopCount, 1 do 
  if stringKeyMap[random] then 
    print("Find " .. random .. " by table key.");
  end
end
print(os.clock() - starttime);