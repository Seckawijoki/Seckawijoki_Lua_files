---------------------------------------------------------------AbsLayoutManager start---------------------------------------------------------------
local AbsLayoutManager = {
    m_szClassName = "AbsLayoutManager",
    m_clsMath = _G.math,
    m_iOffsetX = 0,
    m_iOffsetY = 0,
    m_iMarginX = 0,
    m_iMarginY = 0,
    m_iBoxItemWidth = 0,
    m_iBoxItemHeight = 0,
    m_iMaxRow = 6,
    m_iMaxColumn = 10,
    m_szPoint = "topleft",
    m_szRelativeTo = "UIClient",
    m_szRelativePoint = "topleft",
    m_szNamePrefix = "",
    m_iCount = 0,
    m_bHorizontal = false,
    m_bFromLeftToRight = true,
    m_bFromTopToBottom = true,
    m_bRegularUI = true,
    m_aUIObjects = {},
}
function AbsLayoutManager:onRecycle()
	-- print("AbsLayoutManager@" .. tostring(self) .. ":onLayoutManagerRecycle():")
	self.m_iOffsetX = 0;
	self.m_iOffsetY = 0;
	self.m_iMarginX = 0;
	self.m_iMarginY = 0;
	self.m_iBoxItemWidth = 0;
	self.m_iBoxItemHeight = 0;
	self.m_iMaxRow = 6;
	self.m_iMaxColumn = 10;
	self.m_szPoint = "topleft";
	self.m_szRelativeTo = "UIClient";
	self.m_szRelativePoint = "topleft";
	self.m_szNamePrefix = "";
	self.m_iCount = 0;
	self.m_bHorizontal = false;
	self.m_bFromLeftToRight = true;
	self.m_bFromTopToBottom = true;
	self.m_bRegularUI = true;
	local aUIObjects = self.m_aUIObjects
	if not aUIObjects then
		aUIObjects = {}
		self.m_aUIObjects = aUIObjects
	end
	local length = #aUIObjects
	for i=1, length do 
		aUIObjects[i] = nil
	end
	return self;
end
function AbsLayoutManager:setPoint(szPoint)
	self.m_szPoint = szPoint;
	return self;
end
function AbsLayoutManager:setRelativeTo(szRelativeTo)
	self.m_szRelativeTo = szRelativeTo;
	return self;
end
function AbsLayoutManager:setRelativePoint(szRelativePoint)
	self.m_szRelativePoint = szRelativePoint;
	return self;
end
--[[
	@param szNamePrefix 子控件前缀名
]]
function AbsLayoutManager:setBoxItemNamePrefix(szNamePrefix)
	self.m_szNamePrefix = szNamePrefix
	local uiFirstBoxItem = getglobal(szNamePrefix .. 1);
	if not uiFirstBoxItem then return self end
	self.m_iBoxItemWidth = uiFirstBoxItem:GetWidth();
	self.m_iBoxItemHeight = uiFirstBoxItem:GetHeight();
	return self;
end
--[[
	@param iOffsetX 距离plain控件的X轴初始位移。后续会并入到plain尺寸的计算。
]]
function AbsLayoutManager:setOffsetX(iOffsetX)
	self.m_iOffsetX = iOffsetX;
	return self;
end
function AbsLayoutManager:setOffsetY(iOffsetY)
	self.m_iOffsetY = iOffsetY;
	return self;
end
function AbsLayoutManager:setBoxItemWidth(iBoxItemWidth)
	self.m_iBoxItemWidth = iBoxItemWidth >= 0 and iBoxItemWidth or 0;
	return self;
end
function AbsLayoutManager:setBoxItemHeight(iBoxItemHeight)
	self.m_iBoxItemHeight = iBoxItemHeight >= 0 and iBoxItemHeight or 0;
	return self;
end
--[[
	@param iOffsetX 相邻两个BoxItem的水平位移距离
]]
function AbsLayoutManager:setMarginX(iMarginX)
	self.m_iMarginX = iMarginX >= 0 and iMarginX or 0;
	return self;
