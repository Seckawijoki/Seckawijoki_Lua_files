--------------------------------------------------------AbsLazyTimer start----------------------------------------------------------
--[==[
    粗略的秒数计时器，根据os.time()计时，可暂停和恢复
    Created on 2020-09-05 at 15:42:44
]==]
local AbsLazyTimer = {
	m_szClassName = "AbsLazyTimer",
	time = _G.os.time,
}
-- function AbsLazyTimer:toString()
-- 	return "ResumeTime: " + self.m_aResumeTime + ","
-- 	+ "PauseTime = " + self.m_aPauseTime + ", "
-- 	+ "m_bIsRunning = " + self.m_bIsRunning + ", "
-- 	+ "m_bHasStarted = " + self.m_bHasStarted + ", "
-- 	+ "m_iSeconds = " + self.m_iSeconds + ", "
-- 	+ "m_iCountSeconds = " + self.m_iCountSeconds + ""
-- end

function AbsLazyTimer:onRecycle()
	self.m_bIsRunning = false
	self.m_bHasStarted = false
	self.m_iSeconds = 0
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
function AbsLazyTimer:start(iSeconds)
	self:onRecycle();
	self.m_bIsRunning = true;
	self.m_bHasStarted = true;
	self.m_iSeconds = iSeconds
	self.m_iCountSeconds = 0
	local t = self.time()
	self.m_aResumeTime[#self.m_aResumeTime + 1] = t
	print("AbsLazyTimer:start(): iSeconds = ", iSeconds);
	print("AbsLazyTimer:start(): t = ", t);
	print("AbsLazyTimer:start(): self = ", self);
end

--[[
	停止
	Created on 2019-09-17 at 17:33:16
]]
function AbsLazyTimer:stop()
	self.m_bIsRunning = false;
	self.m_bHasStarted = false;
	local t = self.time()
	local aResumeTime = self.m_aResumeTime
	if #aResumeTime > 0 then
		self.m_iCountSeconds = self.m_iCountSeconds + t - aResumeTime[#aResumeTime]
	end
	self.m_aPauseTime[#self.m_aPauseTime + 1] = t
	print("AbsLazyTimer:stop(): t = ", t);
	print("AbsLazyTimer:stop(): self = ", self);
end

--[[
	恢复
	Created on 2019-09-17 at 17:33:06
]]
function AbsLazyTimer:resume()
	if self.m_bIsRunning then
		return
	end
	self.m_bIsRunning = true;
	local t = self.time()
	self.m_aResumeTime[#self.m_aResumeTime + 1] = t
	print("AbsLazyTimer:resume(): t = ", t);
	print("AbsLazyTimer:resume(): self = ", self);
end

--[[
	暂停
	Created on 2019-09-17 at 17:33:09
]]
function AbsLazyTimer:pause()
	if not self.m_bIsRunning then
		return
	end
	self.m_bIsRunning = false;
	local t = self.time()
	self.m_iCountSeconds = self.m_iCountSeconds + t - self.m_aResumeTime[#self.m_aResumeTime]
	self.m_aPauseTime[#self.m_aPauseTime + 1] = t
	print("AbsLazyTimer:pause(): t = ", t);
	print("AbsLazyTimer:pause(): self = ", self);
end

--[[
	获取已计时的秒数
	Created on 2019-09-17 at 17:37:53
]]
function AbsLazyTimer:getCountSeconds()
	if self.m_bIsRunning then
		return self.m_iCountSeconds + self.time() - self.m_aResumeTime[#self.m_aResumeTime]
	else
		return self.m_iCountSeconds
	end
end

function AbsLazyTimer:hasStarted()
	return self.m_bHasStarted
end

--[[
	获取剩余的秒数
	Created on 2019-09-17 at 19:50:30
]]
function AbsLazyTimer:getResidualSeconds()
	return self.m_iSeconds - self:getCountSeconds()
end
--------------------------------------------------------AbsLazyTimer end----------------------------------------------------------
--------------------------------------------------------AbsUIUpdateTimer start----------------------------------------------------------
--[==[
	根据UI底层的OnUpdate的更新频率计时，大约是1秒3次，仅UI显示时计时
	Created on 2020-09-07 at 16:06:33
]==]
local AbsUIUpdateTimer = {
	-- COUNT_PER_SECOND = 3,
	-- 大致是这个比例，具体受游戏内UI卡顿情况的影响
	REAL_WORLD_TIME_FACTOR = 0.8,
}

function AbsUIUpdateTimer:onRecycle()
	self.m_bIsRunning = false
	self.m_bHasStarted = false
    self.m_iCurTime = 0
	-- self.m_iCurCount = 0
	self.m_iNextUpdateSecond = 0
    self.m_iTotalSeconds = 0
	self.m_clsOnTimeListener = nil
	self.m_bIsRealWorldTimeMode = false
end

--[==[
    一秒钟调用3次，仅UI显示时调用
    Created on 2020-09-05 at 15:46:23
]==]
function AbsUIUpdateTimer:onUpdate(interval)
    if not self.m_bIsRunning then
        return
    end
    if not self.m_bHasStarted then
        return
	end
	if self.m_bIsRealWorldTimeMode then
		-- 将根据现实世界时间更新
		interval = interval * self.REAL_WORLD_TIME_FACTOR
	end
	local iCurTime = self.m_iCurTime
	-- local iCurCount = self.m_iCurCount
	iCurTime = iCurTime + interval;
    if iCurTime >= self.m_iTotalSeconds then
        self:stop();
		return
	end

	local listener = self.m_clsOnTimeListener
	if listener then
		if listener.onTimerUpdateProgress then
			local percentage = iCurTime / self.m_iTotalSeconds;
			-- 回调百分比小数
			listener:onTimerUpdateProgress(self, percentage)
		end

		-- 更新从0开始。到达第一秒的时间比实际偏短
		if listener.onTimerUpdateSecond and iCurTime > self.m_iNextUpdateSecond then
			listener:onTimerUpdateSecond(self, self.m_iNextUpdateSecond);
			self.m_iNextUpdateSecond = self.m_iNextUpdateSecond + 1
		end
	end
	-- iCurCount = iCurCount + 1;
    self.m_iCurTime = iCurTime;
    -- self.m_iCurCount = iCurCount;
end

function AbsUIUpdateTimer:setOnTimeListener(onTimeListener)
	self.m_clsOnTimeListener = onTimeListener
	return self;
end

--[==[
	开始
	Created on 2020-09-07 at 14:40:11
]==]
function AbsUIUpdateTimer:start(iSeconds)
    self.m_iTotalSeconds = iSeconds
    self.m_iCurTime = 0
    -- self.m_iCurCount = 0
	self.m_iNextUpdateSecond = 0
    self.m_bHasStarted = true
    self.m_bIsRunning = true
end

--[==[
	停止
	Created on 2020-09-07 at 14:40:21
]==]
function AbsUIUpdateTimer:stop()
    self.m_bHasStarted = false
    self.m_bIsRunning = false
    self.m_clsOnTimeListener:onTimerUpdateFinish(self);
end

--[==[
	暂停
	Created on 2020-09-07 at 14:40:02
]==]
function AbsUIUpdateTimer:pause()
	self.m_bIsRunning = false
end

--[==[
	恢复
	Created on 2020-09-07 at 14:39:56
]==]
function AbsUIUpdateTimer:resume()
	self.m_bIsRunning = true
end

--[==[
	终止，不回调
	Created on 2020-09-11 at 17:23:48
]==]
function AbsUIUpdateTimer:terminate()
    self.m_bHasStarted = false
    self.m_bIsRunning = false
end

function AbsUIUpdateTimer:getTime()
    return self.m_iCurTime;
end

--[==[
	是否开始计时
	Created on 2020-09-07 at 14:44:40
]==]
function AbsUIUpdateTimer:hasStarted()
	return self.m_bHasStarted;
end

--[==[
	获取游戏内的时间
	Created on 2020-09-07 at 12:02:25
]==]
function AbsUIUpdateTimer:getGameTime()
	local iCurTime = self.m_iCurTime;
	if self.m_bIsRealWorldTimeMode then
		iCurTime = iCurTime / self.REAL_WORLD_TIME_FACTOR
	end
    return iCurTime;
end

function AbsUIUpdateTimer:setRealWorldTimeMode(isRealWorldTimeMode)
	self.m_bIsRealWorldTimeMode = isRealWorldTimeMode;
	return self;
end
--------------------------------------------------------AbsUIUpdateTimer end----------------------------------------------------------
--------------------------------------------------------AbsThreadPoolTimer start----------------------------------------------------------
--[==[
	使用封装的threadpool:work新建协程进行计时，可设置不同的更新间隔
	Created on 2020-09-07 at 16:07:06
]==]
local AbsThreadPoolTimer = {
	REAL_WORLD_TIME_FACTOR = 0.8;
}

function AbsThreadPoolTimer:onRecycle()
	self.m_bIsRunning = false
	self.m_bHasStarted = false
    self.m_iCurTime = 0
	self.m_fTotalSeconds = 0
	self.m_iNextUpdateSecond = 1
	self.m_clsOnTimeListener = nil
	self.m_bIsRealWorldTimeMode = false
	self.m_fIntervalSecond = 0.1
end

--[==[
	根据self.m_fIntervalSecond间隔更新
    Created on 2020-09-05 at 15:46:23
]==]
function AbsThreadPoolTimer:loop()
	local listener = self.m_clsOnTimeListener
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
			local iCurTime = self.m_iCurTime
			-- local iCurCount = self.m_iCurCount
			iCurTime = iCurTime + interval;
			if iCurTime >= totalTime then
				self:stop();
				return
			end
		
			if listener then
				if listener.onTimerUpdateProgress then
					local percentage = iCurTime / totalTime;
					-- 回调百分比小数
					listener:onTimerUpdateProgress(self, percentage)
				end

				-- 更新从0开始。到达第一秒的时间比实际偏短
				if listener.onTimerUpdateSecond and iCurTime > self.m_iNextUpdateSecond then
					listener:onTimerUpdateSecond(self, self.m_iNextUpdateSecond);
					self.m_iNextUpdateSecond = self.m_iNextUpdateSecond + 1
				end
			end
			self.m_iCurTime = iCurTime;
		end
	end
end

function AbsThreadPoolTimer:setInterval(fSecondInterval)
	self.m_fIntervalSecond = fSecondInterval
	return self;
end

function AbsThreadPoolTimer:setOnTimeListener(onTimeListener)
	self.m_clsOnTimeListener = onTimeListener
	return self;
end

--[==[
	开始
	Created on 2020-09-07 at 14:40:11
]==]
function AbsThreadPoolTimer:start(fSeconds)
    self.m_fTotalSeconds = fSeconds
    self.m_iCurTime = 0
    -- self.m_iCurCount = 0
	self.m_iNextUpdateSecond = 0
    self.m_bHasStarted = true
	self.m_bIsRunning = true
	threadpool:work(self.loop, self);
end

--[==[
	停止
	Created on 2020-09-07 at 14:40:21
]==]
function AbsThreadPoolTimer:stop()
    self.m_bHasStarted = false
    self.m_bIsRunning = false
    self.m_clsOnTimeListener:onTimerUpdateFinish(self);
end

--[==[
	终止，不回调
	Created on 2020-09-11 at 17:23:48
]==]
function AbsThreadPoolTimer:terminate()
    self.m_bHasStarted = false
    self.m_bIsRunning = false
end

--[==[
	暂停
	Created on 2020-09-07 at 14:40:02
]==]
function AbsThreadPoolTimer:pause()
	self.m_bIsRunning = false
end

--[==[
	恢复
	Created on 2020-09-07 at 14:39:56
]==]
function AbsThreadPoolTimer:resume()
	self.m_bIsRunning = true
end

function AbsThreadPoolTimer:getTime()
    return self.m_iCurTime;
end

--[==[
	是否开始计时
	Created on 2020-09-07 at 14:44:40
]==]
function AbsThreadPoolTimer:hasStarted()
	return self.m_bHasStarted;
end

function AbsThreadPoolTimer:setRealWorldTimeMode(isRealWorldTimeMode)
	self.m_bIsRealWorldTimeMode = isRealWorldTimeMode;
	return self;
end
--------------------------------------------------------AbsThreadPoolTimer end----------------------------------------------------------
--------------------------------------------------------TimerFactory start----------------------------------------------------------
local TimerFactory = {
	REAL_WORLD_TIME_FACTOR = AbsUIUpdateTimer.REAL_WORLD_TIME_FACTOR
}
_G.TimerFactory = TimerFactory;

--[[
    粗略的秒数计时器，根据os.time()计时，可暂停和恢复
	Created on 2019-09-17 at 18:04:46
]]
function TimerFactory:newLazyTimer()
	local LazyTimer, isCache = ClassesCache:obtain("LazyTimer")
	if isCache then
		return LazyTimer
	end
	AbsLazyTimer.__index = AbsLazyTimer
	ClassesCache:insertSuperClass(LazyTimer, AbsLazyTimer)
	LazyTimer:onRecycle()
	return LazyTimer
end

--[==[
	简述：
		从OnUpdate中分发回调，处理百分比、秒数以及计时结束回调
	使用说明：
	1.使用UIUpdateTimer:setOnTimeListener(listener)注册回调类listener
	2.回调类listener中需包含下面三个函数，参数Timer可识别为不同的计时器：
		onTimerUpdateSecond = function(self, Timer, iCurSeconds)end -- 可选，根据秒数回调，大致一秒3次
		onTimerUpdateProgress = function(self, Timer, percentage)end -- 可选，按百分比回调
		onTimerUpdateFinish = function(self, Timer)end -- 可选，结束时回调
	3.使用UIUpdateTimer:start(second)开始计时
	4.使用UIUpdateTimer:stop()结束计时
	5.使用UIUpdateTimer:pause()暂停计时
	6.使用UIUpdateTimer:resume()恢复计时
	7.将UI底层回调的OnUpdate中调用使用UIUpdateTimer:onUpdate(arg1)来计时
    Created on 2020-09-05 at 15:44:52
]==]
function TimerFactory:newUIUpdateTimer()
	local UIUpdateTimer, isCache = ClassesCache:obtain("UIUpdateTimer")
	if isCache then
		return UIUpdateTimer
	end
	AbsUIUpdateTimer.__index = AbsUIUpdateTimer
	ClassesCache:insertSuperClass(UIUpdateTimer, AbsUIUpdateTimer)
	UIUpdateTimer:onRecycle()
	return UIUpdateTimer
end

--[==[
	简述：
		使用threadpool.work与threadpool.wait联合计时，处理百分比以及计时结束回调
	使用说明：
	1.ThreadPoolTimer:setOnTimeListener(listener)注册回调类listener
	2.回调类listener中需包含下面两个个函数，参数Timer可识别为不同的计时器：
		onTimerUpdateProgress = function(self, Timer, percentage)end -- 可选，按百分比回调
		onTimerUpdateFinish = function(self, Timer)end -- 可选，结束时回调
	3.使用ThreadPoolTimer:start(second)开始计时
	4.使用ThreadPoolTimer:stop()结束计时
	5.使用ThreadPoolTimer:pause()暂停计时
	6.使用ThreadPoolTimer:resume()恢复计时
	7.使用ThreadPoolTimer:setInterval(interval)设置更新间隔
    Created on 2020-09-07 at 16:44:52
]==]
function TimerFactory:newThreadPoolTimer()
	local ThreadPoolTimer, isCache = ClassesCache:obtain("ThreadPoolTimer")
	if isCache then
		return ThreadPoolTimer
	end
	AbsThreadPoolTimer.__index = AbsThreadPoolTimer
	ClassesCache:insertSuperClass(ThreadPoolTimer, AbsThreadPoolTimer)
	ThreadPoolTimer:onRecycle()
	return ThreadPoolTimer
end

--------------------------------------------------------TimerFactory end----------------------------------------------------------