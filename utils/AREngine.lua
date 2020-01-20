local getglobal = _G.getglobal
local math = _G.math
local GetScreenWidth = _G.GetScreenWidth
local GetScreenHeight = _G.GetScreenHeight
local ShowGameTips = _G.ShowGameTips
-----------------------------------------------------AREngineView start-----------------------------------------------------
local Orientation = {
    LANDSCAPE = 0,
    PORTRAIT = 1,
}
local AREngineView = {
    DEMO_FILE_BASE_PATH = "res/ui/mobile/ar_engine_test_points/",
    m_szDemoFilename = "squat",

    m_iInitModelViewAngle = 0,

    m_szFullyCustomModelAnimFilename = "ar_custom_model_standard4",
    m_szAvatarPath = "entity/player/player12/body.omod",

    m_iCurrentOrientation = 0,
    --[[
        模型旋转相关参数  
        Created on 2019-12-17 at 15:11:08
    ]]
    m_bIsDragged = false,
    m_bHasRotated = false,
    m_iActorPosX = 0,
    m_iActorPosY= 0,
    m_bIsFingerMovedVertically = false,
    m_bIsModelViewFirstClicked = true,
    m_tModelAngle = {
        agSwitch = true,
        xAngle = 0,
        yAngle = 0,
        zAngle = 0,
    },

    --[[
        测试按钮和面板布局类 
        Created on 2019-12-17 at 15:11:18
    ]]
    m_clsSkeletonNameLayoutManager = nil,
    m_clsDataNameLayoutManager = nil,
    m_clsDataLayoutManager = nil,
    m_clsSelfTestingButtonsLayoutManager = nil,
    m_clsModelChoicesButtonsLayoutManager = nil,
    m_clsCustomSkinLibPartTypeButtonsLayoutManager = nil,

    --部件类型
    PART_TYPES = 
    {
        {index = 1,  partType = 10,nameID = 9277,icon = "icon_custom_all.png"},	--综合
        {index = 2,  partType = 11,nameID = 1051,icon = "icon_custom_record.png"},	--历史
        {index = 3,  partType = 1, nameID = 9235,icon = "icon_custom_head.png"},	--头
        {index = 4,  partType = 2, nameID = 9236,icon = "icon_custom_Expression"},	--表情
        {index = 5,  partType = 3, nameID = 9237,icon = "icon_custom_mask.png"},	--面饰
        {index = 6,  partType = 4, nameID = 9238,icon = "icon_custom_cloth.png"},	--上衣
        {index = 7,  partType = 5, nameID = 9278,icon = "icon_custom_hands.png"},	--手套
        {index = 8,  partType = 6, nameID = 9239,icon = "icon_custom_pants.png"},	--裤子	
        {index = 9,  partType = 7, nameID = 9240,icon = "icon_custom_shoes.png"},	--鞋子
        {index = 10, partType = 8, nameID = 9241,icon = "icon_custom_back.png"},	--背饰
        {index = 11, partType = 9, nameID = 9279,icon = "icon_custom_foot.png"},	--脚印
    },
}

function AREngineView:init()
    
end

function AREngineView:onGameEvent(szGameEvent, ...)
    local ge = GameEventQue:getCurEvent()
    if szGameEvent == "GE_ON_CLICK" then 
        self:onClick(ge.body.onUIEvent.szUIName)
    elseif szGameEvent == "GE_ON_FOCUS_LOST" then 
        self:onFocusLost(ge.body.onUIEvent.szUIName)
    elseif szGameEvent == "GE_ON_ENTER_PRESSED" then 
        self:onEnterPressed(ge.body.onUIEvent.szUIName)
    end
end

function AREngineView:onModelViewMouseMove()
    local uiModelView = getglobal("HuaweiARTestFrameModelView");
    if not uiModelView then return end
    local uiReferentialModelView = getglobal("HuaweiARTestFrameReferentialModelView");

	local iActorPosX = uiModelView:getActorPosX();
	local iActorPosY = uiModelView:getActorPosY();

	local iHeight = 	 uiModelView:GetRealHeight()
    local iWidth =  uiModelView:GetRealWidth();

    local iPressedDownX = arg1
    local iPressedDownY = arg2
    local iMouseX = arg3
    local iMouseY = arg4
    local abs = math.abs

	-- if self.m_bIsDragged then
	-- 	uiModelView:setActorPosition((arg3 - mx) / 2 , (20 - (arg4 - my)) / 2, -320);
	-- 	return;
    -- end
    
    -- print("onModelViewMouseMove(): iActorPosX = ", iActorPosX);
    -- print("onModelViewMouseMove(): iActorPosY = ", iActorPosY);
    -- print("onModelViewMouseMove(): iHeight = ", iHeight);
    -- print("onModelViewMouseMove(): iWidth = ", iWidth);
    -- print("onModelViewMouseMove(): iPressedDownX = ", iPressedDownX);
    -- print("onModelViewMouseMove(): iPressedDownY = ", iPressedDownY);
    -- print("onModelViewMouseMove(): iMouseX = ", iMouseX);
    -- print("onModelViewMouseMove(): iMouseY = ", iMouseY);

    local tModelAngle = self.m_tModelAngle
    tModelAngle.zAngle = 0;
    if (abs(iMouseX - self.m_iActorPosX) > 10 or abs(iMouseY - self.m_iActorPosY) > 10) 
    and iPressedDownX > iActorPosX-170 
    and iPressedDownX < iActorPosX+170 
    and iPressedDownY > iActorPosY-410 
    and iPressedDownY < iActorPosY+30 then
		local fAngleX = (iPressedDownX - iMouseX) / 2;
		local fAngleY = (iPressedDownY - iMouseY) / 4;

		fAngleX = fAngleX + tModelAngle.xAngle;
		fAngleY = fAngleY + tModelAngle.yAngle;
		uiModelView:setModelAngle(true, fAngleX, fAngleY, tModelAngle.zAngle);
		uiReferentialModelView:setModelAngle(true, fAngleX, fAngleY, tModelAngle.zAngle);
		self.m_bHasRotated = true;
	end

    if self.m_bIsModelViewFirstClicked 
    and abs(iMouseY - iPressedDownY) > abs(iMouseX - iPressedDownX) then
		self.m_bIsFingerMovedVertically = true;
		self.m_bIsModelViewFirstClicked = false;
    elseif self.m_bIsModelViewFirstClicked 
    and abs(iMouseY - iPressedDownY) < abs(iMouseX - iPressedDownX) then
		self.m_bIsFingerMovedVertically = false;
		self.m_bIsModelViewFirstClicked = false;
	end

    if self.m_bIsFingerMovedVertically == true 
    and iPressedDownX > iActorPosX - iHeight 
    and iPressedDownX < iActorPosX + iHeight 
    and iPressedDownY > iActorPosY - iWidth 
    and iPressedDownY < iActorPosY + iWidth then
		local fAngleY = (iPressedDownY - iMouseY) / 4;
		fAngleY = fAngleY + tModelAngle.yAngle;
		uiModelView:setModelAngle(true, tModelAngle.xAngle, fAngleY, tModelAngle.zAngle);
		uiReferentialModelView:setModelAngle(true, tModelAngle.xAngle, fAngleY, tModelAngle.zAngle);
		self.m_bHasRotated = true;
    elseif self.m_bIsFingerMovedVertically == false 
    and iPressedDownX > iActorPosX - iHeight 
    and iPressedDownX < iActorPosX + iHeight 
    and iPressedDownY > iActorPosY - iWidth 
    and iPressedDownY < iActorPosY + iWidth then
		local fAngleX = (iPressedDownX - iMouseX)/2;
		fAngleX = fAngleX + tModelAngle.xAngle;
		uiModelView:setModelAngle(true, fAngleX, tModelAngle.yAngle, tModelAngle.zAngle);
		uiReferentialModelView:setModelAngle(true, fAngleX, tModelAngle.yAngle, tModelAngle.zAngle);
		self.m_bHasRotated = true;
	end
end

