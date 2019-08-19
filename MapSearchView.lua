local MapSearchType = {
    AUTHOR_UIN = 1,
    AUTHOR_NAME = 2,
    MAP_NAME = 3,
}

MapSearchView = {
    mCallback = nil,
    m_btnSearch = nil,
    m_iMapSearchType = MapSearchType.AUTHOR_UIN,
    m_aSearchFunctionDispatcher = {

    },
};

function MapSearchView:Init()
    self.m_aSearchFunctionDispatcher[MapSearchType.AUTHOR_UIN] = function()
        local uin = 204914649;
        self.mCallback:requestSearchByAuthorUin(uin, true);
    end;

    self.m_aSearchFunctionDispatcher[MapSearchType.AUTHOR_NAME] = function()
        local szAuthorName = "seckawijoki";
        self.mCallback:requestSearchByAuthorName(szAuthorName);
    end;

    self.m_aSearchFunctionDispatcher[MapSearchType.MAP_NAME] = function()
        local szMapName = "地图名字";
        self.mCallback:requestSearchByMapName(szMapName);
    end;
end

function MapSearchView:onDisplaySearchByAuthorUin(...)
    print("MapSearchView:onDisplaySearchByAuthorUin:");
end

function MapSearchView:onDisplaySearchByAuthorName(...)
    print("MapSearchView:onDisplaySearchByAuthorName:");
end

function MapSearchView:onDisplaySearchByMapName(...)
    print("MapSearchView:onDisplaySearchByMapName:");
end

function MapSearchView:OnGameEvent(arg1)
    -- if not arg1 == "GE_MVP_ON_CLICK_LISTENER" then return end
    -- local ge = GameEventQue:getCurEvent();
    -- local szUINname = ge.uiname;
    local szUINname = arg1;
    print("MapSearchView:OnGameEvent: szUINname = ", szUINname);

    if szUINname == "MiniWorksFrameSearchInputBtn" then 
        print("MapSearchView:OnGameEvent: self.m_iMapSearchType = ", self.m_iMapSearchType);
        self.m_aSearchFunctionDispatcher[self.m_iMapSearchType]();
        self.m_iMapSearchType = (self.m_iMapSearchType) %3 + 1;
    end
end

return MapSearchView;