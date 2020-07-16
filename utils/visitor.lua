----------------------------------------------------------------访问者----------------------------------------------------------------
--[==[
    抽象访问者
    Created on 2020-07-15 at 11:49:34
]==]
local IVisitor = {

}

--[==[
    具体行为，可带返回值
    Created on 2020-07-15 at 11:50:07
]==]
function IVisitor:visit(Platform)
    return nil
end

-- 继承省略
--[==[
    不同的行为：渠道
    Created on 2020-07-15 at 15:02:02
]==]
local ChannelVisitor = {

}
function ChannelVisitor:visit(Platform)
    -- 取Platform的各种数据，apiid等，可返回值
end
----------------------------------------------------------------结构---------------------------------------------------------------- 
--[==[
    抽象结构。可封装迭代器模式
    Created on 2020-07-15 at 11:47:14
]==]
local IPlatform = {

}

--[==[
    Lua不限制类型
    Created on 2020-07-15 at 11:50:43
]==]
function IPlatform:acceptVisitor()

end

function IPlatform:acceptChannelVisitor(ChannelVisitor)
    ChannelVisitor:visit(self);
end

-- 继承省略
local Android = {

}

local IOS = {

}

local Windows = {

}

_G.Platform = Android;

-- 实际调用参考
local ret = Platform:acceptChannelVisitor(ChannelVisitor);