function AREngineView:onFocusLost(szUIName)
    if szUIName == "HuaweiARTestFrameSelfTestingFrameDemoFilenameEdit" then
        self:saveDemoFilename()
    elseif szUIName == "HuaweiARTestFrameSelfTestingFrameConfidenceLevelEdit" then
        self:setDebugDatum(
            "HuaweiARTestFrameSelfTestingFrameConfidenceLevelEdit", 
            "getConfidenceLevel", 
            "setConfidenceLevel",
            nil,
            5
        )
    elseif szUIName == "HuaweiARTestFrameSelfTestingFrameZFactorEdit" then
        self:setDebugDatum(
            "HuaweiARTestFrameSelfTestingFrameZFactorEdit", 
            "getZFactor", 
            "setZFactor",
            nil,
            1
        )
    elseif szUIName == "HuaweiARTestFrameSelfTestingFrameElbowStomachMinDistanceEdit" then
        self:setDebugDatum(
            "HuaweiARTestFrameSelfTestingFrameElbowStomachMinDistanceEdit", 
            "getElbowStomachMinDistance", 
            "setElbowStomachMinDistance",
            nil,
            0.25
        )
    elseif szUIName == "HuaweiARTestFrameSelfTestingFrameHandStomachMinDistanceEdit" then
        self:setDebugDatum(
            "HuaweiARTestFrameSelfTestingFrameHandStomachMinDistanceEdit", 
            "getHandStomachMinDistance", 
            "setHandStomachMinDistance",
            nil,
            0.15
        )
    elseif szUIName == "HuaweiARTestFrameSelfTestingFrameFootCrotchMinDistanceEdit" then
        self:setDebugDatum(
            "HuaweiARTestFrameSelfTestingFrameFootCrotchMinDistanceEdit", 
            "getFootCrotchMinDistance", 
            "setFootCrotchMinDistance",
            nil,
            0.15
        )
    elseif szUIName == "HuaweiARTestFrameSelfTestingFrameUpperBodyLengthEdit" then
        self:setDebugDatum(
            "HuaweiARTestFrameSelfTestingFrameUpperBodyLengthEdit", 
            "getUpperBodyLength", 
            "setUpperBodyLength",
            nil,
            0
        )
    elseif szUIName == "HuaweiARTestFrameSelfTestingFrameUpperBodyWidthEdit" then
        self:setDebugDatum(
            "HuaweiARTestFrameSelfTestingFrameUpperBodyWidthEdit", 
            "getUpperBodyWidth", 
            "setUpperBodyWidth",
            nil,
            0
        )
    elseif szUIName == "HuaweiARTestFrameSelfTestingFrameUpperBodyHeightEdit" then
        self:setDebugDatum(
            "HuaweiARTestFrameSelfTestingFrameUpperBodyHeightEdit", 
            "getUpperBodyHeight", 
            "setUpperBodyHeight",
            nil,
            0
        )
    elseif szUIName == "HuaweiARTestFrameSelfTestingFrameHeadLengthEdit" then
        self:setDebugDatum(
            "HuaweiARTestFrameSelfTestingFrameHeadLengthEdit", 
            "getHeadLength", 
            "setHeadLength",
            nil,
            0
        )
    elseif szUIName == "HuaweiARTestFrameSelfTestingFrameHeadWidthEdit" then
        self:setDebugDatum(
            "HuaweiARTestFrameSelfTestingFrameHeadWidthEdit", 
            "getHeadWidth", 
            "setHeadWidth",
            nil,
            0
        )
    elseif szUIName == "HuaweiARTestFrameSelfTestingFrameHeadHeightEdit" then
        self:setDebugDatum(
            "HuaweiARTestFrameSelfTestingFrameHeadHeightEdit", 
            "getHeadHeight", 
            "setHeadHeight",
            nil,
            0
        )
    end
end

function AREngineView:onEnterPressed(szUIName)
end

function AREngineView:onModelViewMouseDown()
    self.m_bIsDragged = false;
    self.m_bHasRotated = false;
    self.m_bIsModelViewFirstClicked = true;

    local szUIModelView = "HuaweiARTestFrameModelView";
    self.m_tModelAngle = getglobal(szUIModelView):getModelAngle();
    self.m_iActorPosX = getglobal(szUIModelView):getActorPosX();
    self.m_iActorPosY = getglobal(szUIModelView):getActorPosY();

    local iPressedDownX = arg1
    local iPressedDownY = arg2
    print("onModelViewMouseDown", iPressedDownX, iPressedDownY, self.m_iActorPosX, self.m_iActorPosY)
end

