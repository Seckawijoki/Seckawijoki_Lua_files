--[==[
    
    Created on 2020-10-19 at 18:15:29
]==]

local CmdUtils = {

}
_G.CmdUtils = CmdUtils

--[==[ 
    执行命令行，获取系统返回的结果
    @return 系统返回结果
    Created on 2020-10-15 at 17:01:44
]==]
function CmdUtils:postCommand(szCommand, ...)
    local aParams = {...}
    if #aParams > 0 then
        local szFormat = szCommand
        szCommand = szFormat:format(...);
    end
    -- print("CmdUtils:postCommand(): szCommand = ", szCommand);
    local result = os.execute(szCommand)
    -- print("CmdUtils:postCommand(): result = " + result + " | szCommand = " + szCommand);
    return result
end

--[==[
    执行命令行，获取命令行输出的信息
    @return #string 终端输出的信息
    Created on 2020-10-15 at 17:01:44
]==]
function CmdUtils:execCommand(szCommand, ...)
    local file = self:execCommandForFile(szCommand, ...)
    if not file then
        assert(false);
        return ""
    end
    local output = file:read("*all");
    io.close(file);
    return output;
end

--[==[
    执行命令行，获取保存命令行输出的信息的文件
    @return #table 终端输出的信息保存的文件
    Created on 2020-10-15 at 17:01:44
]==]
function CmdUtils:execCommandForFile(szCommand, ...)
    local aParams = {...}
    if #aParams > 0 then
        local szFormat = szCommand
        szCommand = szFormat:format(...);
    end
    -- print("CmdUtils:execCommandForFile(): szCommand = " + szCommand);
    return io.popen(szCommand, "r");
end

--[==[
    获取改文件上一次提交的svn版本号信息
    @return #number 该文件本地的svn版本号
    Created on 2020-10-20 at 21:29:58
]==]
function CmdUtils:getSvnLastChangedRevision(szPath)
    local file = self:execCommandForFile("svn info \"%s\"", szPath)
    if not file then
        return nil
    end
    local szLine = file:read("*l")
    local KEYWORD = "Last Changed Rev: "
    local KEYWORD_CN = "最后修改的版本: "
    local iSvnRevision = nil;
    while szLine do
        local left, right = szLine:find(KEYWORD, 1, true)
        if not (left and right) then
            left, right = szLine:find(KEYWORD_CN, 1, true)
        end
        if left and right then
            iSvnRevision = tonumber(szLine:sub(right+1))
            break
        end
        szLine = file:read("*l")
    end
    io.close(file);
    -- print("CmdUtils:getSvnLastChangedRevision(): iSvnRevision = " + iSvnRevision + " | szPath = " + szPath);
    return iSvnRevision
end

--[==[
    判断是否是svn文件
    @return #boolean 是svn文件
    Created on 2020-10-20 at 21:29:58
]==]
function CmdUtils:isSvnFile(szPath)
    return self:getSvnLastChangedRevision(szPath) ~= nil
end