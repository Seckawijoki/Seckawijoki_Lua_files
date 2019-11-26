MapSearchModel = {
    mCallback = nil,
};

function MapSearchModel:Init()

end

function MapSearchModel:onRequestSearchByAuthorUin(uin, boolean)
    uin = tonumber(uin);
    print("MapSearchModel:onRequestSearchByAuthorUin: uin = ", uin);
    print("MapSearchModel:onRequestSearchByAuthorUin: boolean = ", boolean);
    self.mCallback:displaySearchByAuthorUin();
end

function MapSearchModel:onRequestSearchByAuthorName(szAuthorName)
    szAuthorName = tostring(szAuthorName);
    print("MapSearchModel:onRequestSearchByAuthorName: szAuthorName = ", szAuthorName);
    self.mCallback:displaySearchByAuthorName();
end

function MapSearchModel:onRequestSearchByMapName(szMapName)
    szMapName = tostring(szMapName);
    print("MapSearchModel:onRequestSearchByMapName: szMapName = ", szMapName);
    self.mCallback:displaySearchByMapName();
end

return MapSearchModel;