function AREngineView:onClick(szUIName)
    if szUIName == "MiniLobbyFrameTopHuaweiARTestBtn" then 
        self:displayShowHuaweiARTestFrame();
    elseif szUIName == "HuaweiARTestFrameCloseBtn" then 
        self:hideHuaweiARTestFrame();
    elseif szUIName == "HuaweiARTestFrameDebugBtn" then 
        self:debug();
    elseif szUIName == "HuaweiARTestFrameSelfTestingBtn" then 
        self:selfTesting();
    elseif szUIName == "HuaweiARTestFrameSelfDefinedBtn" then 
        self:selfDefined();
    elseif szUIName == "HuaweiARTestFrameModelChoicesBtn" then 
        self:modelChoices();
    elseif szUIName == "HuaweiARTestFrameCustomSkinLibBtn" then 
        self:customSkinLib();
    elseif szUIName == "HuaweiARTestFrameSelfTestingFrameAddBodyAR3DRendererToFirstBtn" then 
        self:addBodyAR3DRendererToFirst();
    elseif szUIName == "HuaweiARTestFrameSelfTestingFrameAddBodyAR3DRendererToLastBtn" then 
        self:addBodyAR3DRendererToLast();
    elseif szUIName == "HuaweiARTestFrameSelfTestingFrameSetIsARModeTrueBtn" then 
        ClientMgr:setIsARMode(1);
    elseif szUIName == "HuaweiARTestFrameSelfTestingFrameSetIsARModeFalseBtn" then 
        ClientMgr:setIsARMode(0);
    elseif szUIName == "HuaweiARTestFrameSelfTestingFrameLoopPlayingBtn" then
        self:loopPlaying();
    elseif szUIName == "HuaweiARTestFrameSelfTestingFrameResetLoopingBtn" then
        self:resetLooping();
    elseif szUIName == "HuaweiARTestFrameSelfTestingFrameReadDemoPointsBtn" then 
        self:readDemoPoints();
    elseif szUIName == "HuaweiARTestFrameSelfTestingFrameReadDemoPoints2Btn" then 
        self:readDemoPoints2();
    elseif szUIName == "HuaweiARTestFrameSelfTestingFrameRemoveBodyAR3DRendererBtn" then 
        self:removeBodyAR3DRenderer();
    elseif szUIName == "HuaweiARTestFrameSelfTestingFrameCoordinateAxesBtn" then
        self:coordinateAxes();
    elseif szUIName == "HuaweiARTestFrameSelfTestingFrameIncreaseConfidenceLevelBtn" then 
        -- self:increaseConfidenceLevel(1);
        self:increaseDebugDatum(
            "HuaweiARTestFrameSelfTestingFrameConfidenceLevelEdit", 
            "getConfidenceLevel", 
            "setConfidenceLevel", 
            1,
            100
        )
    elseif szUIName == "HuaweiARTestFrameSelfTestingFrameDecreaseConfidenceLevelBtn" then 
        -- self:decreaseConfidenceLevel(1);
        self:decreaseDebugDatum(
            "HuaweiARTestFrameSelfTestingFrameConfidenceLevelEdit", 
            "getConfidenceLevel", 
            "setConfidenceLevel", 
            1,
            0
        )
    elseif szUIName == "HuaweiARTestFrameSelfTestingFrameIncreaseTenConfidenceLevelBtn" then 
        -- self:increaseConfidenceLevel(10);
        self:increaseDebugDatum(
            "HuaweiARTestFrameSelfTestingFrameConfidenceLevelEdit", 
            "getConfidenceLevel", 
            "setConfidenceLevel", 
            10,
            100
        )
    elseif szUIName == "HuaweiARTestFrameSelfTestingFrameDecreaseTenConfidenceLevelBtn" then 
        -- self:decreaseConfidenceLevel(10);
        self:decreaseDebugDatum(
            "HuaweiARTestFrameSelfTestingFrameConfidenceLevelEdit", 
            "getConfidenceLevel", 
            "setConfidenceLevel", 
            10,
            0
        )
    elseif szUIName == "HuaweiARTestFrameSelfTestingFrameIncreaseZFactorBtn" then 
        -- self:increaseZFactor(0.1);
        self:increaseDebugDatum(
            "HuaweiARTestFrameSelfTestingFrameZFactorEdit", 
            "getZFactor", 
            "setZFactor", 
            0.1,
            nil
        )
    elseif szUIName == "HuaweiARTestFrameSelfTestingFrameDecreaseZFactorBtn" then 
        -- self:decreaseZFactor(0.1);
        self:decreaseDebugDatum(
            "HuaweiARTestFrameSelfTestingFrameZFactorEdit", 
            "getZFactor", 
            "setZFactor", 
            0.1,
            nil
        )
    elseif szUIName == "HuaweiARTestFrameSelfTestingFrameSetAllConfidenceBtn" then
        self:switchAllConfidence();
    elseif szUIName == "HuaweiARTestFrameSelfTestingFrameSetEachConfidenceBtn" then
        self:switchAllConfidence();
    elseif szUIName == "HuaweiARTestFrameSelfTestingFrameFrontCameraBtn" then
        self:setFrontCamera();
    elseif szUIName == "HuaweiARTestFrameSelfTestingFrameRearCameraBtn" then
        self:setRearCamera();
    elseif szUIName == "HuaweiARTestFrameModelChoicesFrameAvatarBtn" then
        self:setAvatarModel();
    elseif szUIName == "HuaweiARTestFrameSelfTestingFrameRead2DBtn" then
        AbsAREngine:setRead2DPoints(true);
    elseif szUIName == "HuaweiARTestFrameSelfTestingFrameRead3DBtn" then
        AbsAREngine:setRead2DPoints(false);
    elseif szUIName == "HuaweiARTestFrameSelfTestingFrameReadHipBoneBtn" then
        AbsAREngine:readHipBone();
    elseif szUIName == "HuaweiARTestFrameSelfTestingFrameClearHipBoneBtn" then
        AbsAREngine:clearHipBone();
    elseif szUIName == "HuaweiARTestFrameSelfTestingFrameChangeSequenceIdModeBtn" then
        AbsAREngine:setChangeSequenceIdMode(true);
    elseif szUIName == "HuaweiARTestFrameSelfTestingFrameSpecifiedTickBtn" then
        AbsAREngine:setChangeSequenceIdMode(false);
    elseif szUIName == "HuaweiARTestFrameSelfTestingFramePenetrationCylinderAdjustmentBtn" then
        AbsAREngine:setPenetrationCylinderAdjustment();
    elseif szUIName == "HuaweiARTestFrameSelfTestingFramePenetrationCuboidAdjustmentBtn" then
        AbsAREngine:setPenetrationAdjustment();
    elseif szUIName == "HuaweiARTestFrameSelfTestingFramePenetrationCuboidAdjustment2Btn" then
        AbsAREngine:setPenetrationCuboidAdjustment2();
    elseif szUIName == "HuaweiARTestFrameSelfTestingFrameIncreaseElbowStomachMinDistanceBtn" then
        self:increaseDebugDatum(
            "HuaweiARTestFrameSelfTestingFrameElbowStomachMinDistanceEdit", 
            "getElbowStomachMinDistance", 
            "setElbowStomachMinDistance", 
            0.01,
            nil
        )
    elseif szUIName == "HuaweiARTestFrameSelfTestingFrameDecreaseElbowStomachMinDistanceBtn" then
        self:decreaseDebugDatum(
            "HuaweiARTestFrameSelfTestingFrameElbowStomachMinDistanceEdit", 
            "getElbowStomachMinDistance", 
            "setElbowStomachMinDistance", 
            0.01,
            nil
        )
    elseif szUIName == "HuaweiARTestFrameSelfTestingFrameIncreaseHandStomachMinDistanceBtn" then
        self:increaseDebugDatum(
            "HuaweiARTestFrameSelfTestingFrameHandStomachMinDistanceEdit", 
            "getHandStomachMinDistance", 
            "setHandStomachMinDistance", 
            0.01,
            nil
        )
    elseif szUIName == "HuaweiARTestFrameSelfTestingFrameDecreaseHandStomachMinDistanceBtn" then
        self:decreaseDebugDatum(
            "HuaweiARTestFrameSelfTestingFrameHandStomachMinDistanceEdit", 
            "getHandStomachMinDistance", 
            "setHandStomachMinDistance", 
            0.01,
            nil
        )
    elseif szUIName == "HuaweiARTestFrameSelfTestingFrameIncreaseFootCrotchMinDistanceBtn" then
        self:increaseDebugDatum(
            "HuaweiARTestFrameSelfTestingFrameFootCrotchMinDistanceEdit", 
            "getFootCrotchMinDistance", 
            "setFootCrotchMinDistance", 
            0.01,
            nil
        )
    elseif szUIName == "HuaweiARTestFrameSelfTestingFrameDecreaseFootCrotchMinDistanceBtn" then
        self:decreaseDebugDatum(
            "HuaweiARTestFrameSelfTestingFrameFootCrotchMinDistanceEdit", 
            "getFootCrotchMinDistance", 
            "setFootCrotchMinDistance", 
            0.01,
            nil
        )
    elseif szUIName == "HuaweiARTestFrameSelfTestingFrameStartRecordingBtn" then
        ShowGameTips("开始录制");
        AbsAREngine:startRecording();
    elseif szUIName == "HuaweiARTestFrameSelfTestingFrameStopRecordingBtn" then
        ShowGameTips("停止录制");
        AbsAREngine:stopRecording();
    elseif szUIName == "HuaweiARTestFrameSelfTestingFrameIncreaseUpperBodyLengthBtn" then
        self:increaseDebugDatum(
            "HuaweiARTestFrameSelfTestingFrameUpperBodyLengthEdit", 
            "getUpperBodyLength", 
            "setUpperBodyLength", 
            0.01,
            nil
        )
    elseif szUIName == "HuaweiARTestFrameSelfTestingFrameDecreaseUpperBodyLengthBtn" then
        self:decreaseDebugDatum(
            "HuaweiARTestFrameSelfTestingFrameUpperBodyLengthEdit", 
            "getUpperBodyLength", 
            "setUpperBodyLength", 
            0.01,
            0
        )
    elseif szUIName == "HuaweiARTestFrameSelfTestingFrameIncreaseUpperBodyWidthBtn" then
        self:increaseDebugDatum(
            "HuaweiARTestFrameSelfTestingFrameUpperBodyWidthEdit", 
            "getUpperBodyWidth", 
            "setUpperBodyWidth", 
            0.01,
            nil
        )
    elseif szUIName == "HuaweiARTestFrameSelfTestingFrameDecreaseUpperBodyWidthBtn" then
        self:decreaseDebugDatum(
            "HuaweiARTestFrameSelfTestingFrameUpperBodyWidthEdit", 
            "getUpperBodyWidth", 
            "setUpperBodyWidth", 
            0.01,
            0
        )
    elseif szUIName == "HuaweiARTestFrameSelfTestingFrameIncreaseUpperBodyHeightBtn" then
        self:increaseDebugDatum(
            "HuaweiARTestFrameSelfTestingFrameUpperBodyHeightEdit", 
            "getUpperBodyHeight", 
            "setUpperBodyHeight", 
            0.01,
            nil
        )
    elseif szUIName == "HuaweiARTestFrameSelfTestingFrameDecreaseUpperBodyHeightBtn" then
        self:decreaseDebugDatum(
            "HuaweiARTestFrameSelfTestingFrameUpperBodyHeightEdit", 
            "getUpperBodyHeight", 
            "setUpperBodyHeight", 
            0.01,
            0
        )
    elseif szUIName == "HuaweiARTestFrameSelfTestingFrameIncreaseHeadLengthBtn" then
        self:increaseDebugDatum(
            "HuaweiARTestFrameSelfTestingFrameHeadLengthEdit", 
            "getHeadLength", 
            "setHeadLength", 
            0.01,
            nil
        )
    elseif szUIName == "HuaweiARTestFrameSelfTestingFrameDecreaseHeadLengthBtn" then
        self:decreaseDebugDatum(
            "HuaweiARTestFrameSelfTestingFrameHeadLengthEdit", 
            "getHeadLength", 
            "setHeadLength", 
            0.01,
            0
        )
    elseif szUIName == "HuaweiARTestFrameSelfTestingFrameIncreaseHeadWidthBtn" then
        self:increaseDebugDatum(
            "HuaweiARTestFrameSelfTestingFrameHeadWidthEdit", 
            "getHeadWidth", 
            "setHeadWidth", 
            0.01,
            nil
        )
    elseif szUIName == "HuaweiARTestFrameSelfTestingFrameDecreaseHeadWidthBtn" then
        self:decreaseDebugDatum(
            "HuaweiARTestFrameSelfTestingFrameHeadWidthEdit", 
            "getHeadWidth", 
            "setHeadWidth", 
            0.01,
            0
        )
    elseif szUIName == "HuaweiARTestFrameSelfTestingFrameIncreaseHeadHeightBtn" then
        self:increaseDebugDatum(
            "HuaweiARTestFrameSelfTestingFrameHeadHeightEdit", 
            "getHeadHeight", 
            "setHeadHeight", 
            0.01,
            nil
        )
    elseif szUIName == "HuaweiARTestFrameSelfTestingFrameDecreaseHeadHeightBtn" then
        self:decreaseDebugDatum(
            "HuaweiARTestFrameSelfTestingFrameHeadHeightEdit", 
            "getHeadHeight", 
            "setHeadHeight", 
            0.01,
            0
        )
    end
end

function AREngineView:coordinateAxes()
    local uiXAxis = getglobal("HuaweiARTestFrameXAxis")
    local uiYAxis = getglobal("HuaweiARTestFrameYAxis")
    if not uiYAxis or not uiYAxis then return end
    if uiXAxis:IsShown() or uiYAxis:IsShown() then
        uiXAxis:Hide();
        uiYAxis:Hide();
    else
        uiXAxis:Show();
        uiYAxis:Show();
    end
end

function AREngineView:onARModelBtnClick()
    local id = this:GetClientID();
    self:setSkinModel(id);
    getglobal("HuaweiARTestFrameModelChoicesFrame"):Hide();
end

function AREngineView:onARCustomSkinLibPartTypeBtnClick()
    local id = this:GetClientID();
    -- self:setSkinModel(id);
    -- getglobal("HuaweiARTestFrameModelChoicesFrame"):Hide();
end

function AREngineView:saveDemoFilename()
    local uiEdit = getglobal("HuaweiARTestFrameSelfTestingFrameDemoFilenameEdit")
    if not uiEdit then return end
    self.m_szDemoFilename = uiEdit:GetText()
