local ItemUseSkinDefTools = {

}
_G.ItemUseSkinDefTools = ItemUseSkinDefTools;
--[==[
	检查是否已拥有皮肤	
]==]
function ItemUseSkinDefTools:checkChameleonUnlocked()
	return self:checkSkinOwned(35) and self:checkSkinOwned(36)
end

--[==[
	检查是否已拥有皮肤	
]==]
function ItemUseSkinDefTools:checkSkinOwned(skinId)
	local print = Android:Localize(Android.SITUATION.QRCODE_SCANNER);
	print("checkSkinOwned(): skinId = " + skinId);
	if not skinId then 
		print("checkSkinOwned(): skinId nil");
		return false
	end
	local skinTime = AccountManager:getAccountData():getSkinTime(skinId);
	print("checkSkinOwned(): skinTime = " + skinTime);
	return skinTime ~= 0
end

--[==[
	通过道具ID，检查是否已拥有皮肤	
]==]
function ItemUseSkinDefTools:checkSkinOwnedByItemId(itemId)
	local print = Android:Localize(Android.SITUATION.QRCODE_SCANNER);
	print("checkSkinOwnedByItemId(): itemId = " + itemId);
	itemId = tonumber(itemId);
	if not itemId then 
		print("checkSkinOwnedByItemId(): itemId nil");
		return false 
	end
	if not _G.ItemUseSkinDef then
		local skinId = _G.ITEM_ID_TO_SKIN_ID[itemId]
		return self:checkSkinOwned(skinId)
	end
	local skinId = self:getSkinIDByItemID(itemId)
	return self:checkSkinOwned(skinId)
end

--[==[
	通过道具ID，检查是否已拥有avatar部件
	Created on 2019-08-31 at 18:05:43
]==]
function ItemUseSkinDefTools:checkAvatarOwned(itemId,doNotUpdateSkinPart)
	local print = Android:Localize(Android.SITUATION.QRCODE_SCANNER);
	print("checkAvatarOwned(): itemId = " + itemId);
	if not itemId then return false end
	itemId = tonumber(itemId);
	local ShopDataManager = GetInst("ShopDataManager");
	-- print("checkAvatarOwned(): ShopDataManager = " + ShopDataManager);
	if not ShopDataManager then  return false end
	local avatarModelID = self:getAvatarModelIDByItemID(itemId)
	if not avatarModelID then return false end
	if not doNotUpdateSkinPart then 
		GetInst("ShopDataManager"):UpdateSkinPartOwnedFlag(avatarModelID)
	end 
	if ShopDataManager:IsBasePart(avatarModelID) then 
		return true 
	else
		local partDef = ShopDataManager:GetSkinPartDefById(avatarModelID)
		-- print("checkAvatarOwned(): partDef = " + partDef);
		if partDef.ownedTime == -1 then 
			--永久拥有
			return true
		elseif partDef.ownedTime == 0 then 
			--未拥有
			return false
		elseif partDef.ownedTime > 0 then 
			--限时拥有
			return false
		end 
		return false
	end 
end

--[==[
	是否是avatar皮肤道具。具体指三个变色龙
	Created on 2020-03-31 at 18:13:35
]==]
function ItemUseSkinDefTools:isAvatarSkinItem(itemId)
	local print = Android:Localize(Android.SITUATION.QRCODE_SCANNER);
	print("isAvatarSkinItem(): itemId = " + itemId);
	local skinId = _G.ITEM_ID_TO_SKIN_ID[itemId]
	return skinId and (skinId == 34 or skinId == 35 or skinId == 36) or false
end

--[==[
	是否是avatar部件
	Created on 2020-03-31 at 18:13:57
]==]
function ItemUseSkinDefTools:isAvatarItem(itemId)
	local print = Android:Localize(Android.SITUATION.QRCODE_SCANNER);
	print("isAvatarItem(): itemId = " + itemId);
	if not itemId then return false end
	local ItemUseSkinDef = _G.ItemUseSkinDef
	itemId = tonumber(itemId);
	local element = ItemUseSkinDef[itemId]
	print("isAvatarItem(): element = " + element);
	if not element then return false end
	local tostring = _G.tostring
	if tostring(element.Uin) == "" or tostring(element.ModelID) == "" or tostring(element.Tag) == "" or tostring(element.Day) == "" then
		return false
	end
	print("isAvatarItem(): is avatar item");
	return true
end

--[==[
	是否是变色龙
	Created on 2020-03-31 at 18:14:13
]==]
function ItemUseSkinDefTools:isChameleonSkin(skinId)
	-- local print = Android:Localize(Android.SITUATION.QRCODE_SCANNER);
	return skinId == 34 or skinId == 35 or skinId == 36
