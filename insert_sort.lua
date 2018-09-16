require "seckawijoki_lib"

comparator = ascend

function insert_sort(array)
    for i=1, #array do 
        local key = array[i]
        j = i-1
        while j>=1 and comparator(array[j], key) do 
            array[j+1] = array[j]
            j = j-1
        end
        array[j+1] = key
        printArray(array)
    end
    return array
end

array = randomArray()
printArray(array)
array = insert_sort(array)
printArray(array)
comparator = descend
array = insert_sort(array)
printArray(array)