end

function AREngineView:loopPlaying()
    AbsAREngine:startPlayOrStopDemo(self.DEMO_FILE_BASE_PATH .. self.m_szDemoFilename .. ".txt");
end

function AREngineView:resetLooping()
    AbsAREngine:resetPlayDemo();
end

function AREngineView:readDemoPoints()
    if not ClientMgr:isPC() then return end
    AbsAREngine:readDemoPoints(self.DEMO_FILE_BASE_PATH .. self.m_szDemoFilename .. ".txt");
end

function AREngineView:readDemoPoints2()
    if not ClientMgr:isPC() then return end
    -- local szDemoPath = "res/ui/mobile/ar_engine_test_points/right_hand_in_upper_right.txt";
    -- local szDemoPath = "res/ui/mobile/ar_engine_test_points/akimbo.txt";
    -- local szDemoPath = "res/ui/mobile/ar_engine_test_points/akimbo_in_back.txt";
    -- local szDemoPath = "res/ui/mobile/ar_engine_test_points/spraddle.txt";
    -- local szDemoPath = "res/ui/mobile/ar_engine_test_points/legs_bend.txt";
    -- local szDemoPath = "res/ui/mobile/ar_engine_test_points/reality.txt";
    -- local szDemoPath = "res/ui/mobile/ar_engine_test_points/crouch.txt";
    -- local szDemoPath = "res/ui/mobile/ar_engine_test_points/20200107_205023.txt";
    --local szDemoPath = "res/ui/mobile/ar_engine_test_points/rotate_body.txt";
    local szDemoPath = "res/ui/mobile/ar_engine_test_points/20200115_181210.txt";
    -- local szDemoPath = "res/ui/mobile/ar_engine_test_points/mixture.txt";
    -- local szDemoPath = "res/ui/mobile/ar_engine_test_points/raise_head.txt";
    -- local szDemoPath = "res/ui/mobile/ar_engine_test_points/right_hand_in_upper_right.txt";
    -- local szDemoPath = "res/ui/mobile/ar_engine_test_points/akimbo.txt";
    -- local szDemoPath = "res/ui/mobile/ar_engine_test_points/akimbo_in_back.txt";
    -- local szDemoPath = "res/ui/mobile/ar_engine_test_points/head_leaning_left.txt";
    -- local szDemoPath = "res/ui/mobile/ar_engine_test_points/legs_bend.txt";
    -- local szDemoPath = "res/ui/mobile/ar_engine_test_points/reality.txt";
    AbsAREngine:readDemoPoints(szDemoPath);
end

function AREngineView:switchAllConfidence()
    local bAllConfidence = AbsAREngine:areAllConfidence();
    if not bAllConfidence then
        AbsAREngine:setAllConfidence(true);
    end
end

function AREngineView:setEachConfidence()
    local bAllConfidence = AbsAREngine:areAllConfidence();
    if bAllConfidence then
        AbsAREngine:setAllConfidence(false);
    end
end

function AREngineView:setConfidenceLevel(iConfidenceLevel)
    if not iConfidenceLevel then
        local eb = getglobal("HuaweiARTestFrameSelfTestingFrameConfidenceLevelEdit");
        iConfidenceLevel = eb:GetText();
    end
    iConfidenceLevel = tonumber(iConfidenceLevel);
    if not iConfidenceLevel then
        iConfidenceLevel = 0
    end
    if iConfidenceLevel < 0 then
        iConfidenceLevel = 0
    end
    if iConfidenceLevel > 100 then
        iConfidenceLevel = 100
    end
    AbsAREngine:setConfidenceLevel(iConfidenceLevel);
end

function AREngineView:increaseConfidenceLevel(increment)
    local iConfidenceLevel = AbsAREngine:getConfidenceLevel()
    iConfidenceLevel = iConfidenceLevel + increment
    if iConfidenceLevel > 100 then
        iConfidenceLevel = 100
    end
    AbsAREngine:setConfidenceLevel(iConfidenceLevel)
    local eb = getglobal("HuaweiARTestFrameSelfTestingFrameConfidenceLevelEdit");
    eb:SetText(tostring(iConfidenceLevel))
end

function AREngineView:decreaseConfidenceLevel(decrement)
    local iConfidenceLevel = AbsAREngine:getConfidenceLevel()
    iConfidenceLevel = iConfidenceLevel - decrement
    if iConfidenceLevel < 0 then
        iConfidenceLevel = 0
    end
    AbsAREngine:setConfidenceLevel(iConfidenceLevel)
    local eb = getglobal("HuaweiARTestFrameSelfTestingFrameConfidenceLevelEdit");
    eb:SetText(tostring(iConfidenceLevel))
end

function AREngineView:setZFactor(fZFactor)
    if not fZFactor  then
        local eb = getglobal("HuaweiARTestFrameSelfTestingFrameZFactorEdit");
        fZFactor = eb:GetText();
    end
    fZFactor = tonumber(fZFactor);
    if not fZFactor then
        fZFactor = 1
    end
    AbsAREngine:setZFactor(fZFactor);
    self:readDemoPoints();
end

function AREngineView:increaseZFactor(increment)
    local fZFactor = AbsAREngine:getZFactor()
    fZFactor = fZFactor + increment
    AbsAREngine:setZFactor(fZFactor)
    local eb = getglobal("HuaweiARTestFrameSelfTestingFrameZFactorEdit");
    eb:SetText(tostring(fZFactor))
end

function AREngineView:decreaseZFactor(decrement)
    local fZFactor = AbsAREngine:getZFactor()
    fZFactor = fZFactor - decrement
    AbsAREngine:setZFactor(fZFactor)
    local eb = getglobal("HuaweiARTestFrameSelfTestingFrameZFactorEdit");
    eb:SetText(tostring(fZFactor))
end

function AREngineView:setDebugDatum(szUIEdit, szFuncGetter, szFuncSetter, datum, defaultDatum)
    if not datum  then
        local eb = getglobal(szUIEdit);
        datum = eb:GetText();
    end
    datum = tonumber(datum);
    if not datum then
        datum = AbsAREngine[szFuncGetter](AbsAREngine);
    end
    if not datum then
        datum = defaultDatum or 0
    end
    AbsAREngine[szFuncSetter](AbsAREngine, datum);
end

function AREngineView:increaseDebugDatum(szUIEdit, szFuncGetter, szFuncSetter, increment, max)
    local datum = AbsAREngine[szFuncGetter](AbsAREngine)
    datum = datum + increment
    if max and datum > max then
        datum = max
    end
    AbsAREngine[szFuncSetter](AbsAREngine, datum)
    local eb = getglobal(szUIEdit);
    if not eb then return end
    eb:SetText(tostring(datum))
end

function AREngineView:decreaseDebugDatum(szUIEdit, szFuncGetter, szFuncSetter, decrement, min)
    local datum = AbsAREngine[szFuncGetter](AbsAREngine)
    datum = datum - decrement
    if min and datum < min then
        datum = min
    end
    AbsAREngine[szFuncSetter](AbsAREngine, datum)
    local eb = getglobal(szUIEdit);
    if not eb then return end
    eb:SetText(tostring(datum))
end

function AREngineView:showDebugDatum(szUIEdit, szFuncGetter, defaultDatum)
    local datum = AbsAREngine[szFuncGetter](AbsAREngine)
    if not datum then
        if defaultDatum then
            datum = defaultDatum
        else
            return
        end
    end
    local eb = getglobal(szUIEdit);
    if not eb then return end
    eb:SetText(tostring(datum))
end

function AREngineView:setAvatarModel()
    local udActorBody = AbsAREngine:getAvatarActorBody(self.m_szAvatarPath);
    self:attachUIModelView("HuaweiARTestFrameModelView", udActorBody);
    getglobal("HuaweiARTestFrameModelChoicesFrame"):Hide();
end

function AREngineView:setSkinModel(nModelID)
    local udActorBody = AbsAREngine:getRoleSkinActorBody(nModelID);
    if not udActorBody then return end
    self:attachUIModelView("HuaweiARTestFrameModelView", udActorBody);
end

function AREngineView:displayShowHuaweiARTestFrame()
    local print = Android:Localize(Android.SITUATION.HUAWEI_AR_ENGINE);
    print("displayShowHuaweiARTestFrame(): ");
    local getglobal = getglobal
	getglobal("HuaweiARTestFrame"):Show();
    getglobal("MiniLobbyFrame"):Hide();
    
    local AbsAREngine = _G.AbsAREngine
    AbsAREngine:setZFactor(1);

    self:setAvatarModel();
    local udActorBody = AbsAREngine:newAvatarActorBody(self.m_szAvatarPath);
    self:attachUIModelView("HuaweiARTestFrameReferentialModelView", udActorBody);

    AbsAREngine:bindModelView("HuaweiARTestFrameModelView");
    self:switchAllConfidence();
    AbsAREngine:setConfidenceLevel(5);
    self:addBodyAR3DRendererToFirst();
    if not ClientMgr:isPC() then
        ClientMgr:setIsARMode(1);
    else
        getglobal("HuaweiARTestFrameBkg"):Show();
        self:displayOnConfigLandscape();
    end

    JavaMethodInvokerFactory:obtain()
        :setClassName("org/appplay/lib/RendererManager")
        :setMethodName("enableOrientationListener")
        :setSignature("()V")
        :call();
