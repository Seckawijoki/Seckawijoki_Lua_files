--------------------------------------------------------LazyTimer start----------------------------------------------------------
--[==[
    粗略的秒数计时器，根据os.time()计时，可暂停和恢复
    Created on 2020-09-05 at 15:42:44
]==]
local LazyTimer = {
	m_szClassName = "LazyTimer",
	time = _G.os.time,
}
-- function LazyTimer:toString()
-- 	return "ResumeTime: " + self.m_aResumeTime + ","
-- 	+ "PauseTime = " + self.m_aPauseTime + ", "
-- 	+ "m_bIsRunning = " + self.m_bIsRunning + ", "
-- 	+ "m_bHasStarted = " + self.m_bHasStarted + ", "
-- 	+ "m_fSecond = " + self.m_fSecond + ", "
-- 	+ "m_iCountSeconds = " + self.m_iCountSeconds + ""
-- end

function LazyTimer:onRecycle()
	self.m_bIsRunning = false
	self.m_bHasStarted = false
	self.m_fSecond = 0
	self.m_iCountSeconds = 0
	local aTime = self.m_aResumeTime
	if not aTime then
		aTime = {}
		self.m_aResumeTime = aTime
	end
	local length = #aTime
	for i=length, 1, -1 do 
		aTime[i] = nil
	end

	aTime = self.m_aPauseTime
	if not aTime then
		aTime = {}
		self.m_aPauseTime = aTime
	end
	length = #aTime
	for i=length, 1, -1 do 
		aTime[i] = nil
	end
end

