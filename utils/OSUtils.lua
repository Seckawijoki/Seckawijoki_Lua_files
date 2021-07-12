--[==[
    
    Created on 2020-10-20 at 15:55:13
]==]
local CmdUtils = _G.CmdUtils
local ClassesCache = _G.ClassesCache
--------------------------------------------------------------------------------------
local ISystem = {

}
function ISystem:onRecycle()

end

function ISystem:getPath(szPath)
    return szPath;
end

function ISystem:deleteFile(szPath)
    os.remove(szPath)
end

function ISystem:deleteDirectory(szPath)
    os.remove(szPath)
end

--[==[
    复制文件
    @param #string szSrcFileName 源文件
    @param #string szDstFileName 目标文件
    @return #boolean
]==]
function ISystem:copy(szSrcFilename, szDstFilename)
    local fileSrc = io.open(szSrcFilename, "r")
    if not fileSrc then
        return false
    end
    local fileDst = io.open(szDstFilename, "w+b")
    if not fileDst then
        return false
    end
    local content = fileSrc:read("*all");
    fileDst:write(content)
    io.close(fileSrc)
    io.close(fileDst)
    return true
end
--------------------------------------------------------------------------------------
local Linux = {
    NAME = "Linux",
    FILE_SEPARATOR = "/",
}
ClassesCache:insertSuperClass(Linux, ISystem);
function Linux:getPath(szPath)
    return string.gsub(szPath, "\\", "/");
end

function Linux:deleteFile(szPath)
    local result = CmdUtils:postCommand("rm -f \"%s\"", szPath);
end

function Linux:deleteDirectory(szPath)

end

--[==[
    复制文件
    @param #string szSrcFileName 源文件
    @param #string szDstFileName 目标文件
    @return #boolean
]==]
function Linux:copy(szSrcFilename, szDstFilename)
    local result = CmdUtils:postCommand("cp \"%s\" \"%s\"", szSrcFilename, szDstFilename)
    return result == 0
end
--------------------------------------------------------------------------------------
local Windows = {
    NAME = "Windows",
    FILE_SEPARATOR = "\\",
}
ClassesCache:insertSuperClass(Windows, ISystem);

function Windows:getPath(szPath)
    return string.gsub(szPath, "/", "\\");
end

function Windows:deleteFile(szPath)
    local result = CmdUtils:postCommand("del \"%s\"", szPath);
    -- print("Windows:deleteFile(): result = ", result);
end

function Windows:deleteDirectory(szPath)

end

--[==[
    复制文件
    @param #string szSrcFileName 源文件
    @param #string szDstFileName 目标文件
    @return #boolean
]==]
function Windows:copy(szSrcFilename, szDstFilename)
    local result = CmdUtils:postCommand("copy \"%s\" \"%s\"", szSrcFilename, szDstFilename)
    return result == 0
end
--------------------------------------------------------------------------------------
local OSUtils = {
    CUR_OS = "",
    FILE_SEPARATOR = "",
}
_G.OSUtils = OSUtils;

local System = ISystem;
_G.System = System;

function OSUtils:isWindows()
    return System == Windows;
end

function OSUtils:isLinux()
    return System == Linux;
end

function OSUtils:init()
    local r1 = CmdUtils:execCommand("ver");
    local r2 = CmdUtils:execCommand("uNAME");
    -- print("OSUtils:init(): r1 = ", r1);
    -- print("OSUtils:init(): r2 = ", r2);
    -- print("OSUtils:init(): #r1 = ", #r1);
    if string.find(r1, Windows.NAME, 0, true) then
        System = Windows;
    elseif string.find(r2, Linux.NAME, 0, true) then
        System = Linux;
    end
    if System then
        self.CUR_OS = System.NAME;
        self.FILE_SEPARATOR = System.FILE_SEPARATOR;
    end
    _G.System = System;
end

OSUtils:init();