end

function AREngineView:attachUIModelView(szUIModelView, udActorBody)
    if not szUIModelView then return end
    if #szUIModelView <= 0 then return end
    if not udActorBody then return end
    local uiModelView = getglobal(szUIModelView);
    if not uiModelView then return end
    local udOldActorBody = uiModelView:getActorbody();
    if udOldActorBody then
        udOldActorBody:detachUIModelView(uiModelView);
    end
    udActorBody:attachUIModelView(uiModelView);
end

function AREngineView:detachUIModelView(szUIModelView)
    if not szUIModelView then return end
    if #szUIModelView <= 0 then return end
    local uiModelView = getglobal(szUIModelView);
    if not uiModelView then return end
    local udActorBody = uiModelView:getActorbody();
    if not udActorBody then return end
    udActorBody:detachUIModelView(uiModelView);
end

function AREngineView:hideHuaweiARTestFrame()
    local print = Android:Localize(Android.SITUATION.HUAWEI_AR_ENGINE);
    print("hideHuaweiARTestFrame(): ");
    ClientMgr:setIsARMode(0);
    self:removeBodyAR3DRenderer();
	getglobal("HuaweiARTestFrame"):Hide();
	getglobal("MiniLobbyFrame"):Show();
    self:detachUIModelView("HuaweiARTestFrameModelView");
    self:detachUIModelView("HuaweiARTestFrameReferentialModelView");

	JavaMethodInvokerFactory:obtain()
        :setClassName("org/appplay/lib/RendererManager")
        :setMethodName("disableOrientationListener")
        :setSignature("()V")
        :call();
end

function AREngineView:addBodyAR3DRendererToFirst()
	JavaMethodInvokerFactory:obtain()
        :setClassName("org/appplay/lib/RendererManager")
		:setMethodName("addBodyAR3DRendererToFirst")
		:setSignature("()V")
		:call();
end

function AREngineView:addBodyAR3DRendererToLast()
	JavaMethodInvokerFactory:obtain()
        :setClassName("org/appplay/lib/RendererManager")
		:setMethodName("addBodyAR3DRendererToLast")
		:setSignature("()V")
		:call();
end

function AREngineView:removeBodyAR3DRenderer()
	JavaMethodInvokerFactory:obtain()
		:setClassName("org/appplay/lib/RendererManager")
		:setMethodName("removeBodyAR3DRenderer")
		:setSignature("()V")
		:call();
end

function AREngineView:setFrontCamera()
	JavaMethodInvokerFactory:obtain()
		:setClassName("org/appplay/lib/RendererManager")
		:setMethodName("setFrontCamera")
		:setSignature("()V")
		:call();
end

function AREngineView:setRearCamera()
	JavaMethodInvokerFactory:obtain()
		:setClassName("org/appplay/lib/RendererManager")
		:setMethodName("setRearCamera")
		:setSignature("()V")
		:call();
end

function AREngineView:debug()
    local getglobal = getglobal
    local frameDebug = getglobal("HuaweiARTestFrameDebugFrame")
    if frameDebug:IsShown() then
        frameDebug:Hide();
    else
        frameDebug:Show();
        self:layoutDebugFrame();
    end
end

function AREngineView:selfTesting()
    -- local print = Android:Localize(Android.SITUATION.HUAWEI_AR_ENGINE);
    local getglobal = getglobal
    local frameSelfTesting = getglobal("HuaweiARTestFrameSelfTestingFrame")
    if frameSelfTesting:IsShown() then
        frameSelfTesting:Hide();
    else
        frameSelfTesting:Show();
        self:layoutSelfTestingButtons();

        getglobal("HuaweiARTestFrameSelfTestingFrameDemoFilenameEdit"):SetText(self.m_szDemoFilename);

        self:showDebugDatum("HuaweiARTestFrameSelfTestingFrameConfidenceLevelEdit", "getConfidenceLevel", 5)
        self:showDebugDatum("HuaweiARTestFrameSelfTestingFrameZFactorEdit", "getZFactor", 0)
        self:showDebugDatum("HuaweiARTestFrameSelfTestingFrameElbowStomachMinDistanceEdit", "getElbowStomachMinDistance", 0)
        self:showDebugDatum("HuaweiARTestFrameSelfTestingFrameHandStomachMinDistanceEdit", "getHandStomachMinDistance", 0)
        self:showDebugDatum("HuaweiARTestFrameSelfTestingFrameFootCrotchMinDistanceEdit", "getFootCrotchMinDistance", 0)
        self:showDebugDatum("HuaweiARTestFrameSelfTestingFrameUpperBodyLengthEdit", "getUpperBodyLength", 0)
        self:showDebugDatum("HuaweiARTestFrameSelfTestingFrameUpperBodyWidthEdit", "getUpperBodyWidth", 0)
        self:showDebugDatum("HuaweiARTestFrameSelfTestingFrameUpperBodyHeightEdit", "getUpperBodyHeight", 0)
        self:showDebugDatum("HuaweiARTestFrameSelfTestingFrameHeadLengthEdit", "getHeadLength", 0)
        self:showDebugDatum("HuaweiARTestFrameSelfTestingFrameHeadWidthEdit", "getHeadWidth", 0)
        self:showDebugDatum("HuaweiARTestFrameSelfTestingFrameHeadHeightEdit", "getHeadHeight", 0)
    end
end

function AREngineView:modelChoices()
    local frameModelChoices = getglobal("HuaweiARTestFrameModelChoicesFrame")
    if frameModelChoices:IsShown() then
        frameModelChoices:Hide();
    else
        frameModelChoices:Show();
        if self.firstTimeToShowModelChoicesFrame then
            self:firstTimeToShowModelChoicesFrame()
            self.firstTimeToShowModelChoicesFrame = nil
        end
        self:layoutModelChoiceButtons();
    end
    getglobal("HuaweiARTestFrameSelfTestingFrame"):Hide();
end

function AREngineView:customSkinLib()
    local frameCustomSkinLib = getglobal("HuaweiARTestFrameCustomSkinLibFrame")
    if frameCustomSkinLib:IsShown() then
        frameCustomSkinLib:Hide();
        getglobal("HuaweiARTestFrameDebugBtn"):Show();
        getglobal("HuaweiARTestFrameSelfTestingBtn"):Show();
        getglobal("HuaweiARTestFrameModelChoicesBtn"):Show();
    else
        frameCustomSkinLib:Show();
        getglobal("HuaweiARTestFrameDebugBtn"):Hide();
        getglobal("HuaweiARTestFrameSelfTestingBtn"):Hide();
        getglobal("HuaweiARTestFrameModelChoicesBtn"):Hide();
        self.mCallback:requestOrganizeSkinPartDefs()
        self:UpdatePartListView(true)
    end
    getglobal("HuaweiARTestFrameSelfTestingFrame"):Hide();
end

--定制库页面部件滑动列表
function HuaweiARTestFrameCustomSkinLibFramePartListView_tableCellAtIndex(tableView,index)
	return AREngineView:UpdatePartCell(index)
end

function HuaweiARTestFrameCustomSkinLibFramePartListView_numberOfCellsInTableView(tableView)
	return AREngineView:GetPartCellCount()
end

function HuaweiARTestFrameCustomSkinLibFramePartListView_tableCellSizeForIndex(tableView,index)
	return AREngineView:GetPartCellSize(index)
end

function HuaweiARTestFrameCustomSkinLibFramePartListView_tableCellWillRecycle(tableView,cell)
	if cell then cell:Hide() end 
end

--刷新部件列表
function AREngineView:UpdatePartListView(isStatic)
	local isStatic = isStatic or false 
    local partListView = getglobal("HuaweiARTestFrameCustomSkinLibFramePartListView")
	local listViewDef = {
		width = 450,
		height = 543,
		cellCountOfRow = 3,
		startOffsetX = 5,
		offsetX = 147,
		offsetY = 10,
		cellWidth = 132,
		cellHeight = 180,
	}
	listViewDef.width = partListView:GetRealWidth2()
	listViewDef.height = partListView:GetRealHeight2()

	partListView:initData(listViewDef.width,listViewDef.height,0,listViewDef.cellCountOfRow,isStatic)
end

