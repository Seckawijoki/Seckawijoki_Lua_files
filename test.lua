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

local szPath = "F:\\Lua_files\\test.lua"
local szFilename = szPath:match( "([^\\]+)$" )
-- local iLastCharacterIndex = #szPath - #szFilename - 1;
-- local szLastCharacter = szPath:sub(iLastCharacterIndex, iLastCharacterIndex);
-- local iCharacterValue = string.byte(szLastCharacter);

print("szFilename = " + szFilename);
-- print("szLastCharacter = " + szLastCharacter);
-- print("iCharacterValue = " + iCharacterValue);