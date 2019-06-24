-- 简版
_G.Lite = {
    m_funcGetGlobal = nil,

    m_mUiNameToUiObject = {

    },

    API_ID_TO_UI_NAMES_MAP = {
        -- 移动简版
        [516] = {

        },

        -- PC简版
        [616] = {
            ["MiniLobbyFrameBottomShop"] = true,
        },
    }
}

Lite.API_ID_TO_UI_NAMES_MAP[999] = Lite.API_ID_TO_UI_NAMES_MAP[616];

function Lite:SetUi(szUiName, ...)
    local apiIdToUiNamesMap = self.API_ID_TO_UI_NAMES_MAP[999];
    if not apiIdToUiNamesMap then return end

    if not self.m_funcGetGlobal then
        self.m_funcGetGlobal = _G.getglobal;
    end

    local uiNameToUiObjectMap = self.m_mUiNameToUiObject;
    if not uiNameToUiObjectMap then 
        uiNameToUiObjectMap = {}
        self.m_mUiNameToUiObject = uiNameToUiObjectMap;
    end
    if not uiNameToUiObjectMap[szUiName] then 
        uiNameToUiObjectMap[szUiName] = {}
    end

    local funcList = {...};
    for i=1, #funcList, 1 do 
        print(tostring(funcList[i]));
        local result = type(funcList[i]) == "function" and funcList[i](self, szUiName);
    end
end

function Lite:Hide(uiObject)
    print("Hide " .. tostring(uiObject));
end

function Lite:Disable(uiObject)
    print("Disable " .. tostring(uiObject));
end

Lite:SetUi("MiniLobbyFrameBottomShop", Lite.Hide, Lite.Disable);
print(tostring(Lite.Hide));
print(tostring(Lite.Disable));