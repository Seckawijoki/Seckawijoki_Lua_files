local ClassesCache = _G.ClassesCache
--------------------------------------------------------------------------------------
local ISystemCommands = {

}
function ISystemCommands:onRecycle()

end

function ISystemCommands:copy(szSrcPath, szDstPath)
end

function ISystemCommands:delete(szPath)
end

function ISystemCommands:mkdir(szPath)
end
--------------------------------------------------------------------------------------
local LinuxCommands = {
    NAME = "Linux",
}
ClassesCache:insertSuperClass(LinuxCommands, ISystemCommands);
--------------------------------------------------------------------------------------
local WindowsCommands = {
    NAME = "Windows",
}
ClassesCache:insertSuperClass(WindowsCommands, ISystemCommands);
function WindowsCommands:copyFile(szSrcPath, szDstPath)
    local szCommandFormat = 'copy "%s" "%s"'
    local szCommand = szCommandFormat:format(szSrcPath, szDstPath);
    return szCommand
end

--[==[
    注意：与一般的copy指令参数用法不同
    例子：
        robocopy "test" "test2" settings.gradle /copy:dat /np /nfl /ndl /njh /njs
    @param #string szSrcDirPath 源文件的文件夹路径
    @param #string szDstDirPath 目标文件夹路径
    @param #string szFilename 目标文件名
    Created on 2021-07-12 at 16:23:27
]==]
function WindowsCommands:copyFileWithTimestamp(szSrcDirPath, szDstDirPath, szFilename)
    local szCommandFormat = [[robocopy "%s" "%s" "%s" /copy:dat /np /nfl /ndl /njh /njs"]]
    local szCommand = szCommandFormat:format(szSrcDirPath, szDstDirPath, szFilename);
    return szCommand
end

function WindowsCommands:copyDir(szSrcPath, szDstPath)
    local szCommandFormat = [[echo a | xcopy /s /e /a /c /q "%s\*" "%s\"]]
    local szCommand = szCommandFormat:format(szSrcPath, szDstPath);
    return szCommand
end

--[==[
    带时间戳拷贝文件夹。无需提前创建目标文件夹
    例子：
        robocopy "test" "test2" *.* /s /copy:dat /dcopy:dat /np /nfl /ndl
    Created on 2021-07-12 at 17:38:23
]==]
function WindowsCommands:copyDirWithTimestamp(szSrcPath, szDstPath)
    local szCommandFormat = [[robocopy "%s" "%s" *.* /s /copy:dat /dcopy:dat /np /nfl /ndl"]]
    local szCommand = szCommandFormat:format(szSrcPath, szDstPath);
    return szCommand
end


--[==[
    残缺式拷贝时间戳。
    注意：复制文件夹和文件的修改时间。复制文件夹的创建时间。源文件相对于目标文件仅有修改时间发生变动时，才拷贝创建时间。
    推荐使用带/copy:dat /dcopy:dat选项的一次性拷贝
    例子：
        robocopy "test" "test2" *.* /s /copy:t /dcopy:t /np /nfl /ndl
    Created on 2021-07-12 at 17:38:54
]==]
function WindowsCommands:copyTimestamp(szSrcPath, szDstPath)
    local szCommandFormat = [[robocopy "%s" "%s" *.* /s /copy:t /dcopy:t /np /nfl /ndl"]]
    local szCommand = szCommandFormat:format(szSrcPath, szDstPath);
    return szCommand
end

function WindowsCommands:delete(szPath)
    local szCommandFormat = 'del "%s"'
    local szCommand = szCommandFormat:format(szPath);
    return szCommand
end

function WindowsCommands:mkdir(szPath)
    local szCommandFormat = 'if not exist "%s" mkdir "%s"'
    local szCommand = szCommandFormat:format(szPath, szPath);
    return szCommand
end

function WindowsCommands:removeDir(szPath)
    local szCommandFormat = 'if exist "%s" rd /q /s "%s"'
    local szCommand = szCommandFormat:format(szPath, szPath);
    return szCommand
end
function WindowsCommands:moveFile(szSrcPath, szDstPath)
    local szCommandFormat = 'move "%s" "%s"'
    local szCommand = szCommandFormat:format(szSrcPath, szDstPath);
    return szCommand
end

function WindowsCommands:echo(sz)
    local szCommandFormat = 'echo %s'
    local szCommand = szCommandFormat:format(sz);
    return szCommand
end
--------------------------------------------------------------------------------------
local OSCommandUtils = {
}
_G.OSCommandUtils = OSCommandUtils;

local SystemCommands = ISystemCommands;
_G.SystemCommands = SystemCommands;

function OSCommandUtils:init()
    if OSUtils:isWindows() then
        SystemCommands = WindowsCommands;
    elseif OSUtils:isLinux() then
        SystemCommands = LinuxCommands;
    end
    _G.SystemCommands = SystemCommands;
end

OSCommandUtils:init();