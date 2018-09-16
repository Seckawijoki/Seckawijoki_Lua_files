require "seckawijoki_lib"

local comparator = ascend
function bubble_sort(array)
    if comparator == nil then comparator = ascend end
    for i=1, #array do 
        for j=i+1, #array do 
            ignored, array[i], array[j] = comparator(array[i], array[j])
        end
        printArray(array)
    end
    return array
end

array = randomArray(1,1000, 5)
print(#array)
printArray(array)
array = bubble_sort(array)
printArray(array)
comparator = descend
array = bubble_sort(array)
printArray(array)