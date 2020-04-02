--解释器模式
require "lfs"
require("ClassesCache")
require("StringUtil")
local ARRAY_KEY_WORDS = {
    "function",
    "local",
    "do",
    "end",
    "for",
    "in",
}

--------------------------------------------------------------模板--------------------------------------------------------------
local AbsModelExp = {

}
setmetatable(AbsModelExp, AbsExp)
AbsModelExp.__index = AbsModelExp;
function AbsModelExp:interpret(sz, index)
    
end
--------------------------------------------------------------抽象类--------------------------------------------------------------
local AbsExp = {

}
_G.AbsExp = AbsExp
AbsExp.__index = AbsExp
function AbsExp:init()
    self.m_aExps = {}
end

function AbsExp:onRecycle()
    self.m_aExps = {}
end

function AbsExp:toString()
    local aExps = self.m_aExps
    local toString
    if aExps and #aExps > 0 then
        toString = {}
        for i=1, aExps do 
            toString[#toString + 1] = aExps[i]:toString();
        end
        toString = table.concat(toString);
    else
        toString = tostring(self);
    end
    return toString
end

function AbsExp:addExp(Exp)
    self.m_aExps[#self.m_aExps + 1] = Exp
end

function AbsExp:interpret(sz, index)
    
end
--------------------------------------------------------------boolean语句--------------------------------------------------------------
local AbsBooleanExp = {

}
setmetatable(AbsBooleanExp, AbsExp)
AbsBooleanExp.__index = AbsBooleanExp;
function AbsBooleanExp:interpret(sz, index)
    
end
--------------------------------------------------------------结束语句--------------------------------------------------------------
local AbsEndExp = {

}
setmetatable(AbsEndExp, AbsExp)
AbsEndExp.__index = AbsEndExp;
function AbsEndExp:interpret(sz, index)

end
--------------------------------------------------------------值语句--------------------------------------------------------------
local AbsVariableExp = {

}
setmetatable(AbsVariableExp, AbsExp)
AbsVariableExp.__index = AbsVariableExp;
function AbsVariableExp:interpret(sz, index)

end
--------------------------------------------------------------赋值语句--------------------------------------------------------------
local AbsAssignExp = {

}
setmetatable(AbsAssignExp, AbsExp)
AbsAssignExp.__index = AbsAssignExp;
function AbsAssignExp:interpret(sz, index)
    for i=index, #sz do 
        if sz[i] ~= ' ' and sz[i] ~= ';' then
            
        end
    end
end
--------------------------------------------------------------申明语句--------------------------------------------------------------
local AbsDeclareExp = {

}
setmetatable(AbsDeclareExp, AbsExp)
AbsDeclareExp.__index = AbsDeclareExp;
function AbsDeclareExp:init()
    super:init();
    self.m_szVarName = "";
end

function AbsDeclareExp:interpret(sz, index)
    local headLetter = sz[index]
    if tonumber(headLetter) then
        error("gramma error: variable name starts with number")
        assert(false)
    end
    
    local resultIndex = -1
    for i=index, #sz do 
        if sz[i] == ' ' or sz[i] == '\n' then
            local szVarName = string.sub(sz, index, i - 1);
            szVarName = string.trim(szVarName)
            self.m_szVarName = szVarName;
        elseif sz[i] == ';' then
            local szVarName = string.sub(sz, index, i - 1);
            szVarName = string.trim(szVarName)
            self.m_szVarName = szVarName;
            resultIndex = i + 1
            return i + 1
        elseif sz[i] == '=' then
            local AssignExp = ExpUtils:newAssignExp()
            AssignExp:init();
            local resultIndex = AssignExp:interpret(sz, i+1);
            self:addExp(AssignExp)
        else
            return i
        end
    end

    if resultIndex >= 0 then

    end
    
    return resultIndex
end
--------------------------------------------------------------local 语句--------------------------------------------------------------
local AbsLocalExp = {

}
setmetatable(AbsLocalExp, AbsExp)
AbsLocalExp.__index = AbsLocalExp;
function AbsLocalExp:interpret(sz, index)
    if string.sub(sz, index, index+4) ~= "local" do 
        if sz[index+5] ~= ' ' then
            error("gramma error: after local")
            assert(false)
        end
        local DeclareExp = ExpUtils:newDeclareExp()
        i = DeclareExp:interpret(sz, i+6)
        self:addExp(DeclareExp)
    end
end
--------------------------------------------------------------do end 语句--------------------------------------------------------------
local AbsDoEndExp = {

}
setmetatable(AbsDoEndExp, AbsExp)
AbsDoEndExp.__index = AbsDoEndExp;
function AbsDoEndExp:interpret(sz, index)
    
end
--------------------------------------------------------------函数--------------------------------------------------------------
local AbsFuncExp = {

}
setmetatable(AbsFuncExp, AbsExp)
AbsFuncExp.__index = AbsFuncExp;
function AbsFuncExp:interpret(sz, index)
    
end
--------------------------------------------------------------文件--------------------------------------------------------------
local AbsFileExp = {

}
setmetatable(AbsFileExp, AbsExp)
AbsFileExp.__index = AbsFileExp;
function AbsFileExp:interpret(sz, index)
    if not sz or type(sz) ~= "string" or #sz <= 0 then return end
    if not index then
        index = 1
    end
    if index > #sz then
        return
    end
    local aExps = self.m_aExps
    local resultIndex
    for i=index, #sz do 
        if string.sub(sz, i, i+4) == "local" then
            local LocalExp = ExpUtils:newLocalExp()
            i = LocalExp:interpret(sz, i)
            self:addExp(LocalExp)
        end
    end
end
----------------------------------------------------------------------------------------------------------------------------
local ExpUtils = {

}
_G.ExpUtils = ExpUtils
function ExpUtils:interpret(sz)
    if not sz or type(sz) ~= "string" or #sz <= 0 then return nil end
    local FileExp = self:newFileExp()
    FileExp:interpret(sz)
    return FileExp
end

function ExpUtils:newAssignExp()
    local AssignExp = ClassesCache:obtain("AssignExp");
    ClassesCache:insertSuperClass(AssignExp, AbsAssignExp)
    AssignExp:init();
    return AssignExp;
end

function ExpUtils:newDeclareExp()
    local DeclareExp = ClassesCache:obtain("DeclareExp");
    ClassesCache:insertSuperClass(DeclareExp, AbsDeclareExp)
    DeclareExp:init();
    return DeclareExp;
end

function ExpUtils:newLocalExp()
    local LocalExp = ClassesCache:obtain("LocalExp");
    ClassesCache:insertSuperClass(LocalExp, AbsLocalExp)
    LocalExp:init();
    return LocalExp;
end

function ExpUtils:newFileExp()
    local FileExp = ClassesCache:obtain("FileExp");
    ClassesCache:insertSuperClass(FileExp, AbsFileExp)
    FileExp:init();
    return FileExp;
end

function ExpUtils:newFuncExp()
    local FuncExp = ClassesCache:obtain("FuncExp");
    ClassesCache:insertSuperClass(FuncExp, AbsFuncExp)
    FuncExp:init();
    return FuncExp;
end
----------------------------------------------------------------------------------------------------------------------------

local function mix()
    local szPath = "MixtureTest.lua"
    local file = io.open(szPath, "r")
    local sz = file:read("*all")
    print("mix(): sz = " + sz);
    local Exp = ExpUtils:interpret(sz);
    print("mix(): Exp = " + Exp);
end

mix();
