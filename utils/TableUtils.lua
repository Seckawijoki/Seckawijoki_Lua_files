function appendTable(...)
    local aTables = {...}
    local totalTable = {}
    for k, v in ipairs(aTables) do 
        if type(v) == "table" then 
            for i=1, #v do 
                totalTable[#totalTable+1] = v[i]
            end
        end
    end
    return totalTable
end

function printTable(table)
    for k, v in pairs(table) do 
        print(k, v)
    end
end