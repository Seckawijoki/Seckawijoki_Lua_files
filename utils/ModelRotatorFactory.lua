local AbsModelRotator = {
}

function AbsModelRotator:init()
    self:onRecycle();
end

function AbsModelRotator:onRecycle()
    self.mv = nil;
    self.btnRotate = nil;
    self.m_bIsSwept = false;
    self.m_bHasRotated = false;
    self.m_iActorPosX = 0;
    self.m_iActorPosY= 0;
    self.m_bIsFingerMovedVertically = false;
    self.m_bIsModelViewFirstClicked = true;
    self.m_iLastRotateBtnPressedX = 0;
    self.m_iLastRotateBtnPressedY = 0;
    self.m_bIsRotatingModel = false;
    self.m_tModelAngle = {
        agSwitch = true,
        xAngle = 0,
        yAngle = 0,
        zAngle = 0,
    };
    self.m_bEnabled = true;
    self.mv2 = nil;
end

--[==[
    是否在拖拽中
    Created on 2020-08-10 at 11:33:38
]==]
function AbsModelRotator:isRotating()
    return self.m_bIsRotatingModel;
end

--[==[
    必要调用
    Created on 2020-08-10 at 11:33:20
]==]
function AbsModelRotator:setModelView(mv)
    self.mv = mv;
    return self;
end

--[==[
    必要调用
    Created on 2020-08-10 at 11:33:20
]==]
function AbsModelRotator:setModelView2(mv)
    self.mv2 = mv;
    return self;
end

--[==[
    必要调用
    Created on 2020-08-10 at 11:33:20
]==]
function AbsModelRotator:setRotateButton(btnRotate)
    self.btnRotate = btnRotate;
    return self;
end

function AbsModelRotator:enable()
    self.m_bEnabled = true;
    return self;
end

function AbsModelRotator:disable()
    self.m_bEnabled = false;
    self.m_bIsRotatingModel = false;
    return self;
end

function AbsModelRotator:setModelAngle(agSwitch, fAngleX, fAngleY, fAngleZ)
    if self.mv then
        self.mv:setModelAngle(agSwitch, fAngleX, fAngleY, fAngleZ)
    end
    if self.mv2 then
        self.mv2:setModelAngle(agSwitch, fAngleX, fAngleY, fAngleZ)
    end
end
--[==[
    适配器的组合转换接口之一
    最开始按下手指，或最开始点击鼠标左键
    Created on 2020-05-27 at 16:37:16
]==]
function AbsModelRotator:onRotateBtnMouseDown(iKey, szFlag, iPressedDownX, iPressedDownY)
	local print = Android:Localize(Android.SITUATION.MODEL_ROTATE);
    print("onRotateBtnMouseDown(): iPressedDown = ", iPressedDownX, iPressedDownY);
    if not self.m_bEnabled then
        return
    end
	-- local print = Android:Localize(Android.SITUATION.AR_MOTION_CAPTURE);
    -- print("onRotateBtnMouseDown(): iKey = ", iKey);
    -- print("onRotateBtnMouseDown(): szFlag = ", szFlag);
    self.m_bIsSwept = false;
    self.m_bHasRotated = false;
    self.m_bIsModelViewFirstClicked = true;
    self.m_tModelAngle = self.mv:getModelAngle();
    self.m_iActorPosX = self.mv:getActorPosX();
    self.m_iActorPosY = self.mv:getActorPosY();
    self.m_fScale = UIFrameMgr:GetScreenScale();
    self.m_bIsRotatingModel = true;
    -- local iBtnWidth = self.btnRotate:GetWidth();
    -- local iBtnHeight = self.btnRotate:GetHeight();
    -- local iBtnLeft = self.btnRotate:GetLeft();
    -- local iBtnTop = self.btnRotate:GetTop();
    -- local iBtnRight = self.btnRotate:GetRight();
    -- local iBtnBottom = self.btnRotate:GetBottom();
    -- local iMvWidth = self.mv:GetWidth();
    -- local iMvHeight = self.mv:GetHeight();
    -- local iMvLeft = self.mv:GetLeft();
    -- local iMvTop = self.mv:GetTop();
    -- local iMvRight = self.mv:GetRight();
    -- local iMvBottom = self.mv:GetBottom();
    -- print(
    --     "onRotateBtnMouseDown(): btn = ", iBtnLeft, iBtnTop, iBtnRight, iBtnBottom, iBtnWidth, iBtnHeight,
    --     "| mv = ", iMvLeft, iMvTop, iMvRight, iMvBottom, iMvWidth, iMvHeight
    -- );
    -- print("onRotateBtnMouseDown(): ActorPos = ", self.m_iActorPosX, self.m_iActorPosY)
end

--[==[
    适配器的组合转换接口之一
    手指离开屏幕，或鼠标左键松开
    Created on 2020-05-27 at 16:36:56
]==]
function AbsModelRotator:onRotateBtnMouseUp(iKey, szFlag)
	local print = Android:Localize(Android.SITUATION.MODEL_ROTATE);
    if not self.m_bEnabled then
        return
    end
	--local print = Android:Localize(Android.SITUATION.AR_MOTION_CAPTURE);
    --print("onRotateBtnMouseUp(): ");
    print("onRotateBtnMouseUp(): ");
    -- print("onRotateBtnMouseUp(): iKey = ", iKey);
    -- print("onRotateBtnMouseUp(): szFlag = ", szFlag);
    -- print("onRotateBtnMouseUp(): os.time() = ", os.time());
    self.m_bIsRotatingModel = false;