end

--[==[
	是否是变色龙道具
	Created on 2020-03-31 at 18:14:13
]==]
function ItemUseSkinDefTools:isChameleonSkinItem(itemId)
	local print = Android:Localize(Android.SITUATION.QRCODE_SCANNER);
	return itemId == 20411 or itemId == 20412 or itemId == 20413
end

--[==[
	是否是永久皮肤道具
	element =  {
		ExpireTimeType = 3, 
		Tag = [[]], 
		SkinID = 9, 
		MiniBean = 10, 
		ModelID = [[]], 
		ItemID = 13029, 
		Uin = [[]], 
		Day = [[]]
	} 
]==]
function ItemUseSkinDefTools:isPermanentSkinItem(itemId)
	local print = Android:Localize(Android.SITUATION.QRCODE_SCANNER);
	print("isPermanentSkinItem(): itemId = " + itemId);
	if not itemId then return false end
	itemId = tonumber(itemId);
	local element =  _G.ItemUseSkinDef[itemId];
	print("isPermanentSkinItem(): element = " + element);
	return element and element.ExpireTimeType == 3 or false;
end

--[==[
	获取皮肤ID
	element =  {
		ExpireTimeType = 3, 
		Tag = [[]], 
		SkinID = 9, 
		MiniBean = 10, 
		ModelID = [[]], 
		ItemID = 13029, 
		Uin = [[]], 
		Day = [[]]
	} 
]==]
function ItemUseSkinDefTools:getSkinIDByItemID(itemId)
	local print = Android:Localize(Android.SITUATION.QRCODE_SCANNER);
	print("getSkinIDByItemID(): type(itemId) = ", type(itemId));
	itemId = tonumber(itemId)
	print("getSkinIDByItemID(): type(itemId) = ", type(itemId));
	local element = _G.ItemUseSkinDef[itemId]
	print("getSkinIDByItemID(): element = " + element);
	if not element then	return nil end
	if type(element.SkinID) == "string" and #element.SkinID <= 0 then return nil end
	return element.SkinID
end

--[==[	
	element =  {
		ExpireTimeType = 3, 
		Tag = [[]], 
		SkinID = 9, 
		MiniBean = 10, 
		ModelID = [[]], 
		ItemID = 13029, 
		Uin = [[]], 
		Day = [[]]
	} 
]==]
function ItemUseSkinDefTools:getAvatarModelIDByItemID(itemId)
	local print = Android:Localize(Android.SITUATION.QRCODE_SCANNER);
	local element = _G.ItemUseSkinDef[itemId]
	print("getAvatarModelIDByItemID(): element = " + element);
	if not element then return nil end
	if type(element.ModelID) == "string" and #element.ModelID <= 0 then return nil end
	return element.ModelID
end

function ItemUseSkinDefTools:isMiniCoin(itemId)
	return itemId == 10002
end

function ItemUseSkinDefTools:isMiniBean(itemId)
	return itemId == 10000
end


--[==[	
	皮肤id 获取 皮肤物品id
	tag 物品类型 0=普通皮肤体验卡，4=Avatar体验卡（获取后自动使用），5=装扮位道具，6=直接获得皮肤
	element =  {
		ExpireTimeType = 3, 
		Tag = [[]], 
		SkinID = 9, 
		MiniBean = 10, 
		ModelID = [[]], 
		ItemID = 13029, 
		Uin = [[]], 
		Day = [[]]
	} 
]==]
function ItemUseSkinDefTools:getItemIDBySkinID(skinId, tag)
	local itemId = nil
	local iusd = _G.ItemUseSkinDef

	for k, v in pairs(iusd) do
		if v.Tag and tag == v.Tag and v.SkinID and skinId == v.SkinID then
			itemId = k
			break
		end
	end

	return itemId
end

--[==[	
	avatar modelid 获取 物品id
	tag 物品类型 0=普通皮肤体验卡，4=Avatar体验卡（获取后自动使用），5=装扮位道具，6=直接获得皮肤
	element =  {
		ExpireTimeType = 3, 
		Tag = [[]], 
		SkinID = 9, 
		MiniBean = 10, 
		ModelID = [[]], 
		ItemID = 13029, 
		Uin = [[]], 
		Day = [[]]
	} 
]==]
function ItemUseSkinDefTools:getItemIDByAvtModelID(modelid)
	local itemId = nil
	local iusd = _G.ItemUseSkinDef

	for k, v in pairs(iusd) do
		if v.ModelID and modelid == v.ModelID and v.Tag and 4 == v.Tag and v.Day and 0 == v.Day then
			itemId = k
			break
		end
	end

	return itemId
end