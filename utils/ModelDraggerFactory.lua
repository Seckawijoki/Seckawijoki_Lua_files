--[==[
    根据现有UI事件分发机制封装模型拖动功能
    Created on 2020-08-10 at 11:25:22
]==]
local AbsModelDragger = {
}

function AbsModelDragger:init()
    self:onRecycle();
end

function AbsModelDragger:onRecycle()
    self.mv = nil;
    self.btnDrag = nil;
    self.m_fModelViewAnchorOffsetX = 0;
    self.m_fModelViewAnchorOffsetY = 0;
    self.m_bIsDraggingModel = false;
    self.m_bEnabled = true;
end

--[==[
    是否在拖拽中
    Created on 2020-08-10 at 11:33:38
]==]
function AbsModelDragger:isDragging()
    return self.m_bIsDraggingModel;
end

--[==[
    必要调用
    Created on 2020-08-10 at 11:33:20
]==]
function AbsModelDragger:setModelView(mv)
    self.mv = mv;
    return self;
end

--[==[
    必要调用
    Created on 2020-08-10 at 11:33:20
]==]
function AbsModelDragger:setDragButton(btnDrag)
    self.btnDrag = btnDrag;
    return self;
end

function AbsModelDragger:enable()
    self.m_bEnabled = true;
    return self;
end

function AbsModelDragger:disable()
    self.m_bEnabled = false;
    self.m_bIsDraggingModel = false;
    return self;
end

--[==[
    适配器的组合转换接口之一
    Created on 2020-08-10 at 11:33:52
]==]
function AbsModelDragger:onDragBtnMouseDown(iKey, szFlag, iPressedDownX, iPressedDownY)
	local print = Android:Localize(Android.SITUATION.MODEL_DRAG);
    print("onDragBtnMouseDown(): iPressedDown = ", iPressedDownX, iPressedDownY, "| enabled = ", self.m_bEnabled);
    if not self.m_bEnabled then
        return
    end
    local mv = self.mv;
    if mv then
        self.m_fModelViewAnchorOffsetX = mv:GetAnchorOffsetX();
        self.m_fModelViewAnchorOffsetY = mv:GetAnchorOffsetY();
        print("onDragBtnMouseDown(): m_fModelViewAnchorOffset = ", self.m_fModelViewAnchorOffsetX, self.m_fModelViewAnchorOffsetY);
    end
    local btnDrag = self.btnDrag
    if btnDrag then 
        self.m_fDragBtnAnchorOffsetX = btnDrag:GetAnchorOffsetX();
        self.m_fDragBtnAnchorOffsetY = btnDrag:GetAnchorOffsetY();
    end
    self.m_fScale = UIFrameMgr:GetScreenScale();
    self.m_bIsDraggingModel = true;
    -- local iBtnWidth = self.btnDrag:GetWidth();
    -- local iBtnHeight = self.btnDrag:GetHeight();
    -- local iBtnLeft = self.btnDrag:GetLeft();
    -- local iBtnTop = self.btnDrag:GetTop();
    -- local iBtnRight = self.btnDrag:GetRight();
    -- local iBtnBottom = self.btnDrag:GetBottom();
    -- local iMvWidth = self.mv:GetWidth();
    -- local iMvHeight = self.mv:GetHeight();
    -- local iMvLeft = self.mv:GetLeft();
    -- local iMvTop = self.mv:GetTop();
    -- local iMvRight = self.mv:GetRight();
    -- local iMvBottom = self.mv:GetBottom();
    -- print(
    --     "onDragBtnMouseDown(): btn = ", iBtnLeft, iBtnTop, iBtnRight, iBtnBottom, iBtnWidth, iBtnHeight,
    --     "| mv = ", iMvLeft, iMvTop, iMvRight, iMvBottom, iMvWidth, iMvHeight
    -- );
end

--[==[
    适配器的组合转换接口之一
    Created on 2020-08-10 at 11:33:52
]==]
function AbsModelDragger:onDragBtnMouseUp(iKey, szFlag)
	local print = Android:Localize(Android.SITUATION.MODEL_DRAG);
    if not self.m_bEnabled then
        return
    end
	--local print = Android:Localize(Android.SITUATION.AR_MOTION_CAPTURE);
    print("onDragBtnMouseUp(): ");
    self.m_bIsDraggingModel = false;
    local mv = self.mv;
    if mv then
        self.m_fModelViewAnchorOffsetX = mv:GetAnchorOffsetX();
        self.m_fModelViewAnchorOffsetY = mv:GetAnchorOffsetY();
        -- print("onDragBtnMouseUp(): m_fModelViewAnchorOffset = ", self.m_fModelViewAnchorOffsetX, self.m_fModelViewAnchorOffsetY);
    end
end

--[==[
    适配器的组合转换接口之一
    移动模型
    Created on 2020-05-27 at 16:38:21
]==]
function AbsModelDragger:onDragBtnMouseMove(iPressedDownX, iPressedDownY, iMouseX, iMouseY)
	local print = Android:Localize(Android.SITUATION.MODEL_DRAG);
    print(
        "onDragBtnMouseMove(): iPressedDown = ", iPressedDownX, iPressedDownY, 
        "| iMouse = ", iMouseX, iMouseY, 
        "| enabled = ", self.m_bEnabled,
        "| isDragging = ", self.m_bIsDraggingModel
    );
    if not self.m_bEnabled then
        return
    end
    if not self.m_bIsDraggingModel then
        return
    end
    if iPressedDownX == iMouseX and iPressedDownY == iMouseY then
        return
    end
    local fScale = self.m_fScale;
    if not fScale then
        fScale = UIFrameMgr:GetScreenScale();
        self.m_fScale = fScale;
    end
    local fOffsetX = self.m_fModelViewAnchorOffsetX;
    local fOffsetY = self.m_fModelViewAnchorOffsetY;
    local iMoveX = iMouseX - iPressedDownX
    local iMoveY = iMouseY - iPressedDownY
    iMoveX = iMoveX / fScale;
    iMoveY = iMoveY / fScale;
    fOffsetX = fOffsetX + iMoveX;
    fOffsetY = fOffsetY + iMoveY;
    -- fOffsetX = fOffsetX / fScale;
    -- fOffsetY = fOffsetY / fScale;
    -- print("onDragBtnMouseMove(): fOffset = ", fOffsetX, fOffsetY, "| iMove = ", iMoveX, iMoveY);
    local mv = self.mv
    if mv then
        mv:SetAnchorOffset(fOffsetX, fOffsetY);
    end
end

--[==[
    适配器的组合转换接口之一
    关联旋转按钮的flag，避免拖拽完无法旋转模型
    Created on 2020-05-27 at 16:37:52
]==]
function AbsModelDragger:onDragBtnHide()
	local print = Android:Localize(Android.SITUATION.MODEL_DRAG);
    if not self.m_bEnabled then
        return
    end
    print("onDragBtnHide(): ");
    self.m_bIsDraggingModel = false;
end
--------------------------------------------------------------AbsModelDragger end--------------------------------------------------------------
local ModelDraggerFactory = {

}
_G.ModelDraggerFactory = ModelDraggerFactory;

function ModelDraggerFactory:new()
    local ModelDragger = ClassesCache:obtain("ModelDragger");
	AbsModelDragger.__index = AbsModelDragger
    ClassesCache:insertSuperClass(ModelDragger, AbsModelDragger)
    ModelDragger:onRecycle();
    return ModelDragger;
end