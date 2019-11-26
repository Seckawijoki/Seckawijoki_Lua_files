
--------------------------------------------------------MVPUtils start----------------------------------------------------------
_G.MVPUtils = {
	DEBUG_MODE = true,
}

function MVPUtils:registerDisplayFunctionFromView(clsPresenter, clsView)
    clsView.DEBUG_MODE = self.DEBUG_MODE;
    local szPresenterFuncName
    for szFuncName, func in pairs(clsView) do 
        if string.sub(szFuncName, 1, 7) == "display" and type(func) == "function" then 
            szPresenterFuncName = "display" .. string.sub(szFuncName, 8);
            clsPresenter[szPresenterFuncName] = function(self, ...)
                -- print("Presenter@" .. tostring(self) .. ":" .. szFuncName);
                if self.DEBUG_MODE then
                    clsView[szFuncName](clsView, ...);
                elseif clsView[szFuncName] then
                    clsView[szFuncName](clsView, ...);
                end
            end
        end
    end
end

function MVPUtils:registerRequestFunctionFromModel(clsPresenter, clsModel)
    clsModel.DEBUG_MODE = self.DEBUG_MODE;
    for szFuncName, func in pairs(clsModel) do 
        if string.sub(szFuncName, 1, 7) == "request" and type(func) == "function" then 
            szPresenterFuncName = "request" .. string.sub(szFuncName, 8);
            clsPresenter[szPresenterFuncName] = function(self, ...)
                -- print("Presenter@" .. tostring(self) .. ":" .. szFuncName);
                if self.DEBUG_MODE then
                    clsModel[szFuncName](clsModel, ...);
                elseif clsModel[szFuncName] then
                    clsModel[szFuncName](clsModel, ...);
                end
            end
        end
    end
end

function MVPUtils:registerGameEventFunction(clsPresenter)
	clsPresenter.onGameEvent = function(self, arg1)
		-- print("Presenter@" .. tostring(self) .. ":onGameEvent(): arg1 = " .. arg1);
		self.m_clsView:onGameEvent(arg1)
		self.m_clsModel:onGameEvent(arg1)
	end
end

function MVPUtils:registerSelfViewModel(clsPresenter, clsView, clsModel) 
    --1.记录本View和Model
    clsPresenter.m_clsView = clsView;
    clsPresenter.m_clsModel = clsModel;
    --2.统一注册Presenter函数
    self:registerDisplayFunctionFromView(clsPresenter, clsView);
	self:registerRequestFunctionFromModel(clsPresenter, clsModel);
	self:registerGameEventFunction(clsPresenter)
    --3.记录Presenter
    clsView.mCallback = clsPresenter;
    clsModel.mCallback = clsPresenter;
    --4.本模块初始化
    clsView:init();
    clsModel:init();
end
--------------------------------------------------------MVPUtils end----------------------------------------------------------
