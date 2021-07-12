local AbsAnimator = {

}

function AbsAnimator:onRecycle()
    if not self.Timer then
        self.Timer = TimerFactory:newUIUpdateTimer();
        self.Timer:setOnTimerListener(self);
    end

    self.ui = nil;
    self.m_bDebug = false;
    self.m_fDuration = 0;
    self.m_bIsAnimating = false;
    self.m_bIsReverseAnimation = false;
    self.m_iCurAnimateCount = 1;
    self.m_iRepeatCount = 1;
    self.m_clsOnAnimationListener = nil;
    if not self.m_clsInterpolator then
        self.m_clsInterpolator = InterpolatorFactory:newLinearInterpolator();
    end
    return self;
end

function AbsAnimator:onUpdate(interval)
    self.Timer:onUpdate(interval)
end

function AbsAnimator:debug(enable)
    self.m_bDebug = enable;
    self.Timer:debug(enable);
    return self;
end

function AbsAnimator:setUIName(szUIName)
    self:setUI(getglobal(szUIName))
    return self;
end

function AbsAnimator:setUI(ui)
    if not self:__onCheckUI(ui) then
        assert(false)
    end
    self.ui = ui;
    return self;
end

--[==[
    检查UI的tolua接口
    Created on 2021-05-05 at 18:20:16
]==]
function AbsAnimator:__onCheckUI(ui)
    return true
end

function AbsAnimator:setOnAnimationListener(onAnimationListener)
    self.m_clsOnAnimationListener = onAnimationListener;
    return self;
end

function AbsAnimator:setInterpolator(interpolator)
    self.m_clsInterpolator = interpolator;
    return self;
end

function AbsAnimator:setStartDelay(fSeconds)
    self.Timer:delay(fSeconds);
    return self;
end

function AbsAnimator:setDuration(fSeconds)
    self.m_fDuration = fSeconds;
    return self;
end

function AbsAnimator:setReverseMode(bReverseMode)
    self.m_bReverseMode = bReverseMode;
    return self;
end

function AbsAnimator:setRepeatCount(iRepeatCount)
    self.m_iRepeatCount = iRepeatCount;
    return self;
end

function AbsAnimator:isAnimating()
    return self.m_bIsAnimating;
end

function AbsAnimator:start()
    if not self.ui:IsShown() then
        return self;
    end
    self.m_iCurAnimateCount = 1;
    self.Timer:start(self.m_fDuration);
    return self;
end

function AbsAnimator:cancel()
    if not self:isAnimating() then
        return self;
    end
    self.m_iCurAnimateCount = self.m_iRepeatCount;
    self.m_bIsReverseAnimation = false;
    self.Timer:cancel();
    return self;
end

function AbsAnimator:onTimerStart(Timer, percentage)
    if Timer ~= self.Timer then
        return
    end
    if not self.m_clsOnAnimationListener then
        return
    end
    local listener = self.m_clsOnAnimationListener
    if listener.onAnimationStart then
        listener:onAnimationStart(self);
    end
end

function AbsAnimator:onTimerCancel(Timer)
    if Timer ~= self.Timer then
        return
    end
    if not self.m_clsOnAnimationListener then
        return
    end
    local listener = self.m_clsOnAnimationListener
    if listener.onAnimationCancel then
        listener:onAnimationCancel(self);
    end
end

function AbsAnimator:onTimerUpdate(Timer, percentage)
    if Timer ~= self.Timer then
        self.m_bIsAnimating = false;
        return
    end
    self.m_bIsAnimating = true;

    local interpolation = self.m_clsInterpolator:getInterpolation(percentage);
    if self.m_bIsReverseAnimation then
        interpolation = 1 - interpolation;
    end
    self:__onUpdatePercentage(interpolation);

    if not self.m_clsOnAnimationListener then
        return
    end
    local listener = self.m_clsOnAnimationListener
    if listener.onAnimationUpdate then
        listener:onAnimationUpdate(self, interpolation);
    end
end

--[==[
    更新正向的动画
    Created on 2021-05-05 at 18:19:50
]==]
function AbsAnimator:__onUpdatePercentage(percentage)
end

function AbsAnimator:onTimerFinish(Timer)
    if Timer ~= self.Timer then
        return false;
    end
    -- if self.m_bDebug then
    --     print("onTimerFinish(): " + string.format("(%d/%d)", self.m_iCurAnimateCount, self.m_iRepeatCount));
    -- end
    if self.m_iCurAnimateCount < self.m_iRepeatCount then 
	    if self.m_bReverseMode then
	        self.m_bIsReverseAnimation = not self.m_bIsReverseAnimation;
        else
            self.m_bIsReverseAnimation = false;
	    end
	    self.m_iCurAnimateCount = self.m_iCurAnimateCount + 1;
	    self.Timer:start(self.m_fDuration);
	    return false
    end
    self.m_bIsAnimating = false;
    local listener = self.m_clsOnAnimationListener
    if listener then
        if listener.onAnimationEnd then
            listener:onAnimationEnd(self);
        end
    end
    return true
