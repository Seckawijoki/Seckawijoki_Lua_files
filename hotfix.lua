NickModifyFrame_OnShowOld = _G.NickModifyFrame_OnShow
function NickModifyFrame_OnShow()
	local edit         = getglobal("NickModifyFrameContentNameEdit");
	local costFont         = getglobal("NickModifyFrameContentNeedCost");
	local modifyNum = AccountManager:getAccountData():getNickModify();
	edit:Clear();
	local enablealternick = if_open_alter_name();
	edit:enableEdit(enablealternick); 

	local env = get_game_env()
	local is_debug = LuaInterface and LuaInterface:isdebug() or false
	local is_UseChangeNameCard = g_ChangeNameCard.callback and true or false
	if is_UseChangeNameCard then
			edit:enableEdit(true);
	end

	local Free_Modify_Num = getFunctionVpValue(NickModifyFrame_OnShowOld, "Free_Modify_Num")
	local cost         = 0;
	if modifyNum < Free_Modify_Num  or g_ChangeNameCard.callback then
			costFont:SetText(0);
			cost = 0;
	else
			local renameCost = AccountManager:getAccountData():getNickModifyCost();
			costFont:SetText(renameCost);
			cost = renameCost;
	end
	local hasMini        = AccountManager:getAccountData():getMiniCoin();

	if ClientCurGame and ClientCurGame:isInGame() and not getglobal("NickModifyFrame"):IsReshow() then
			ClientCurGame:setOperateUI(true);
	end

	SetCurEditBox("NickModifyFrameContentNameEdit");
end

function NickModifyFrameModifyBtn_OnClick()
	local isChangeCard = g_ChangeNameCard.callback and true or false
	if not isChangeCard and not CheckCanAlterName() then
			return
	end

	local costMini         = 0;
	local modifyNum = AccountManager:getAccountData():getNickModify();
	local Free_Modify_Num = getFunctionVpValue(NickModifyFrame_OnShowOld, "Free_Modify_Num")
	if modifyNum < Free_Modify_Num then
			costMini = 0;
	else
			costMini = AccountManager:getAccountData():getNickModifyCost();
	end

	local hasMini        = AccountManager:getAccountData():getMiniCoin();
	if hasMini >= costMini or isChangeCard then
			local edit = getglobal("NickModifyFrameContentNameEdit");
			local editText = edit:GetText();
			local appid = ClientMgr:getApiId();
			--角色名字含有空格
			if ClientMgr:getApiId() < 300 or ClientMgr:getApiId() == 999 then
					if string.find(editText,"%s")   then
							ShowGameTips(GetS(20663), 3);
							return;
					end
			end

			if CheckFilterString(editText) then        --提示角色名有敏感词
					return;
			end

			if editText == "" then                        --提示角色名不能为空                        
					ShowGameTips(GetS(45), 3)
					return;
			end
			if not AccountManager:requestCheckNickname(editText) then                --提示角色名已存在
					ShowGameTips(GetS(46), 3)
					return;
			end
			if string.find(editText, "#") then                --提示“#”号
					ShowGameTips(GetS(358), 3);
					return
			end

			if AccountManager:getAccountData():notifyServerAddNickModify(costMini) ~= 0 then
					--ShowGameTips(DefMgr:getStringDef(282), 3);
					return;
			end

			if AccountManager:requestModifyRole(editText, AccountManager:getRoleModel(), AccountManager:getRoleSkinModel(), false, nil,isChangeCard) then
					ShowGameTips(GetS(126)..editText, 3);
					--使用改名卡回调
					if g_ChangeNameCard.callback then
							g_ChangeNameCard.callback()
					end

					getglobal("NickModifyFrame"):Hide();

					getglobal("LobbyFrameHeadInfoRoleName"):SetText(AccountManager:getNickName());
					getglobal("MiniLobbyFrameTopRoleInfoName"):SetText(AccountManager:getBlueVipIconStr(AccountManager:getUin())..AccountManager:getNickName(), 53, 84, 84);
					getglobal("PlayerExhibitionCenterRoleInfoName"):SetText(AccountManager:getBlueVipIconStr(AccountManager:getUin())..AccountManager:getNickName(), 61, 69, 70);
					getglobal("GameSetFrameBaseName"):SetText(AccountManager:getNickName());
					
					PlayerCenterFrame_dataChange(2);  --名字修改                        

					--统计消耗迷你币
					if costMini > 0 then
							local name = "修改名字";
							ClientMgr:statisticsGamePurchaseMiniCoin(name, 1, costMini);
					end
			end
	else
			local lackMiniNum = costMini - hasMini;
			--[[
			local cost = math.ceil(lackMiniNum/10);
			local buyNum = cost * 10;
			cost,buyNum = GetPayRealCost(cost);
			]]
			local cost, buyNum = GetPayRealCost(lackMiniNum);
			local text = GetS(453, cost, buyNum);
			StoreMsgBox(6, text, GetS(456), -1, lackMiniNum, costMini, nil, NotEnoughMiniCoinCharge, cost);
	end
end