end
function AbsLayoutManager:setMarginY(iMarginY)
	self.m_iMarginY = iMarginY >= 0 and iMarginY or 0;
	return self;
end
--[[
	@param iMaxRow 最大行数
]]
function AbsLayoutManager:setMaxRow(iMaxRow)
	self.m_iMaxRow = iMaxRow > 0 and iMaxRow or self.m_iMaxRow;
	return self;
end
--[[
	@param iMaxColumn 最大列数
]]
function AbsLayoutManager:setMaxColumn(iMaxColumn)
	self.m_iMaxColumn = iMaxColumn > 0 and iMaxColumn or self.m_iMaxColumn;
	return self;
end
function AbsLayoutManager:setHorizontal()
	self.m_bHorizontal = true;
	return self;
end
function AbsLayoutManager:setVertical()
	self.m_bHorizontal = false;
	return self;
end
--[[
	Need inherited implementation.
]]
function AbsLayoutManager:resetPlaneSize()
	return self;
end
--[[
	Need inherited implementation.
]]
function AbsLayoutManager:layoutAll(iCount)
	return self;
end
function AbsLayoutManager:setFromLeftToRight()
	self.m_bFromLeftToRight = true;
	return self
end
function AbsLayoutManager:setFromRightToLeft()
	self.m_bFromLeftToRight = false;
	return self
end
function AbsLayoutManager:setFromTopToBottom()
	self.m_bFromTopToBottom = true;
	return self
end
function AbsLayoutManager:setFromBottomToTop()
	self.m_bFromTopToBottom = false;
	return self
end
--[[
	??
]]
function AbsLayoutManager:setRegularUI(bRegular)
	self.m_bRegularUI = bRegular;
	return self