--部件刷新
function AREngineView:UpdatePartCell(index,skinPartDefs,tryOnSkinParts)
    --LUA的索引跟C++相差1
    -- self.m_iPartTypeIndex;
	local curPartType = self.mCallback:requestGetCurPartType()
	local skinPartTypeDefs = self.mCallback:requestGetSkinPartTypeDefs(curPartType)
	local tryOnSkinParts = self.mCallback:requestGetTryOnSkinParts()
	local index = index + 1
    --从缓存中取cell复用
    local partListView = getglobal("HuaweiARTestFrameCustomSkinLibFramePartListView")
	local cell,uiIndex = partListView:dequeueCell(0)
	--没有可复用的，创建cell
	if not cell then 
		local typeName = "Button"
		local itemName = partListView:GetName() .. "Item" .. uiIndex 
		local templateName = "ShopCustomSkinItemTemplate"
		local tableViewName = partListView:GetName()
		cell = UIFrameMgr:CreateFrameByTemplate(typeName,itemName,templateName,tableViewName)
	end 
	cell:Show()
	--根据数据刷新cell
	self:UpdatePartPageIndex()
	self:UpdatePartCellUI(index,skinPartDefs,tryOnSkinParts,cell)

	-- local shopCtrl = GetInst("UIManager"):GetCtrl("Shop")
	-- shopCtrl:UpdateTipsFrame(index, cell:GetName());

	--返回cell
	return cell
end

--部件列表页数刷新
function AREngineView:UpdatePartPageIndex()
	--设置当前滚动页
    local partListView = getglobal("HuaweiARTestFrameCustomSkinLibFramePartListView")
	local curPageIndex = partListView:GetCurPageIndex()
	local maxPageIndex = partListView:GetTotalPageIndex()
	-- self.pageText:SetText(curPageIndex .. "/" .. maxPageIndex)
end

--部件UI刷新
function AREngineView:UpdatePartCellUI(index,skinPartDefs,tryOnSkinParts,cell)
	local partDef = skinPartDefs[index]
	if partDef then 
		-- --图标
		self:UpdatePartCellIcon(cell,partDef)
		-- --体验状态
		-- self:UpdatePartCellExperienceState(cell,partDef)
		-- --标签
		-- self:UpdatePartCellTag(cell,partDef)
		-- --底部按钮
		-- self:UpdatePartCellBottomBtn(cell,partDef,tryOnSkinParts)
		-- --选中框
		-- self:UpdatePartCellCheckState(cell,partDef,tryOnSkinParts)
		-- --删除按钮
		-- self:UpdatePartCellDeleteBtn(cell)
	end
end

--部件图标刷新
function AREngineView:UpdatePartCellIcon(cell,partDef)
	local icon = self:GetChild("Icon",cell)
	if GetInst("ShopService"):CheckSkinPartRes(partDef.ModelID,nil,icon) == 0 then 
		--资源已下载
		icon:SetTexture(string.format(self.define.part.iconPath,partDef.ModelID))
	else
		--资源未下载
		icon:SetTexture(self.define.part.defaultIconPath)
	end 
end

function AREngineView:firstTimeToShowModelChoicesFrame()
    local print = Android:Localize(Android.SITUATION.HUAWEI_AR_ENGINE);
    print("firstTimeToShowModelChoicesFrame(): ");
    local DefMgr = _G.DefMgr
    local getglobal = getglobal
    local nRoleSkinCount = DefMgr:getRoleSkinNum();
    if nRoleSkinCount <= 0 then return end
    UIFrameMgr:CreateFrameList(
        "Button",
        "HuaweiARTestFrameModelChoicesFrameSkinBtn",
        "TemplateARModelBtn",
        "HuaweiARTestFrameModelChoicesFrame",
        nRoleSkinCount
    );

    for i=1, nRoleSkinCount do
        local udRoleSkinDef = DefMgr:getRoleSkinByIndex(i-1)
        local uiModelBtn = getglobal("HuaweiARTestFrameModelChoicesFrameSkinBtn" .. i)
        if udRoleSkinDef and uiModelBtn then
            uiModelBtn:SetText(udRoleSkinDef.Name);
            uiModelBtn:SetClientID(udRoleSkinDef.ID);
        end
    end

    self.m_clsModelChoicesButtonsLayoutManager = LayoutManagerFactory:newRelativeOffsetGridLayoutManager()
        :setOffsetX(-4)
        :setOffsetY(4)
        :setMarginX(-4)
        :setMarginY(4)
        :setFromRightToLeft()
        :setVertical()
        :setPoint("topright")
        :setRelativeTo("HuaweiARTestFrameModelChoicesFrame")
        :setRelativePoint("topright")
        :addIrregularUI("HuaweiARTestFrameModelChoicesFrameAvatarBtn")
        :addRegularUICount("HuaweiARTestFrameModelChoicesFrameSkinBtn", nRoleSkinCount);
    self:layoutModelChoiceButtons();
    print("firstTimeToShowModelChoicesFrame(): self.m_clsModelChoicesButtonsLayoutManager ~= nil = " + (self.m_clsModelChoicesButtonsLayoutManager ~= nil));
end

function AREngineView:layoutSelfTestingButtons()
    if self.m_clsSelfTestingButtonsLayoutManager then
        local fScale = UIFrameMgr:GetScreenScale();	
        local iScreenHeight = GetScreenHeight();
        iScreenHeight = iScreenHeight / fScale;
        local iMaxRow = math.floor((iScreenHeight - 8) / 54);
        -- print("layoutSelfTestingButtons(): self.m_clsSelfTestingButtonsLayoutManager = " + self.m_clsSelfTestingButtonsLayoutManager);
        local iWidth, iHeight
        if self.m_iCurrentOrientation == Orientation.LANDSCAPE then
            iMaxRow = math.floor((iScreenHeight - 8) / 54);
            iWidth = 130
            iHeight = 50
        elseif self.m_iCurrentOrientation == Orientation.PORTRAIT then 
            iMaxRow = math.floor((iScreenHeight - 8) / 80);
            iWidth = 160
            iHeight = 80
        else
            iMaxRow = math.floor((iScreenHeight - 8) / 54);
            iWidth = 130
            iHeight = 50
        end
        self.m_clsSelfTestingButtonsLayoutManager
            :setMaxRow(iMaxRow - 1)
            :layoutAll()
            :resetOtherPlaneSize("HuaweiARTestFrameSelfTestingFrame")
            :resetUISize(iWidth, iHeight)
    end
end

function AREngineView:layoutModelChoiceButtons()
    if self.m_clsModelChoicesButtonsLayoutManager then
        local fScale = UIFrameMgr:GetScreenScale();	
        local iScreenHeight = GetScreenHeight();
        iScreenHeight = iScreenHeight / fScale;
        local iMaxRow = math.floor((iScreenHeight - 8) / 54);
        -- print("layoutModelChoiceButtons(): self.m_clsModelChoicesButtonsLayoutManager = " + self.m_clsModelChoicesButtonsLayoutManager);
        local iWidth, iHeight
        if self.m_iCurrentOrientation == Orientation.LANDSCAPE then
            iWidth = 130
            iHeight = 50
        elseif self.m_iCurrentOrientation == Orientation.PORTRAIT then 
            iWidth = 160
            iHeight = 80
        else
            iWidth = 130
            iHeight = 50
        end
        self.m_clsModelChoicesButtonsLayoutManager
            :setMaxRow(iMaxRow)
            :layoutAll()
            :resetPlaneSize()
            :resetUISize(iWidth, iHeight)
    end
end

function AREngineView:layoutDebugFrame()
    local uiTitle = getglobal("HuaweiARTestFrameDebugFrameTitle")
	local fScale = UIFrameMgr:GetScreenScale();	
	local iScreenWidth = GetScreenWidth();
    local iScreenHeight = GetScreenHeight();
    iScreenWidth = iScreenWidth / fScale;
    iScreenHeight = iScreenHeight / fScale;
    local iWidth
    local iHeight
    if self.m_iCurrentOrientation == Orientation.LANDSCAPE then
        iWidth = math.floor((iScreenWidth * 0.8) / 5) - 2
        iHeight = math.floor((iScreenHeight * 1) / 16) - 2
        iFontSize = 20
    elseif self.m_iCurrentOrientation == Orientation.PORTRAIT then
        iWidth = math.floor((iScreenWidth * 0.75) / 5) - 2
        iHeight = math.floor((iScreenHeight * 0.5) / 16) - 2
        iFontSize = 36
    else
        return
    end
    uiTitle:SetSize(iWidth, iHeight)
    if self.m_clsSkeletonNameLayoutManager then
        self.m_clsSkeletonNameLayoutManager:resetUISize(iWidth, iHeight):resetUIFontSize(iFontSize)
    end
    if self.m_clsDataNameLayoutManager then
        self.m_clsDataNameLayoutManager:resetUISize(iWidth, iHeight):resetUIFontSize(iFontSize)
    end
    if self.m_clsDataLayoutManager then
        self.m_clsDataLayoutManager:resetUISize(iWidth, iHeight):resetUIFontSize(iFontSize)
    end
end

function AREngineView:displayOnConfigLandscape()
    self.m_iCurrentOrientation = Orientation.LANDSCAPE;
    self:onScreenOrientationChanged()
end

function AREngineView:displayOnConfigPortrait()
    self.m_iCurrentOrientation = Orientation.PORTRAIT;
    self:onScreenOrientationChanged()
end

