require "lfs"

function getFileName(path)
    local idx = str:match(".+()%.%w+$")
    if idx then
        return str:sub(1, idx-1)
    else
        return str
    end
end

function getExtension(str)
    return str:match(".+%.(%w+)$")
end

function printFileAttribute(filepath)
    if not filepath then return end
    local attr = lfs.attributes(filepath)
    print(filepath)
    for k, v in pairs(attr) do 
        print(k,v)
    end
end

function iterateFiles(rootpath)
    for entry in lfs.dir(rootpath) do 
        if entry ~= '.' and entry ~= '..' then 
            -- print("entry = " .. entry)
            local filepath = rootpath .. '\\' .. entry
            local attr = lfs.attributes(filepath)
            -- local filename = getFileName(entry)
            local filename = entry
            -- printFileAttribute(filepath)
            if not attr.mode == 'directory' then 
                local postfix = getExtension(entry)
                print(filename .. '\t' .. attr.mode .. '\t' .. postfix)
            else
                print(filename .. '\t' .. attr.mode)
                iterateFiles(filepath)
            end
        end
    end
end

iterateFiles("..\\Batch_files\\")