end

------------------------------------AbsAnimator end------------------------------------
------------------------------------TranslationAnimator start------------------------------------
local TranslationAnimator = {

}
ClassesCache:insertSuperClass(TranslationAnimator, AbsAnimator);
function TranslationAnimator:onRecycle()
    self.super.super.onRecycle(self)
    self.m_fAnchorX = 0;
    self.m_fAnchorY = 0;
    self.m_fTranslateX = 0;
    self.m_fTranslateY = 0;
    self.m_fCurTranslateX = 0;
    self.m_fCurTranslateY = 0;
    return self;
end

function TranslationAnimator:markAnchorOffset()
    self.m_fAnchorX = self.ui:GetAnchorOffsetX();
    self.m_fAnchorY = self.ui:GetAnchorOffsetY();
    return self;
end

function TranslationAnimator:setUI(ui)
    self.super.super.setUI(self, ui);
    self:markAnchorOffset();
    return self;
end

function TranslationAnimator:__onCheckUI(ui)
    return ui.SetAnchorOffset and true or false
end

function TranslationAnimator:setTranslateX(x)
    if not x then
        x = self.ui:GetRealWidth2();
    end
    self.m_fTranslateX = x;
    return self;
end

function TranslationAnimator:setTranslateY(y)
    if not y then
        y = self.ui:GetRealHeight2();
    end
    self.m_fTranslateY = y;
    return self;
end

function TranslationAnimator:setTranslateXSelfPercentage(percentage)
    if not percentage then
        percentage = 1;
    end
    self:setTranslateX(self.ui:GetRealWidth2() * percentage)
    return self;
end

function TranslationAnimator:setTranslateYSelfPercentage(percentage)
    if not percentage then
        percentage = 1;
    end
    self:setTranslateY(self.ui:GetRealHeight2() * percentage)
    return self;
end

function TranslationAnimator:setCurTranslateX(x)
    if not x then
        x = 0;
    end
    self.m_fTranslateX = x;
    return self;
end

function TranslationAnimator:setCurTranslateY(y)
    if not y then
        y = 0;
    end
    self.m_fTranslateY = y;
    return self;
end

function TranslationAnimator:__onUpdatePercentage(percentage)
	local offsetX = self.m_fAnchorX + self.m_fTranslateX * percentage;
	local offsetY = self.m_fAnchorY + self.m_fTranslateY * percentage;
	self.m_fCurTranslateX = offsetX;
	self.m_fCurTranslateY = offsetY;
    self.ui:SetAnchorOffset(offsetX, offsetY);
    -- if self.m_bDebug then
    --     print("__onUpdatePercentage(): ", percentage, self.m_fAnchorX, self.m_fTranslateX, offsetX);
    -- end
end

------------------------------------TranslationAnimator end------------------------------------
------------------------------------ResizeAnimator start------------------------------------
local ResizeAnimator = {

}

ClassesCache:insertSuperClass(ResizeAnimator, AbsAnimator);
function ResizeAnimator:onRecycle()
    self.super.super.onRecycle(self)
    self.m_fOldWidth = 0;
    self.m_fOldHeight = 0;
    self.m_fNewWidth = 0;
    self.m_fNewHeight = 0;
    return self;
end

function ResizeAnimator:markOldSize()
    self.m_fOldWidth = self.ui:GetWidth();
    self.m_fOldHeight = self.ui:GetHeight();
    return self;
end

function ResizeAnimator:setUI(ui)
    self.super.super.setUI(self, ui);
    self:markOldSize();
    return self;
end

function ResizeAnimator:resizeWidth(fTargetWidth)
    if not fTargetWidth then
        fTargetWidth = 0;
    end
    if fTargetWidth < 0 then
        fTargetWidth = 0;
    end
    self.m_fNewWidth = fTargetWidth;
    return self;
end

function ResizeAnimator:resizeHeight(fTargetHeight)
    if not fTargetHeight then
        fTargetHeight = 0;
    end
    if fTargetHeight < 0 then
        fTargetHeight = 0;
    end
    self.m_fNewHeight = fTargetHeight;
    return self;
end

function ResizeAnimator:__onUpdatePercentage(percentage)
	local curWidth = self.m_fOldWidth + (self.m_fNewWidth - self.m_fOldWidth) * percentage;
	local curHeight = self.m_fOldHeight + (self.m_fNewHeight - self.m_fOldHeight) * percentage;
    self.ui:SetSize(curWidth, curHeight);
    if self.ui.ChangeTexUVWidth then
        local tex = self.ui
        tex:ChangeTexUVWidth(curWidth);
    end
end

------------------------------------ResizeAnimator end------------------------------------
------------------------------------ColorAnimator start------------------------------------
local ColorAnimator = {
    Color = {
    },
}

ClassesCache:insertSuperClass(ColorAnimator, AbsAnimator);
function ColorAnimator:onRecycle()
    self.super.super.onRecycle(self)
    self.m_fOldColor = self:__newColor();
    self.m_fNewColor = self:__newColor();
    self.m_fCurColor = self:__newColor();
    return self;