end
--[[
	添加需要布局的单个控件
]]
function AbsLayoutManager:addIrregularUI(szUIName)
	if not szUIName then return self end
	local ui = getglobal(szUIName)
	if not ui then return self end
	self.m_aUIObjects[#self.m_aUIObjects + 1] = ui
	return self
end
--[[
	添加需要批量规则布局的控件
]]
function AbsLayoutManager:addRegularCount(szNamePrefix, iCount)
	if not szNamePrefix then return self end
	if not iCount or iCount <= 0 then return self end
	local aUIObjects = self.m_aUIObjects;
	for i=1, iCount do 
		local ui = getglobal(szNamePrefix .. i)
		if ui then
			aUIObjects[#aUIObjects + 1] = ui
		end
	end
	return self
end
--[[
	添加需要批量规则布局的控件
]]
function AbsLayoutManager:addRegularUIFromTo(szNamePrefix, iFrom, iTo)
	if not szNamePrefix then return self end
	if not iFrom or not iTo then return self end
	if iFrom > iTo then return self end
	local aUIObjects = self.m_aUIObjects;
	for i=iFrom, iTo do 
		local ui = getglobal(szNamePrefix .. i)
		if ui then
			aUIObjects[#aUIObjects + 1] = ui
		end
	end
	return self
end
---------------------------------------------------------------AbsLayoutManager end---------------------------------------------------------------
---------------------------------------------------------------LayoutManagerFactory start---------------------------------------------------------------
local LayoutManagerFactory = {
    AbsLayoutManager = AbsLayoutManager,
}
_G.LayoutManagerFactory = LayoutManagerFactory
--[[
	@member m_bHorizontal 行优先排列

	格子布局
	默认行优先排列，可通过setHorizontal设置
	所有格子皆以m_szRelativeTo为目标，
	根据列数m_iMaxColumn、单位宽度m_iBoxItemWidth、初始偏移m_iOffsetX、单位外间距m_iMarginX，设置不同位置的X轴上的偏移距离
	根据列数m_iMaxColumn、单位宽度m_iBoxItemHeight、初始偏移m_iOffsetY、单位外间距m_iMarginY，设置不同位置的Y轴上的偏移距离
]]
function LayoutManagerFactory:newGridLayoutManager(szClassName)
	if not szClassName then
		szClassName = "GridLayoutManager"
	end
	local GridLayoutManager, isCache = ClassesCache:obtain(szClassName)
	if isCache then
		GridLayoutManager.m_bHorizontal = true
		return GridLayoutManager
	end
	local AbsLayoutManager = self.AbsLayoutManager
	AbsLayoutManager.__index = AbsLayoutManager
	ClassesCache:insertSuperClass(GridLayoutManager, AbsLayoutManager)
	GridLayoutManager.m_bHorizontal = true
	--[[
		计算作为SlidingFrame的Plane控件的尺寸
	]]
	function GridLayoutManager:resetPlaneSize(iMinWidth, iMinHeight)
		-- self.m_iMaxColumn = iMaxColumn > 0 and iMaxColumn or self.m_iMaxColumn;
		local uiPlane = getglobal(self.m_szRelativeTo);
		iMinWidth = iMinWidth or uiPlane:GetWidth();
		iMinHeight = iMinHeight or uiPlane:GetHeight();
		local iTargetWidth, iTargetHeight
		if self.m_bHorizontal then
			local iRow = self.m_clsMath.ceil((self.m_iCount - 1) / self.m_iMaxColumn);
			iTargetWidth = 2 * self.m_iOffsetX + (self.m_iMaxColumn) * (self.m_iMarginX + self.m_iBoxItemWidth) - self.m_iMarginX;
			iTargetHeight = 2 * self.m_iOffsetY + (iRow) * (self.m_iMarginY + self.m_iBoxItemHeight) - self.m_iMarginY;
		else
			local iColumn = self.m_clsMath.ceil((self.m_iCount - 1) / self.m_iMaxRow);
			iTargetWidth = 2 * self.m_iOffsetX + (iColumn) * (self.m_iMarginX + self.m_iBoxItemWidth) - self.m_iMarginX;
			iTargetHeight = 2 * self.m_iOffsetY + (self.m_iMaxRow) * (self.m_iMarginY + self.m_iBoxItemHeight) - self.m_iMarginY;
		end
		-- print("GridLayoutManager:resetPlaneSize(): iTargetWidth = ", iTargetWidth, "iTargetHeight = ", iTargetHeight);
		iTargetWidth = iTargetWidth > iMinWidth and iTargetWidth or iMinWidth;
		iTargetHeight = iTargetHeight > iMinHeight and iTargetHeight or iMinHeight;
		uiPlane:SetWidth(iTargetWidth);
		uiPlane:SetHeight(iTargetHeight);
		return self;
	end
	--[[
		@param uiTarget UI的userdata
		@param iCurrentRow 以1开头
		@param iCurrentColumn 以1开头
	]]
	function GridLayoutManager:onLayoutGrid(uiTarget, iCurrentRow, iCurrentColumn)
		-- print("GridLayoutManager:onLayoutGrid(): iCurrentRow = ", iCurrentRow, "iCurrentColumn = ", iCurrentColumn);
		local totalOffsetX = self.m_iOffsetX + (iCurrentColumn - 1) * (self.m_iMarginX + self.m_iBoxItemWidth);
		local totalOffsetY = self.m_iOffsetY + (iCurrentRow - 1) * (self.m_iMarginY + self.m_iBoxItemHeight);
		-- print("GridLayoutManager:onLayoutGrid(): totalOffsetX = ", totalOffsetX, "totalOffsetY = ", totalOffsetY);
		uiTarget:SetPoint(
			self.m_szPoint,
			self.m_szRelativeTo,
			self.m_szRelativePoint,
			totalOffsetX,
			totalOffsetY
		)
		return self;
	end
	--[[
		@param index UI后缀名以1开头
	]]
	function GridLayoutManager:onLayoutIndex(index)
		if not self.m_szNamePrefix or #self.m_szNamePrefix <= 0 then return end
		local uiTarget = getglobal(self.m_szNamePrefix .. index);

		if self.m_bHorizontal then
			self:onLayoutGrid(
				uiTarget, 
				self.m_clsMath.floor((index - 1) / self.m_iMaxColumn) + 1,
				(index - 1) % self.m_iMaxColumn + 1
			)
		else
			self:onLayoutGrid(
				uiTarget, 
				(index - 1) % self.m_iMaxRow + 1,
				self.m_clsMath.floor((index - 1) / self.m_iMaxRow) + 1
			)
		end
		return self;
	end
	--[[
		@Override
		@param iCount 控件数量
	]]
	function GridLayoutManager:layoutAll(iCount)
		self.m_iCount = iCount;
		-- print("GridLayoutManager:layoutAll(): iCount = ", iCount);
		for i=1, iCount do 
			self:onLayoutIndex(i);
		end
		return self;
	end
	return GridLayoutManager;
end

--[[
	从指定UI水平向两边平均分配批量子控件
]]
function LayoutManagerFactory:newHorizontalSplitLayoutManager(szClassName)
	if not szClassName then
		szClassName = "HorizontalSplitLayoutManager"
	end
	local HorizontalSplitLayoutManager, isCache = ClassesCache:obtain(szClassName)
	if isCache then
		return HorizontalSplitLayoutManager
	end
	local AbsLayoutManager = self.AbsLayoutManager
	AbsLayoutManager.__index = AbsLayoutManager
	ClassesCache:insertSuperClass(HorizontalSplitLayoutManager, AbsLayoutManager)
	--[[
		@Override
		@param iMaxVisibleCount 最大可见控件数量
		@param iMaxCount XML分配的最大控件数量
	]]
	function HorizontalSplitLayoutManager:layoutAll(iMaxVisibleCount, iMaxCount)
		-- local aAllPoints = {"topleft", "top", "topright", "left", "center", "right", "bottomleft", "bottom", "bottomright",}
		iMaxVisibleCount = iMaxVisibleCount > iMaxCount and iMaxCount or iMaxVisibleCount;
		local iMiddleIndex = math.ceil(iMaxVisibleCount / 2); -- 中间索引值
		local szOriginalPoint = self.m_szPoint;
		local szNamePrefix = self.m_szNamePrefix;
		local szRelativeTo = self.m_szRelativeTo;
		local iMarginX = self.m_iMarginX;
		local iMarginY = self.m_iMarginY;
		local szRelativePoint = self.m_szRelativePoint;
		local totalOffsetX, totalOffsetY;
		local uiObject;
		local szVerticalPoint = szOriginalPoint;
		local szMiddleIndexPoint = "center";
		if string.find(szOriginalPoint, "top", 1, true) then
			szVerticalPoint = "top";
			szMiddleIndexPoint = szVerticalPoint;
		elseif string.find(szOriginalPoint, "bottom", 1, true) then
			szVerticalPoint = "bottom"
			szMiddleIndexPoint = szVerticalPoint;
		end 

		if iMaxVisibleCount %2 == 0 then -- 偶数个布局策略 4/2=2
			totalOffsetY = self.m_iOffsetY;
			for i=iMiddleIndex, 1, -1 do 
				totalOffsetX = self.m_iMarginX / 2 + (self.m_iBoxItemWidth + self.m_iMarginX) * (iMiddleIndex - i);
				totalOffsetX = -totalOffsetX;
				uiObject = getglobal(szNamePrefix .. i);
				if uiObject then uiObject:SetPoint(szVerticalPoint .. "right", szRelativeTo, szRelativePoint, totalOffsetX, totalOffsetY); end
			end
			for i=iMiddleIndex+1, iMaxVisibleCount do 
				totalOffsetX = self.m_iMarginX / 2 + (self.m_iBoxItemWidth + self.m_iMarginX) * (i - iMiddleIndex - 1);
				uiObject = getglobal(szNamePrefix .. i);
				if uiObject then uiObject:SetPoint(szVerticalPoint .. "left", szRelativeTo, szRelativePoint, totalOffsetX, totalOffsetY); end
			end
		else  -- 奇数个布局策略 5/2=2
			totalOffsetY = self.m_iOffsetY;
			uiObject = getglobal(szNamePrefix .. iMiddleIndex);
			if uiObject then uiObject:SetPoint(szMiddleIndexPoint, szRelativeTo, szRelativePoint, 0, totalOffsetY); end
			for i=iMiddleIndex-1, 1, -1 do 
				totalOffsetX = self.m_iBoxItemWidth / 2 + self.m_iMarginX * (iMiddleIndex - i) + self.m_iBoxItemWidth* (iMiddleIndex - 1 - i);
				totalOffsetX = -totalOffsetX;
				uiObject = getglobal(szNamePrefix .. i);
				if uiObject then uiObject:SetPoint(szVerticalPoint .. "right", szRelativeTo, szRelativePoint, totalOffsetX, totalOffsetY); end
			end
			for i=iMiddleIndex+1, iMaxVisibleCount do 
				totalOffsetX = self.m_iBoxItemWidth / 2 + self.m_iMarginX * (i - iMiddleIndex) + self.m_iBoxItemWidth * (i - 1 - iMiddleIndex);
				uiObject = getglobal(szNamePrefix .. i);
				if uiObject then uiObject:SetPoint(szVerticalPoint .. "left", szRelativeTo, szRelativePoint, totalOffsetX, totalOffsetY); end
			end
		end
		for i=1, iMaxVisibleCount do 
			uiObject = getglobal(szNamePrefix .. i);
			if uiObject then uiObject:Show(); end
		end
		for i=iMaxVisibleCount+1, iMaxCount do 
			uiObject = getglobal(szNamePrefix .. i);
			if uiObject then uiObject:Hide(); end
		end
		return self;
	end
	return HorizontalSplitLayoutManager;
end

--[[
	相邻UI相对偏移分布
]]
function LayoutManagerFactory:newRelativeOffsetGridLayoutManager(szClassName)
	if not szClassName then
		szClassName = "RelativeOffsetGridLayoutManager"
	end
	local RelativeOffsetGridLayoutManager, isCache = ClassesCache:obtain(szClassName)
	if isCache then
		return RelativeOffsetGridLayoutManager
	end
	local AbsLayoutManager = self.AbsLayoutManager
	AbsLayoutManager.__index = AbsLayoutManager
	ClassesCache:insertSuperClass(RelativeOffsetGridLayoutManager, AbsLayoutManager)
	--[[
		@Override
	]]
	function RelativeOffsetGridLayoutManager:layoutAll()
		local iMarginX = self.m_iMarginX;
		local iMarginY = self.m_iMarginY;
		local aUIObjects = self.m_aUIObjects;
		iMarginX = math.abs(iMarginX)
		iMarginY = math.abs(iMarginY)
		iMarginX = self.m_bFromLeftToRight and iMarginX or -iMarginX
		iMarginY = self.m_bFromTopToBottom and iMarginY or -iMarginY
		local length = #aUIObjects;
		if length <= 0 then
			return self;
		end
		if self.m_bHorizontal then
			local iMaxColumn = self.m_iMaxColumn;
			local szPoint = self.m_bFromLeftToRight and "left" or "right"
			local szRelativePoint = self.m_bFromLeftToRight and "right" or "left"
			local szHeadPoint = self.m_bFromTopToBottom and "top" or "bottom"
			local szHeadRelativePoint = self.m_bFromTopToBottom and "bottom" or "top"
			aUIObjects[1]:SetPoint(self.m_szPoint, self.m_szRelativeTo, self.m_szRelativePoint, self.m_iOffsetX, self.m_iOffsetY)
			for i=2, length do 
				if i % iMaxColumn == 1 then
					aUIObjects[i]:SetPoint(szHeadPoint, aUIObjects[i-iMaxColumn]:GetName(), szHeadRelativePoint, 0, iMarginY)
				else
					aUIObjects[i]:SetPoint(szPoint, aUIObjects[i-1]:GetName(), szRelativePoint, iMarginX, 0)
				end
			end
		else
			local iMaxRow = self.m_iMaxRow;
			local szPoint = self.m_bFromTopToBottom and "top" or "bottom"
			local szRelativePoint = self.m_bFromTopToBottom and "bottom" or "top"
			local szHeadPoint = self.m_bFromLeftToRight and "left" or "right"
			local szHeadRelativePoint = self.m_bFromLeftToRight and "right" or "left"
			aUIObjects[1]:SetPoint(self.m_szPoint, self.m_szRelativeTo, self.m_szRelativePoint, self.m_iOffsetX, self.m_iOffsetY)
			for i=2, length do 
				if i % iMaxRow == 1 then
					aUIObjects[i]:SetPoint(szHeadPoint, aUIObjects[i-iMaxRow]:GetName(), szHeadRelativePoint, iMarginX, 0)
				else
					aUIObjects[i]:SetPoint(szPoint, aUIObjects[i-1]:GetName(), szRelativePoint, 0, iMarginY)
				end
			end
		end
		return self;
	end
	function RelativeOffsetGridLayoutManager:resetPlaneSize()
		local math = _G.math
		local iMarginX = math.abs(self.m_iMarginX)
		local iMarginY = math.abs(self.m_iMarginY)
		local iOffsetX = math.abs(self.m_iOffsetX)
		local iOffsetY = math.abs(self.m_iOffsetY)
		local aUIObjects = self.m_aUIObjects;
		iMarginX = self.m_bFromLeftToRight and iMarginX or -iMarginX
		iMarginY = self.m_bFromTopToBottom and iMarginY or -iMarginY
		local length = #aUIObjects;
		if length <= 0 then
			return self;
		end
		local iMaxHeight = 2 * iOffsetY
		local iMaxWidth = 2 * iOffsetX
		local iMaxRow
		local iMaxColumn
		local iMaxColumnHeight = 0
		local iColumnHeight = 0
		local iMaxRowWidth = 0
		local iRowWidth = 0
		if self.m_bHorizontal then
			
		else
			iMaxRow = self.m_iMaxRow;
			iMaxColumn = math.ceil(length / iMaxRow)
			iMaxHeight = iMaxHeight + iMaxRow * iMarginY - iMarginY
			iMaxWidth = iMaxWidth + iMaxColumn * iMarginX - iMarginX
			
			for i=1, iMaxColumn do 
				iColumnHeight = 0
				for j=1, iMaxRow do 
					local index = (i - 1) * iMaxRow + j
					if index > length then break end
					iColumnHeight = iColumnHeight + aUIObjects[index]:GetHeight()
				end
				if iMaxColumnHeight < iColumnHeight then
					iMaxColumnHeight = iColumnHeight
				end
			end

			for j=1, iMaxRow do 
				iRowWidth = 0
				for i=1, iMaxColumn do 
					local index = (i - 1) * iMaxRow + j
					if index > length then break end
					iRowWidth = iRowWidth + aUIObjects[index]:GetWidth()
				end
				if iMaxRowWidth < iRowWidth then
					iMaxRowWidth = iRowWidth
				end
			end
		end

		iMaxHeight = iMaxHeight + iMaxColumnHeight
		iMaxWidth = iMaxWidth + iMaxRowWidth
		getglobal(self.m_szRelativeTo):SetSize(iMaxWidth, iMaxHeight)
		return self;
	end
	return RelativeOffsetGridLayoutManager;
end

--[[
	均匀分布。
	数组中第一个UI以self.m_szRelativeTo为目标设置Anchor，其余UI均以前一个为目标设置Anchor。
	可设置初始偏移。
]]
function LayoutManagerFactory:newLinearLayoutManager(szClassName)
	if not szClassName then
		szClassName = "LinearLayoutManager"
	end
	local LinearLayoutManager, isCache = ClassesCache:obtain(szClassName)
	if isCache then
		return LinearLayoutManager
	end
	local AbsLayoutManager = self.AbsLayoutManager
	AbsLayoutManager.__index = AbsLayoutManager
	ClassesCache:insertSuperClass(LinearLayoutManager, AbsLayoutManager)
	LinearLayoutManager.m_szPoint = "center";
	--[[
		@Override
	]]
	function LinearLayoutManager:layoutAll()
		local iMarginX = self.m_iMarginX;
		local iMarginY = self.m_iMarginY;
		local aUIObjects = self.m_aUIObjects;
		local length = #aUIObjects;
		if length <= 0 then
			return self;
		end
		if self.m_bHorizontal then
			aUIObjects[1]:SetPoint(self.m_szPoint, self.m_szRelativeTo, self.m_szRelativePoint, self.m_iOffsetX, self.m_iOffsetY)
			for i=2, length do 
				aUIObjects[i]:SetPoint("left", aUIObjects[i-1]:GetName(), "right", iMarginX, 0)
			end
		else
			aUIObjects[1]:SetPoint(self.m_szPoint, self.m_szRelativeTo, self.m_szRelativePoint, self.m_iOffsetX, self.m_iOffsetY)
			for i=2, length do 
				aUIObjects[i]:SetPoint("top", aUIObjects[i-1]:GetName(), "bottom", 0, iMarginY)
			end
		end
		return self;
	end
	--[[
		垂直布局：
		根据所有控件的最大宽度和m_iMarginX，重设szRelativeTo的宽
		根据所有控件的高度和、m_iMarginY和m_iOffsetY，重设szRelativeTo的高
		水平布局：
		根据所有控件的宽度和、m_iMarginX和m_iOffsetX，重设szRelativeTo的宽
		根据所有控件的最大高度和m_iMarginY，重设szRelativeTo的高
		@Override
	]]
	function LinearLayoutManager:resetPlaneSize()
		local iTotalHeight = 0
		local iTotalWidth = 0
		local aUIObjects = self.m_aUIObjects;
		local length = #aUIObjects;
		if length <= 0 then 
			return self
		end
		if self.m_bHorizontal then
			local iTempHeight
			local iMaxHeight = 0
			iTotalWidth = 2 * self.m_iOffsetX
			for i=1, length do
				iTotalWidth = iTotalWidth + aUIObjects[i]:GetWidth()
				iTempHeight = aUIObjects[i]:GetHeight()
				iMaxHeight = iMaxHeight < iTempHeight and iTempHeight or iMaxHeight
			end
			iTotalWidth = iTotalWidth + (length - 1) * self.m_iMarginX;
			iTotalHeight = iMaxHeight + 2 * self.m_iMarginY
		else
			local iTempWidth
			local iMaxWidth = 0
			iTotalHeight = 2 * self.m_iOffsetY
			for i=1, length do
				iTotalHeight = iTotalHeight + aUIObjects[i]:GetHeight()
				iTempWidth = aUIObjects[i]:GetWidth()
				iMaxWidth = iMaxWidth < iTempWidth and iTempWidth or iMaxWidth
			end
			iTotalWidth = iMaxWidth + 2 * self.m_iMarginX
			iTotalHeight = iTotalHeight + (length - 1) * self.m_iMarginY;
		end
		local uiRelativeTo = getglobal(self.m_szRelativeTo);
		if not uiRelativeTo then
			return self;
		end
		uiRelativeTo:SetHeight(iTotalHeight);
		uiRelativeTo:SetWidth(iTotalWidth);
		return self;
	end
	return LinearLayoutManager;
end
---------------------------------------------------------------LayoutManagerFactory end---------------------------------------------------------------