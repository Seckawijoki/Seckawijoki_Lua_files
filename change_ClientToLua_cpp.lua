require "lfs"

local function changeLine(szFileInput, szKeyWord, szAppendant)
    print("changeLine(): szFileInput = ", szFileInput);
    print("changeLine(): szKeyWord = ", szKeyWord);
    print("changeLine(): szAppendant = ", szAppendant);
    local io = _G.io
    local iChangeCount = 0
    local szFileOutput = "lua_written_file.cpp"

    local fileInput = io.open(szFileInput, "r")
    if fileInput == nil then 
        error("input file " .. szFileInput .. " does not exist.")
        return false
    end
    io.input(fileInput)
    fileInput:seek("set")

    local fileOutput = io.open(szFileOutput, "w+")
    if fileOutput == nil then 
        error("output file " .. szFileOutput .. " does not exist.")
        return false
    end
    io.output(fileOutput)

    local szLine
    while true do 
        szLine = io.read("*l")
        -- print("changeLine(): szLine = ", szLine);
        if not szLine then break end
        local _, iKeyWordEndIndex = string.find(szLine, szKeyWord, 0, true)
        -- print("changeLine(): _ = ", _);
        -- print("changeLine(): iKeyWordEndIndex = ", iKeyWordEndIndex);
        if _ and iKeyWordEndIndex then 
            local iRightBracketAndSemicolonStartIndex, iRightBracketAndSemicolonEndIndex
            iRightBracketAndSemicolonStartIndex, iRightBracketAndSemicolonEndIndex = string.find(szLine, ");", iKeyWordEndIndex, true)
            if iRightBracketAndSemicolonStartIndex and iRightBracketAndSemicolonEndIndex and iRightBracketAndSemicolonStartIndex >= 1 and iRightBracketAndSemicolonEndIndex >= 1 then
                iChangeCount = iChangeCount + 1
                local szNewLine = string.sub(szLine, 0, iRightBracketAndSemicolonStartIndex-1)
                szNewLine = szNewLine .. szAppendant
                szNewLine = szNewLine .. string.sub(szLine, iRightBracketAndSemicolonEndIndex-1)
                szNewLine = szNewLine .. "\n"
                io.write(szNewLine)
            end
        else
            io.write(szLine)
            io.write("\n")
        end
    end

    io.close(fileInput)
    io.close(fileOutput)
    print("changeLine(): iChangeCount = ", iChangeCount);

    return true
end

changeLine("ClientToLua.cpp", "tolua_pushstring", ",__FILE__,__LINE__")