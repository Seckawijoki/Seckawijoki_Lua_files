_G.MVPCommonUtils = {
    m_bDebugMode = true,
}
function MVPCommonUtils.AddViewToPresenter(clsPresenter, clsView)
    local bDebugMode = MVPCommonUtils.bDebugMode;
    clsView.m_clsPresenter = clsPresenter;
    if not clsPresenter.m_aViewList then clsPresenter.m_aViewList = {} end
    local aViewList = clsPresenter.m_aViewList;
    aViewList[#aViewList + 1] = clsView;
end

function MVPCommonUtils.RegisterDisplayFunctionFromView(clsPresenter, clsView)
    local bDebugMode = MVPCommonUtils.bDebugMode;
    local aViewList = clsPresenter.m_aViewList or {}
    for szFuncName, func in pairs(clsView) do 
        if string.sub(szFuncName, 1, 7) == "Display" and type(func) == "function" then 
            clsPresenter["On" .. szFuncName] = function(self, ...)
                print("MapSearchPresenter:On" .. szFuncName);
                --回调本View
                if bDebugMode then
                    clsView[szFuncName](clsView, ...);
                elseif clsView[szFuncName] then
                    clsView[szFuncName](clsView, ...);
                end
                --回调其它View
                if bDebugMode then 
                    for i=1 , #aViewList do 
                        aViewList[i][szFuncName](aViewList[i], ...);
                    end
                else
                    for i=1 , #aViewList do if aViewList[i][szFuncName] then
                            aViewList[i][szFuncName](aViewList[i], ...);
                    end end
                end
            end
        end
    end
end

function MVPCommonUtils.RegisterRequestFunctionFromModel(clsPresenter, clsModel)
    local bDebugMode = MVPCommonUtils.bDebugMode;
    for szFuncName, func in pairs(clsModel) do 
        if string.sub(szFuncName, 1, 7) == "Request" and type(func) == "function" then 
            clsPresenter["On" .. szFuncName] = function(self, ...)
                print("MapSearchPresenter:On" .. szFuncName);
                if bDebugMode then
                    clsModel[szFuncName](clsModel, ...);
                elseif clsModel[szFuncName] then
                    clsModel[szFuncName](clsModel, ...);
                end
            end
        end
    end
end

function MVPCommonUtils.RegisterSelfViewModel(clsPresenter, clsView, clsModel) 
    local MVPCommonUtils = _G.MVPCommonUtils;
    --记录本View和Model
    clsPresenter.m_clsView = clsView;
    clsPresenter.m_clsModel = clsModel;
    --统一注册Presenter函数
    MVPCommonUtils.RegisterDisplayFunctionFromView(clsPresenter, clsView);
    MVPCommonUtils.RegisterRequestFunctionFromModel(clsPresenter, clsModel);
    --记录Presenter
    clsView.m_clsPresenter = clsPresenter;
    clsModel.m_clsPresenter = clsPresenter;
    --本模块初始化
    clsView:Init();
    clsModel:Init();
end

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
    MVPCommonUtils.RegisterSelfViewModel(self, MapSearchView, MapSearchModel);
end

function MapSearchPresenter:OnLoad()
	-- this:RegisterEvent("GE_MVP_ON_CLICK_LISTENER");
end

function MapSearchPresenter:PostOnClickListener(szUIName)
    -- GameEventQue:postOnClickListener(this:GetName());
    GameEventQue:postOnClickListener(szUIName);
end

MapSearchPresenter:Init();