end

--[==[
    适配器的组合转换接口之一
    旋转模型
    Created on 2020-05-27 at 16:36:38
]==]
function AbsModelRotator:onRotateBtnMouseMove(iPressedDownX, iPressedDownY, iMouseX, iMouseY)
	local print = Android:Localize(Android.SITUATION.MODEL_ROTATE);
    print(
        "onRotateBtnMouseMove(): iPressedDown = ", iPressedDownX, iPressedDownY, 
        "| iMouse = ", iMouseX, iMouseY, 
        "| enabled = ", self.m_bEnabled,
        "| isRotating = ", self.m_bIsRotatingModel
    );
    if not self.m_bEnabled then
        return
    end
    if not self.m_bIsRotatingModel then
        return
    end
    local mv = self.mv
    if not mv then return end

	local iActorPosX = mv:getActorPosX();
	local iActorPosY = mv:getActorPosY();

	local iHeight = mv:GetRealHeight()
    local iWidth = mv:GetRealWidth();

    local abs = math.abs

    local tModelAngle = self.m_tModelAngle
    local fScale = self.m_fScale;
    if not fScale then
        fScale = UIFrameMgr:GetScreenScale();
        self.m_fScale = fScale;
    end
    tModelAngle.zAngle = 0;
    if (abs(iMouseX - self.m_iActorPosX) > 10 / fScale or abs(iMouseY - self.m_iActorPosY) > 10 / fScale) 
    and iPressedDownX > iActorPosX - 170 / fScale
    and iPressedDownX < iActorPosX + 170  / fScale
    and iPressedDownY > iActorPosY - 410 / fScale 
    and iPressedDownY < iActorPosY + 30 / fScale then
		local fAngleX = (iPressedDownX - iMouseX) / 2;
		local fAngleY = (iPressedDownY - iMouseY) / 4;

		fAngleX = fAngleX + tModelAngle.xAngle;
		fAngleY = fAngleY + tModelAngle.yAngle;
        self:setModelAngle(true, fAngleX, fAngleY, tModelAngle.zAngle);
		self.m_bHasRotated = true;
	end

    if self.m_bIsModelViewFirstClicked then
        self.m_bIsModelViewFirstClicked = false;
        if abs(iMouseY - iPressedDownY) > abs(iMouseX - iPressedDownX) then
            self.m_bIsFingerMovedVertically = true;
        elseif  abs(iMouseY - iPressedDownY) < abs(iMouseX - iPressedDownX) then
            self.m_bIsFingerMovedVertically = false;
        end
    end

    if self.m_bIsFingerMovedVertically == true 
    and iPressedDownX > iActorPosX - iHeight 
    and iPressedDownX < iActorPosX + iHeight 
    and iPressedDownY > iActorPosY - iWidth 
    and iPressedDownY < iActorPosY + iWidth then
		local fAngleY = (iPressedDownY - iMouseY) / 4;
		fAngleY = fAngleY + tModelAngle.yAngle;
        self:setModelAngle(true, tModelAngle.xAngle, fAngleY, tModelAngle.zAngle);
		self.m_bHasRotated = true;
    elseif self.m_bIsFingerMovedVertically == false 
    and iPressedDownX > iActorPosX - iHeight 
    and iPressedDownX < iActorPosX + iHeight 
    and iPressedDownY > iActorPosY - iWidth 
    and iPressedDownY < iActorPosY + iWidth then
		local fAngleX = (iPressedDownX - iMouseX)/2;
		fAngleX = fAngleX + tModelAngle.xAngle;
        self:setModelAngle(true, fAngleX, tModelAngle.yAngle, tModelAngle.zAngle);
		self.m_bHasRotated = true;
	end
end

--------------------------------------------------------------AbsModelRotator end--------------------------------------------------------------
local ModelRotatorFactory = {

}
_G.ModelRotatorFactory = ModelRotatorFactory;
--[==[
    简述：
        根据现有UI事件分发机制封装模型旋转功能
    使用：
        需在辅助按钮的3个UI注册的函数中调用适配器函数
        1.在OnMouseDown回调中调用ModelRotator:onRotateBtnMouseDown(arg1, arg2, arg3, arg4)
        2.在OnMouseUp回调中调用ModelRotator:onRotateBtnMouseUp(arg1, arg2)
        3.在OnMouseMove回调中调用ModelRotator:onRotateBtnMouseMove(arg1, arg2, arg3, arg4)
    Created on 2020-08-10 at 11:25:22
]==]
function ModelRotatorFactory:new()
    local ModelRotator = ClassesCache:obtain("ModelRotator");
	AbsModelRotator.__index = AbsModelRotator
    ClassesCache:insertSuperClass(ModelRotator, AbsModelRotator)
    ModelRotator:onRecycle();
    return ModelRotator;
end