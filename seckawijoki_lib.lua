function randomArray(left, right, count) 
    if left == nil then left = 10 end
    if right == nil then right  = 99 end
    if count == nil then count = 10 end
    local array = {}
    for i = 1, count do 
        array[i] = math.random(left, right)
    end
    for i = 1, count do 
        array[i] = math.random(left, right)
    end
    return array
end

function printArray(a)
    if a == nil then
        io.write("a is nil\n")
        return
    end
    if type(a) ~= "table" then 
        io.write("a is not a table\n")
        return
    end
    for i, v in pairs(a) do 
        io.write(v, " ")
    end
    io.write("\n")
end

function printMatrix(matrix)
    for i1, v1 in pairs(matrix) do 
        for i2, v2 in pairs(matrix[i1]) do 
            io.write(v2, " ")
        end
        io.write("\n")
    end
end


function descend(x, y)
    if x > y then 
        return false,x, y
    else 
        return true,y, x
    end
end

function ascend(x, y)
    if x < y then 
        return false,x, y
    else
        return true,y, x
    end
end