--[[
	开始
	Created on 2019-09-17 at 17:33:13
]]
function LazyTimer:start(fSeconds)
	self:onRecycle();
	self.m_bIsRunning = true;
	self.m_bHasStarted = true;
	self.m_fSecond = fSeconds
	self.m_iCountSeconds = 0
	local t = self.time()
	self.m_aResumeTime[#self.m_aResumeTime + 1] = t
	print("LazyTimer:start(): fSeconds = ", fSeconds);
	print("LazyTimer:start(): t = ", t);
	print("LazyTimer:start(): self = ", self);
end

--[[
	停止
	Created on 2019-09-17 at 17:33:16
]]
function LazyTimer:stop()
	self.m_bIsRunning = false;
	self.m_bHasStarted = false;
	local t = self.time()
	local aResumeTime = self.m_aResumeTime
	if #aResumeTime > 0 then
		self.m_iCountSeconds = self.m_iCountSeconds + t - aResumeTime[#aResumeTime]
	end
	self.m_aPauseTime[#self.m_aPauseTime + 1] = t
	print("LazyTimer:stop(): t = ", t);
	print("LazyTimer:stop(): self = ", self);
end

--[[
	恢复
	Created on 2019-09-17 at 17:33:06
]]
function LazyTimer:resume()
	if self.m_bIsRunning then
		return
	end
	self.m_bIsRunning = true;
	local t = self.time()
	self.m_aResumeTime[#self.m_aResumeTime + 1] = t
	print("LazyTimer:resume(): t = ", t);
	print("LazyTimer:resume(): self = ", self);
end

--[[
	暂停
	Created on 2019-09-17 at 17:33:09
]]
function LazyTimer:pause()
	if not self.m_bIsRunning then
		return
	end
	self.m_bIsRunning = false;
	local t = self.time()
	self.m_iCountSeconds = self.m_iCountSeconds + t - self.m_aResumeTime[#self.m_aResumeTime]
	self.m_aPauseTime[#self.m_aPauseTime + 1] = t
	print("LazyTimer:pause(): t = ", t);
	print("LazyTimer:pause(): self = ", self);
end

--[[
	获取已计时的秒数
	Created on 2019-09-17 at 17:37:53
]]
function LazyTimer:getCountSeconds()
	if self.m_bIsRunning then
		return self.m_iCountSeconds + self.time() - self.m_aResumeTime[#self.m_aResumeTime]
	else
		return self.m_iCountSeconds
	end
end

function LazyTimer:hasStarted()
	return self.m_bHasStarted
end

--[[
	获取剩余的秒数
	Created on 2019-09-17 at 19:50:30
]]
function LazyTimer:getResidualSeconds()
	return self.m_fSecond - self:getCountSeconds()
end
--------------------------------------------------------LazyTimer end----------------------------------------------------------
--------------------------------------------------------UIUpdateTimer start----------------------------------------------------------
--[==[
	根据UI底层的OnUpdate的更新频率计时，大约是1秒3次，仅UI显示时计时
	Created on 2020-09-07 at 16:06:33
]==]
local UIUpdateTimer = {
	-- COUNT_PER_SECOND = 3,
	-- 大致是这个比例，具体受游戏内UI卡顿情况的影响
	REAL_WORLD_TIME_FACTOR = 0.8,
}

function UIUpdateTimer:onRecycle()
	self.m_bDebug = false;
	self.m_bIsRunning = false
	self.m_bHasStarted = false
    self.m_fCurTime = 0
	-- self.m_iCurCount = 0
	self.m_fNextUpdateSecond = 0
    self.m_fTotalSeconds = 0
	self.m_clsOnTimerListener = nil
	self.m_bIsRealWorldTimeMode = false
	self.m_fDelayTime = 0
	self.m_bIsDelayFinished = true
end

--[==[
    一秒钟调用3次，仅UI显示时调用
    Created on 2020-09-05 at 15:46:23
]==]
function UIUpdateTimer:onUpdate(interval)
    if not self.m_bIsRunning then
        return
	end
	
	local fCurTime = self.m_fCurTime
	if self.m_fDelayTime > 0 and not self.m_bIsDelayFinished then
		if fCurTime <= self.m_fDelayTime then
			fCurTime = fCurTime + interval;
			self.m_fCurTime = fCurTime;
			return
		end
		self.m_bIsDelayFinished = true;
	end

	self.m_bHasStarted = true;
	
	if self.m_bIsRealWorldTimeMode then
		-- 将根据现实世界时间更新
		interval = interval * self.REAL_WORLD_TIME_FACTOR
	end

	local fTrueCurTime = fCurTime - self.m_fDelayTime;

	local listener = self.m_clsOnTimerListener
	if listener then
		if listener.onTimerUpdate then
			local percentage = fTrueCurTime / self.m_fTotalSeconds;
			if percentage > 1 then
				percentage = 1
			end
			-- 回调百分比小数
			-- if self.m_bDebug then
			-- 	print("onUpdate(): ", self.m_bIsDelayFinished, self.m_fDelayTime, self.m_fTotalSeconds, fCurTime, fTrueCurTime, percentage);
			-- end
			listener:onTimerUpdate(self, percentage)
		end

		-- 更新从0开始。到达第一秒的时间比实际偏短
		if listener.onTimerUpdateSecond and fTrueCurTime > self.m_fNextUpdateSecond then
			listener:onTimerUpdateSecond(self, self.m_fNextUpdateSecond);
			self.m_fNextUpdateSecond = self.m_fNextUpdateSecond + 1
		end
	end
	

	-- local iCurCount = self.m_iCurCount
	fCurTime = fCurTime + interval;
	fTrueCurTime = fTrueCurTime + interval;
    if fTrueCurTime >= self.m_fTotalSeconds then
        self:stop();
		return
	end

    self.m_fCurTime = fCurTime;
end

function UIUpdateTimer:debug(enable)
	self.m_bDebug = enable
	return self;
end

function UIUpdateTimer:setOnTimerListener(onTimerListener)
	self.m_clsOnTimerListener = onTimerListener
	return self;
end

--[==[
	开始
	Created on 2020-09-07 at 14:40:11
]==]
function UIUpdateTimer:delay(fSeconds)
	self.m_fDelayTime = fSeconds
	return self;
end

--[==[
	开始
	Created on 2020-09-07 at 14:40:11
]==]
function UIUpdateTimer:start(fSeconds)
    self.m_fTotalSeconds = fSeconds
    self.m_fCurTime = 0
    -- self.m_iCurCount = 0
	self.m_fNextUpdateSecond = 0
    self.m_bIsRunning = true
	self.m_bIsDelayFinished = self.m_fDelayTime <= 0 and true or false
end

--[==[
	停止
	Created on 2020-09-07 at 14:40:21
]==]
function UIUpdateTimer:stop()
    self.m_bHasStarted = false
    self.m_bIsRunning = false
	if self.m_clsOnTimerListener then
		self.m_clsOnTimerListener:onTimerFinish(self);
	end
end

--[==[
	暂停
	Created on 2020-09-07 at 14:40:02
]==]
function UIUpdateTimer:pause()
	self.m_bIsRunning = false
end

--[==[
	恢复
	Created on 2020-09-07 at 14:39:56
]==]
function UIUpdateTimer:resume()
	self.m_bIsRunning = true
end

--[==[
	终止，不回调
	Created on 2020-09-11 at 17:23:48
]==]
function UIUpdateTimer:terminate()
    self.m_bHasStarted = false
    self.m_bIsRunning = false
end

function UIUpdateTimer:getTime()
    return self.m_fCurTime - self.m_fDelayTime;
end

--[==[
	是否开始计时
	Created on 2020-09-07 at 14:44:40
]==]
function UIUpdateTimer:hasStarted()
	return self.m_bHasStarted;
end

--[==[
	获取游戏内的时间
	Created on 2020-09-07 at 12:02:25
]==]
function UIUpdateTimer:getGameTime()
	local fCurTime = self.m_fCurTime;
	if self.m_bIsRealWorldTimeMode then
		fCurTime = fCurTime / self.REAL_WORLD_TIME_FACTOR
	end
    return fCurTime;
end

function UIUpdateTimer:setRealWorldTimeMode(isRealWorldTimeMode)
	self.m_bIsRealWorldTimeMode = isRealWorldTimeMode;
	return self;
end
--------------------------------------------------------UIUpdateTimer end----------------------------------------------------------
--------------------------------------------------------ThreadPoolTimer start----------------------------------------------------------
--[==[
	使用封装的threadpool:work新建协程进行计时，可设置不同的更新间隔
	Created on 2020-09-07 at 16:07:06
]==]
local ThreadPoolTimer = {
	REAL_WORLD_TIME_FACTOR = 0.8;
}

function ThreadPoolTimer:onRecycle()
	self.m_bIsRunning = false
	self.m_bHasStarted = false
    self.m_fCurTime = 0
	self.m_fTotalSeconds = 0
	self.m_fNextUpdateSecond = 1
	self.m_clsOnTimerListener = nil
	self.m_bIsRealWorldTimeMode = false
	self.m_fIntervalSecond = 0.1
end

--[==[
	根据self.m_fIntervalSecond间隔更新
    Created on 2020-09-05 at 15:46:23
]==]
function ThreadPoolTimer:loop()
	local listener = self.m_clsOnTimerListener
	local interval = self.m_fIntervalSecond
	local totalTime = self.m_fTotalSeconds
	local waitTime = interval;
	if self.m_bIsRealWorldTimeMode then
		interval = interval * self.REAL_WORLD_TIME_FACTOR;
	end
	while true do 
		threadpool:wait(waitTime)
		if not self.m_bHasStarted then
			return
		end
		if self.m_bIsRunning then
			local fCurTime = self.m_fCurTime
			-- local iCurCount = self.m_iCurCount
			fCurTime = fCurTime + interval;
			if fCurTime >= totalTime then
				self:stop();
				return
			end
		
			if listener then
				if listener.onTimerUpdate then
					local percentage = fCurTime / totalTime;
					-- 回调百分比小数
					listener:onTimerUpdate(self, percentage)
				end

				-- 更新从0开始。到达第一秒的时间比实际偏短
				if listener.onTimerUpdateSecond and fCurTime > self.m_fNextUpdateSecond then
					listener:onTimerUpdateSecond(self, self.m_fNextUpdateSecond);
					self.m_fNextUpdateSecond = self.m_fNextUpdateSecond + 1
				end
			end
			self.m_fCurTime = fCurTime;
		end
	end
end

function ThreadPoolTimer:setInterval(fSecondInterval)
	self.m_fIntervalSecond = fSecondInterval
	return self;
end

function ThreadPoolTimer:setOnTimerListener(onTimerListener)
	self.m_clsOnTimerListener = onTimerListener
	return self;
end

--[==[
	开始
	Created on 2020-09-07 at 14:40:11
]==]
function ThreadPoolTimer:start(fSeconds)
    self.m_fTotalSeconds = fSeconds
    self.m_fCurTime = 0
    -- self.m_iCurCount = 0
	self.m_fNextUpdateSecond = 0
    self.m_bHasStarted = true
	self.m_bIsRunning = true
	threadpool:work(self.loop, self);
end

--[==[
	停止
	Created on 2020-09-07 at 14:40:21
]==]
function ThreadPoolTimer:stop()
    self.m_bHasStarted = false
	self.m_bIsRunning = false
	if self.m_clsOnTimerListener then
		self.m_clsOnTimerListener:onTimerFinish(self);
	end
end

--[==[
	终止，不回调
	Created on 2020-09-11 at 17:23:48
]==]
function ThreadPoolTimer:terminate()
    self.m_bHasStarted = false
    self.m_bIsRunning = false
end

--[==[
	暂停
	Created on 2020-09-07 at 14:40:02
]==]
function ThreadPoolTimer:pause()
	self.m_bIsRunning = false
end

--[==[
	恢复
	Created on 2020-09-07 at 14:39:56
]==]
function ThreadPoolTimer:resume()
	self.m_bIsRunning = true
end

function ThreadPoolTimer:getTime()
    return self.m_fCurTime;
end

--[==[
	是否开始计时
	Created on 2020-09-07 at 14:44:40
]==]
function ThreadPoolTimer:hasStarted()
	return self.m_bHasStarted;
end

function ThreadPoolTimer:setRealWorldTimeMode(isRealWorldTimeMode)
	self.m_bIsRealWorldTimeMode = isRealWorldTimeMode;
	return self;
end
--------------------------------------------------------ThreadPoolTimer end----------------------------------------------------------
--------------------------------------------------------TimerFactory start----------------------------------------------------------
local TimerFactory = {
	REAL_WORLD_TIME_FACTOR = UIUpdateTimer.REAL_WORLD_TIME_FACTOR
}
_G.TimerFactory = TimerFactory;

--[[
    粗略的秒数计时器，根据os.time()计时，可暂停和恢复
	Created on 2019-09-17 at 18:04:46
]]
function TimerFactory:newLazyTimer()
	return ClassesCache:obtain("LazyTimer", LazyTimer)
end

--[==[
	简述：
		从OnUpdate中分发回调，处理百分比、秒数以及计时结束回调
	使用说明：
	1.使用UIUpdateTimer:setOnTimerListener(listener)注册回调类listener
	2.回调类listener中需包含下面三个函数，参数Timer可识别为不同的计时器：
		onTimerUpdateSecond = function(self, Timer, iCurSeconds)end -- 可选，根据秒数回调，大致一秒3次
		onTimerUpdate = function(self, Timer, percentage)end -- 可选，按百分比回调
		onTimerFinish = function(self, Timer)end -- 可选，结束时回调
	3.使用UIUpdateTimer:start(second)开始计时
	4.使用UIUpdateTimer:stop()结束计时
	5.使用UIUpdateTimer:pause()暂停计时
	6.使用UIUpdateTimer:resume()恢复计时
	7.将UI底层回调的OnUpdate中调用使用UIUpdateTimer:onUpdate(arg1)来计时
    Created on 2020-09-05 at 15:44:52
]==]
function TimerFactory:newUIUpdateTimer()
	return ClassesCache:obtain("UIUpdateTimer", UIUpdateTimer)
end

--[==[
	简述：
		使用threadpool.work与threadpool.wait联合计时，处理百分比以及计时结束回调
	使用说明：
	1.ThreadPoolTimer:setOnTimerListener(listener)注册回调类listener
	2.回调类listener中需包含下面两个个函数，参数Timer可识别为不同的计时器：
		onTimerUpdate = function(self, Timer, percentage)end -- 可选，按百分比回调
		onTimerFinish = function(self, Timer)end -- 可选，结束时回调
	3.使用ThreadPoolTimer:start(second)开始计时
	4.使用ThreadPoolTimer:stop()结束计时
	5.使用ThreadPoolTimer:pause()暂停计时
	6.使用ThreadPoolTimer:resume()恢复计时
	7.使用ThreadPoolTimer:setInterval(interval)设置更新间隔
    Created on 2020-09-07 at 16:44:52
]==]
function TimerFactory:newThreadPoolTimer()
	return ClassesCache:obtain("ThreadPoolTimer", ThreadPoolTimer)
end

--------------------------------------------------------TimerFactory end----------------------------------------------------------