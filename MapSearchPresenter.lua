_G.MVPUtils = {
    DEBUG_MODE = false,
}

function MVPUtils.RegisterDisplayFunctionFromView(clsPresenter, clsView)
    clsView.DEBUG_MODE = DEBUG_MODE;
    local szPresenterFuncName
    for szFuncName, func in pairs(clsView) do 
        if string.sub(szFuncName, 1, 9) == "onDisplay" and type(func) == "function" then 
            szPresenterFuncName = "display" .. string.sub(szFuncName, 10);
            clsPresenter[szPresenterFuncName] = function(self, ...)
                print("MapSearchPresenter:display" .. szFuncName);
                if self.DEBUG_MODE then
                    clsView[szFuncName](clsView, ...);
                elseif clsView[szFuncName] then
                    clsView[szFuncName](clsView, ...);
                end
            end
        end
    end
end

function MVPUtils.RegisterRequestFunctionFromModel(clsPresenter, clsModel)
    clsModel.DEBUG_MODE = MVPUtils.DEBUG_MODE;
    for szFuncName, func in pairs(clsModel) do 
        if string.sub(szFuncName, 1, 9) == "onRequest" and type(func) == "function" then 
            szPresenterFuncName = "request" .. string.sub(szFuncName, 10);
            clsPresenter[szPresenterFuncName] = function(self, ...)
                print("MapSearchPresenter:request" .. szFuncName);
                if self.DEBUG_MODE then
                    clsModel[szFuncName](clsModel, ...);
                elseif clsModel[szFuncName] then
                    clsModel[szFuncName](clsModel, ...);
                end
            end
        end
    end
end

function MVPUtils.RegisterSelfViewModel(clsPresenter, clsView, clsModel) 
    local MVPUtils = _G.MVPUtils;
    --记录本View和Model
    clsPresenter.m_clsView = clsView;
    clsPresenter.m_clsModel = clsModel;
    --统一注册Presenter函数
    MVPUtils.RegisterDisplayFunctionFromView(clsPresenter, clsView);
    MVPUtils.RegisterRequestFunctionFromModel(clsPresenter, clsModel);
    --记录Presenter
    clsView.mCallback = clsPresenter;
    clsModel.mCallback = clsPresenter;
    --本模块初始化
    clsView:Init();
    clsModel:Init();
end

-- function MVPUtils.AddViewToPresenter(clsPresenter, clsView)
--     local DEBUG_MODE = MVPUtils.DEBUG_MODE;
--     clsView.mActionCallback = clsPresenter;
--     if not clsPresenter.m_aViewList then clsPresenter.m_aViewList = {} end
--     local aViewList = clsPresenter.m_aViewList;
--     aViewList[#aViewList + 1] = clsView;
-- end

-- function MVPUtils.RegisterDisplayFunctionFromViewToList(clsPresenter, clsView)
--     local DEBUG_MODE = MVPUtils.DEBUG_MODE;
--     local aViewList = clsPresenter.m_aViewList or {}
--     local szPresenterFuncName
--     for szFuncName, func in pairs(clsView) do 
--         if string.sub(szFuncName, 1, 9) == "onDisplay" and type(func) == "function" then 
--             szPresenterFuncName = "display" .. string.sub(szFuncName, 10);
--             clsPresenter[szPresenterFuncName] = function(self, ...)
--                 print("MapSearchPresenter:On" .. szFuncName);
--                 --回调本View
--                 if self.DEBUG_MODE then
--                     clsView[szFuncName](clsView, ...);
--                 elseif clsView[szFuncName] then
--                     clsView[szFuncName](clsView, ...);
--                 end
--                 --回调其它View
--                 if self.DEBUG_MODE then 
--                     for i=1 , #aViewList do 
--                         aViewList[i][szFuncName](aViewList[i], ...);
--                     end
--                 else
--                     for i=1 , #aViewList do if aViewList[i][szFuncName] then
--                             aViewList[i][szFuncName](aViewList[i], ...);
--                     end end
--                 end
--             end
--         end
--     end
-- end

--[[
    Multi View to one Model via one Presenter
]]
_G.MapSearchPresenter = {
    m_clsView = nil,
    m_clsModel = nil,
    m_aViewList = {},
}

GameEventQue = {

}
function GameEventQue:postOnClickListener(szUIName)
    MapSearchPresenter.m_clsView:OnGameEvent(szUIName);
end

function MapSearchPresenter:Init()
    require("MapSearchView");
    require("MapSearchModel");
    MVPUtils.RegisterSelfViewModel(self, MapSearchView, MapSearchModel);
end

function MapSearchPresenter:OnLoad()
	-- this:RegisterEvent("GE_MVP_ON_CLICK_LISTENER");
end

function MapSearchPresenter:PostOnClickListener(szUIName)
    -- GameEventQue:postOnClickListener(this:GetName());
    GameEventQue:postOnClickListener(szUIName);
end

MapSearchPresenter:Init();