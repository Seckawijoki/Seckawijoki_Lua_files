local DecoratorUtils = {

}
_G.DecoratorUtils = DecoratorUtils;
function DecoratorUtils:decorate(class, clsInnerDecorator)
	-- local print = Android:Localize(Android.SITUATION.QRCODE_SCANNER);
	-- rawset(class, "m_clsInnerDecorator", clsInnerDecorator)
	class.m_clsInnerDecorator = clsInnerDecorator
	-- print("DecoratorUtils:decorate(): tostring(class) = ", tostring(class));
	-- print("DecoratorUtils:decorate(): tostring(clsInnerDecorator) = ", tostring(clsInnerDecorator));
end

function DecoratorUtils:unwrap(class)
	-- local clsInnerDecorator = rawget(class, "m_clsInnerDecorator")
	if not class then return nil end
	local clsInnerDecorator = class.m_clsInnerDecorator
	-- rawset(class, "m_clsInnerDecorator", nil)
	class.m_clsInnerDecorator = nil
	class:recycle();
	return clsInnerDecorator;
end

function DecoratorUtils:recycleAll(class)
	while class do 
		class = self:unwrap(class)
	end
	return nil
end

function DecoratorUtils:hasInner(class)
	return class ~= nil and class.m_clsInnerDecorator ~= nil;
end