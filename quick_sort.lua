require "seckawijoki_lib"

comparator = ascend

function partition(array, left, right)
    if comparator == nil then comparator = ascend end
    -- print("partition(): left = " .. tostring(left) .. " | right = " .. tostring(right))
    if array == nil
    or left == nil or right == nil or left <= 0 or right > #array or left > right then 
        return array, nil 
    end
    pivot = array[left]
    while left < right do 
        compareResult = comparator(array[right], pivot)
        while compareResult and left < right do
            right = right - 1
            compareResult = comparator(array[right], pivot)
        end
        array[left] = array[right]
        compareResult = comparator(pivot, array[left])
        while compareResult and left < right do 
            left = left + 1
            compareResult = comparator(pivot, array[left])
        end
        array[right] = array[left]
    end
    array[left] = pivot
    printArray(array)
    return array, left
end


function quick_sort(array, left, right)
    -- print("quick_sort(): left = " .. tostring(left) .. " | right = " .. tostring(right))
    -- printArray(array)
    if left <= 0 or right > #array or left > right then
        return array
    end
    local middle
    array, middle = partition(array, left, right)
    -- print("quick_sort(): middle = " .. tostring(middle))
    if array == nil or type(array) ~= "table" or middle == nil or middle <= 0 or middle > #array then 
        return nil 
    end
    array = quick_sort(array, left, middle-1)
    array = quick_sort(array, middle+1, right)
    return array
end

array = {}
array = randomArray()
print(#array)
printArray(array)
array = quick_sort(array, 1, #array)
comparator = descend
array = quick_sort(array, 1, #array)
printArray(array)