local Animal = {age = 3, gender = "male", params = {}}    --定义一个Animal的表
function Animal:extend()   --定义表中的一个extend方法（继承机制的核心就是下面四行代码）
	local obj = obj or {} --if obj not nil return obj,else return {}
	setmetatable(obj, self)  --set self as obj's metatable 把Animal表自己作为元表放入obj表中
	self.__index = self     --索引__index是一个特殊的机制，只有设置了索引值，才能在子类调用父类方法时，能找到self(也就是Animal表)中的方法
	return obj  --返回带有元表的obj
end

function Animal:getAge()
  	return self.age
end
function Animal:getParams()
	return self.params
end

function Animal:run()  --定义父类的一个方法，作为动物，都可以跑的公共函数
	print("run is my gift~! : ".. tostring(self))
end
-----------------------------------------------------------------------------------
local Horse = Animal:extend() --获取带有元表的obj
Horse.age = 4
Horse.params = {}
function Horse:eat()   --子类的方法
	print("eat grass..."..tostring(self))
end
-----------------------------------------------------------------------------------
local Cat = Animal:extend()
Cat.age = 5
Cat.params = {}
function Cat:eat()
	print("eat fish..."..tostring(self))
end
 
-----------------------------------------------------------------------------------
print(Horse)
print(Cat)
Horse:run()
Cat:run()
Horse:eat()
Cat:eat()
print(Horse:getAge())
print(Cat:getAge())
print("local(): Horse.params = ", Horse.params);
print("local(): Cat.params = ", Cat.params);
print("local(): Horse:getParams() = ", Horse:getParams());
print("local(): Cat:getParams() = ", Cat:getParams());