end

function ColorAnimator:__newColor()
    return ClassesCache:obtain("Color", self.Color)
end

function ColorAnimator:__onCheckUI(ui)
    return ui.SetColor and true or false
end

function ColorAnimator:setOldRGB(r, g, b)
    self.m_fOldColor:setRGB(r, g, b);
    return self;
end

function ColorAnimator:setNewRGB(r, g, b)
    self.m_fNewColor:setRGB(r, g, b);
    return self;
end

function ColorAnimator:__onUpdatePercentage(percentage)
    local CurColor = self.m_fCurColor;
    CurColor:__onColorUpdate(self, percentage);
    -- if self.m_bDebug then
    --     print("__onUpdatePercentage(): CurColor = " + CurColor);
        -- print("__onUpdatePercentage(): m_bIsReverseAnimation = " + self.m_bIsReverseAnimation);
    -- end
    self.ui:SetColor(CurColor.r, CurColor.g, CurColor.b);
end

function ColorAnimator.Color:onRecycle()
    self.r = 255;
    self.g = 255;
    self.b = 255;
end

function ColorAnimator.Color:setRGB(r, g, b)
    self.r = self:__getValidValue(r);
    self.g = self:__getValidValue(g);
    self.b = self:__getValidValue(b);
end

function ColorAnimator.Color:toString()
    return string.format("(%3d, %3d, %3d)", self.r, self.g, self.b);
end

function ColorAnimator.Color:__getValidValue(value)
    if not value then
        value = 255;
    end
    if value < 0 then
        value = 0;
    end
    if value > 255 then
        value = 255;
    end
    return value;
end

function ColorAnimator.Color:__onColorUpdate(ColorAnimator, percentage)
    self.r = ColorAnimator.m_fOldColor.r + (ColorAnimator.m_fNewColor.r - ColorAnimator.m_fOldColor.r) * percentage;
    self.g = ColorAnimator.m_fOldColor.g + (ColorAnimator.m_fNewColor.g - ColorAnimator.m_fOldColor.g) * percentage;
    self.b = ColorAnimator.m_fOldColor.b + (ColorAnimator.m_fNewColor.b - ColorAnimator.m_fOldColor.b) * percentage;
    if ColorAnimator.m_bDebug then
        print("__onColorUpdate(): " + self + " | " + ColorAnimator.m_bIsReverseAnimation + " | " + percentage);
    end
end

------------------------------------ColorAnimator end------------------------------------
------------------------------------AlphaAnimator start------------------------------------
local AlphaAnimator = {

}

ClassesCache:insertSuperClass(AlphaAnimator, AbsAnimator);
function AlphaAnimator:onRecycle()
    self.super.super.onRecycle(self)
    self.m_fOldAlpha = 0;
    self.m_fNewAlpha = 0;
    return self;
end

function AlphaAnimator:__onCheckUI(ui)
    return ui.SetBlendAlpha and true or false
end

function AlphaAnimator:setAlphaFrom(fOldAlpha)
    if not fOldAlpha then
        fOldAlpha = 0;
    end
    if fOldAlpha < 0 then
        fOldAlpha = 0;
    end
    if fOldAlpha > 1 then
        fOldAlpha = 1;
    end
    self.m_fOldAlpha = fOldAlpha;
    return self;
end

function AlphaAnimator:setAlphaTo(fNewAlpha)
    if not fNewAlpha then
        fNewAlpha = 0;
    end
    if fNewAlpha < 0 then
        fNewAlpha = 0;
    end
    if fNewAlpha > 1 then
        fNewAlpha = 1;
    end
    self.m_fNewAlpha = fNewAlpha;
    return self;
end

function AlphaAnimator:__onUpdatePercentage(percentage)
    local curAlpha = self.m_fOldAlpha + (self.m_fNewAlpha - self.m_fOldAlpha) * percentage;
    self.ui:SetBlendAlpha(curAlpha);
end

------------------------------------AlphaAnimator end------------------------------------
------------------------------------AnimatorFactory start------------------------------------
local AnimatorFactory = {

}
_G.AnimatorFactory = AnimatorFactory

function AnimatorFactory:newTranslationAnimator(onAnimationListener)
    return ClassesCache:obtain("TranslationAnimator", TranslationAnimator)
        :setOnAnimationListener(onAnimationListener);
end

function AnimatorFactory:newResizeAnimator(onAnimationListener)
    return ClassesCache:obtain("ResizeAnimator", ResizeAnimator)
        :setOnAnimationListener(onAnimationListener);
end

function AnimatorFactory:newColorAnimator(onAnimationListener)
    return ClassesCache:obtain("ColorAnimator", ColorAnimator)
        :setOnAnimationListener(onAnimationListener);
end

function AnimatorFactory:newAlphaAnimator(onAnimationListener)
    return ClassesCache:obtain("AlphaAnimator", AlphaAnimator)
        :setOnAnimationListener(onAnimationListener);
end
------------------------------------AnimatorFactory end------------------------------------