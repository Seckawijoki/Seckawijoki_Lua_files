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
    self.m_bReverse = false;
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
    self.ui = ui;
    return self;
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

function AbsAnimator:isAnimating()
    return self.m_bIsAnimating;
end

function AbsAnimator:start()
    if not self.ui:IsShown() then
        return self;
    end
    self.Timer:start(self.m_fDuration);
    return self;
end

function AbsAnimator:cancel()
    self.Timer:stop();
    return self;
end

function AbsAnimator:onTimerUpdate(Timer, percentage)
    if not Timer == self.Timer then
        return false;
    end
    if not self.m_clsOnAnimationListener then
        return true;
    end
    local listener = self.m_clsOnAnimationListener
    if listener.onAnimationUpdate then
        listener:onAnimationUpdate(self, percentage);
    end
    return true;
end

function AbsAnimator:onTimerFinish(Timer)
    if not Timer == self.Timer then
        return;
    end
    self.m_bIsAnimating = false;
    local listener = self.m_clsOnAnimationListener
    if listener then
        if listener.onAnimationEnd then
            listener:onAnimationEnd(self);
        end
    end
end

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
    -- print("markAnchorOffset(): self.m_fAnchorX = " + self.m_fAnchorX);
    return self;
end

function TranslationAnimator:setUI(ui)
    self.super.super.setUI(self, ui);
    self:markAnchorOffset();
    return self;
end

function TranslationAnimator:setTranslateX(x)
    if not x then
        x = self.ui:GetRealWidth();
    end
    self.m_fTranslateX = x;
    return self;
end

function TranslationAnimator:setTranslateY(y)
    if not y then
        y = self.ui:GetRealHeight();
    end
    self.m_fTranslateY = y;
    return self;
end

function TranslationAnimator:setTranslateXSelfPercentage(percentage)
    if not percentage then
        percentage = 1;
    end
    self:setTranslateX(self.ui:GetRealWidth() * percentage)
    return self;
end

function TranslationAnimator:setTranslateYSelfPercentage(percentage)
    if not percentage then
        percentage = 1;
    end
    self:setTranslateY(self.ui:GetRealHeight() * percentage)
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

function TranslationAnimator:onTimerUpdate(Timer, percentage)
    if not self.super.super.onTimerUpdate(self, Timer, percentage) then
        return
    end
    local interpolation = self.m_clsInterpolator:getInterpolation(percentage);
    if self.m_bReverse then
        interpolation = 1 - interpolation;
    end
	local offsetX = self.m_fAnchorX + self.m_fTranslateX * interpolation;
	local offsetY = self.m_fAnchorY + self.m_fTranslateY * interpolation;
	self.m_fCurTranslateX = offsetX;
	self.m_fCurTranslateY = offsetY;
    self.ui:SetAnchorOffset(offsetX, offsetY);
    -- if self.m_bDebug then
    --     print("onTimerUpdate(): ", percentage, self.m_fAnchorX, self.m_fTranslateX, offsetX);
    -- end
    self.m_bIsAnimating = true;
end

------------------------------------AnimatorFactory start------------------------------------
local AnimatorFactory = {

}
_G.AnimatorFactory = AnimatorFactory

function AnimatorFactory:newTranslationAnimator()
    return ClassesCache:obtain("TranslationAnimator", TranslationAnimator);
end