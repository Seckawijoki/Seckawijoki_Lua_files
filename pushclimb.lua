--[[
    说明：
    @field 大写驼峰：全局类、本地类、全局函数、本地函数
    @field 大写下划线：常量
    @field 小写驼峰：本地变量
    @field 表内小写驼峰：成员变量、成员函数

    玩家数据使用本地
    方块相关使用类
]]

-----------------------------------------------------------------开发者工具类-----------------------------------------------------------------
local UI = class.UI.new()
local Chat = class.Chat.new()
local Game = class.Game.new()
local Team = class.Team.new()
local Actor = class.Actor.new()
local World = class.World.new()
local Block = class.Block.new()
local Player = class.Player.new()
local GameRule = class.GameRule.new()
local Creature = class.Creature.new()
local Backpack = class.Backpack.new()
local Spawnport = class.Spawnport.new()
_G.Trigger = class.Trigger.new()
local TriggerBlock = Trigger.Block

--[[
    缺少接口：
    1.计算玩家到方块的距离
    2.锁定某几个方向的移动
    3.判断鼠标右键是否处于点击状态
    4.停止挖掘
    5.event_block_actorwalking判断玩家是否行走
]]

-----------------------------------------------------------------方块和物品常量-----------------------------------------------------------------
local BLOCK_NORMAL = 504 -- 花纹岩石砖，普通移动
local BLOCK_INMOVABLE = 124 -- 硫磺岩，不可移动
--[[
    3.	大型方块：
    相连的同颜色的方块视为一个整体，推拉操作、坍塌掉落时整体进行移动。推拉时每次可被移动一格
]]
local BLOCK_PURPLE_FLUORESCENCE = 446  -- 紫荧矿石
local BLOCK_STAR_COPPER = 445  -- 星铜矿石
--[[
    4.	裂纹方块：
    站立在裂纹方块上时，持续减少方块耐久度，离开方块顶面时停止破坏方块、恢复耐久度
]]
local BLOCK_FRAGILE = 505  -- 岩石块
--[[
    5.	陷阱方块：
        不可被移动。站在上面一秒后触发陷阱，一秒后收回。在陷阱触发期间停留在方块上，判定为死亡。
        通过摆放、推、拉方块等形式，在陷阱上覆盖其他方块时可破坏陷阱。
        陷阱方块只会出现在不可动方块上面。
    缺失的接口：
        动态通电
        攻击力修改
]]
local BLOCK_TRAP = 721 -- 地刺陷阱
local BLOCK_AIR = 0 -- 空气
local BLOCK_STAR = 997 -- 闪星方块
local ITEM_SELF_DEFINED_VIEW = 11071 -- 自定义视角
local BLOCK_AIR_WALL = 1001 -- 空气墙方块
local BLOCK_PUMPKIN_LAMP = 816 -- 方南瓜灯
local BLOCK_FLUORESCENCE = 1070 -- 荧光方块
local ITEM_TORCH = 1046 -- 火把
local BLOCK_TORCH = 817 -- 火把
local BLOCK_MARK = 919 -- 红色战旗
-- local BLOCK_CLASSICAL_STREET_LAMP = 899 -- 古典路灯
-- local BLOCK_LANTERN = 898 -- 灯笼
--[[
    测试方块触发事件
]]
local TRIGGERED_BLOCKS = {
    BLOCK_NORMAL,  -- 花纹岩石砖
    BLOCK_INMOVABLE,  -- 硫磺岩
    BLOCK_PURPLE_FLUORESCENCE,  -- 紫荧矿石
    BLOCK_STAR_COPPER,  -- 星铜矿石
    BLOCK_FRAGILE,  -- 岩石块
    BLOCK_TRAP, 
} 

local MOVABLE_BLOCKS = {
    BLOCK_NORMAL,  -- 花纹岩石砖
    BLOCK_PURPLE_FLUORESCENCE,  -- 紫荧矿石
    BLOCK_STAR_COPPER,  -- 星铜矿石
    BLOCK_FRAGILE,  -- 岩石块
} 

local LARGE_BLOCKS = {
    BLOCK_PURPLE_FLUORESCENCE,  -- 紫荧矿石
    BLOCK_STAR_COPPER,  -- 星铜矿石
} 
-----------------------------------------------------------------Lua全局-----------------------------------------------------------------
local table = _G.table
local math = _G.math
local unpack = _G.unpack

-----------------------------------------------------------------开发者全局-----------------------------------------------------------------
local ErrorCode = _G.ErrorCode

