--[==[
    文件工具类
    Created on 2020-10-19 at 15:32:46
]==]
local lfs = _G.lfs
local CmdUtils = _G.CmdUtils
local System = _G.System

local FileUtils = {
    FILE_SEPERATOR = System.FILE_SEPERATOR,
}
_G.FileUtils = FileUtils;

--[==[
    复制文件
    @param #string szSrcPath 源文件
    @param #string szDstPath 目标文件
    @return #boolean
]==]
function FileUtils:copy(szSrcPath, szDstPath)
    local fileSrc = io.open(szSrcPath, "rb+")
    if not fileSrc then
        print("FileUtils:copy(): src file not found : " + szSrcPath);
        return false
    end
    local fileDst = io.open(szDstPath, "wb+")
    if not fileDst then
        print("FileUtils:copy(): target path cannot be copied to : " + szDstPath);
        return false
    end
    local content = fileSrc:read("*all");
    fileDst:write(content)
    io.close(fileSrc)
    io.close(fileDst)
    return true
    -- return System:copy(szSrcPath, szDstPath);
end

--[==[
    读文件
    @param #string szPath 文件路径
    @return #string
    Created on 2020-10-20 at 11:21:28
]==]
function FileUtils:read(szPath)
    local file = io.open(szPath, "r");
    if not file then
        -- assert(false);
        return "";
    end
    local content = file:read("*all");
    io.close(file);
    return content;
end

--[==[
    写文件
    @param #string szPath 文件路径
    @return #boolean
    Created on 2020-10-20 at 11:21:28
]==]
function FileUtils:write(szPath, szContent)
    local file = io.open(szPath, "w+");
    if not file then
        -- assert(false);
        return false;
    end
    file:write(szContent);
    io.close(file);
    return true;
end

--[==[
    删除文件
    @param #string szPath 文件路径
    @return #boolean
    Created on 2020-10-20 at 11:21:28
]==]
function FileUtils:delete(szPath)
    -- print("FileUtils:delete(): szPath = " + szPath);
    local attr = lfs.attributes(szPath)
    if attr then
        -- print("FileUtils:delete(): attr.mode = " + attr.mode);
        if attr.mode == "directory" then
            System:deleteDirectory(szPath);
        elseif attr.mode == "file" then
            System:deleteFile(szPath);
        end
    end
end

--[==[
    删除文件
    @param #string szPath 文件路径
    @return #boolean
    Created on 2020-10-20 at 11:21:28
]==]
function FileUtils:delete(szPath)
    -- print("FileUtils:delete(): szPath = " + szPath);
    local attr = lfs.attributes(szPath)
    if attr then
        -- print("FileUtils:delete(): attr.mode = " + attr.mode);
        if attr.mode == "directory" then
            System:deleteDirectory(szPath);
        elseif attr.mode == "file" then
            System:deleteFile(szPath);
        end
    end
end

--[==[
    文件是否存在
    @param #string szPath 文件路径
    @return #boolean
    Created on 2020-10-20 at 11:21:28
]==]
function FileUtils:isFileExist(szPath)
    local file = io.open(szPath, "r");
    if not file then
        return false;
    end
    io.close(file);
    return true;
end

--[==[
    文件夹是否存在
    @param #string szPath 文件路径
    @return #boolean
    Created on 2020-10-20 at 11:21:28
]==]
function FileUtils:isDirectoryExist(szPath)
    local szCommandFormat = "cd \"%s\""
    local result = CmdUtils:postCommand(szCommandFormat, szPath)
    -- print("FileUtils:isDirectoryExist(): result = ", result);
    return result and result == 0;
end

--[==[
    创建文件夹
    @param #string szPath 文件路径
    @return #boolean
    Created on 2020-10-20 at 11:21:28
]==]
function FileUtils:mkdir(szPath)
    -- print("FileUtils:mkdir(): szPath = " + szPath);
    if not szPath then
        return false
    end
    if szPath == "" then
        return false
    end
    local FILE_SEPERATOR = self.FILE_SEPERATOR;
    local index = szPath:find(FILE_SEPERATOR, 1, true)
    -- print("FileUtils:mkdir(): index = " + index);
    if not index then
        if not self:isDirectoryExist(szPath) then
            local result = CmdUtils:postCommand("mkdir \"%s\"", szPath);
            -- print("FileUtils:mkdir(): 1 result = " + result);
            result = result and result == 0
            if not result then
                -- print("FileUtils:mkdir(): 1 failed : " + szPath);
            end
            return result
        end
    end
    local lastIndex
    local szDirectoryPath
    local hasCreated = false
    while index and index > 0 and index <= #szPath do
        if index then
            szDirectoryPath = szPath:sub(1, index);
            -- print("FileUtils:mkdir(): szDirectoryPath = " + szDirectoryPath);
            if not self:isDirectoryExist(szDirectoryPath) then
                -- print("FileUtils:mkdir(): mkdir : " + szDirectoryPath);
                local result = CmdUtils:postCommand("mkdir \"%s\"", szDirectoryPath);
                -- print("FileUtils:mkdir(): 2 result = " + result);
                hasCreated = result and result == 0
                if not hasCreated then
                    -- print("FileUtils:mkdir(): 2 failed : " + szPath);
                end
            end
        end
        lastIndex = index
        index = szPath:find(FILE_SEPERATOR, lastIndex + 1, true)
    end
    return hasCreated;
end

--[==[
    获取文件大小
    @param #string szPath 文件路径
    @return #number
    Created on 2020-10-20 at 11:21:28
]==]
function FileUtils:getFileSize(szPath)
    local file = io.open(szPath, "r");
    if not file then
        assert(false);
        return 0;
    end
    local size  = file:seek("end");
    io.close(file)
    return size;
end

--[==[
    获取文件大小
    @param #string szPath 文件路径
    @return #string
    Created on 2020-10-20 at 11:21:28
]==]
function FileUtils:getFilename(szPath)
    if not szPath then
        return "";
    end
    local FILE_SEPERATOR = self.FILE_SEPERATOR;
    local index = szPath:find(FILE_SEPERATOR, 0, true);
    local previousIndex;
    while index do
        previousIndex = index;
        index = szPath:find(FILE_SEPERATOR, 0, true);
    end
    local szFilename
    if previousIndex then
        szFilename = szPath:sub(previousIndex + 1);
    else
        szFilename = ""
    end
    return szFilename;
end

--[==[
    获取文件名后缀
    @param #string szPath 文件路径
    @return #string
    Created on 2020-10-20 at 11:21:28
]==]
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

function FileUtils:getConcisePath(szPath)
    if not szPath then
        return "";
    end
    szPath = szPath:gsub("[^%.]%.%" + System.FILE_SEPERATOR, "");
    szPath = szPath:gsub("%" + System.FILE_SEPERATOR + "%.[^%.]", "");
    local left, right = szPath:find("..", 0, true);
    print("FileUtils:getConcisePath(): szPath = " + szPath);
    print("FileUtils:getConcisePath(): #szPath = " + #szPath);
    print("FileUtils:getConcisePath(): left = " + left);
    print("FileUtils:getConcisePath(): right = " + right);
    if not left or left <= 2 then
        return szPath
    end
    local before = szPath:find("%" + System.FILE_SEPERATOR, 0, left-1);
    print("FileUtils:getConcisePath(): before = " + before);
    local szConcisePath = szPath:sub(1, before) + szPath:sub(right+1);
    print("FileUtils:getConcisePath(): szConcisePath = " + szConcisePath);
    return szConcisePath;
end