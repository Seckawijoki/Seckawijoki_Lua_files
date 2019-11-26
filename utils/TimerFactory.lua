
--------------------------------------------------------TimerFactory start----------------------------------------------------------
local AbsCountdownClock = {
	m_szClassName = "AbsCountdownClock",
	time = _G.os.time,
}
-- function AbsCountdownClock:toString()
-- 	return "ResumeTime: " + self.m_aResumeTime + ","
-- 	+ "PauseTime = " + self.m_aPauseTime + ", "
-- 	+ "m_bIsRunning = " + self.m_bIsRunning + ", "
-- 	+ "m_bHasStarted = " + self.m_bHasStarted + ", "
-- 	+ "m_iCountdownSeconds = " + self.m_iCountdownSeconds + ", "
-- 	+ "m_iCountSeconds = " + self.m_iCountSeconds + ""
-- end

function AbsCountdownClock:onRecycle()
	self.m_bIsRunning = false
	self.m_bHasStarted = false
	self.m_iCountdownSeconds = 0
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
function AbsCountdownClock:start(iCountdownSeconds)
	self:onRecycle();
	self.m_bIsRunning = true;
	self.m_bHasStarted = true;
	self.m_iCountdownSeconds = iCountdownSeconds
	self.m_iCountSeconds = 0
	local t = self.time()
	self.m_aResumeTime[#self.m_aResumeTime + 1] = t
	print("AbsCountdownClock:start(): iCountdownSeconds = ", iCountdownSeconds);
	print("AbsCountdownClock:start(): t = ", t);
	print("AbsCountdownClock:start(): self = ", self);
end

--[[
	停止
	Created on 2019-09-17 at 17:33:16
]]
function AbsCountdownClock:stop()
	self.m_bIsRunning = false;
	self.m_bHasStarted = false;
	local t = self.time()
	local aResumeTime = self.m_aResumeTime
	if #aResumeTime > 0 then
		self.m_iCountSeconds = self.m_iCountSeconds + t - aResumeTime[#aResumeTime]
	end
	self.m_aPauseTime[#self.m_aPauseTime + 1] = t
	print("AbsCountdownClock:stop(): t = ", t);
	print("AbsCountdownClock:stop(): self = ", self);
end

--[[
	恢复
	Created on 2019-09-17 at 17:33:06
]]
function AbsCountdownClock:resume()
	if self.m_bIsRunning then
		return
	end
	self.m_bIsRunning = true;
	local t = self.time()
	self.m_aResumeTime[#self.m_aResumeTime + 1] = t
	print("AbsCountdownClock:resume(): t = ", t);
	print("AbsCountdownClock:resume(): self = ", self);
end

--[[
	暂停
	Created on 2019-09-17 at 17:33:09
]]
function AbsCountdownClock:pause()
	if not self.m_bIsRunning then
		return
	end
	self.m_bIsRunning = false;
	local t = self.time()
	self.m_iCountSeconds = self.m_iCountSeconds + t - self.m_aResumeTime[#self.m_aResumeTime]
	self.m_aPauseTime[#self.m_aPauseTime + 1] = t
	print("AbsCountdownClock:pause(): t = ", t);
	print("AbsCountdownClock:pause(): self = ", self);
end

--[[
	获取已计时的秒数
	Created on 2019-09-17 at 17:37:53
]]
function AbsCountdownClock:getCountSeconds()
	if self.m_bIsRunning then
		return self.m_iCountSeconds + self.time() - self.m_aResumeTime[#self.m_aResumeTime]
	else
		return self.m_iCountSeconds
	end
end

function AbsCountdownClock:hasStarted()
	return self.m_bHasStarted
end

--[[
	获取剩余的秒数
	Created on 2019-09-17 at 19:50:30
]]
function AbsCountdownClock:getResidualSeconds()
	return self.m_iCountdownSeconds - self:getCountSeconds()
end

_G.TimerFactory = {
	AbsCountdownClock = AbsCountdownClock,
}
--[[
	计时工具	
	Created on 2019-09-17 at 18:04:46
]]
function TimerFactory:newCountdownClock()
	local CountdownClock, isCache = ClassesCache:obtain("CountdownClock")
	if isCache then
		return CountdownClock
	end
	local AbsCountdownClock = self.AbsCountdownClock
	AbsCountdownClock.__index = AbsCountdownClock
	ClassesCache:insertSuperClass(CountdownClock, AbsCountdownClock)
	CountdownClock:onRecycle()
	return CountdownClock
end

--------------------------------------------------------TimerFactory end----------------------------------------------------------