-----------------------------------------------------------------自定义全局-----------------------------------------------------------------
local MAX_INTEGER = 3524635674574
function math.bunch_calculate(funcMath, ...)
    if not funcMath or type(funcMath) ~= "function" then return ... end
    local before = {...}
    local after = {}
    for i=1, #before do 
        afters[#afters + 1] = funcMath(before[i])
    end
    return unpack(after, 1, #after)
end
function math.bunch_floor(...)
    return math.bunch_calculate(math.floor, ...)
end
--[[
    @Deprecated
]]
local squareRootOfThree = math.sqrt(3) -- 根号3

-----------------------------------------------------------------游戏功能变量与常量-----------------------------------------------------------------
--[[
    仅赋值一次
]]
local myUin --玩家uin
--[[
    实时更新当前位置
    后续对移动方块，踩在功能方块上的条件做补充
    响应{_G.OnGameRunning()}
]]
local lastPlayerX, lastPlayerY, lastPlayerZ = 0, 0, 0
local curPlayerX, curPlayerY, curPlayerZ = 0, 0, 0
local lastPlayerXInt, lastPlayerYInt, lastPlayerZInt = 0, 0, 0
local curPlayerXInt, curPlayerYInt, curPlayerZInt = 0, 0, 0
--[[
    移动限制常量
]]
local MIN_PUSH_DISTANCE = 0.2
local MAX_PUSH_DISTANCE = 1.5
local MIN_PULL_DISTANCE = 1.25
local MAX_PULL_DISTANCE = 2.15
local MIN_WALKING_DISTANCE = 0
--[[
    @Deprecated
]]
local lastWalkingUpdateTime = 0
--[[
    @Deprecated
]]
local intervalWalkingUpdateSecond = 1
--[[
    当前踩踏的方块id
]]
local steppingBlockId
--[[
    记录踩踏时间
]]
local lastSteppingUpdateTime = 0
--[[
    踩踏功能响应的更新间隔
]]
local intervalSteppingUpdateSecond = 1
--[[
    裂纹方块最大的生命值
]]
local HP_BLOCK_FRAGILE = 100
--[[
    裂纹方块每秒减少/恢复的生命值
    在{SteppingOnBlockFragile()}，{_G.OnBlockWalkedOn()}中响应
]]
local HP_INCREMENT_BLOCK_FRAGILE = 10
--[[
    上一次踩踏的坐标
]]
local lastSteppingBlockXInt, lastSteppingBlockYInt, lastSteppingBlockZInt = 0, 0, 0
--[[
    上一次踩到陷阱的事件
]]
local lastSteppingOnTrapTime = 0
--[[
    踩到陷阱，按{intervalSteppingOnTrapSecond}的频率更新次数
]]
local countSteppingOnTrap = 0
--[[
    根据{intervalSteppingOnTrapSecond}，{countSteppingOnTrap}决定
    陷阱限定最多1秒停止事件
]]
local MAX_COUNT_STEPPING_ON_TRAP = 1
--[[
    停止在陷阱上的计数间隔
]]
local intervalSteppingOnTrapSecond = 1

local MAX_PUSH_COUNT = 5

-----------------------------------------------------------------方向计算-----------------------------------------------------------------
--[[
    API接口：坐标轴的6个方向的计算
]]
local AxisOrientation = {
    NOT_ON_A_LINE = 0,
    X_POSITIVE = 1,
    X_NEGATIVE = 2,
    Y_POSITIVE = 3,
    Y_NEGATIVE = 4,
    Z_POSITIVE = 5,
    Z_NEGATIVE = 6,
}
function AxisOrientation:isOnALine(axisOrientation)
    return axisOrientation >= self.X_POSITIVE and axisOrientation <= self.Z_NEGATIVE
end
function AxisOrientation:isOnXAxis(axisOrientation)
    return axisOrientation == self.X_POSITIVE or axisOrientation == self.X_NEGATIVE
end
function AxisOrientation:isOnYAxis(axisOrientation)
    return axisOrientation == self.Y_POSITIVE or axisOrientation == self.Y_NEGATIVE
end
function AxisOrientation:isOnZAxis(axisOrientation)
    return axisOrientation == self.Z_POSITIVE or axisOrientation == self.Z_NEGATIVE
end
function AxisOrientation:getAccurateAxisOrientation(fromX, fromY, fromZ, toX, toY, toZ)
    local axisOrientation = self.NOT_ON_A_LINE
    if fromX == toX and fromY == toY then
        axisOrientation = (fromZ < toZ and self.Z_POSITIVE) or (fromZ > toZ and self.Z_NEGATIVE) or axisOrientation
    elseif fromX == toX and fromZ == toZ then
        axisOrientation = (fromY < toY and self.Y_POSITIVE) or (fromY > toY and self.Y_NEGATIVE) or axisOrientation
    elseif fromY == toY and fromZ == toZ then
        axisOrientation = (fromX < toX and self.X_POSITIVE) or (fromX > toX and self.X_NEGATIVE) or axisOrientation
    end
    return axisOrientation
end
function AxisOrientation:getAxisOrientation(fromX, fromY, fromZ, toX, toY, toZ)
    return self:getAccurateAxisOrientation(math.bunch_floor(fromX, fromY, fromZ, toX, toY, toZ))
end
function AxisOrientation:getDistance(axisOrientation, distance)
    if not axisOrientation then 
        print(debug.traceback())
        return
    end
    axisOrientation = axisOrientation >= self.NOT_ON_A_LINE and axisOrientation <= self.Z_NEGATIVE and axisOrientation or self.NOT_ON_A_LINE
    distance = distance or 1
    local distanceX, distanceY, distanceZ = 0, 0, 0
    if axisOrientation == self.X_POSITIVE then 
        distanceX = distance
    elseif axisOrientation == self.X_NEGATIVE then 
        distanceX = 0 - distance
    elseif axisOrientation == self.Y_POSITIVE then 
        distanceY = distance
    elseif axisOrientation == self.Y_NEGATIVE then 
        distanceY = 0 - distance
    elseif axisOrientation == self.Z_POSITIVE then 
        distanceZ = distance
    elseif axisOrientation == self.Z_NEGATIVE then 
        distanceZ = 0 - distance
    end
    return distanceX, distanceY, distanceZ
end
function AxisOrientation:getTargetCoordinate(x, y, z, axisOrientation, distance)
    if not x or not y or not z then return end
    local distanceX, distanceY, distanceZ = self:getDistance(axisOrientation, distance)
    return x + distanceX, y + distanceY, z + distanceZ
end

-----------------------------------------------------------------标记方块-----------------------------------------------------------------
--[[
    暂定方法：
    移动标记
]]
local StaticBlockMark = {
    
}
function StaticBlockMark:move(x, y, z, axisOrientation, distance)
    if not x or not y or not z then return end
    local ret, blockAbove = Block:getBlockID(x, y, z)
    print("StaticBlockMark:move: blockAbove",blockAbove)
    if ret == ErrorCode.OK and blockAbove == BLOCK_MARK then
        Block:destroyBlock(x, y, z)
    end
    x, y, z = AxisOrientation:getTargetCoordinate(x, y, z, axisOrientation, distance)
    ret, blockAbove = Block:getBlockID(x, y, z)
    print("StaticBlockMark:move: blockAbove", blockAbove)
    if ret == ErrorCode.OK and blockAbove ~= BLOCK_MARK and Block:isSolidBlock(x, y, z) ~= ErrorCode.OK then
        -- Block:setBlockAll(x, y, z, BLOCK_MARK)
        Block:placeBlock(BLOCK_MARK, x, y, z)
    end
end
--[[
    暂定方法：
    移除标记
]]
function StaticBlockMark:remove(x, y, z)
    if not x or not y or not z then return end

    local ret, blockAbove = Block:getBlockID(x, y, z)
    print("StaticBlockMark:remove: blockAbove",blockAbove)
    if ret == ErrorCode.OK and blockAbove == BLOCK_MARK then
        Block:destroyBlock(x, y, z, nil)
    end
end
--[[
    暂定方法：
    放置标记
]]
function StaticBlockMark:place(x, y, z)
    if not x or not y or not z then return end

    local ret, blockAbove = Block:getBlockID(x, y, z)
    print("StaticBlockMark:place: blockAbove", blockAbove)
    if ret == ErrorCode.OK and blockAbove ~= BLOCK_MARK and Block:isAirBlock(x, y, z) == ErrorCode.OK then
        -- Block:setBlockAll(x, y, z, BLOCK_MARK)
        Block:setBlockAll(x, y, z, BLOCK_MARK)
    end
end

-----------------------------------------------------------------公共函数-----------------------------------------------------------------
local function RemoveAllAirWall()
end

local function CreateAirWallOnBothSides(x, y, z)
    local _, faceYaw = Actor:getFaceYaw(myUin)
    print("CreateAirWall(): faceYaw", faceYaw)

end

local function IsMovableBlock(blockid)
    if not blockid then return false end
    for i=1, #MOVABLE_BLOCKS do 
        if blockid == MOVABLE_BLOCKS[i] then return true end
    end
    return false
end

local function IsLargeBlock(blockid)
    if not blockid then return false end
    for i=1, #LARGE_BLOCKS do 
        if blockid == LARGE_BLOCKS[i] then return true end
    end
    return false
end

-----------------------------------------------------------------选择-----------------------------------------------------------------
local Selection = {
    x = nil,
    y = nil,
    z = nil,
    blockid = nil,
}
function Selection:getBlockID()
    return self.blockid or BLOCK_AIR
end
function Selection:hasSelected()
    return self.x and self.y and self.z and true or false
end
function Selection:hasSelectedThis(x, y, z)
    return self.x == x and self.y == y and self.z == z
end
function Selection:switch(x, y, z)
    if self:hasSelected() and not self:hasSelectedThis(x, y, z) then
        self:select(x, y, z)
    else
        self:disselect(x, y, z)
    end
end
function Selection:select(x, y, z)
    -- print("Selection:select():")
    if not x or not y or not z then return end
    local ret, blockid = Block:getBlockID(x, y, z)
    if ret ~= ErrorCode.OK then return end
    if not IsMovableBlock(blockid) then return end
    self.x, self.y, self.z, self.blockid = x, y, z, blockid
    StaticBlockMark:place(x, y+1, z)
end
function Selection:disselect(x, y, z)
    -- print("Selection:disselect():")
    if x and y and z then 
        StaticBlockMark:remove(x, y + 1, z)
    end
    if not self.x or not self.y or not self.z then return false end
    StaticBlockMark:remove(self.x, self.y + 1, self.z)
    self.x, self.y, self.z, self.blockid = nil, nil, nil, nil
    RemoveAllAirWall()
    GameRule.GravityFactor = 1
    return true
end

-----------------------------------------------------------------空气墙管理-----------------------------------------------------------------
local AirWalls = {
    xs = {},
    ys = {},
    zs = {},
    createOnBothSizes = function(self, actorId)
        actorId = actorId or myUin
        local ret, playerX, playerY, playerZ = Actor:getPosition(actorId)
        playerX, playerY, playerZ = math.floor(playerX), math.floor(playerY), math.floor(playerZ)
        local faceYaw
        ret, faceYaw = Player:getFaceYaw(actorId)

    end,

    add = function(self, x, y, z)
        if Block:getBlockID(x, y, z) == ErrorCode.OK then return end
        print("enable adding")
        Block:placeBlock(BLOCK_AIR_WALL, x, y, z)
        xs[#xs + 1] = x
        ys[#ys + 1] = y
        zs[#zs + 1] = z
    end,

    removeAll = function(self)
        local ret, id
        for i=#xs, 1, -1 do 
            ret, id = Block:getBlockID(x, y, z)
            if ret == ErrorCode.OK and id == BLOCK_AIR_WALL then
                Block:destroyBlock(x, y, z)
                xs[i] = nil
                ys[i] = nil
                zs[i] = nil    
            end        
        end
    end
}

-----------------------------------------------------------------裂纹方块生命值计算-----------------------------------------------------------------
--[[
    单独计算每个裂纹方块的生命值
]]
local FragileBlockHPManager = {
    --[[
        坐标使用3个数组代替，而不是类
    ]]
    xs = {},
    ys = {},
    zs = {},
    hps = {},
    --[[
        响应{OnGameRunning()}
        避免频繁添加相同的坐标
    ]]
    lastAddedIndex = 0,
}
function FragileBlockHPManager:printAll()
    local lastAddedIndex = self.lastAddedIndex
    local xs, ys, zs, hps = self.xs, self.ys, self.zs, self.hps
    for i=1, #hps do 
        print("FragileBlockHPManager:printAll(): i, x, y, z, hp = ", i, xs[i], ys[i], zs[i], hps[i])
    end
    print("FragileBlockHPManager:printAll(): lastAddedIndex = ", lastAddedIndex)
end
--[[
    添加裂纹方块的坐标
    优先查找生命值满或零的坐标，后在数组末尾插入坐标
    @return 是否添加成功
]]
function FragileBlockHPManager:put(x, y, z)
    -- print("add(): x, y, z", x, y, z)
    local ret, blockid = Block:getBlockID(x, y, z)
    if ret ~= ErrorCode.OK or blockid ~= BLOCK_FRAGILE then return false end
    local existent = false
    local foundEmptyIndex = false
    local lastAddedIndex = self.lastAddedIndex
    local xs, ys, zs, hps = self.xs, self.ys, self.zs, self.hps
    -- print("add(): before: lastAddedIndex = ", lastAddedIndex)
    self:printAll()
    -- 1.读取上一次记录的下标
    if lastAddedIndex and lastAddedIndex > 0 
    and xs[lastAddedIndex] == x and ys[lastAddedIndex] == y and zs[lastAddedIndex] == z
    and hps[lastAddedIndex] > 0 and hps[lastAddedIndex] <= HP_BLOCK_FRAGILE then
        -- print("add(): added the same")
        return false
    end
    -- 2.查找是否有相同坐标。坐标生命值未满，已添加
    for i=1, #hps do if xs[i] == x and ys[i] == y and zs[i] == z then 
        lastAddedIndex = i
        self.lastAddedIndex = i
        hps[i] = (hps[i] <= 0 or hps[i] > HP_BLOCK_FRAGILE) and HP_BLOCK_FRAGILE or hps[i]
        -- print("add(): existent")
        self:printAll()
        return false
    end end
    -- 3.寻找生命值满或负数的坐标，有则插入
    for i=1, #hps do if hps[i] >= HP_BLOCK_FRAGILE or hps[i] <= 0 then 
        xs[i] = x
        ys[i] = y
        zs[i] = z
        hps[i] = HP_BLOCK_FRAGILE
        lastAddedIndex = i
        self.lastAddedIndex = i
        -- print("add(): found empty index")
        self:printAll()
        return true
    end end
    -- 4.队列末尾加入新坐标
    lastAddedIndex = #hps + 1
    xs[lastAddedIndex] = x
    ys[lastAddedIndex] = y
    zs[lastAddedIndex] = z
    hps[lastAddedIndex] = HP_BLOCK_FRAGILE
    self.lastAddedIndex = lastAddedIndex
    -- print("add(): inserted")
    self:printAll()
    return true
end
--[[
    HP小于0会销毁
    @return 是否减少
]]
function FragileBlockHPManager:decreaseHp(x, y, z)
    local xs, ys, zs, hps = self.xs, self.ys, self.zs, self.hps
    for i=1, #hps do if xs[i] == x and ys[i] == y and zs[i] == z then 
        hps[i] = hps[i] - HP_INCREMENT_BLOCK_FRAGILE;
        if hps[i] > 0 then break end
        Block:destroyBlock(x, y, z)
        if self.lastAddedIndex == i then self.lastAddedIndex = 0 end
        return true
    end end
    return false
end
--[[
    @return 是否销毁
]]
function FragileBlockHPManager:tryDestroy(x, y, z)
    local xs, ys, zs, hps = self.xs, self.ys, self.zs, self.hps
    for i=1, #hps do 
        if xs[i] == x and ys[i] == y and zs[i] == z then 
            if hps[i] > 0 then return false end
            Block:destroyBlock(x, y, z)
            if self.lastAddedIndex == i then self.lastAddedIndex = 0 end
            return true
        end
    end
    return false
end
function FragileBlockHPManager:tryDestroyCurrent()
    return self:tryDestroy(lastSteppingBlockXInt, lastSteppingBlockYInt, lastSteppingBlockZInt)
end
--[[
    响应{OnGameRunning()}事件
]]
function FragileBlockHPManager:onUpdateAll()
    local xs, ys, zs, hps = self.xs, self.ys, self.zs, self.hps
    -- print("onUpdateAll(): before")
    self:printAll()
    for i=1, #hps do 
        if xs[i] == lastSteppingBlockXInt and ys[i] == lastSteppingBlockYInt and zs[i] == lastSteppingBlockZInt then 
            hps[i] = hps[i] - HP_INCREMENT_BLOCK_FRAGILE
            if hps[i] <= 0 then 
                Block:destroyBlock(lastSteppingBlockXInt, lastSteppingBlockYInt, lastSteppingBlockZInt)
                lastSteppingBlockXInt, lastSteppingBlockYInt, lastSteppingBlockZInt = nil, nil, nil
                self.lastAddedIndex = self.lastAddedIndex == i and 0 or self.lastAddedIndex
            end
        elseif hps[i] > 0 and hps[i] < HP_BLOCK_FRAGILE then
            hps[i] = hps[i] + HP_INCREMENT_BLOCK_FRAGILE
        end
    end
    -- print("onUpdateAll(): after")
    -- self:printAll()
end

-----------------------------------------------------------------方块管理基类-----------------------------------------------------------------
local AbsBlocksOperation = {
    newDataStructure = nil,
    newInheritor = nil,
}
--[[
    数据结构相关类
]]
function AbsBlocksOperation:newDataStructure()
    local BlocksDataStructure = {
        length = 0,
        capacity = 10,
        xs = {},
        ys = {},
        zs = {},
        ids = {},
    }
    function BlocksDataStructure:printAll()
        local xs, ys, zs, ids = self.xs, self.ys, self.zs, self.ids
        local length = #xs
        if length <= 0 then return self end
        print("BlocksDataStructure:printAll(): #xs = ", length)
        for i=1, length do 
            print("BlocksDataStructure:printAll(): i, x, y, z = ", i, xs[i], ys[i], zs[i])
        end
        return self
    end
    function BlocksDataStructure:empty()
        return #self.xs <= 0 or #self.ys <= 0 or #self.zs <= 0 or #self.ids <= 0
    end
    function BlocksDataStructure:contains(x, y, z, id)
        if not id then _, id = Block:getBlockID(x, y, z) end
        local xs, ys, zs, ids = self.xs, self.ys, self.zs, self.ids
        local length = #xs
        if length <= 0 then return false end
        for i=1, length do 
            if xs[i] == x and ys[i] == y and zs[i] == z and ids[i] == id then return true end
        end
        return false
    end
    --[[
        末尾入队
    ]]
    function BlocksDataStructure:add(x, y, z, id)
        if not id then _, id = Block:getBlockID(x, y, z) end
        local xs, ys, zs, ids = self.xs, self.ys, self.zs, self.ids
        xs[#xs + 1] = x
        ys[#ys + 1] = y
        zs[#zs + 1] = z
        ids[#ids + 1] = id
        return true
    end
    --[[
        集合操作
    ]]
    function BlocksDataStructure:put(x, y, z, id)
        if not id then _, id = Block:getBlockID(x, y, z) end
        if self:contains(x, y, z, id) then return false end
        return self:add(x, y, z, id)
    end
    function BlocksDataStructure:pop()
        local xs, ys, zs, ids = self.xs, self.ys, self.zs, self.ids
        local x, y, z, id = xs[#xs], ys[#ys], zs[#zs], ids[#ids]
        xs[#xs], ys[#ys], zs[#zs], ids[#ids] = nil, nil, nil, nil
        return x, y, z, id
    end
    function BlocksDataStructure:clear()
        local xs, ys, zs, ids = self.xs, self.ys, self.zs, self.ids
        if #xs <= 0 then return self end
        local i = #xs
        while i >= 1 do 
            xs[i] = nil
            ys[i] = nil
            zs[i] = nil
            ids[i] = nil
            i = i - 1
        end
        return self
    end
    --[[
        并集
    ]]
    function BlocksDataStructure:unionWithClass(BlocksDataStructure)
        if not BlocksDataStructure then return end
        self:unionWith(BlocksDataStructure.xs, BlocksDataStructure.ys, BlocksDataStructure.zs, BlocksDataStructure.ids)
    end
    function BlocksDataStructure:unionWith(xs, ys, zs, ids)
        if not xs or not ys or not zs or not ids then 
            print(debug.traceback())
            return 
        end
        if type(xs) ~= "table" or type(ys) ~= "table" or type(zs) ~= "table" or type(ids) ~= "table" then return end
        if #xs <= 0 or #ys <= 0 or #zs <= 0 or #ids <= 0 then return end
        if #xs ~= #ys and #xs ~= #zs and #xs ~= ids then return end
        local length = #xs
        for i=1, length do 
            if not self:contains(xs[i], ys[i], zs[i], ids[i]) then 
                self:add(xs[i], ys[i], zs[i], ids[i])
            end
        end
    end
    return BlocksDataStructure
end
--[[
    游戏内方块逻辑相关类
    包含的主要成员函数：
    checkMovable()
    checkAndMove()
    move()
    collect(x, y, z, blockid)
]]
function AbsBlocksOperation:newInheritor()
    local BlocksMemberField = self:newDataStructure()
    setmetatable(BlocksMemberField, self)
    BlocksMemberField.axisOrientation = AxisOrientation.NOT_ON_A_LINE
    BlocksMemberField.distance = 1
    function BlocksMemberField:setAxisOrientation(axisOrientation)
        -- print("BlocksMemberField:setAxisOrientation(): axisOrientation = ", axisOrientation)
        self.axisOrientation = axisOrientation
        return self
    end
    function BlocksMemberField:setDistance(distance)
        -- print("BlocksMemberField:setDistance(): distance = ", distance)
        self.distance = distance
    end
    --[[
        基类空函数
        推、拉、脱落会实现不同的逻辑
    ]]
    function BlocksMemberField:checkMovable()
        return false
    end
    --[[
        统一入口，含依赖倒置原则：
        清楚原有数据，收集需要移动的方块，检查可否移动的情况，收集脱落方块，最后做出移动，并且对标记做出移动
    ]]
    function BlocksMemberField:checkAndMove(x, y, z, blockid)
        self.distance = 1
        -- print("BlocksMemberField:checkAndMove(): clear")
        self:clear()
        -- print("BlocksMemberField:checkAndMove(): collect")
        self:collect(x, y, z, blockid)
        -- self:printAll()
        -- print("BlocksMemberField:checkAndMove(): checkMovable")
        if not self:checkMovable() then return false end
        -- print("BlocksMemberField:checkAndMove(): move")
        self:collectFallingBlocks()
        self:move()
        self:moveBlockMark()
        -- print("BlocksMemberField:checkAndMove(): move block mark")

        if not self.BlocksFallingOff then return end
        self.BlocksFallingOff:checkAndMove()
    end
    --[[
        暂定方法：移动标记
    ]]
    function BlocksMemberField:moveBlockMark()
        StaticBlockMark:move(Selection.x, Selection.y+1, Selection.z, self.axisOrientation, self.distance)
        Selection.x, Selection.y, Selection.z = self.xs[1], self.ys[1], self.zs[1]
    end
    --[[
        递归收集处于当前脱落方块集合中的第二次脱落的方块
    ]]
    function BlocksMemberField:collectFallingBlocks()
        local xs, ys, zs, ids = self.xs, self.ys, self.zs, self.ids
        local BlocksFallingOff = self.BlocksFallingOff
        if not BlocksFallingOff then return end
        -- print(debug.traceback())
        for i=1, #xs do 
            if not self:contains(xs[i], ys[i] + 1, zs[i]) then
                BlocksFallingOff:collect(xs[i], ys[i] + 1, zs[i])
            end
            if not self:contains(xs[i] + 1, ys[i], zs[i]) then
                BlocksFallingOff:collect(xs[i] + 1, ys[i], zs[i])
            end
            if not self:contains(xs[i] - 1, ys[i], zs[i]) then
                BlocksFallingOff:collect(xs[i] - 1, ys[i], zs[i])
            end
            if not self:contains(xs[i], ys[i], zs[i] + 1) then
                BlocksFallingOff:collect(xs[i], ys[i], zs[i] + 1)
            end
            if not self:contains(xs[i], ys[i], zs[i] - 1) then
                BlocksFallingOff:collect(xs[i], ys[i], zs[i] - 1)
            end
        end
    end
    --[[
        先全部销毁，计算所有坐标后再创建方块
    ]]
    function BlocksMemberField:move()
        local xs, ys, zs, ids = self.xs, self.ys, self.zs, self.ids
        if #xs <= 0 then return false end
        local axisOrientation = self.axisOrientation
        local distance = self.distance
        -- print("BlocksMemberField:move(): ")
        -- self:printAll()
        -- print("BlocksMemberField:move(): destroy and change coordinates")

        for i=1, #xs do 
            Block:destroyBlock(xs[i], ys[i], zs[i])
            xs[i], ys[i], zs[i] = AxisOrientation:getTargetCoordinate(xs[i], ys[i], zs[i], axisOrientation, distance)
        end
        -- print("BlocksMemberField:move(): set blocks")
        for i=1, #xs do 
            Block:setBlockAll(xs[i], ys[i], zs[i], ids[i])
        end
        -- self:printAll()
        -- print("BlocksMemberField:move(): finished", Selection.x, Selection.y, Selection.z)
        
    end
    --[[
        收集相同的方块
    ]]
    function BlocksMemberField:collect(x, y, z, linkedBlockId)
        -- print("BlocksMemberField:collect(): x, y, z, id, ", x, y, z, linkedBlockId)
        local ret, blockid = Block:getBlockID(x, y, z)
        if ret ~= ErrorCode.OK then return end
        if blockid ~= linkedBlockId then return end
        if blockid == BLOCK_NORMAL or blockid == BLOCK_FRAGILE then 
            self:put(x, y, z, blockid)
            return
        end
        if IsLargeBlock(blockid) and not self:contains(x, y, z, blockid) then 
            self:add(x, y, z, blockid)
            self:collect(x, y + 1, z, blockid)
            self:collect(x, y - 1, z, blockid)
            self:collect(x + 1, y, z, blockid)
            self:collect(x - 1, y, z, blockid)
            self:collect(x, y, z + 1, blockid)
            self:collect(x, y, z - 1, blockid)
        end
    end
    return BlocksMemberField
end

--[[
    方块推动中的翼外大型方块管理类，坐标收集含在推动排上面的方块
]]
function AbsBlocksOperation:newLargeBlocksPushing()
    local LargeBlocksPushing = self:newInheritor()
    --[[
        @Override
    ]]
    function LargeBlocksPushing:moveBlockMark()
    end
    --[[
        指BlocksPushing这个类
    ]]
    function LargeBlocksPushing:setTreeParent(treeParent)
        self.treeParent = treeParent
    end
    --[[
        判断是否在其它大型方块组中，或在推动排的方块组中
    ]]
    function LargeBlocksPushing:checkInOtherParts(x, y, z, id)
        -- print("LargeBlocksPushing:checkInOtherParts(): ", x, y, z, id)
        if not self.treeParent then return false end
        if not x or not y or not z then return false end
        local LargeBlocksPushings = self.treeParent.LargeBlocksPushings
        local length = #LargeBlocksPushings
        if length <= 0 then return false end
        for i=length, 1, -1 do if LargeBlocksPushings[i] ~= self then
            if LargeBlocksPushings[i]:contains(x, y, z, id) then return true end
        end end
        return self.treeParent:contains(x, y, z, id)
    end
    function LargeBlocksPushing:checkMovable()
        local xs, ys, zs, ids = self.xs, self.ys, self.zs, self.ids
        for i=1, #xs do 
            if not self:checkFrontLargeBlock(xs[i], ys[i], zs[i], ids[i]) then 
                -- print("LargeBlocksPushing:checkMovable(): current immovable: ")
                -- self:printAll()
                print("LargeBlocksPushing:checkMovable(): current immovable: ", xs[i], ys[i], zs[i], ids[i])
                return false
            end
        end
        return true
    end
    --[[
        前方的方块涵盖情况：
            1.普通阻挡（空气、陷阱、其它固体）
            2.本属于推动排上的方块
            3.处于其它大型方块组的方块
        可通行：
            1.非固体，判断终止
            2.陷阱，判断终止
            3.大型方块，相同类型，递归判断
            4.忽略标记
            5.前方的固体方块在其它组的大型方块或推动排的方块组里
        不可通行：
            1.前方的固体方块既不在其它组的大型方块，也不在推动排的方块组里
    ]]
    function LargeBlocksPushing:checkFrontLargeBlock(x, y, z, LARGE_BLOCK_ID)
        -- self.checkPullingEnabledStackDepth = self.checkPullingEnabledStackDepth + 1
        local movable = true
        local ret, blockid = Block:getBlockID(x, y, z)
        if ret ~= ErrorCode.OK then return false end
        -- 非固体，判断终止
        if Block:isSolidBlock(x, y, z) ~= ErrorCode.OK or blockid == BLOCK_MARK then 
            -- print("LargeBlocksPushing:checkFrontLargeBlock(): orient to non-solid ", x, y, z, LARGE_BLOCK_ID)
            return true 
        end
        -- 陷阱，判断终止
        if blockid == BLOCK_TRAP then return true end
        if IsMovableBlock(blockid) then
            --[[
                可移动方块，分三种情况：
                    1.相同的大型方块，递归判断
                    2.不同的大型方块，判断是否在其它组里
                    3.普通或裂纹方块，判断是否在其它组里
            ]]
            if IsLargeBlock(blockid) then
                -- 大型方块
                if LARGE_BLOCK_ID == blockid then 
                    -- 大型方块，相同类型，递归判断
                    local targetX, targetY, targetZ = AxisOrientation:getTargetCoordinate(x, y, z, self.axisOrientation, self.distance)
                    if not self:checkFrontLargeBlock(targetX, targetY, targetZ, blockid) then 
                        print("LargeBlocksPushing:checkFrontLargeBlock(): recursion stop ", x, y, z, blockid)
                        return false
                    end
                elseif self:checkInOtherParts(x, y, z, blockid) then
                    -- 其它大型方块
                    -- print("LargeBlocksPushing:checkFrontLargeBlock(): collided with large block in other group")
                    return true
                else
                    print("LargeBlocksPushing:checkFrontLargeBlock(): collided with isolated large block", x, y, z, blockid)
                    return false
                end
            else
                -- 普通或裂纹方块
                if self:checkInOtherParts(x, y, z, blockid) then
                    -- print("LargeBlocksPushing:checkFrontLargeBlock(): collided with normal or fragile block in pushing row")
                    return true
                else
                    print("LargeBlocksPushing:checkFrontLargeBlock(): collided with isolated normal or fragile block", x, y, z, blockid)
                    return false
                end
            end
        else
            -- 其它固体
            print("LargeBlocksPushing:checkFrontLargeBlock(): collided with other solid ", x, y, z, blockid)
            return false
        end
        -- 递归出栈
        return true
    end
    return LargeBlocksPushing
end

--[[
    方块脱落类
]]
function AbsBlocksOperation:newBlocksFalling()
    local BlocksFalling = self:newInheritor()
    --[[
        指BlocksPushing这个类
    ]]
    function BlocksFalling:moveBlockMark()
    end
    function BlocksFalling:setTreeParent(treeParent)
        self.treeParent = treeParent
    end
    --[[
        @Override
    ]]
    function BlocksFalling:checkMovable()
        local xs, ys, zs, ids = self.xs, self.ys, self.zs, self.ids
        local length = #xs
        if length <= 0 then return false end
        local fallingHeight = MAX_INTEGER
        local distances = {}
        for i=1, length do 
            local height = self.treeParent:getFallingHeight(xs[i], ys[i], zs[i], ids[i])
            if height <= 0 then
                print("BlocksFalling:checkMovable(): cannot fall off", xs[i], ys[i], zs[i], ids[i])
                return false
            end
            distances[#distances + 1] = height
            fallingHeight = math.min(fallingHeight, height)
        end
        for i=1, length do 
            print("BlocksFalling:checkMovable():", xs[i], ys[i], zs[i], ids[i], distances[i])
        end
        if fallingHeight <= 0 then 
            print("BlocksFalling:checkMovable(): none can fall off")
            return false 
        end
        self.distance = fallingHeight
        return true
    end
    return BlocksFalling
end
-----------------------------------------------------------------方块脱落管理-----------------------------------------------------------------
--[[
    先收集初始坐标，根据初始坐标的方块分为普通和裂纹、大型方块，共2类。
    对此二类进行不同的判断和移动。
]]
local BlocksFallingOff = AbsBlocksOperation:newInheritor()
BlocksFallingOff.BlocksFallingOff = BlocksFallingOff
function BlocksFallingOff:moveBlockMark()
end
--[[
    @Override
]]
function BlocksFallingOff:collect(x, y, z)
    if self:contains(x, y, z) then return false end
    if Block:isSolidBlock(x, y, z) ~= ErrorCode.OK then return false end
    local ret, blockid = Block:getBlockID(x, y, z)
    if ret ~= ErrorCode.OK then return false end
    if not IsMovableBlock(blockid) then return false end
    self:add(x, y, z, blockid)
end
--[[
    @Override
]]
function BlocksFallingOff:checkAndMove()
    local xs, ys, zs, ids = self.xs, self.ys, self.zs, self.ids
    local length = #xs
    if length <= 0 then return false end
    for i=1, length do 
        if IsMovableBlock(ids[i]) then
            local BlocksFalling = AbsBlocksOperation:newBlocksFalling()
            BlocksFalling:setTreeParent(self)
            BlocksFalling.BlocksFallingOff = self
            BlocksFalling:setAxisOrientation(AxisOrientation.Y_NEGATIVE)
            BlocksFalling:checkAndMove(xs[i], ys[i], zs[i], ids[i])
        end
    end
end
--[[
    大型方块忽略是当前大型方块的情况
]]
function BlocksFallingOff:canLargeBlocksFallOffFrom(x, y, z, LARGE_BLOCK_ID)
    local ret, blockid, isSolid
    ret, blockid = Block:getBlockID(x, y, z)
    isSolid = Block:isSolidBlock(x, y, z)
    return isSolid ~= ErrorCode.OK or blockid == BLOCK_MARK or (LARGE_BLOCK_ID and blockid == LARGE_BLOCK_ID)
end
function BlocksFallingOff:canBlocksFallOffFrom(x, y, z)
    local ret, blockid, isSolid
    ret, blockid = Block:getBlockID(x, y, z)
    isSolid = Block:isSolidBlock(x, y, z)
    return isSolid ~= ErrorCode.OK or blockid == BLOCK_MARK
end
--[[
    获取单个方块可下落的最大距离。区分大型方块和普通、裂纹方块两类
    大型方块：会忽略四周是相同大型方块的情况
    普通、裂纹方块：从上往下计算可孤立的高度
]]
function BlocksFallingOff:getFallingHeight(x, y, z, LARGE_BLOCK_ID)
    if not x or not y or not z then return 0 end
    local height = 0
    local ret, blockid, blockDownward, isSolid
    local targetX, targetY, targetZ
    if LARGE_BLOCK_ID and IsLargeBlock(LARGE_BLOCK_ID) then
        while true do 
            if not self:canLargeBlocksFallOffFrom(x + 1, y, z, LARGE_BLOCK_ID) then return height end
            if not self:canLargeBlocksFallOffFrom(x - 1, y, z, LARGE_BLOCK_ID) then return height end
            if not self:canLargeBlocksFallOffFrom(x, y, z + 1, LARGE_BLOCK_ID) then return height end
            if not self:canLargeBlocksFallOffFrom(x, y, z - 1, LARGE_BLOCK_ID) then return height end
            ret, blockDownward = Block:getBlockID(x, y - 1, z)
            --下滑底面直到固体。陷阱可覆盖继续下滑。
            if Block:isSolidBlock(x, y - 1, z) == ErrorCode.OK and blockDownward ~= BLOCK_TRAP then return height end
            y = y - 1
            height = height + 1
        end
    else
        while true do 
            if not self:canBlocksFallOffFrom(x + 1, y, z) then return height end
            if not self:canBlocksFallOffFrom(x - 1, y, z) then return height end
            if not self:canBlocksFallOffFrom(x, y, z + 1) then return height end
            if not self:canBlocksFallOffFrom(x, y, z - 1) then return height end
            ret, blockDownward = Block:getBlockID(x, y - 1, z)
            --下滑底面直到固体。陷阱可覆盖继续下滑。
            if Block:isSolidBlock(x, y - 1, z) == ErrorCode.OK and blockDownward ~= BLOCK_TRAP then return height end
            y = y - 1
            height = height + 1
        end
    end
    return height
end

-----------------------------------------------------------------方块拉动管理-----------------------------------------------------------------
--[[
    分两类：
    1.普通和裂纹
    2.大型，需整体判断
]]
local BlocksPulling = AbsBlocksOperation:newInheritor()
BlocksPulling.BlocksFallingOff = BlocksFallingOff
--[[
    @Override
]]
function BlocksPulling:checkMovable()
    local xs, ys, zs, ids = self.xs, self.ys, self.zs, self.ids
    --只有一个普通或裂纹方块可移动
    if #xs == 1 then return true end
    for i=1, #xs do 
        if ids[i] ~= Selection:getBlockID() or not self:checkFrontLargeBlock(xs[i], ys[i], zs[i], ids[i]) then 
            print("BlocksPulling:checkMovable(): current immovable: ", xs[i], ys[i], zs[i], ids[i])
            return false 
        end
    end
    return true
end
--[[
    可通行：
        1.非固体，判断终止
        2.陷阱，判断终止
        3.大型方块，相同类型，递归判断
        4.忽略标记
    不可通行：
        1.固体
        2.不同的大型方块
]]
function BlocksPulling:checkFrontLargeBlock(x, y, z, LARGE_BLOCK_ID)
    local movable = true
    local ret, blockid = Block:getBlockID(x, y, z)
    if ret ~= ErrorCode.OK then return false end
    -- 1.非固体，判断终止
    if Block:isSolidBlock(x, y, z) ~= ErrorCode.OK or blockid == BLOCK_MARK then 
        -- print("BlocksPulling:checkFrontLargeBlock(): orient to non-solid ", x, y, z, LARGE_BLOCK_ID)
        return true 
    end
    if not LARGE_BLOCK_ID then 
        LARGE_BLOCK_ID = blockid 
    end
    -- 2.陷阱，判断终止
    if blockid == BLOCK_TRAP then return true end
    local targetX, targetY, targetZ
    if IsLargeBlock(LARGE_BLOCK_ID) and LARGE_BLOCK_ID == blockid then
        -- 3.大型方块，递归判断
        targetX, targetY, targetZ = AxisOrientation:getTargetCoordinate(x, y, z, self.axisOrientation, self.distance)
        if not self:checkFrontLargeBlock(targetX, targetY, targetZ, LARGE_BLOCK_ID) then 
            print("BlocksPulling:checkFrontLargeBlock(): recursion stop ", x, y, z, LARGE_BLOCK_ID)
            return false 
        end
    else 
        -- 3.不同的大型方块，或者是其它固体
        print("BlocksPulling:checkFrontLargeBlock(): collided with solid ", x, y, z, LARGE_BLOCK_ID)
        return false
    end
    -- 递归出栈
    return true
end
--[[
    判断玩家移动的条件，以及与方块的坐标关系
]]
function BlocksPulling:canPullBackward()
    if not Selection:getBlockID() then return false end
    -- print("BlocksPulling:canPullBackward: select", Selection.x, Selection.y, Selection.z)
    if not Selection:hasSelected() then return false end
    -- print("BlocksPulling:canPullBackward: y", curPlayerYInt, lastPlayerYInt)
    if math.abs(curPlayerYInt - lastPlayerYInt) > 2 or Selection.y - curPlayerYInt >= 2 or Selection.y - curPlayerYInt < 0 then return false end
    -- print("BlocksPulling:canPullBackward: last", lastPlayerX, lastPlayerY, lastPlayerZ)
    -- print("BlocksPulling:canPullBackward: cur", curPlayerX, curPlayerY, curPlayerZ)
    if curPlayerX == lastPlayerX and curPlayerZ == lastPlayerZ then return false end
    -- print("BlocksPulling:canPullBackward: algorithm")
    if (
        curPlayerZInt == lastPlayerZInt and curPlayerZInt == Selection.z
        and (
            ( 
                curPlayerX < lastPlayerX and curPlayerX < Selection.x and lastPlayerX < Selection.x
                and Selection.x - curPlayerX >= MIN_PULL_DISTANCE
                and Selection.x - curPlayerX <= MAX_PULL_DISTANCE
            )
            or
            (
                curPlayerX > lastPlayerX and curPlayerX > Selection.x and lastPlayerX > Selection.x
                and curPlayerX - Selection.x >= MIN_PULL_DISTANCE
                and curPlayerX - Selection.x <= MAX_PULL_DISTANCE
            )
        )
    ) or (
        curPlayerXInt == lastPlayerXInt and curPlayerXInt == Selection.x
        and (
            ( 
                curPlayerZ < lastPlayerZ and curPlayerZ < Selection.z and lastPlayerZ < Selection.z
                and Selection.z - curPlayerZ >= MIN_PULL_DISTANCE
                and Selection.z - curPlayerZ <= MAX_PULL_DISTANCE
            )
            or
            (
                curPlayerZ > lastPlayerZ and curPlayerZ > Selection.z and lastPlayerZ > Selection.z
                and curPlayerZ - Selection.z >= MIN_PULL_DISTANCE
                and curPlayerZ - Selection.z <= MAX_PULL_DISTANCE
            )
        )
    ) then 
        return true 
    end
    return false
end
-----------------------------------------------------------------方块推动管理-----------------------------------------------------------------
--[[
    先判断该排。可推动，加入到自己的数组中。
    再从远到近（从数组尾到头）判断大型方块，递归判断大型方块的情况。再加入到数组中。
]]
local BlocksPushing = AbsBlocksOperation:newInheritor()
BlocksPushing.BlocksFallingOff = BlocksFallingOff
--[[
    大型方块类数组
]]
BlocksPushing.LargeBlocksPushings = {}
--[[
    @Override
    先收集一排，边收集边检查。
    后续checkMovable只检查该排的数组大小，其余检查排列上的大型方块组。
]]
function BlocksPushing:collect(startX, startY, startZ)
    local ret
    local targetX, targetY, targetZ = startX, startY, startZ
    ret, blockForward = Block:getBlockID(targetX, targetY, targetZ)
    -- print("BlocksPushing:collect(): first: ret, blockForward = ", ret, blockForward)
    while ret == ErrorCode.OK do 
        -- 固体，但不是陷阱
        -- print("BlocksPushing:collect(): blockForward = ", blockForward)
        -- print("BlocksPushing:collect(): IsMovableBlock(blockForward) = ", IsMovableBlock(blockForward))
        local isSolid = Block:isSolidBlock(targetX, targetY, targetZ)
        -- print("BlocksPushing:collect(): isSolid = ", isSolid)
        if not IsMovableBlock(blockForward) and blockForward ~= BLOCK_TRAP and isSolid == ErrorCode.OK then 
            print("BlocksPushing:collect(): collided with solid blocks other than trap")
            self:clear()
            break
        end

        -- 陷阱
        if blockForward == BLOCK_TRAP then
            print("BlocksPushing:collect(): collided with trap.")
            break
        end

        -- 非固体
        if isSolid ~= ErrorCode.OK then
            print("BlocksPushing:collect(): movable")
            break
        end

        self:add(targetX, targetY, targetZ, blockForward)
        targetX, targetY, targetZ = AxisOrientation:getTargetCoordinate(targetX, targetY, targetZ, self.axisOrientation, self.distance)
        ret, blockForward = Block:getBlockID(targetX, targetY, targetZ)
    end 

    if self:empty() then return end
    local LargeBlocksPushings = self.LargeBlocksPushings
    for i=#LargeBlocksPushings, 1, -1 do 
        LargeBlocksPushings[i] = nil
    end
    local xs, ys, zs, ids = self.xs, self.ys, self.zs, self.ids
    for i=#xs, 1, -1 do 
        if IsLargeBlock(ids[i]) then 
            -- print("BlocksPushing:collect(): collect large ", xs[i], ys[i], zs[i], ids[i])
            local LargeBlocksPushing = AbsBlocksOperation:newLargeBlocksPushing()
            LargeBlocksPushings[#LargeBlocksPushings + 1] = LargeBlocksPushing
            LargeBlocksPushing:setAxisOrientation(self.axisOrientation)
            LargeBlocksPushing:setDistance(self.distance)
            LargeBlocksPushing:setTreeParent(self)
            LargeBlocksPushing:collect(xs[i], ys[i], zs[i], ids[i])
        end
    end
end
--[[
    @Override
]]
function BlocksPushing:checkMovable()
    if self:empty() then 
        print("BlocksPushing:checkMovable(): empty")
        return false 
    end
    local LargeBlocksPushings = self.LargeBlocksPushings
    local length = #LargeBlocksPushings
    -- 没有大型方块
    if length <= 0 then return true end
    for i=1, length do 
        if not LargeBlocksPushings[i]:checkMovable() then 
            print("BlocksPushing:checkMovable(): large blocks immovable", i)
            return false 
        end
    end
    --判断为可推动后，先合并坐标。为的是先收集脱落方块坐标。
    self:uinonLarge()
    return true
end
--[[
    判断可移动后，先合并坐标，再进行移动
]]
function BlocksPushing:uinonLarge()
    local LargeBlocksPushings = self.LargeBlocksPushings
    local length = #LargeBlocksPushings
    if length <= 0 then
        return false
    end
    for i=length, 1, -1 do 
        self:unionWithClass(LargeBlocksPushings[i])
        LargeBlocksPushings[i]:clear()
        LargeBlocksPushings[i] = nil
    end
end
--[[
    判断玩家移动的条件，以及与方块的坐标关系
]]
function BlocksPushing:canPushForward()
    if not Selection:getBlockID() then return false end
    -- print("BlocksPulling:canPullBackward: select", Selection.x, Selection.y, Selection.z)
    if not Selection:hasSelected() then return false end
    -- print("BlocksPulling:canPullBackward: y", curPlayerYInt, lastPlayerYInt)
    if math.abs(curPlayerYInt - lastPlayerYInt) > 2 or Selection.y - curPlayerYInt >= 2 or Selection.y - curPlayerYInt < 0 then return false end
    -- print("BlocksPulling:canPullBackward: last", lastPlayerX, lastPlayerY, lastPlayerZ)
    -- print("BlocksPulling:canPullBackward: cur", curPlayerX, curPlayerY, curPlayerZ)
    if curPlayerX == lastPlayerX and curPlayerZ == lastPlayerZ then return false end
    -- print("BlocksPulling:canPullBackward: algorithm")
    if (
        curPlayerZInt == lastPlayerZInt and curPlayerZInt == Selection.z
        and (
            ( 
                curPlayerX > lastPlayerX and curPlayerX < Selection.x and lastPlayerX < Selection.x
                and Selection.x - curPlayerX >= MIN_PUSH_DISTANCE
                and Selection.x - curPlayerX <= MAX_PUSH_DISTANCE
            )
            or
            (
                curPlayerX < lastPlayerX and curPlayerX > Selection.x and lastPlayerX > Selection.x
                and curPlayerX - Selection.x >= MIN_PUSH_DISTANCE
                and curPlayerX - Selection.x <= MAX_PUSH_DISTANCE
            )
        )
    ) or (
        curPlayerXInt == lastPlayerXInt and curPlayerXInt == Selection.x
        and (
            ( 
                curPlayerZ > lastPlayerZ and curPlayerZ < Selection.z and lastPlayerZ < Selection.z
                and Selection.z - curPlayerZ >= MIN_PUSH_DISTANCE
                and Selection.z - curPlayerZ <= MAX_PUSH_DISTANCE
            )
            or
            (
                curPlayerZ < lastPlayerZ and curPlayerZ > Selection.z and lastPlayerZ > Selection.z
                and curPlayerZ - Selection.z >= MIN_PUSH_DISTANCE
                and curPlayerZ - Selection.z <= MAX_PUSH_DISTANCE
            )
        )
    ) then 
        return true 
    end
    return false
end

-----------------------------------------------------------------OnBlockPlacedBy-----------------------------------------------------------------
OnBlockPlacedBy = function(args, x, y, z, blockid, actorId)
    local x, y, z = args['x'], args['y'], args['z']
    local blockid, actorId = args['blockid'], args['byobjid']
    print("OnBlockPlacedBy(): ", x, y, z, blockid, actorId);
end


OnBlockCollided = function(args, x, y, z, blockid, actorId)
    local x, y, z = args['x'], args['y'], args['z']
    local blockid, actorId = args['blockid'], args['byobjid']
    -- print("OnBlockCollided(): ");
    -- Actor:jumpOnce(actorId);
    if actorId ~= myUin then return end
    print("OnBlockCollided(): ", x, y, z, blockid, actorId);
    lastPlayerX, lastPlayerY, lastPlayerZ = curPlayerX, curPlayerY, curPlayerZ
    lastPlayerXInt, lastPlayerYInt, lastPlayerZInt = curPlayerXInt, curPlayerYInt, curPlayerZInt
    _, curPlayerX, curPlayerY, curPlayerZ = Player:getPosition(actorId);
end

OnBlockTriggered = function(args, x, y, z, blockid, actorId) 
    local x, y, z = args['x'], args['y'], args['z']
    local blockid, actorId = args['blockid'], args['byobjid']
    print("OnBlockTriggered(): ", x, y, z, blockid, actorId);
end

OnBlockFertilized = function(args, x, y, z, blockid, actorId)
    local x, y, z = args['x'], args['y'], args['z']
    local blockid, actorId = args['blockid'], args['byobjid']
    print("OnBlockFertilized(): ", x, y, z, blockid, actorId);
end

-----------------------------------------------------------------OnBlockWalkedOn-----------------------------------------------------------------

local function SteppingOnBlockFragile(x, y, z)
    local ret, blockStepping = Block:getBlockID(x, y, z)
    if ret == ErrorCode.OK and blockStepping ~= BLOCK_FRAGILE then 
        return
    end

    if not FragileBlockHPManager:put(x, y, z) then 
        FragileBlockHPManager:decreaseHp(x, y, z)
    end

    -- 停留在裂纹方块
    Player:playBodyEffect(myUin, ACTORBODY_EFFECT.BODYFX_DIZZY)
end

local localPrint = function(...)
    local a = {...};
    local concat = {};
    for i=1, #a do 
        concat[#concat + 1] = tostring(a[i]);
    end
    Chat:sendChat(table.concat(concat, " "));
end
local function SteppingOnBlockTrap(x, y, z)
    -- local print = localPrint
    print("x, y, z = ", x, y, z)
    print("last x, y, z = ", lastSteppingBlockXInt, lastSteppingBlockYInt, lastSteppingBlockZInt)
    if lastSteppingBlockXInt ~= x or lastSteppingBlockYInt ~= y or lastSteppingBlockZInt ~= z then 
        countSteppingOnTrap = 0
        local pos = {x=lastSteppingBlockXInt, y=lastSteppingBlockYInt, z=lastSteppingBlockZInt}
        TriggerBlock:setBlockSwitchStatus(pos, false)
        print("not the same")
        return
    end

    print("countSteppingOnTrap = ", countSteppingOnTrap)
    if countSteppingOnTrap < MAX_COUNT_STEPPING_ON_TRAP then
        lastSteppingOnTrapTime = os.time()
        countSteppingOnTrap = 1
        local pos = {x=x, y=y, z=z}
        TriggerBlock:setBlockSwitchStatus(pos, true)
        return
    end

    if os.time() - lastSteppingOnTrapTime >= intervalSteppingOnTrapSecond then 
        countSteppingOnTrap = 0
        lastSteppingBlockXInt, lastSteppingBlockYInt, lastSteppingBlockZInt = 99999, 99999, 99999
        Player:killSelf(myUin)
        Selection:disselect()
        local pos = {x=x, y=y, z=z}
        TriggerBlock:setBlockSwitchStatus(pos, false)
        return
    end
end

local function SteppingOnBlock(x, y, z, steppingBlockId)
    -- print("SteppingOnBlock(): x, y, z, steppingBlockId = ", x, y, z, steppingBlockId)
    if not steppingBlockId then 
        local ret
        ret, steppingBlockId = Block:getBlockID(x, y, z)
        -- print("SteppingOnBlock(): ret, steppingBlockId = ", ret, steppingBlockId)
        if ret ~= ErrorCode.OK then return end
    end
    if steppingBlockId == BLOCK_FRAGILE then 
        SteppingOnBlockFragile(x, y, z)
    elseif steppingBlockId == BLOCK_TRAP then 
        SteppingOnBlockTrap(x, y, z)
    end
    lastSteppingBlockXInt, lastSteppingBlockYInt, lastSteppingBlockZInt = x, y, z
end

OnBlockWalkedOn = function(args, x, y, z, blockid, actorId)
    
    local x, y, z = args['x'], args['y'], args['z']
    local blockid, actorId = args['blockid'], args['byobjid']
    if actorId ~= myUin then return end
    -- local print = localPrint
    print("OnBlockWalkedOn(): ", actorId);

    if os.time() - lastSteppingUpdateTime >= intervalSteppingUpdateSecond then 
        SteppingOnBlock(x, y, z, blockid)
        lastSteppingUpdateTime = os.time()
    end
end

-----------------------------------------------------------------OnBlockBeginningBeingDug-----------------------------------------------------------------

--[[
    先判断是否有选择
]]
OnBlockBeginningBeingDug = function(args, x, y, z, blockid, actorId)
    -- print("OnBlockBeginningBeingDug():")
    local x, y, z = args['x'], args['y'], args['z']
    local blockid, actorId = args['blockid'], args['byobjid']
    local ret, playerX, playerY, playerZ = Actor:getPosition(actorId)
    print("OnBlockBeginningBeingDug():", x, y, z, blockid, actorId)

    if Selection:hasSelected() then 
        if Selection:hasSelectedThis(x, y, z) then
            -- print("OnBlockBeginningBeingDug(): cancel selection")
            Selection:disselect(x, y, z)
        else
            -- print("OnBlockBeginningBeingDug(): has selected:", Selection.x, Selection.y, Selection.z)
            Selection:disselect(Selection.x, Selection.y, Selection.z)
            Selection:select(x, y, z)
        end
    else
        -- print("OnBlockBeginningBeingDug(): has no selection")
        local intervalYInt = y and playerY and (math.floor(y) - math.floor(playerY)) or -1
        print("OnBlockBeginningBeingDug(): intervalYInt", intervalYInt)
        if y and playerY and (intervalYInt < 0 or intervalYInt > 1) then 
            if intervalYInt > 1 then
                print("OnBlockBeginningBeingDug(): Too high to select.", playerY, y)
            else
                print("OnBlockBeginningBeingDug(): Too low to select.", playerY, y)
            end
            return 
        end
        intervalYInt = nil
    
        local playerXInt, playerYInt, playerZInt = math.floor(playerX), math.floor(playerY), math.floor(playerZ)
        if x ~= playerXInt and z ~= playerZInt then 
            Selection:disselect()
            print("OnBlockBeginningBeingDug(): Cannot select a block outside of its axis.")
            return
        end
        print("OnBlockBeginningBeingDug(): remove star")
        if Selection.x and Selection.y and Selection.z then
            StaticBlockMark:remove(Selection.x, Selection.y+1, Selection.z)
        end
    
        Selection:select(x, y, z)
    
        if ret == ErrorCode.OK then
            CreateAirWallOnBothSides(playerX, playerY, playerZ)
        end
        -- print("place star")
        StaticBlockMark:place(Selection.x, Selection.y+1, Selection.z)
        GameRule.GravityFactor = 10
        
    end
    print("OnBlockBeginningBeingDug(): finally select ", Selection.x, Selection.y, Selection.z)
end

OnBlockFinishingBeingDug = function(args, x, y, z, blockid, actorId)
    print("OnBlockFinishingBeingDug(): ")

end

OnBlockCancellingBeingDug = function(args, x, y, z, blockid, actorId)
    print("OnBlockCancellingBeingDug(): ")
end

-----------------------------------------------------------------OnGameRunning-----------------------------------------------------------------
--[[
    @Deprecated
]]
local function BuryBlockTrap(x, y, z)
    local ret, blockTrap = Block:getBlockID(x, y, z)
    if ret ~= ErrorCode.OK or blockTrap ~= BLOCK_TRAP then return false end
    Block:destroyBlock(x, y, z)
    Block:setBlockAll(x, y, z, BLOCK_NORMAL)
    return true
end

--[[
    @Deprecated
    递归函数：先四周，再往上
    @return 下沉后的新坐标
]]
local LargeBlockSinking
LargeBlockSinking = function(x, y, z)
    if not x or not y or not z then return x, y, z end
    print("LargeBlockSinking: ",x ,y ,z)
    local ret, blockLarge = Block:getBlockID(x, y, z)
    print("LargeBlockSinking: blockLarge", blockLarge)
    if ret ~= ErrorCode.OK or (blockLarge ~= BLOCK_PURPLE_FLUORESCENCE and blockLarge ~= BLOCK_STAR_COPPER) then return x, y, z end
    local blockBottom
    ret, blockBottom = Block:getBlockID(x, y-1, z)
    print("LargeBlockSinking: blockBottom", blockBottom)
    if ret ~= ErrorCode.OK then return x, y, z end
    if Block:isSolidBlock(x, y-1, z) == ErrorCode.OK then return x, y, z end
    Block:destroyBlock(x, y, z)
    Block:setBlockAll(x, y-1, z, blockLarge)
    LargeBlockSinking(x+1, y, z)
    LargeBlockSinking(x-1, y, z)
    LargeBlockSinking(x, y, z+1)
    LargeBlockSinking(x, y, z-1)
    LargeBlockSinking(x, y+1, z)
    return x, y-1, z
end

--[[
    @Deprecated
]]
local function SimplyMoveSelectedBlock()
    if not Selection:getBlockID() then return end
    if not lastPlayerXInt or not lastPlayerYInt or not lastPlayerZInt then return end
    if not curPlayerXInt or not curPlayerYInt or not curPlayerZInt then return end
    if not Selection.x or not Selection.y or not Selection.z then return end
    -- print("SimplyMoveSelectedBlock: Selection:getBlockID()",Selection:getBlockID())
    -- print("SimplyMoveSelectedBlock: last", lastPlayerXInt, lastPlayerYInt, lastPlayerZInt)
    -- print("SimplyMoveSelectedBlock: cur", curPlayerXInt, curPlayerYInt, curPlayerZInt)
    -- print("SimplyMoveSelectedBlock: select", Selection.x, Selection.y, Selection.z)
    local targetX, targetY, targetZ
    if math.abs(lastPlayerZInt - curPlayerZInt) >= 1 and lastPlayerXInt == curPlayerXInt then
        -- print("SimplyMoveSelectedBlock: z")
        targetX = Selection.x
        targetY = Selection.y
        targetZ = Selection.z+ curPlayerZInt - lastPlayerZInt
    elseif math.abs(lastPlayerXInt - curPlayerXInt) >= 1 and lastPlayerZInt == curPlayerZInt then
        -- print("SimplyMoveSelectedBlock: x")
        targetX = Selection.x + curPlayerXInt - lastPlayerXInt
        targetY = Selection.y
        targetZ = Selection.z
    end

    if not targetX or not targetY or not targetZ then return end
    -- print("SimplyMoveSelectedBlock: target", targetX, targetY, targetZ)
    local ret, destinationBlockId = Block:getBlockID(targetX, targetY, targetZ)
    if ret == ErrorCode.OK and Block:isSolidBlock(targetX, targetY, targetZ) == ErrorCode.OK then
        if destinationBlockId == BLOCK_TRAP then
            -- print("bury trap")
            Block:destroyBlock(targetX, targetY, targetZ)
        else
            -- print("SimplyMoveSelectedBlock: collision", destinationBlockId)
            return false
        end
    end

    -- print("SimplyMoveSelectedBlock: ")
    Block:destroyBlock(Selection.x, Selection.y, Selection.z)
    StaticBlockMark:remove(Selection.x, Selection.y+1, Selection.z)
    Block:setBlockAll(targetX, targetY, targetZ, Selection:getBlockID())
    StaticBlockMark:place( targetX, targetY+1, targetZ)
    -- BuryBlockTrap(targetX, targetY-1, targetZ)
    -- print("SimplyMoveSelectedBlock: sink")
    LargeBlockSinking(Selection.x, Selection.y+1, Selection.z)
    -- print("SimplyMoveSelectedBlock: refresh coordinate")
    Selection.x, Selection.y, Selection.z = targetX, targetY, targetZ
end

--[[
    @Deprecated
]]
local function PushRowForward()
    if not Selection:getBlockID() then return end
    if not lastPlayerX or not lastPlayerY or not lastPlayerZ then return end
    print("PushRowForward(): lastPlayerX, lastPlayerY, lastPlayerZ = ", lastPlayerX, lastPlayerY, lastPlayerZ)
    if not curPlayerX or not curPlayerY or not curPlayerZ then return end
    print("PushRowForward(): curPlayerX, curPlayerY, curPlayerZ = ", curPlayerX, curPlayerY, curPlayerZ)
    if not lastPlayerXInt or not lastPlayerYInt or not lastPlayerZInt then return end
    print("PushRowForward(): lastPlayerXInt, lastPlayerYInt, lastPlayerZInt = ", lastPlayerXInt, lastPlayerYInt, lastPlayerZInt)
    if not curPlayerXInt or not curPlayerYInt or not curPlayerZInt then return end
    print("PushRowForward(): curPlayerXInt, curPlayerYInt, curPlayerZInt = ", curPlayerXInt, curPlayerYInt, curPlayerZInt)
    if not Selection.x or not Selection.y or not Selection.z then return end
    print("PushRowForward(): Selection.x, Selection.y, Selection.z = ", Selection.x, Selection.y, Selection.z)
    if curPlayerX == lastPlayerX and curPlayerZ == lastPlayerZ then return end
    print("PushRowForward(): moving")
    local axisOrientation
    if lastPlayerX == curPlayerX then
        if curPlayerZ > lastPlayerZ then
            axisOrientation = AxisOrientation.Z_POSITIVE
        elseif curPlayerZ < lastPlayerZ then
            axisOrientation = AxisOrientation.Z_NEGATIVE
        else
            return
        end
    elseif lastPlayerZ == curPlayerZ then
        if curPlayerX > lastPlayerX then
            axisOrientation = AxisOrientation.X_POSITIVE
        elseif curPlayerX < lastPlayerX then
            axisOrientation = AxisOrientation.X_NEGATIVE
        else
            return
        end
    else
        return
    end
    print("PushRowForward(): axisOrientation = ", axisOrientation)

    local targetX, targetY, targetZ = Selection.x, Selection.y, Selection.z
    local movableCoordinates = {
        [1] = nil,
        [2] = nil,
        [3] = nil,
    }
    ret, blockForward = Block:getBlockID(targetX, targetY, targetZ)
    print("PushRowForward(): first: ret, blockForward = ", ret, blockForward)
    while ret == ErrorCode.OK do 
        -- 固体，但不是陷阱
        print("PushRowForward(): blockForward = ", blockForward)
        print("PushRowForward(): IsMovableBlock(blockForward) = ", IsMovableBlock(blockForward))
        local isSolid = Block:isSolidBlock(targetX, targetY, targetZ)
        print("PushRowForward(): isSolid = ", isSolid)
        if not IsMovableBlock(blockForward) and blockForward ~= BLOCK_TRAP and isSolid == ErrorCode.OK then 
            print("PushRowForward(): collided with solid blocks other than trap")
            movableCoordinates = nil
            break
        end

        -- 超过最大推动的数量
        if #movableCoordinates > MAX_PUSH_COUNT then
            print("PushRowForward(): too many blocks to push: count = ", #movableCoordinates)
            movableCoordinates = nil
            break
        end

        movableCoordinates[#movableCoordinates + 1] = {x = targetX, y = targetY, z = targetZ,}
        -- 陷阱
        if blockForward == BLOCK_TRAP then
            print("PushRowForward(): collided with trap.")
            break
        end

        -- 非固体
        if isSolid ~= ErrorCode.OK then
            print("PushRowForward(): movable")
            break
        end
        -- movableCoordinates[#movableCoordinates + 1] = targetX
        -- movableCoordinates[#movableCoordinates + 1] = targetY
        -- movableCoordinates[#movableCoordinates + 1] = targetZ
        targetX, targetY, targetZ = AxisOrientation:getTargetCoordinate(targetX, targetY, targetZ, axisOrientation, 1)
        ret, blockForward = Block:getBlockID(targetX, targetY, targetZ)
    end 

    local blockCur
    local curCoordinate, forwardCoordinate
    print("PushRowForward(): movableCoordinates = ", movableCoordinates)
    if movableCoordinates and next(movableCoordinates) then for i=#movableCoordinates-1, 1, -1 do 
        curCoordinate = movableCoordinates[i]
        forwardCoordinate = movableCoordinates[i+1]
        ret, blockCur = Block:getBlockID(curCoordinate.x, curCoordinate.y, curCoordinate.z)
        Block:destroyBlock(curCoordinate.x, curCoordinate.y, curCoordinate.z)
        Block:setBlockAll(forwardCoordinate.x, forwardCoordinate.y, forwardCoordinate.z, blockCur)
        local finalX, finalY, finalZ = LargeBlockSinking(forwardCoordinate.x, forwardCoordinate.y, forwardCoordinate.z)
        if i == 1 and finalX and finalY and finalZ then 
            print("PushRowForward(): change star coordinate ")
            StaticBlockMark:remove(curCoordinate.x, curCoordinate.y+1, curCoordinate.z)
            StaticBlockMark:place(finalX, finalY+1, finalZ)
            print("PushRowForward(): change selected block coordinate")
            Selection.x, Selection.y, Selection.z = finalX, finalY, finalZ
        end
    end end
end

OnGameRunning = function(args)
    -- print("OnGameRunning: lastWalkingUpdateTime", lastWalkingUpdateTime)
    local ret
    ret, curPlayerX, curPlayerY, curPlayerZ = Actor:getPosition(myUin);
    if ret ~= ErrorCode.OK then
        return
    end
    curPlayerXInt, curPlayerYInt, curPlayerZInt = math.floor(curPlayerX), math.floor(curPlayerY), math.floor(curPlayerZ) 
    --[[
        @Deprecated
    ]]
    -- if os.time() - lastWalkingUpdateTime >= intervalWalkingUpdateSecond then
    --     -- print("OnGameRunning: last", lastPlayerX, lastPlayerY, lastPlayerZ)
    --     SimplyMoveSelectedBlock();
        -- lastPlayerX, lastPlayerY, lastPlayerZ = curPlayerX, curPlayerY, curPlayerZ
    --     lastPlayerXInt, lastPlayerYInt, lastPlayerZInt = math.floor(lastPlayerX), math.floor(lastPlayerY), math.floor(lastPlayerZ)
        -- print("OnGameRunning: cur", curPlayerX, curPlayerY, curPlayerZ)
    --     lastWalkingUpdateTime = os.time()
    -- end

    --[[
        @Deprecated
    ]]
    -- local intervalX = curPlayerXInt - lastPlayerXInt
    -- local intervalZ = curPlayerZInt - lastPlayerZInt
    -- print("OnGameRunning: interval", intervalX, intervalZ)
    -- if curPlayerYInt == lastPlayerYInt and (intervalX == 1 or intervalX == -1 or intervalZ == 1 or intervalZ == -1) then
        -- print("OnGameRunning: last", lastPlayerX, lastPlayerY, lastPlayerZ)
        -- SimplyMoveSelectedBlock();
        -- print("OnGameRunning: cur", curPlayerX, curPlayerY, curPlayerZ)
        -- lastWalkingUpdateTime = os.time()
    -- end

    BlocksFallingOff:clear()

    if BlocksPulling:canPullBackward() then 
        -- print("OnGameRunning(): can pull backward")
        --[[
            @Deprecated
        ]]
        -- SimplyMoveSelectedBlock();
        -- BlocksPulling.collectStackDepth = 0
        -- print("OnGameRunning(): last", lastPlayerX, lastPlayerY, lastPlayerZ)
        -- print("OnGameRunning(): cur", curPlayerX, curPlayerY, curPlayerZ)
        local axisOrientation = AxisOrientation:getAccurateAxisOrientation(lastPlayerXInt, curPlayerYInt, lastPlayerZInt, curPlayerXInt, curPlayerYInt, curPlayerZInt)
        -- local axisOrientation = AxisOrientation:getAccurateAxisOrientation(Selection.x, curPlayerYInt, Selection.z, curPlayerXInt, curPlayerYInt, curPlayerZInt)
        -- print("OnGameRunning(): axisOrientation = ", axisOrientation)
        if AxisOrientation:isOnALine(axisOrientation) then
            -- print("OnGameRunning(): is on a line")
            BlocksPulling:setAxisOrientation(axisOrientation)
            BlocksPulling:checkAndMove(Selection.x, Selection.y, Selection.z, Selection:getBlockID())
        end
        -- SimplyMoveSelectedBlock()
    elseif BlocksPushing:canPushForward() then
        print("OnGameRunning(): can push forward")
        --[[
            @Deprecated
        ]]
        -- PushRowForward()

        -- local axisOrientation = AxisOrientation:getAccurateAxisOrientation(lastPlayerXInt, curPlayerYInt, lastPlayerZInt, curPlayerXInt, curPlayerYInt, curPlayerZInt)
        local axisOrientation = AxisOrientation:getAccurateAxisOrientation(lastPlayerX, curPlayerYInt, lastPlayerZ, curPlayerX, curPlayerYInt, curPlayerZ)
        -- local axisOrientation = AxisOrientation:getAccurateAxisOrientation(Selection.x, curPlayerYInt, Selection.z, curPlayerXInt, curPlayerYInt, curPlayerZInt)
        print("OnGameRunning(): axisOrientation = ", axisOrientation)
        if AxisOrientation:isOnALine(axisOrientation) then
            print("OnGameRunning(): is on a line")
            BlocksPushing:setAxisOrientation(axisOrientation)
            BlocksPushing:checkAndMove(Selection.x, Selection.y, Selection.z, Selection:getBlockID())
        end
    -- elseif curPlayerXInt ~= Selection.x and curPlayerZInt ~= Selection.z then
    --     -- print("OnGameRunning(): not standing on a line with selected block")
    --     Selection:disselect()
    end

    if os.time() - lastSteppingUpdateTime >= intervalSteppingUpdateSecond then 
        FragileBlockHPManager:onUpdateAll()
        SteppingOnBlock(lastPlayerXInt, lastPlayerYInt-1, lastPlayerZInt)
        lastSteppingUpdateTime = os.time()
    end

    lastPlayerX, lastPlayerY, lastPlayerZ = curPlayerX, curPlayerY, curPlayerZ
    lastPlayerXInt, lastPlayerYInt, lastPlayerZInt = math.floor(lastPlayerX), math.floor(lastPlayerY), math.floor(lastPlayerZ)
end

-----------------------------------------------------------------Game_Start-----------------------------------------------------------------

--[[
    self testing
]]
local function CreateRandomBlock(x, y, z)
    local randomIndex = math.random(#TRIGGERED_BLOCKS + 1);
    -- Block:placeBlock(TRIGGERED_BLOCKS[randomIndex], x, y, z)
    Block:setBlockAll(x, y, z, TRIGGERED_BLOCKS[randomIndex])
end

--[[
    self testing
]]
local function PavingFloor(targetX, targetZ)
    targetX = targetX or 30
    targetZ = targetZ or 30
    local y = 6
    local randomIndex
    for x=-targetX, targetX, 1 do for z=-targetZ, targetZ, 1 do
        CreateRandomBlock(x, y, z)
    end end
end

--[[
    self testing
]]
local function ClearLandingBlocks(targetX, targetZ)
    targetX = targetX or 30
    targetZ = targetZ or 30
    local y = 7
    for x=-targetX, targetX, 1 do for z=-targetZ, targetZ, 1 do
        Block:destroyBlock(x, y, z)
    end end
end

--[[
    self testing
]]
local function CreateLightBlocks(count)
    count = count or 20
    local squareSide = 20
    for i=1, count do 
        local x = math.random(-squareSide, squareSide)
        local y = math.random(12, 32)
        local z = math.random(-squareSide, squareSide)
        Block:setBlockAll(x, y, z, BLOCK_PUMPKIN_LAMP)
    end
    squareSide = squareSide * 3
    count  = count * 3
    local y = 7
    for i=1, count do 
        local x = math.random(-squareSide, squareSide)
        local z = math.random(-squareSide, squareSide)
        Block:setBlockAll(x, y, z, BLOCK_TORCH)
        -- Block:placeBlock(ITEM_TORCH, x, y, z)
    end
end

local function CreatePartBlocks(fromX, fromZ, toX, toZ)
    local intervalX = fromX < toX and 1 or -1
    local intervalZ = fromZ < toZ and 1 or -1
    local fromY = 7
    for x=fromX, toX, intervalX do for z=fromZ, toZ, intervalZ do
        local toY = x+z <= fromY and fromY or x+z
        for y=fromY, toY, 1 do
            CreateRandomBlock(x, y, z)
        end
    end end
end

--[[
    自测试创建随机方块
]]
local function CreateBlocks(fromX, fromZ, toX, toZ)
    -- print("CreateBlock: ")
    local randomIndex;
    fromX = fromX or 10
    fromZ = fromX
    toX = toX or 20
    toZ = toX
    local middleX = math.floor((fromX + toX) /2)
    local middleZ = math.floor((fromZ + toZ) /2)

    -- CreatePartBlocks(fromX, fromZ, middleX, middleZ)
    local fromY = 7
    for x=-toX, toX, 1 do for z=fromZ, toZ, 1 do 
        local yStart = fromY
        -- local yEnd = math.random(yStart, yStart+x+z)
        local yEnd = math.random(yStart, yStart+x+math.abs(z))
        local y=yStart
        while y <= yEnd do
            CreateRandomBlock(x, y, z)
            y = y + math.random(1, 3)
        end 
    end end     

    for x=-toX, toX, 1 do for z=-fromZ, -toZ, -1 do 
        local yStart = fromY
        -- local yEnd = math.random(yStart, yStart+x+z)
        -- local yEnd = math.random(yStart, yStart+math.abs(x)+math.abs(z))
        local yEnd = math.random(yStart, yStart+math.abs(x)+z)
        local y=yStart
        while y <= yEnd do
            CreateRandomBlock(x, y, z)
            y = y + math.random(1, 3)
        end 
    end end
end
--[[
    self testing
]]
local function CreateFragileBlocks(fromX, fromZ, toX, toZ)
    fromX = fromX or -20
    toX = toX or -40
    fromZ = fromZ or -toX
    toZ = toZ or toX
    local y = 7
    local intervalX = fromX < toX and 1 or -1
    local intervalZ = fromZ < toZ and 1 or -1
    for x=fromX, toX, intervalX do for z=fromZ, toZ, intervalZ do 
        Block:setBlockAll(x, y, z, BLOCK_FRAGILE)
    end end
end


OnGameStarted = function(args)
    _, myUin = Player:getMainPlayerUin()
    -- ClearLandingBlocks()
    Chat:sendChat(tostring(myUin))
    -- PavingFloor()
    -- CreateBlocks()
    -- CreateLightBlocks()
    -- CreateFragileBlocks()
    -- Player:gainItems(myUin, BLOCK_TORCH, 50, BACKPACK_TYPE.SHORTCUT)

    local TriggerFactorToMethod = _G.TriggerFactorToMethod
    local key = 10001
    local className = TriggerFactorToMethod[key][2]
    local methodName = TriggerFactorToMethod[key][1]
    local class = _G[className]
    local method = class[methodName]
    method(class)
    Chat:sendChat("ok")
end

-----------------------------------------------------------------OnGameLoaded-----------------------------------------------------------------
--计算游戏结果
function Battle_Ended(teamId, retType)

end

--游戏结算界面
function ShowGBattleUI()
    -- 设置排行/分数
    local ret, rank = Player:getGameRanking()
    if not rank or rank==0 then rank = 1 end
    local ret, score = Player:getGameScore()

    -- 队伍数量及成员量
    local ret1, teamNum = Team:getNumTeam()
    local ret2, redNum = Team:getTeamPlayers(Teamx.red)
    local ret3, blueNum = Team:getTeamPlayers(Teamx.blue)
    local totalPlayers = 1
    if ret2==ErrorCode.OK and ret3==ErrorCode.OK then
        totalPlayers = redNum+blueNum
    end

    local ret, txtTitle = Game:getDefString(rank==1 and 8028 or 8029)
    local ret, txtTRank = Game:getDefString(8032)
    local ret, txtRanker = Game:getDefString(8030)
    local ret, txtDefeat = Game:getDefString(3176)
    UI:setGBattleUI('left_title', txtTRank..tostring(rank))--第1/1
    UI:setGBattleUI('right_title', "/"..totalPlayers)
    UI:setGBattleUI('left_desc', txtTitle)--大吉大利/继续努力
    UI:setGBattleUI('left_little_desc', txtRanker..tostring(rank))--排名
    UI:setGBattleUI('right_little_desc', txtDefeat..tostring(score))--得分
    UI:setGBattleUI('battle_btn', false)
    UI:setGBattleUI('result', false)
    UI:setGBattleUI('result_bkg', false)
    UI:setGBattleUI('reopen', true)
end

local function InitGameRule()
    GameRule.CurTime = 9 --当前时间
    GameRule.TimeLocked = 1 --锁定时间
	GameRule.EndTime = 60  		 --游戏时长
	GameRule.TeamNum = 2         --队伍数量
	GameRule.MaxPlayers = 4      --最大玩家量
	GameRule.StartMode = 0       --开启模式 0:主开
	GameRule.StartPlayers = 1    --最低玩家量 2人
	GameRule.PlayerDieDrops = 0  --死亡掉落 1:true
	GameRule.DisplayScore = 1    --显示比分 1:true
	GameRule.AllowMidwayJoin = 0 --中途加入 1:允许
	GameRule.ScoreKillPlayer = 0 --击杀玩家 得1分
	GameRule.BlockDestroy = 0    --方块可被摧毁 1:true
    GameRule.WinLoseEndTime = 0  --游戏超时结束则全胜
    -- GameRule.CameraDir = 1 -- 相机视角模式: 0/1/2:缺省主视角/正视角/背视角, 3/4/5/6:锁定主视角/正视角/背视角/俯视角
    GameRule.GravityFactor = 1.0 --重力参数
   GameRule.MobGen = 0 --是否刷怪: -1:按创建的选项刷, 0:不刷, 1:刷
end

OnGameLoaded = function()
	tickCount = 0
	itemcTime = 0
    math.randomseed(os.time())
    InitGameRule()

    local ret, actorId = Player:getMainPlayerUin();
end

--[[
    function to be invoked by game_main.lua
]]
function ListenEvents_PushingClimbing()
	-- 监听事件
	local ScriptSupportEvent = class.ScriptSupportEvent.new()

    local events = {}
	--{{{ 注册游戏事件
	events.event_game_loaded = OnGameLoaded
	events.event_game_started = OnGameStarted
	events.event_game_run = OnGameRunning--每tick调
	events.event_game_ended = OnGameEnded
	events.event_game_timeover = OnGameTimeOver

	-- 玩家响应事件
	-- events.event_player_inited = Player_Inited
	-- events.event_player_dead = Player_Dead
	-- events.event_player_revived = Player_Revive
	-- events.event_player_enterteam = Player_EnterTm
	-- 怪物响应事件
	-- events.event_mob_dead = Monster_Dead
	-- 背包响应事件
	-- events.event_backpack_additem = BackPack_AddItem

	-- 方块响应事件
    -- events.event_block_placedby      = OnBlockPlacedBy        --function(x, y, z, blockid, byactor) end,
    -- events.event_block_trigger       = OnBlockTriggered         --function(x, y, z, blockid, byactor) end,
    -- events.event_block_actorcollided = OnBlockCollided   --function(x, y, z, blockid, byactor) end,
    -- events.event_block_actorwalking  = OnBlockWalkedOn    --function(x, y, z, blockid, byactor) end,
    -- events.event_block_fertilized    = OnBlockFertilized      --function(x, y, z, blockid, fertilizer) end,
    -- events.event_block_begindig = OnBlockBeginningBeingDug

    -- events.event_block_added         = Block_added           --function(x, y, z, blockid) end,
    -- events.event_block_removed       = Block_removed         --function(x, y, z, blockid) end,
    -- events.event_block_endeddig = OnBlockFinishingBeingDug
    -- events.event_block_canceldig = OnBlockCancellingBeingDug

    local allBlocksConditions = {
        {BLOCK_NORMAL},
        {BLOCK_PURPLE_FLUORESCENCE},
        {BLOCK_STAR_COPPER},
        {BLOCK_FRAGILE},
    }
    local selectingConditions = {
        {BLOCK_NORMAL},
        {BLOCK_PURPLE_FLUORESCENCE},
        {BLOCK_STAR_COPPER},
        {BLOCK_FRAGILE},
        {BLOCK_MARK},
    }
    -- events.reg_trigger_listen_conditions = selectingConditions
    events.reg_begindig_listen_conditions = allBlocksConditions
    -- events.reg_placedby_listen_conditions = selectingConditions
    -- events.reg_endeddig_listen_conditions = allBlocksConditions
    events.reg_actorcollided_listen_conditions = allBlocksConditions
    -- events.reg_fertilized_listen_conditions = selectingConditions
    events.reg_actorwalking_listen_conditions = {
        {BLOCK_FRAGILE},
        {BLOCK_TRAP}
    }

	ScriptSupportEvent:register(events)
end