function AREngineView:onScreenOrientationChanged()
    local getglobal = getglobal
	local fScale = UIFrameMgr:GetScreenScale();	
	local iScreenWidth = GetScreenWidth();
    local iScreenHeight = GetScreenHeight();
    iScreenWidth = iScreenWidth / fScale;
    iScreenHeight = iScreenHeight / fScale;
    -- print("displayOnConfigLandscape(): iScreenWidth = ", iScreenWidth);
    -- print("displayOnConfigLandscape(): iScreenHeight = ", iScreenHeight);
    self:layoutSelfTestingButtons();
    self:layoutModelChoiceButtons();
    self:layoutDebugFrame();
    local uiModelView = getglobal("HuaweiARTestFrameModelView");
    local uiReferentialModelView = getglobal("HuaweiARTestFrameReferentialModelView")
    local uiRotateView = getglobal("HuaweiARTestFrameRotateView")
    uiModelView:SetPoint("bottomleft", "HuaweiARTestFrame", "bottomleft", 0, 0)
    local iModelViewWidth, iModelViewHeight
    local iRefModelViewWidth
    if self.m_iCurrentOrientation == Orientation.LANDSCAPE then
        iModelViewWidth = iScreenWidth * 0.5
        iModelViewHeight = iScreenHeight * 0.9
        iRefModelViewWidth = iScreenWidth * 0.4
    elseif self.m_iCurrentOrientation == Orientation.PORTRAIT then
        iModelViewWidth = iScreenWidth * 0.5
        iModelViewHeight = iScreenHeight * 0.55
        iRefModelViewWidth = iModelViewWidth
    else
        return
    end
    uiModelView:SetSize(iModelViewWidth, iModelViewHeight)
    uiRotateView:SetSize(iModelViewWidth, iModelViewHeight)
    uiReferentialModelView:SetSize(iRefModelViewWidth, iModelViewHeight)
    uiReferentialModelView:SetPoint("left", "HuaweiARTestFrameModelView", "right", 0, 0);
end

function AREngineView:displayData(index, data)
    -- local print = Android:Localize(Android.SITUATION.HUAWEI_AR_ENGINE);
    -- print("displayData(): index = ", index);
    -- print("displayData(): data = ", data);
    if index <= 0 or index > 80 then return end
    local ui = getglobal("HuaweiARTestFrameDebugFrameData" .. index);
    if not ui then return end
    local frameDebug = getglobal("HuaweiARTestFrameDebugFrame")
    if not frameDebug then return end
    if not frameDebug:IsShown() then return end
    ui:SetText(data);
end

function AREngineView:onLoad()
    local print = Android:Localize(Android.SITUATION.HUAWEI_AR_ENGINE);
    local w = 160
    local h = 40
    local marginX = 2
    local marginY = 2

    getglobal("HuaweiARTestFrameDebugFrameTitle"):SetSize(w, h);

    self.m_clsSkeletonNameLayoutManager = LayoutManagerFactory:newLinearLayoutManager()
        :setPoint("top")
        :setRelativePoint("bottom")
		:setRelativeTo("HuaweiARTestFrameDebugFrameTitle")
        :addRegularUICount("HuaweiARTestFrameDebugFrameSkeletonName", 16)
		:setMarginX(marginX)
		:setMarginY(marginY)
        :setOffsetX(0)
        :setMaxRow(16)
        :setVertical()
		:layoutAll()

    self.m_clsDataNameLayoutManager = LayoutManagerFactory:newLinearLayoutManager()
        :setPoint("left")
        :setRelativePoint("right")
        :setRelativeTo("HuaweiARTestFrameDebugFrameTitle")
        :addRegularUICount("HuaweiARTestFrameDebugFrameDataName", 5)
		:setMarginX(marginX)
        :setMarginY(marginY)
        :setHorizontal()
        :layoutAll()
        
    self.m_clsDataLayoutManager = LayoutManagerFactory:newRelativeOffsetGridLayoutManager()
        :setPoint("topleft")
        :setRelativePoint("bottomright")
        :setRelativeTo("HuaweiARTestFrameDebugFrameTitle")
        :addRegularUICount("HuaweiARTestFrameDebugFrameData", 80)
        :setMarginX(marginX)
        :setMarginY(marginY)
        :setOffsetX(0)
        :setMaxRow(16)
        :setVertical()
        :layoutAll()

    self.m_clsSelfTestingButtonsLayoutManager = LayoutManagerFactory:newRelativeOffsetGridLayoutManager()
        :setOffsetX(0)
        :setOffsetY(-4)
        :setMarginX(-4)
        :setMarginY(4)
        :setFromRightToLeft()
        :setVertical()
        :setPoint("topright")
        :setRelativeTo("HuaweiARTestFrameCloseBtn")
        :setRelativePoint("bottomright")
        :addIrregularUI("HuaweiARTestFrameDebugBtn")
        :addIrregularUI("HuaweiARTestFrameSelfTestingBtn")
        :addIrregularUI("HuaweiARTestFrameModelChoicesBtn")
        :addIrregularUI("HuaweiARTestFrameCustomSkinLibBtn")
        :addIrregularUI("HuaweiARTestFrameSelfTestingFrameAddBodyAR3DRendererToFirstBtn")
        :addIrregularUI("HuaweiARTestFrameSelfTestingFrameAddBodyAR3DRendererToLastBtn")
        :addIrregularUI("HuaweiARTestFrameSelfTestingFrameSetIsARModeTrueBtn")
        :addIrregularUI("HuaweiARTestFrameSelfTestingFrameSetIsARModeFalseBtn")
        :addIrregularUI("HuaweiARTestFrameSelfTestingFrameRemoveBodyAR3DRendererBtn")
        :addIrregularUI("HuaweiARTestFrameSelfTestingFrameDemoFilenameEdit")
        :addIrregularUI("HuaweiARTestFrameSelfTestingFrameLoopPlayingBtn")
        :addIrregularUI("HuaweiARTestFrameSelfTestingFrameResetLoopingBtn")
        :addIrregularUI("HuaweiARTestFrameSelfTestingFrameReadDemoPointsBtn")
        :addIrregularUI("HuaweiARTestFrameSelfTestingFrameReadDemoPoints2Btn")
        :addIrregularUI("HuaweiARTestFrameSelfTestingFrameSetAllConfidenceBtn")
        :addIrregularUI("HuaweiARTestFrameSelfTestingFrameSetEachConfidenceBtn")
        :addIrregularUI("HuaweiARTestFrameSelfTestingFrameConfidenceLevelEdit")
        :addIrregularUI("HuaweiARTestFrameSelfTestingFrameIncreaseConfidenceLevelBtn")
        :addIrregularUI("HuaweiARTestFrameSelfTestingFrameDecreaseConfidenceLevelBtn")
        :addIrregularUI("HuaweiARTestFrameSelfTestingFrameIncreaseTenConfidenceLevelBtn")
        :addIrregularUI("HuaweiARTestFrameSelfTestingFrameDecreaseTenConfidenceLevelBtn")
        :addIrregularUI("HuaweiARTestFrameSelfTestingFrameZFactorEdit")
        :addIrregularUI("HuaweiARTestFrameSelfTestingFrameIncreaseZFactorBtn")
        :addIrregularUI("HuaweiARTestFrameSelfTestingFrameDecreaseZFactorBtn")
        :addIrregularUI("HuaweiARTestFrameSelfTestingFrameFrontCameraBtn")
        :addIrregularUI("HuaweiARTestFrameSelfTestingFrameRearCameraBtn")
        :addIrregularUI("HuaweiARTestFrameSelfTestingFrameRead2DBtn")
        :addIrregularUI("HuaweiARTestFrameSelfTestingFrameRead3DBtn")
        :addIrregularUI("HuaweiARTestFrameSelfTestingFrameCoordinateAxesBtn")
        :addIrregularUI("HuaweiARTestFrameSelfTestingFrameReadHipBoneBtn")
        :addIrregularUI("HuaweiARTestFrameSelfTestingFrameClearHipBoneBtn")
        -- :addIrregularUI("HuaweiARTestFrameSelfTestingFrameChangeSequenceIdModeBtn")
        -- :addIrregularUI("HuaweiARTestFrameSelfTestingFrameSpecifiedTickBtn")
        :addIrregularUI("HuaweiARTestFrameSelfTestingFramePenetrationCylinderAdjustmentBtn")
        :addIrregularUI("HuaweiARTestFrameSelfTestingFrameElbowStomachMinDistanceEdit")
        :addIrregularUI("HuaweiARTestFrameSelfTestingFrameIncreaseElbowStomachMinDistanceBtn")
        :addIrregularUI("HuaweiARTestFrameSelfTestingFrameDecreaseElbowStomachMinDistanceBtn")
        :addIrregularUI("HuaweiARTestFrameSelfTestingFrameHandStomachMinDistanceEdit")
        :addIrregularUI("HuaweiARTestFrameSelfTestingFrameIncreaseHandStomachMinDistanceBtn")
        :addIrregularUI("HuaweiARTestFrameSelfTestingFrameDecreaseHandStomachMinDistanceBtn")
        :addIrregularUI("HuaweiARTestFrameSelfTestingFrameFootCrotchMinDistanceEdit")
        :addIrregularUI("HuaweiARTestFrameSelfTestingFrameIncreaseFootCrotchMinDistanceBtn")
        :addIrregularUI("HuaweiARTestFrameSelfTestingFrameDecreaseFootCrotchMinDistanceBtn")
        :addIrregularUI("HuaweiARTestFrameSelfTestingFrameStartRecordingBtn")
        :addIrregularUI("HuaweiARTestFrameSelfTestingFrameStopRecordingBtn")
        :addIrregularUI("HuaweiARTestFrameSelfTestingFramePenetrationCuboidAdjustmentBtn")
        :addIrregularUI("HuaweiARTestFrameSelfTestingFramePenetrationCuboidAdjustment2Btn")
        :addIrregularUI("HuaweiARTestFrameSelfTestingFrameUpperBodyLengthEdit")
        :addIrregularUI("HuaweiARTestFrameSelfTestingFrameIncreaseUpperBodyLengthBtn")
        :addIrregularUI("HuaweiARTestFrameSelfTestingFrameDecreaseUpperBodyLengthBtn")
        :addIrregularUI("HuaweiARTestFrameSelfTestingFrameUpperBodyWidthEdit")
        :addIrregularUI("HuaweiARTestFrameSelfTestingFrameIncreaseUpperBodyWidthBtn")
        :addIrregularUI("HuaweiARTestFrameSelfTestingFrameDecreaseUpperBodyWidthBtn")
        :addIrregularUI("HuaweiARTestFrameSelfTestingFrameUpperBodyHeightEdit")
        :addIrregularUI("HuaweiARTestFrameSelfTestingFrameIncreaseUpperBodyHeightBtn")
        :addIrregularUI("HuaweiARTestFrameSelfTestingFrameDecreaseUpperBodyHeightBtn")
        :addIrregularUI("HuaweiARTestFrameSelfTestingFrameHeadLengthEdit")
        :addIrregularUI("HuaweiARTestFrameSelfTestingFrameIncreaseHeadLengthBtn")
        :addIrregularUI("HuaweiARTestFrameSelfTestingFrameDecreaseHeadLengthBtn")
        :addIrregularUI("HuaweiARTestFrameSelfTestingFrameHeadWidthEdit")
        :addIrregularUI("HuaweiARTestFrameSelfTestingFrameIncreaseHeadWidthBtn")
        :addIrregularUI("HuaweiARTestFrameSelfTestingFrameDecreaseHeadWidthBtn")
        :addIrregularUI("HuaweiARTestFrameSelfTestingFrameHeadHeightEdit")
        :addIrregularUI("HuaweiARTestFrameSelfTestingFrameIncreaseHeadHeightBtn")
        :addIrregularUI("HuaweiARTestFrameSelfTestingFrameDecreaseHeadHeightBtn")
        
    self:layoutSelfTestingButtons();

    self.m_clsCustomSkinLibPartTypeButtonsLayoutManager = LayoutManagerFactory:newRelativeOffsetGridLayoutManager()
        :setPoint("topright")
        :setRelativeTo("HuaweiARTestFrameCloseBtn")
        :setRelativePoint("bottomright")
        :addRegularUIFromTo("HuaweiARTestFrameCustomSkinLibFramePartTypeBtn", 1, 3)
        :addIrregularUI("HuaweiARTestFrameCustomSkinLibBtn")
        :addRegularUIFromTo("HuaweiARTestFrameCustomSkinLibFramePartTypeBtn", 4, 10)
        :setMarginX(marginX)
        :setMarginY(marginY)
        :setOffsetX(0)
        :setMaxRow(16)
        :setVertical()
        :layoutAll()

    for i=1, 10 do 
        getglobal("HuaweiARTestFrameCustomSkinLibFramePartTypeBtn" .. i):SetText(GetS(self.PART_TYPES[i].nameID));
    end

    -- print("onLoad(): self.m_clsSelfTestingButtonsLayoutManager = ", self.m_clsSelfTestingButtonsLayoutManager);
    -- print("onLoad(): self.m_clsSelfTestingButtonsLayoutManager ~= nil = " + (self.m_clsSelfTestingButtonsLayoutManager ~= nil));

    local aSkeletonNames = {
        "头",
        "颈部",
        "右肩",
        "右肘",
        "右手腕",
        "左肩",
        "左肘",
        "左手腕",
        "右髋关节",
        "右膝",
        "右脚腕",
        "左髋关节",
        "左膝盖",
        "左脚腕",
        "身体中心点",
        "骨骼点个数",
    }

    for i=1, 16 do 
        getglobal("HuaweiARTestFrameDebugFrameSkeletonName" .. i):SetText(aSkeletonNames[i]);
    end
