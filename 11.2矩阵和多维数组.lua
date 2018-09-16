function printMatrix(matrix)
    for i1, v1 in pairs(matrix) do 
        for i2, v2 in pairs(matrix[i1]) do 
            io.write(v2, " ")
        end
        io.write("\n")
    end
end

function printArray(a)
    for i, v in pairs(a) do 
        io.write(v, " ")
    end
    print("\r")
end

n = 5
m = 3
mt = {}
for i=1, n do 
    mt[i] = {}
    for j=1, m do 
        mt[i][j] = "(" .. tostring(i) .. "," .. tostring(j) .. ")"
    end
end
printMatrix(mt)

mt = {}
for i=1, n do 
    for j=1, m do 
        mt[i*m + j] = "i=" .. tostring(i) .. " | j=" .. tostring(j)
    end
end
printArray(mt)