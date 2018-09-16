list = nil
list = {next = list, value = 1}
list = {next = list, value = 2}
list = {next = list, value = 3}
list = {next = list, value = 4}
list = {next = list, value = 5}
local l = list
while l do 
    io.write(l.value, "->");
    l = l.next
end
io.write("nil\n")