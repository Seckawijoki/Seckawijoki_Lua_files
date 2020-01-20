require "utils/MVPUtils"

local AREngineView = {

}

function AREngineView:init()

end

function AREngineView:test()

end

local AbsAREngineModel = {
    m_iPartTypeIndex = 1,
    skinPartDefs = {},
    skinPartTypeDefs = {},
    tryOnSkinParts = {},
}

function AbsAREngineModel:init()
    self.__index = self;
end

function AbsAREngineModel:onGameEvent(arg1)
    
end

function AbsAREngineModel:requestOrganizeSkinPartDefs()
    print("requestOrganizeSkinPartDefs(): ");
end

--------------------------HuaweiAREngineModel--------------------------
local HuaweiAREngineModel = {

}
-----------------------------------------------------AbsAREngineModel end-----------------------------------------------------

-----------------------------------------------------AREnginePresenter start-----------------------------------------------------
local AREnginePresenter = {

}

--[[
    
    Created on 2019-09-03 at 11:40:23
]]
function AREnginePresenter:init()
    AbsAREngineModel.__index = AbsAREngineModel
    setmetatable(HuaweiAREngineModel, AbsAREngineModel);
    MVPUtils:registerSelfViewModel(self, AREngineView, HuaweiAREngineModel);
end
-----------------------------------------------------AREnginePresenter end-----------------------------------------------------

AREnginePresenter:init()
_G.AREnginePresenter = AREnginePresenter

AREnginePresenter.m_clsModel["requestOrganizeSkinPartDefs"](AREnginePresenter.m_clsModel);