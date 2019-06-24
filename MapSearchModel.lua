MapSearchModel = {
    m_clsPresenter = nil,
};

function MapSearchModel:Init()

end

function MapSearchModel:RequestSearchByAuthorUin(uin, boolean)
    uin = tonumber(uin);
    print("MapSearchModel:RequestSearchByAuthorUin: uin = ", uin);
    print("MapSearchModel:RequestSearchByAuthorUin: boolean = ", boolean);
    self.m_clsPresenter:OnDisplaySearchByAuthorUin();
end

function MapSearchModel:RequestSearchByAuthorName(szAuthorName)
    szAuthorName = tostring(szAuthorName);
    print("MapSearchModel:RequestSearchByAuthorName: szAuthorName = ", szAuthorName);
    self.m_clsPresenter:OnDisplaySearchByAuthorName();
end

function MapSearchModel:RequestSearchByMapName(szMapName)
    szMapName = tostring(szMapName);
    print("MapSearchModel:RequestSearchByMapName: szMapName = ", szMapName);
    self.m_clsPresenter:OnDisplaySearchByMapName();
end

return MapSearchModel;