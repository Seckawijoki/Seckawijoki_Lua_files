require "seckawijoki_lib"

comparator = ascend

function select_sort(array) 
    for i=1, #array do 
        local index = i
        local min = array[i]
        for j=i+1, #array do 
            if comparator(min, array[j]) then 
                index = j 
                min = array[j]
            end
        end
        array[i], array[index] = array[index], array[i]
        printArray(array)
    end
    return array
end

array = randomArray()
printArray(array)
array = select_sort(array)
printArray(array)
comparator = descend
array = select_sort(array)
printArray(array)