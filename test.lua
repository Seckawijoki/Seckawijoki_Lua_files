-- require("deep_copy_table");
require("utils/Android")
require("utils/override_string___add")
require("utils/override_table___tostring")
require("utils/ResponsibilityChainPattern")

local t = {

}

-- t['下载运营配置'] = function(self)
--   print("下载运营配置(): 123");
-- end

-- t['下载运营配置'](t)


-- local s = "1234567890";

-- local l, r, ret = string.find(s, "456", 1, true);
-- print(l, r, ret);

local FileUtils = {}
function FileUtils:getPostfix(szPath)
    if not szPath then
        return "";
    end
    local index = szPath:find(".", 1, true);
    local previousIndex;
    while index do
        previousIndex = index;
        index = szPath:find(".", index + 1, true);
    end
    local szPostfix
    if previousIndex then
        szPostfix = szPath:sub(previousIndex + 1);
    else
        szPostfix = "";
    end
    return szPostfix;
    -- return szPath:gsub('%.[^%.]+$', '');
end

function trim(sz)
	if not sz then return "" end
	local after = {}
	for i=1, #sz do 
	  local c = sz:sub(i, i)
	  -- print(char)
	  if c ~= ' ' then
		after[#after + 1] = c
	  end
	end
	return table.concat(after)
end

function split(sz)
    local words = {}
    local start = 1;
	for i=1, #sz do 
        local c = sz:sub(i, i)
        -- print(char)
        if c == ' ' then
            if start ~= i then
                words[#words + 1] = sz:sub(start, i - 1)
            end
            start = i + 1
        end
	end
    words[#words + 1] = sz:sub(start)
    return words
end

local sz = "	class  HttpReportMgr : //tolua_exports"
local KEY_WORD = "//tolua_exports";
local left = sz:find(KEY_WORD, 1, true);

local words = split(sz);
print("word(): #words = " + #words);
for i=1, #words do 
    local word = words[i];
    print("word(): word = " + word);
    if (not word:find("public", 1, true)) 
    and (not word:find("class", 1, true)) 
    and (not word:find("[:<>{}+]", 1, false)) 
    and word:match("[%a%d_]+") then
        print("ok(): word = " + word);
    end
end

-- if left and left > 0 then
--     sz = sz:sub(1, left - 1);
--     -- print("left(): sz = " + sz);
--     local right
--     left, right = sz:find("class")
--     if right and right > 0 then
--         sz = sz:sub(right + 1);
--         -- print("right(): sz = " + sz);
--     end
-- end
-- local iLastCharacterIndex = #szPath - #szFilename - 1;
-- local szLastCharacter = szPath:sub(iLastCharacterIndex, iLastCharacterIndex);
-- local iCharacterValue = string.byte(szLastCharacter);

-- print("szClassName = " + szClassName);
-- print("szLastCharacter = " + szLastCharacter);
-- print("iCharacterValue = " + iCharacterValue);

-- local tab = { _name = "default" }
-- setmetatable(tab, {
--     __gc = function ( t )
--       print("__gc, _name:", t._name)
--     end
--   })
-- collectgarbage("collect") -- 强制垃圾回收