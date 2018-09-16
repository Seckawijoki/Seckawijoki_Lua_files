function printArray(a)
    for i, v in pairs(a) do 
        io.write(v, " ")
    end
    print("\r")
end

a={}
for i=1, 1000 do 
    a[i] = i
end
printArray(a)

a = {}
for i=-5, 5 do 
    a[i] = i
end
printArray(a)

squares = {1,4,9,16,25,36,49,64,81}
printArray(squares)