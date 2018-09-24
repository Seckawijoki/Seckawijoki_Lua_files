reserved0 = {
    ["while"] = true,
    ["end"] = true,
    ["function"] = true,
    ["local"] = true
}

for w in allwords() do 
    if reserved0[w] then 
        print(reserved0[w])
    end
end