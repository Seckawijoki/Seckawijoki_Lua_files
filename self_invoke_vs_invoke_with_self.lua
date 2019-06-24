-- 简版
_G.getglobal = function()
    return
end

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
            -- lobby top
            ["MiniLobbyFrameTopMiniBean"] = true,
            ["MiniLobbyFrameTopMiniCoin"] = true,
            ["MiniLobbyFrameTopActivity"] = true,
            ["MiniLobbyFrameTopMail"] = true,

            -- lobby main
            ["MiniLobbyFrameCenterHomeChest"] = true,

            -- lobby bottom
            ["MiniLobbyFrameBottomShop"] = true,
            ["MiniLobbyFrameBottomBuddy"] = true,
            ["MiniLobbyFrameBottomFacebookThumbUp"] = true,
            ["MiniLobbyFrameBottomVideoLive"] = true,
            ["MiniLobbyFrameBottomSubscribe"] = true,
            ["MiniLobbyFrameBottomNotice"] = true,
            ["MiniLobbyFrameBottomNoticeText"] = true,

            -- settings
            ["SetMenuFrameFAQBtn"] = true,
            ["SetMenuFrameFeedBackBtn"] = true,
            ["SetMenuFrameFeedBackBtn2"] = true,
            ["SetMenuFrameQueryData"] = true,
            ["SetMenuFrameQueryData2"] = true,
            ["SetMenuFrameGotoQQForum"] = true,
            ["SetMenuFrameGotoQQForum2"] = true,

            -- archive game
            ["GongNengFrameScreenshotBtn"] = true,
            ["GongNengFrameMenuArrow"] = true,
            ["CreateBackpackFrameStashBtn"] = true,
        },
    }
}

-- PC测试
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

    local uiObject = uiNameToUiObjectMap[szUiName];
    if not uiObject then 
        uiObject = self.m_funcGetGlobal(szUiName);
        uiNameToUiObjectMap[szUiName] = uiObject;
    end

    local funcList = {...};
    for i=1, #funcList, 1 do 
        -- print(tostring(funcList[i]));
        -- local result = type(funcList[i]) == "function" and funcList[i](self, uiObject);
        local result = type(funcList[i]) == "function" and funcList[i](self, szUiName);
    end
end

function Lite:Hide(uiObject)
    -- print("Hide " .. tostring(uiObject));
    -- if not uiObject then return end
    -- uiObject:Hide();
end

function Lite:Disable(uiObject)
    -- print("Disable " .. tostring(uiObject));
end

local szUiName = "MiniLobbyFrameCenterHomeChest";
local starttime;

starttime = os.clock();
for i=1, 10000000 do 
    Lite:Hide(szUiName);
end
print(os.clock() - starttime)

starttime = os.clock();
for i=1, 10000000 do 
    Lite.Hide(Lite, szUiName);
end
print(os.clock() - starttime)