end
-----------------------------------------------------AREngineView end-----------------------------------------------------

-----------------------------------------------------AbsAREngineModel start-----------------------------------------------------
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

--组织部件列表数据
--[==[
    示例：
    srcSkinPartDefs[i] =  {
        photo = [[avatar_icon1000_587]], 
        serverTag = 0, 
        Sex = 1, 
        BuyTips = [[]], 
        BeginTime = 1579017601, 
        Num = 188, 
        AstringID = 22184, 
        ItemID = 0, 
        Uin = 1000, 
        ownedTime = 0, 
        Desc = [[]], 
        UseItemID = 0, 
        RGBA = [[{{0,201,159,122},{1,167,105,75},{2,249,235,236}}]], 
        Tag = 1, 
        CltVersion = [[0.41.0]], 
        ShieldID = [[]], 
        Name = [[]], 
        Part = 8, 
        ExchangeRate = 0, 
        CloseEnv = [[2,12]], 
        ModelID = 589, 
        Day = 0, 
        EndTime = 1581263999, 
        CostType = 2, 
        Resize = 0, 
        Default = 0
    }   
    Created on 2020-01-18 at 10:59:27
]==]
function AbsAREngineModel:requestOrganizeSkinPartDefs()
    print("requestOrganizeSkinPartDefs(): ");
    local skinPartDefs = self.skinPartDefs
    if not skinPartDefs then 
        skinPartDefs = {}
        self.skinPartDefs = skinPartDefs
    end
    if #skinPartDefs > 0 then
        return
    end
    local ShopDataManager = GetInst("ShopDataManager")
    local srcSkinPartDefs = ShopDataManager:GetSkinPartDefs()
    print("requestOrganizeSkinPartDefs(): #srcSkinPartDefs = ", #srcSkinPartDefs);
    if not srcSkinPartDefs or #srcSkinPartDefs <= 0 then
        ShopDataManager:InitSkinPartDefs()
        srcSkinPartDefs = ShopDataManager:GetSkinPartDefs()
    end
    print("requestOrganizeSkinPartDefs(): #srcSkinPartDefs = ", #srcSkinPartDefs);
	for i = 1,#srcSkinPartDefs do 
		if not GetInst("ShopDataManager"):IsBasePart(srcSkinPartDefs[i].ModelID) then 
            table.insert(skinPartDefs, srcSkinPartDefs[i])
            -- print("organizeSkinPartDefs(): srcSkinPartDefs = ", srcSkinPartDefs[i]);
		end 
	end 
end

--获取部件分组列表数据
function AbsAREngineModel:requestGetSkinPartTypeDefs(partType)
	-- if partType ~= self.define.searchPartType then
		return self.skinPartTypeDefs[partType]
	-- else
	-- 	local searchPartTypeDefs = {}
	-- 	for i = 1,#self.skinPartTypeDefs[10] do
	-- 		local aPartDef = self.skinPartTypeDefs[10][i]
	-- 		local aPartName = ""
	-- 		if aPartDef.AstringID ~= "" then
	-- 			local itemDef = DefMgr:getItemDef(tonumber(aPartDef.AstringID))	
	-- 			if itemDef then
	-- 				aPartName = itemDef.Name
	-- 			end
	-- 		end
	-- 		if string.find(aPartName,self.searchKey) then 
	-- 			table.insert(searchPartTypeDefs,aPartDef)
	-- 		end 
	-- 	end 
	-- 	return searchPartTypeDefs
	-- end 
end

--部件列表数据分组
function AbsAREngineModel:requestSetSkinPartTypeDefs()
	self.skinPartTypeDefs ={}
	--各类型部件
	for i = 1,#self.skinPartDefs do 
		local aDef = self.skinPartDefs[i]
		if not self.skinPartTypeDefs[aDef.Part] then 
			self.skinPartTypeDefs[aDef.Part] = {}
		end 
		table.insert(self.skinPartTypeDefs[aDef.Part],aDef)
	end 
	--综合
	self.skinPartTypeDefs[10] = self.skinPartDefs
	--历史
	self:GetPartHistory()
end

--获取角色穿戴
function AbsAREngineModel:requestGetTryOnSkinPart(partType)
	return self.tryOnSkinParts[partType]
end

--获取角色全部的穿戴
function AbsAREngineModel:requestGetTryOnSkinParts()
	return self.tryOnSkinParts
end

--获取当前页签类型
function AbsAREngineModel:requestGetCurPartType()
	return self.m_iPartTypeIndex 
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