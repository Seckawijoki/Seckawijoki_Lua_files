print("Hello world!");
function fact(n)
  if n == 0 then
    return 1
  else 
    return n * fact(n-1)
  end
end
a=1
b=2
c={}
--[==[
print("Enter a number:");
a = io.read("*number");
c=a+c[c[i]]
print(fact(a))
--]==]

print(gcinfo());

local apiId = 300

function IsAndroidBlockark()
	return apiId == 303 or apiId == 310 or apiId == 399;
end

print(IsAndroidBlockark())

facebook = not IsAndroidBlockark()
print(facebook)
