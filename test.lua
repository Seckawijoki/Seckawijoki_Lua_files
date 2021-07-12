-- require("deep_copy_table");
require "utils/include"

local t = {

}

-- t['下载运营配置'] = function(self)
--   print("下载运营配置(): 123");
-- end

-- t['下载运营配置'](t)


-- local s = "1234567890";

-- local l, r, ret = string.find(s, "456", 1, true);
-- print(l, r, ret);

-- local sz = "	class  HttpReportMgr : //tolua_exports"
-- local KEY_WORD = "//tolua_exports";
-- local left = sz:find(KEY_WORD, 1, true);

-- local words = split(sz);
-- print("word(): #words = " + #words);
-- for i=1, #words do 
--     local word = words[i];
--     print("word(): word = " + word);
--     if (not word:find("public", 1, true)) 
--     and (not word:find("class", 1, true)) 
--     and (not word:find("[:<>{}+]", 1, false)) 
--     and word:match("[%a%d_]+") then
--         print("ok(): word = " + word);
--     end
-- end

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

function gcsth()
    local tab = { _name = "default" }
    setmetatable(tab, {
        __gc = function ( t )
          print("__gc, _name:", t._name)
        end
    })
end
gcsth()

local tt = {
    name = "123",
}
printTable(tt);
-- collectgarbage("collect") -- 强制垃圾回收

-- test


local function testVector3()
    -- local v1 = Vector3(1, 2, 3);
    -- local v2 = Vector3(4, 5, 6);
    -- local v3 = v1 + v2;
    -- local v4 = v1 + 10;
    -- local v5 = v1 - v2;
    -- local v6 = v1 - 10;
    -- local v7 = v1 * 10;
    -- local abs = v1 * v2;
    -- local v8 = v1 / 10;
    -- print("testVector3(): v1 = " + v1);
    -- print("testVector3(): v2 = " + v2);
    -- print("testVector3(): v3 = " + v3);
    -- print("testVector3(): v4 = " + v4);
    -- print("testVector3(): v5 = " + v5);
    -- print("testVector3(): v6 = " + v6);
    -- print("testVector3(): v7 = " + v7);
    -- print("testVector3(): abs = " + abs);
    -- print("testVector3(): v8 = " + v8);
end

local function testQuaternion()
    -- local q1 = Quaternion(1, 2, 3);
    -- local q2 = Quaternion(4, 5, 6);
    -- local q3 = q1 + q2;
    -- local q4 = q1 + 10;
    -- local q5 = q1 - q2;
    -- local q6 = q1 - 10;
    -- local q7 = q1 * 10;
    -- local abs = q1 * q2;
    -- local q8 = q1 / 10;
    -- print("testQuaternion(): q1 = " + q1);
    -- print("testQuaternion(): q2 = " + q2);
    -- print("testQuaternion(): q3 = " + q3);
    -- print("testQuaternion(): q4 = " + q4);
    -- print("testQuaternion(): q5 = " + q5);
    -- print("testQuaternion(): q6 = " + q6);
    -- print("testQuaternion(): q7 = " + q7);
    -- print("testQuaternion(): abs = " + abs);
    -- print("testQuaternion(): q8 = " + q8);
end

local szPath = [[F:\Lua_files\utils\override_string___add.lua]]
local szParentPath = FileUtils:getParentPath(szPath)
print("szParentPath(): szParentPath = " + szParentPath);
