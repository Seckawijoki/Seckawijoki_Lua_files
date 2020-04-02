require("utils/ClassesCache")
--------------------------------------------------------DecoratorFactory start----------------------------------------------------------
local DecoratorFactory = {

}
_G.DecoratorFactory = DecoratorFactory;

function DecoratorFactory:new(szClassName, clsInnerDecorator)
	-- local print = Android:Localize(Android.SITUATION.QRCODE_SCANNER);
	print("DecoratorFactory:new(): szClassName = ", szClassName);
	local class, isCache = ClassesCache:obtain(szClassName);
	print("DecoratorFactory:new(): tostring(class) = ", tostring(class));
	print("DecoratorFactory:new(): isCache = ", isCache);
	self:decorate(class, clsInnerDecorator)
	return class, isCache
end

function DecoratorFactory:decorate(class, clsInnerDecorator)
	-- local print = Android:Localize(Android.SITUATION.QRCODE_SCANNER);
	-- rawset(class, "m_clsInnerDecorator", clsInnerDecorator)
	class.m_clsInnerDecorator = clsInnerDecorator
	-- print("DecoratorFactory:decorate(): tostring(class) = ", tostring(class));
	-- print("DecoratorFactory:decorate(): tostring(clsInnerDecorator) = ", tostring(clsInnerDecorator));
end

function DecoratorFactory:unwrap(class)
	-- local clsInnerDecorator = rawget(class, "m_clsInnerDecorator")
	local clsInnerDecorator = class.m_clsInnerDecorator
	-- rawset(class, "m_clsInnerDecorator", nil)
	class.m_clsInnerDecorator = nil
	class:recycle();
	return clsInnerDecorator;
end

function DecoratorFactory:recycleAll(class)
	while class do 
		class = self:unwrap(class)
	end
	return nil
end

function DecoratorFactory:hasInner(class)
	return class ~= nil and class.m_clsInnerDecorator ~= nil;
end
--------------------------------------------------------DecoratorFactory end----------------------------------------------------------