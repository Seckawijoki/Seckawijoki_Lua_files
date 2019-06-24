local option = 3
local flag = false
function add(a, b)
    return a, b 
end

if option == 3 and not flag == true and add then 
    print("if true")
end

if not option or not add then 
    print("if2 true")
end