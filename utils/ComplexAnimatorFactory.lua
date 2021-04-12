local ScreenEdgeDrawerAnimator = {
    DRAWER_DELAY_FACTOR = 0.15
}

function ScreenEdgeDrawerAnimator:onRecycle()
    if not self.IconSlideInAnimator then
        self.IconSlideInAnimator = AnimatorFactory:newTranslationAnimator();
        self.IconSlideInAnimator:setOnAnimationListener(self);
    end

    if not self.DrawerSlideInAnimator then
        self.DrawerSlideInAnimator = AnimatorFactory:newTranslationAnimator();
        self.DrawerSlideInAnimator:setOnAnimationListener(self);
        self.DrawerSlideInAnimator:setInterpolator(InterpolatorFactory:newAccelerateDecelerateInterpolator());
    end
    
    if not self.IconSlideOutAnimator then
        self.IconSlideOutAnimator = AnimatorFactory:newTranslationAnimator();
        self.IconSlideOutAnimator:setOnAnimationListener(self);
    end

    if not self.DrawerSlideOutAnimator then
        self.DrawerSlideOutAnimator = AnimatorFactory:newTranslationAnimator();
        self.DrawerSlideOutAnimator:setOnAnimationListener(self);
        self.DrawerSlideOutAnimator:setInterpolator(InterpolatorFactory:newAccelerateDecelerateInterpolator());
    end
    
    if not self.KeepVisibleTimer then
        self.KeepVisibleTimer = TimerFactory:newUIUpdateTimer();
        self.KeepVisibleTimer:setOnTimerListener(self);
    end

	self.uiIcon = nil;
	self.uiDrawer = nil;

	self.m_bVisible = false;
    self.m_bIsSlidingOut = false;
    
	self.slideInSecond = 1;
	self.slideOutSecond = 1;
    self.m_fKeepVisibleSecond = 10;
end

function ScreenEdgeDrawerAnimator:onUpdate(interval)
	self.IconSlideInAnimator:onUpdate(interval);
    self.DrawerSlideInAnimator:onUpdate(interval);
    
	self.IconSlideOutAnimator:onUpdate(interval);
    self.DrawerSlideOutAnimator:onUpdate(interval);
    
	self.KeepVisibleTimer:onUpdate(interval);
end

function ScreenEdgeDrawerAnimator:setIconUI(szUIName)
    self.IconSlideInAnimator:setUIName(szUIName)
    self.IconSlideOutAnimator:setUIName(szUIName)
    return self;
end

function ScreenEdgeDrawerAnimator:setDrawerUI(szUIName)
    self.DrawerSlideInAnimator:setUIName(szUIName)
    self.DrawerSlideOutAnimator:setUIName(szUIName)
    return self;
end

function ScreenEdgeDrawerAnimator:setSlideInSecond(fSeconds)
    self.IconSlideInAnimator:setDuration(fSeconds)
    self.DrawerSlideInAnimator:setDuration(fSeconds * (1 - self.DRAWER_DELAY_FACTOR) * 0.75)
    -- self.DrawerSlideInAnimator:setStartDelay(fSeconds * self.DRAWER_DELAY_FACTOR)
    return self;
end

function ScreenEdgeDrawerAnimator:setSlideOutSecond(fSeconds)
    self.IconSlideOutAnimator:setDuration(fSeconds)
    self.DrawerSlideOutAnimator:setDuration(fSeconds * (1 - self.DRAWER_DELAY_FACTOR) * 0.75)
    -- self.DrawerSlideOutAnimator:setStartDelay(fSeconds * self.DRAWER_DELAY_FACTOR)
    return self;
end

function ScreenEdgeDrawerAnimator:setKeepVisibleSecond(fSeconds)
    self.m_fKeepVisibleSecond = fSeconds;
    return self;
end

function ScreenEdgeDrawerAnimator:fromLeftToRight()
    self.IconSlideInAnimator:setTranslateXSelfPercentage(0.5);
    self.IconSlideInAnimator:setTranslateY(0);

    self.DrawerSlideInAnimator:setTranslateXSelfPercentage(1);
    self.DrawerSlideInAnimator:setTranslateY(0);

    self.IconSlideOutAnimator:setTranslateXSelfPercentage(-0.5);
    self.IconSlideOutAnimator:setTranslateY(0);

    self.DrawerSlideOutAnimator:setTranslateXSelfPercentage(-1);
    self.DrawerSlideOutAnimator:setTranslateY(0);
    return self;
end

-- function ScreenEdgeDrawerAnimator:fromToToBottom()
--     self.IconSlideInAnimator:setTranslateX(0);
--     self.IconSlideInAnimator:setTranslateYSelfPercentage(0.5);

--     self.DrawerSlideInAnimator:setTranslateX(0);
--     self.DrawerSlideInAnimator:setTranslateYSelfPercentage(1);

--     self.IconSlideOutAnimator:setTranslateX(0);
--     self.IconSlideOutAnimator:setTranslateYSelfPercentage(-0.5);

--     self.DrawerSlideOutAnimator:setTranslateX(0);
--     self.DrawerSlideOutAnimator:setTranslateYSelfPercentage(-1);
--     return self;
-- end

function ScreenEdgeDrawerAnimator:onAnimationUpdate(Animator, percentage)
    if Animator == self.IconSlideInAnimator then
		self.m_bVisible = true;
	elseif Animator == self.IconSlideOutAnimator then
		self.m_bVisible = true;
		self.m_bIsSlidingOut = true;
	end
end

function ScreenEdgeDrawerAnimator:onAnimationEnd(Animator)
    if Animator == self.IconSlideInAnimator then
        self.m_bVisible = true;
        self.KeepVisibleTimer:start(self.m_fKeepVisibleSecond);
    elseif Animator == self.IconSlideOutAnimator then
		self.m_bIsSlidingOut = false;
		self.m_bVisible = false;
    end
end

function ScreenEdgeDrawerAnimator:onTimerFinish(Timer)
    if Timer == self.KeepVisibleTimer then
		self.IconSlideOutAnimator:markAnchorOffset();
        self.DrawerSlideOutAnimator:markAnchorOffset();
        
		self.IconSlideOutAnimator:start();
		self.DrawerSlideOutAnimator:start();
	end
end

function ScreenEdgeDrawerAnimator:start()
	-- if self.m_bIsSlidingOut then
	-- 	self.m_bIsSlidingOut = false;
	-- 	self.SlideOutTimer:terminate();
	-- 	self.SlideInTimer:start(self.slideInSecond - self.SlideOutTimer:getTime())
	-- 	return
    -- end
    
	if self.m_bVisible then
		self.KeepVisibleTimer:start(self.m_fKeepVisibleSecond);
		return
    end
    
    self.IconSlideInAnimator:start();
    self.DrawerSlideInAnimator:start();
end

------------------------------------ComplexAnimatorFactory start------------------------------------
local ComplexAnimatorFactory = {

}
_G.ComplexAnimatorFactory = ComplexAnimatorFactory;

function ComplexAnimatorFactory:newScreenEdgeDrawerAnimator()
    return ClassesCache:obtain("ScreenEdgeDrawerAnimator", ScreenEdgeDrawerAnimator)
end