-- utf-8 --
{
    ver = '0.12.1',

	{
		ver_list="0.39.5",
		install = function()



            -- 1
            if _G.__dev_to_game_call__ then
                _G.__dev_to_game_call_hotfix__ = _G.__dev_to_game_call_hotfix__ or _G.__dev_to_game_call__
                _G.__dev_to_game_call__ = function (servicename, methodname, msg)
                    if servicename == 'area' then
                        print('game call -area-, -' .. tostring(methodname) .. '-')
                        local params = ((type(msg) == 'string' and msg ~= '' and JSON:decode(msg)) or {})
                        print('game call IN : params=', unpack(params))
                        local newfunc = {
                            objInArea = function(areaid, objid)
                                local areaMgr = CurWorld and CurWorld:getSceneAreaMgr()
                                if areaMgr and CurWorld then
                                    local actor = CurWorld:getActorMgr():findActorByWID(objid)
                                    if actor then
                                        local x, y, z = actor:getPosition(0, 0, 0)
                                        x, y, z = x * 0.01, y * 0.01, z * 0.01
                                        x, y, z = math.floor(x), math.floor(y), math.floor(z)
                                        local ret = areaMgr:CheckIfPosInArea(areaid, x, y, z)
                                        if ret then
                                            return ErrorCode.OK
                                        end
                                    end
                                end
                        
                                return ErrorCode.FAILED
                            end,
                        }
    
                        local f = newfunc[methodname]
                        if f then
                            local ret = {f(unpack(params))}
                            print('game call OUT : params=', unpack(ret))
                            return JSON:encode(ret)
                        end
                    end
    
                    return _G.__dev_to_game_call_hotfix__(servicename, methodname, msg)
                end 
            end


            -- 2
            _G.ScriptSupportCtrl.version = '2019-11-15'
            _G.ScriptSupportTrigger.makeActionCellCode = function(self, cell, index)
                if type(cell) == 'table' then
                    if cell.toggle == false then
                        return
                    end
                    if not next(cell) then -- 空table
                        return
                    end
                end

                -- value
                index = index or -1
                local debug = ScriptSupportCtrl:getDebugFlag() and true
                local exeobjflag = true
                local vcode = self:makeCodeForValue(cell, debug, exeobjflag) or ''

                -- 生成单元
                local content = [==[
                    if Trigger and Trigger:checkTriggerInsID(_ins_id_) then
                        _status_idx_ = <index>
                        _exeObjid_ = nil
                        local cellresult = true
                
                        local status, err = pcall(function()
                            return <func>
                        end)
                
                        if not status then
                            print('--- [sstrigger] action error!!! --', _status_idx_, err)
                            --Game:msgBox('[action] error idx =' .. tostring(_status_idx_) .. '\n'.. err)
                            cellresult = false
                        else
                            cellresult = (err == nil or err) and true or false
                        end
                
                        if logidx then
                            Trigger.Debug:setTriggerActionResult(logidx, _status_idx_, cellresult)
                        end
                
                        _status_idx_ = 0
                        _exeObjid_ = nil
                    end
                ]==]
                content = string.gsub(content, '<func>', vcode, 1)
                content = string.gsub(content, '<index>', tostring(index), 1)
                return content
            end



SpamPreventionPresenter.m_clsView.onEnterPressed = function(self, szUIName)
    if szUIName == "ChatInputBox" then
        self:sendChat(szUIName);
        getglobal("ChatInputFrame"):Hide();
        UIFrameMgr:setCurEditBox(nil);
    end
end

SpamPreventionPresenter.m_clsView.displayFullscreenSendChat = function(self)
    self:sendChat("ChatInputBox");
    getglobal("ChatInputFrame"):Hide();
    UIFrameMgr:setCurEditBox(nil);
end

SpamPreventionPresenter.m_clsView.sendChat = function(self, szUIName)
    local ebChat = getglobal(szUIName);
    local szPlayerMsg = ebChat:GetText();
    ebChat:AddStringToHistory(szPlayerMsg);
    self.mCallback:requestSendChat(szPlayerMsg);
    ebChat:Clear();
end

		end
	},



	{
		ver_list="0.39.0 0.39.1",
		install = function()


function RoomUIFramePlayerInfo_OnUpdate()
	if not ClientCurGame:isInGame() then return end

	local t = {};	--所有的玩家的信息
	local myBriefInfo = ClientCurGame:getPlayerBriefInfo(-1);	--自己
	if myBriefInfo ~= nil then
		table.insert(t, myBriefInfo);
	end

	local num = ClientCurGame:getNumPlayerBriefInfo();
	for i=1, num do
		local briefInfo = ClientCurGame:getPlayerBriefInfo(i-1);
		if briefInfo ~= nil then
			table.insert(t, briefInfo);
		end
	end

	local teamNum = ClientCurGame:getNumTeam();
	--if teamNum > 1 then
		table.sort(t,
			function(a, b)
				return a.teamid < b.teamid;
			end
		)
	--end

	for i=1, RoomInteractiveData.maxTeamNum do
		local teamMark = getglobal("RoomUIFramePlayerInfoTeamMark"..i);
		teamMark:Hide();
	end
	getglobal("RoomUIFramePlayerInfoTeamMark999"):Hide();

	local curY = 0;
	local curX = 0;

	if teamNum >= 1 then
		local curTeamId = 0;

		for i=1, #t do
			local player = getglobal("RoomUIFramePlayerInfoPlayer"..i);
			local briefInfo = t[i];
			if briefInfo.teamid ~= curTeamId then
				if curX ~= 0 then
					curX = 0;
					curY = curY + 85;
				end

				curTeamId = briefInfo.teamid
				local teamMark = getglobal("RoomUIFramePlayerInfoTeamMark"..curTeamId);
				teamMark:SetPoint("top", "RoomUIFramePlayerInfoPlane", "top", 0, curY);

				local teamIcon = getglobal("RoomUIFramePlayerInfoTeamMark"..curTeamId.."Icon");
				teamIcon:SetTexUV(RoomInteractiveData.teamData[curTeamId].uvName);
				
				if briefInfo.teamid == 999 then
					teamIcon:SetGray(true);
				end

				local teamName = getglobal("RoomUIFramePlayerInfoTeamMark"..curTeamId.."Name");
				teamName:SetText(GetS(RoomInteractiveData.teamData[curTeamId].nameSID));

				teamMark:Show();

				curY = curY + 30;
			end

			local bkg = getglobal("RoomUIFramePlayerInfoPlayer"..i.."Bkg");
			local bkgColor = RoomInteractiveData.teamData[curTeamId] and RoomInteractiveData.teamData[curTeamId].bkgColor or nil;
			if not bkgColor or curTeamId == 999 then
				bkg:SetColor(255, 255 ,255, 255);
			else
				bkg:SetColor(
					bkgColor.r, 
					bkgColor.g, 
					bkgColor.b, 
					128
				);
			end
			player:SetPoint("topleft", "RoomUIFramePlayerInfoPlane", "topleft", curX, curY);
			if curX == 0 then
				curX = 278;
			else
				curX = 0;
				curY = curY + 85;
			end
		end
	else
		for i=1, #t do
			local player = getglobal("RoomUIFramePlayerInfoPlayer"..i);
			local briefInfo = t[i];

			local bkg = getglobal("RoomUIFramePlayerInfoPlayer"..i.."Bkg");
			bkg:SetColor(255, 255, 255, 255);

			if briefInfo.teamid == 999 then
				if curX ~= 0 then
					curX = 0;
					curY = curY + 85;
				end

				curTeamId = briefInfo.teamid
				local teamMark = getglobal("RoomUIFramePlayerInfoTeamMark"..curTeamId);
				teamMark:SetPoint("top", "RoomUIFramePlayerInfoPlane", "top", 0, curY);

				local teamIcon = getglobal("RoomUIFramePlayerInfoTeamMark"..curTeamId.."Icon");
				teamIcon:SetTexUV(RoomInteractiveData.teamData[curTeamId].uvName);
				teamIcon:SetGray(true);

				local teamName = getglobal("RoomUIFramePlayerInfoTeamMark"..curTeamId.."Name");
				teamName:SetText(GetS(RoomInteractiveData.teamData[curTeamId].nameSID));

				teamMark:Show();

				curY = curY + 30;
			end
			
			player:SetPoint("topleft", "RoomUIFramePlayerInfoPlane", "topleft", curX, curY);
			
			if curX == 0 then
				curX = 278;
			else
				curX = 0;
				curY = curY + 85;
			end
		end
	end

	local canJoinHalfway = true;
	if CurWorld:isGameMakerRunMode() and ClientCurGame:getRuleOptionVal(38) == 0 and ClientCurGame:getGameStage() >= 3 then
		canJoinHalfway = false;
	end

	if ClientCurGame:getMaxPlayerNum() > num+1 and canJoinHalfway then --有空位并且中途能加入游戏
		getglobal("RoomUIFramePlayerInviteFriendBtn"):Enable();
		getglobal("RoomUIFramePlayerInviteFriendBtnNormal"):SetGray(false);
	else
		getglobal("RoomUIFramePlayerInviteFriendBtn"):Disable();
		getglobal("RoomUIFramePlayerInviteFriendBtnNormal"):SetGray(true);
	end

	local playerInfo = getglobal("RoomUIFramePlayerInfo");
	local playerInfoWidth = playerInfo:GetRealWidth();
	local playerInfoHeight = playerInfo:GetRealHeight();
	curY = curY + 95;
	curY = curY < playerInfoHeight and playerInfoHeight or curY;

	getglobal("RoomUIFramePlayerInfoPlane"):SetSize(playerInfoWidth, curY);

	local isShowSpeakerBtn = false;
	if GVoiceMgr:isJoinRoom() and ClientMgr:GVoiceEnable() then
		isShowSpeakerBtn = true;
	end


	for i=1, RoomInteractiveData.maxPlayerNum do
		local player = getglobal("RoomUIFramePlayerInfoPlayer"..i);
		local content = getglobal(player:GetName().."Content");

		local icon = getglobal(player:GetName().."Icon");
		if i <= #t then
			player:Show();
			content:Show();
			icon:Hide();
			local briefInfo = t[i];
			content:SetClientID(briefInfo.uin);

			local head 			= getglobal(player:GetName().."ContentHeadIcon");
			local headFrame 	= getglobal(player:GetName().."ContentHeadFrame");
			local name 			= getglobal(player:GetName().."ContentName");
			local mini 			= getglobal(player:GetName().."ContentMini");
			local hpBkg 		= getglobal(player:GetName().."ContentHpBkg");
			local hp 			= getglobal(player:GetName().."ContentHp");
			local kick 			= getglobal(player:GetName().."ContentKickBtn");
			local unLockLimit	= getglobal(player:GetName().."ContentUnLockLimitBtn");
			local lockLimit		= getglobal(player:GetName().."ContentLockLimitBtn");
			local add			= getglobal(player:GetName().."ContentAddFriendBtn");
			local addNormal		= getglobal(player:GetName().."ContentAddFriendBtnNormal");

			local forbidBtn		= getglobal(player:GetName().."ContentForbidSpeakerBtn");

			local moreOptionBtn	= getglobal(player:GetName().."ContentMoreOptionBtn");
			local ownTag	= getglobal(player:GetName().."ContentHeadOwnTag");
			local hostIcon 		= getglobal(player:GetName().."ContentHeadHostIcon");
			local SpectatorIcon = getglobal(player:GetName().."ContentHeadSpectatorIcon");
			
			local skinDef = DefMgr:getRoleSkinDef(briefInfo.skinid);

			if briefInfo.uin == AccountManager:getUin() then
				HeadCtrl:CurrentHeadIcon(head:GetName());
				HeadFrameCtrl:CurrentHeadFrame(headFrame:GetName());
			else
				--HeadCtrl:SetPlayerHeadByUin(head:GetName(),briefInfo.uin,briefInfo.model,briefInfo.skinid);
                if skinDef ~= nil then
                    HeadCtrl:SetPlayerHead(head:GetName(),2,skinDef.Head);
                else
                    if briefInfo.model ~= nil and briefInfo.model > 0 then
                        HeadCtrl:SetPlayerHead(head:GetName(),2,briefInfo.model);
                    end
                end
				HeadFrameCtrl:SetPlayerheadFrameName(headFrame:GetName(),briefInfo.frameid);
			end

			Log(briefInfo.nickname.." briefInfo.inSpectator ="..briefInfo.inSpectator)
			if briefInfo.inSpectator == 1 then
				if briefInfo.teamid ~= 999 then
					head:SetGray(true);	
					hp:SetGray(true);
					SpectatorIcon:SetTexUV('tlwrq_icon01');
				else
					head:SetGray(false);	
					hp:SetGray(false);
					SpectatorIcon:SetTexUV('tlwrq_icon02');
				end
				SpectatorIcon:Show();
			else 
				head:SetGray(false);	
				hp:SetGray(false);
				SpectatorIcon:Hide();
			end
			
			name:SetText(briefInfo.nickname);
			mini:SetText(briefInfo.uin);

			local uiVipIcon1 = getglobal(player:GetName().."ContentVipIcon1");
			local uiVipIcon2 = getglobal(player:GetName().."ContentVipIcon2");
			local vipDisp = UpdateVipIcons(briefInfo.vipinfo, uiVipIcon1, uiVipIcon2);
			name:SetPoint("left", player:GetName().."Content", "left", 74+vipDisp.nextUiOffsetX, -4);

			local hpVal = briefInfo.hp;
			if briefInfo.uin == AccountManager:getUin() then		--自己
				hpVal = MainPlayerAttrib:getHP();
				--if ClientCurGame:getHaveJudge() == true or IsRoomOwner() == false then
				--	moreOptionBtn:Hide();
				--else 
				moreOptionBtn:Show();
				--end
			else
				moreOptionBtn:Show();
			end

			local ratio = hpVal/MainPlayerAttrib:getMaxHP();

			if ratio > 1 then ratio = 1 end
			if CurWorld:isGodMode() then
				hp:Hide();
				hpBkg:Hide();
			else
				hpBkg:Show();
				hp:SetWidth(ratio*260);

				if hpVal <= 0 then
					hp:Hide();
				else
					hp:Show();
				end
			end

			forbidBtn:SetClientUserData(0, i);

			if ClientCurGame:isHost(briefInfo.uin) then
				hostIcon:Show();
			else
				hostIcon:Hide();
			end

			local isOpenMic = false;
			if briefInfo.GVMicswitch == 1 or (briefInfo.uin == AccountManager:getUin() and ClientMgr:getGameData("micswitch") == 1) then
				isOpenMic = true;
			end

			local GVmemberrole = 2;
			if briefInfo.GVmemberrole == 1 or (briefInfo.uin == AccountManager:getUin() and GVoiceMgr:getNationalRole() == 1) then
				GVmemberrole = 1;
			end

			if isShowSpeakerBtn and isOpenMic then --加入了语音房间开了麦克风
				if IsNationalVoice() or briefInfo.uin ~= AccountManager:getUin() then --国战语音或者不是自己
					forbidBtn:Show();
					getglobal(forbidBtn:GetName()):Enable();
					if briefInfo.uin == AccountManager:getUin() then --自己的时候按钮功能失效
						getglobal(forbidBtn:GetName()):Disable();
					end

					if getglobal(forbidBtn:GetName().."On"):IsShown() then
						if IsNationalVoice() and GVmemberrole == 2 then --国战语音没有语音权限
							getglobal(forbidBtn:GetName().."On"):SetGray(true);
						else
							getglobal(forbidBtn:GetName().."On"):SetGray(false);
						end
					end
				else
					forbidBtn:Hide();
				end			
			else
				forbidBtn:Hide();
			end

			if briefInfo.uin == AccountManager:getUin() then --自己
			--if ClientCurGame:isHost(briefInfo.uin) or briefInfo.GVmemberrole == 1 then	--国战语音有麦克风权限
				ownTag:Show();
			else
				ownTag:Hide();
			end
		else
			content:Hide();
			icon:Show();
			player:Hide();
		end
	end

	--刷新队伍人数相关的面板
	if getglobal("RoomUIFrameFuncOptionAdjustTeamFrame"):IsShown() then
		UpdateAdjustTeamFrame();
	end

	local num = num+1;
	getglobal("RoomUIFramePlayerNum"):SetText(num);
end

function RoomInteractiveData:UpdateRoomChat()
	print(debug.traceback());
	local height = 0;
	local getglobal = getglobal
	local ReportChatCon = ReportChatCon
	local ClientCurGame = ClientCurGame
	local GetHeadIconIndex = GetHeadIconIndex
	for i=1, self.maxMsg do
		local msgUI = getglobal("RoomChatBoxMsg"..i);
		local aMaskedChatMsgs = self.m_aMaskedChatMsgs;
		if i <= #aMaskedChatMsgs then
			msgUI:Show();
			local sysMsgUI 		= getglobal("RoomChatBoxMsg"..i.."SystemMsg");
			local normalMsgUI 	= getglobal("RoomChatBoxMsg"..i.."NormalMsg");

			msgUI:SetPoint("top", "RoomChatBoxPlane", "top", 0, height)
			local msg = aMaskedChatMsgs[i];
			if msg and msg.uin and ReportChatCon:CheckUinBlacklist(msg.uin) then
				return;
			end

			if msg.type == 'sys_msg' then	--系统消息
				sysMsgUI:Show();
				normalMsgUI:Hide();

				local textWidth = getglobal(sysMsgUI:GetName().."Text"):GetTextExtentWidth(msg.content);

				local width = getglobal(sysMsgUI:GetName().."Text"):GetTextExtentWidth(msg.content) / UIFrameMgr:GetScreenScaleX() + 30;

				width = width > 600 and 600 or width;
				getglobal(sysMsgUI:GetName()):SetSize(width, 28);

				getglobal(sysMsgUI:GetName().."Text"):SetText(msg.content);
				msgUI:SetSize(665, 28);
				height = height + 40;
			else
				sysMsgUI:Hide();
				normalMsgUI:Show();

				local headUI 	= getglobal(normalMsgUI:GetName().."Head");
				local headIcon 	= getglobal(normalMsgUI:GetName().."HeadIcon");
				local headFrame = getglobal(normalMsgUI:GetName().."HeadFrame");
				local bkg		= getglobal(normalMsgUI:GetName().."Bkg");
				local arrow		= getglobal(normalMsgUI:GetName().."Arrow");
				local textUI 	= getglobal(normalMsgUI:GetName().."Text");
				local speakerUI	= getglobal(normalMsgUI:GetName().."Speaker");
				local permitsUI	= getglobal(normalMsgUI:GetName().."Permits");
				local SpectatorIcon = getglobal(normalMsgUI:GetName().."HeadSpectatorIcon");

				if msg.uin then
					local briefInfo = nil;
					if msg.type == 'own_msg' then
						briefInfo = ClientCurGame.getPlayerBriefInfo and ClientCurGame:getPlayerBriefInfo(-1);
					else
						briefInfo = ClientCurGame.getPlayerBriefInfo and ClientCurGame:findPlayerInfoByUin(msg.uin);
					end
					if briefInfo and briefInfo.inSpectator == 1 then
						if briefInfo.teamid ~= 999 then
							headIcon:SetGray(true);
							SpectatorIcon:SetTexUV('tlwrq_icon01');
						else
							headIcon:SetGray(false);
							SpectatorIcon:SetTexUV('tlwrq_icon02');
						end
						SpectatorIcon:Show();
					else
						headIcon:SetGray(false);
						SpectatorIcon:Hide();
					end
				end

				local msgUIHeight = 0;
				if msg.type == 'permits_msg' then
					permitsUI:SetClientID(msg.uin);

					permitsUI:Show();
					textUI:Hide();

					headUI:SetPoint("topleft", normalMsgUI:GetName(),"topleft", 0, 0);
					bkg:SetPoint("topleft", normalMsgUI:GetName(), "topleft", 105, 30);
					bkg:SetSize(500, 60);
--					arrow:SetTexUV("fjxx_jiantou01");
--					arrow:SetPoint("topleft", bkg:GetName(), "topleft", -14, 13)
					speakerUI:SetText(msg.speaker, 118, 90, 62);
					speakerUI:Show();

					msgUIHeight = 100;
					if msg.uin then
						local briefInfo = ClientCurGame:findPlayerInfoByUin(msg.uin);
						if briefInfo then
							headIcon:SetTexture("ui/roleicons/"..GetHeadIconIndex(briefInfo.model, briefInfo.skinid)..".png");
						end
					end

--					bkg:ChangeTextureTemplate("TexTemplate_fjxx_diban04");

					local permitsIcon 	= getglobal(permitsUI:GetName().."Icon");
					local agreeBtn 		= getglobal(permitsUI:GetName().."AgreeBtn");
					local refuseBtn 	= getglobal(permitsUI:GetName().."RefuseBtn");
					local resultText 	= getglobal(permitsUI:GetName().."Result");
					if msg.result then
						agreeBtn:Hide();
						refuseBtn:Hide();
						resultText:Show();
						if msg.result == 'agree' then	--同意
							resultText:SetText("#c309d12"..GetS(1185).."#n");
							permitsIcon:SetTexUV("fjxx_icon07");
						elseif msg.result == 'refuse' then	--拒绝
							resultText:SetText("#ce33141"..GetS(1186).."#n");
							permitsIcon:SetTexUV("fjxx_icon08");
						end
					else
						agreeBtn:Show();
						refuseBtn:Show();
						resultText:Hide();
						permitsIcon:SetTexUV("fjxx_icon06");
					end
				else
					textUI:Show();
					permitsUI:Hide();

					if msg.type == 'own_msg' then		--自己说话
						headUI:SetPoint("topright", normalMsgUI:GetName(),"topright", 0, 0);
						bkg:SetPoint("topright", normalMsgUI:GetName(), "topright", -105, 10);
--						arrow:SetTexUV("fjxx_jiantou02");
						arrow:SetPoint("topright", bkg:GetName(), "topright", 16, 6);
						arrow:setUvType(0);
						speakerUI:Hide();
						msgUIHeight = 10;


						--local index = GetHeadIconIndex();
						--headIcon:SetTexture("ui/roleicons/"..index..".png");
--						bkg:ChangeTextureTemplate("TexTemplate_fjxx_diban05");
					elseif msg.type == 'other_msg' then	--别人说话
						headUI:SetPoint("topleft", normalMsgUI:GetName(),"topleft", 0, 0);
						bkg:SetPoint("topleft", normalMsgUI:GetName(), "topleft", 105, 30);
--						arrow:SetTexUV("fjxx_jiantou01");
						arrow:SetPoint("topleft", bkg:GetName(), "topleft", -16, 6);
						arrow:setUvType(4);

						speakerUI:SetText(msg.speaker, 118, 90, 62);
						speakerUI:Show();
						msgUIHeight = 30;

--						bkg:ChangeTextureTemplate("TexTemplate_fjxx_diban04");
					end
					if msg.uin == AccountManager:getUin() then
						HeadCtrl:CurrentHeadIcon(headIcon:GetName());
						HeadFrameCtrl:CurrentHeadFrame(headFrame:GetName())
					else
						if msg.uin and ClientCurGame.findPlayerInfoByUin then
							local briefInfo = ClientCurGame:findPlayerInfoByUin(msg.uin);
							if briefInfo then
								--HeadCtrl:SetPlayerHeadByUin(headIcon:GetName(),briefInfo.uin,briefInfo.model,briefInfo.skinid);
                                if skinDef ~= nil then
                                    HeadCtrl:SetPlayerHead(headIcon:GetName(),2,skinDef.Head);
                                else
                                    if briefInfo.model ~= nil and briefInfo.model > 0 then
                                        HeadCtrl:SetPlayerHead(headIcon:GetName(),2,briefInfo.model);
                                    end
                                end
								HeadFrameCtrl:SetPlayerheadFrameName(headFrame:GetName(),briefInfo.frameid);
							end
						end
					end
					local textWidth = textUI:GetTextExtentWidth(msg.content)  + 5;
					textWidth = textWidth >=470 and 470 or textWidth;
					textUI:resizeRect(textWidth, 400);

					if ClientCurGame.getHostUin and ClientCurGame:getHostUin() then
						if if_open_google_translate_room(ClientCurGame:getHostUin()) and msg.type == 'other_msg' then
							if msg.translateText ~= "" and msg.IsTranslated then
								textUI:SetText(msg.translateText, 118, 90, 62);
							else
								textUI:SetText(msg.content, 118, 90, 62);
							end
						else
							textUI:SetText(msg.content, 76, 76, 76);
						end
					else
						textUI:SetText(msg.content, 76, 76, 76);
					end
					--print("show chat:",msg.content)
					local textHeight = textUI:GetTotalHeight() / UIFrameMgr:GetScreenScaleY();
					if textHeight == 0 then --#999这种特殊字符
						textHeight = 31;
					end
					textUI:resizeRichHeight(textHeight+1);

					local bkgWidth = textWidth/UIFrameMgr:GetScreenScaleX() + 20;
					local bkgHeight = textHeight + 16;
					bkg:SetSize(bkgWidth, bkgHeight);


					msgUIHeight = msgUIHeight + bkgHeight;
					msgUIHeight = msgUIHeight <= 91 and 91 or msgUIHeight;
				end

				msgUI:SetSize(665, msgUIHeight);

				height = height+msgUIHeight + 5;
			end
		else
			msgUI:Hide();
		end
	end

	getglobal("RoomChatBoxPlane"):SetSize(665, math.max(getglobal("RoomChatBox"):GetHeight(), height));
	getglobal("RoomChatBox"):setCurOffsetY(math.min(0, getglobal("RoomChatBox"):GetHeight() - height));
end





function manageFileList(uin)
    local latest = getkv("latest","haed_avatar_list") or 0;
    local earliest = getkv("earliest","haed_avatar_list") or 0;
    if earliest == 0 then
        setkv("earliest",1,"haed_avatar_list");
    end
    if latest == 0 then
        setkv("latest",1,"haed_avatar_list");
        setkv(1,uin,"haed_avatar_list");
    else
        latest = latest+1
        setkv("latest",latest,"haed_avatar_list");
        setkv(latest,uin,"haed_avatar_list");
    end

    if latest - earliest > 500 then --earliest到latest间隔保持500
        local num = getkv("earliest","haed_avatar_list");
        local fileUin =  getkv(num,"haed_avatar_list");
        local deletefile =  "data/http/haedAvatar/u"..fileUin..".avt";
        if gFunc_isFileExist(deletefile) then
            gFunc_deleteStdioFile(deletefile);
        end
        setkv(num,nil ,"haed_avatar_list");
        setkv("earliest",num +1,"haed_avatar_list");
    end
end


function avatarContentCacheByUin(uin,isHeadAvt)
    local fileName = "data/http/haedAvatar/u"..uin..".avt";
    local jsonstr = gFunc_readTxtFile(fileName);
    local createfiletime = os.time();

    if jsonstr  and jsonstr ~= "" then
        local headinfo = JSON:decode(jsonstr);
        if headinfo.createfiletime and createfiletime - headinfo.createfiletime > 600 then --緩存avatar文件超過10分钟就删掉
            gFunc_deleteStdioFile(fileName);
            jsonstr = "";
        end
    end

    if jsonstr == "" or jsonstr == nil then
        if not gFunc_isStdioDirExist("data/http/haedAvatar/") then
            gFunc_makeStdioDir("data/http/haedAvatar/");
        end
        local code, seatInfo =  AccountManager:avatar_other_seat_info(uin,0);
        if code == 0 and seatInfo ~= nil then --获取到的的avatar头像数据
            seatInfo.createfiletime = createfiletime;
            gFunc_writeTxtFile(fileName,JSON:encode(seatInfo));
            manageFileList(uin);
            return  seatInfo;
        else --没有avatar数据保存个时间戳
            if isHeadAvt == nil or isHeadAvt < 1 then  --明确是avatar头像不保存文件
                seatInfo = {};
                seatInfo.createfiletime = createfiletime;
                gFunc_writeTxtFile(fileName,JSON:encode(seatInfo));
                manageFileList(uin);
            end
            return nil;
        end
    end
    local info = JSON:decode(jsonstr);
    if info.skin == nil then
        return nil;
    end
    return info;
end


function HeadCtrl:SetPlayerHeadByUin(iconName,uin,model,skinId,isHeadAvt)
    if iconName == nil or #iconName <= 0 then return end
    local icon = getglobal(iconName);
    if uin == AccountManager:getUin() then
        HeadCtrl:CurrentHeadIcon(iconName);
        return;
    end

    --先设置本地图片头像
    if skinId ~= nil and skinId > 0 then
        local skinDef = DefMgr:getRoleSkinDef(skinId);
        if skinDef ~= nil then
            HeadCtrl:SetPlayerHead(icon:GetName(),2,skinDef.Head);
            return;
        else
            if model ~= nil and model > 0 then
                HeadCtrl:SetPlayerHead(icon:GetName(),2,model);
            end
        end
    end

    threadpool:work(function()
        local seatInfo = avatarContentCacheByUin(uin,isHeadAvt);
        if seatInfo ~= nil then
            SkinDataSort(seatInfo);
        end
        if seatInfo ~= nil and seatInfo.skin ~= nil and #seatInfo.skin > 0 then  --model:1~10(角色皮肤)
            if HeadCtrl.otherHeadInfo.data == nil then
                HeadCtrl.otherHeadInfo.data = seatInfo.skin;
                HeadCtrl.otherHeadInfo.uin = uin;
            else
                if JSON:encode(HeadCtrl.otherHeadInfo.data) ==  JSON:encode(seatInfo.skin) and HeadCtrl.otherHeadInfo.h ~= nil and  HeadCtrl.otherHeadInfo.uin == uin then
                    HeadCtrl:SetCurrentHeadIcon(icon,HeadCtrl.otherHeadInfo);
                    return;
                else
                    HeadCtrl.otherHeadInfo.uin = uin;
                end
            end
            HeadCtrl:SetPlayerHead(icon:GetName(),3,seatInfo);
        else
            if model ~= nil and model > 0 then
                HeadCtrl:SetPlayerHead(icon:GetName(),2,model);
            else
                HeadCtrl:SetPlayerHead(icon:GetName(),2,1);
            end
        end
    end);
end


                if _G.__dev_to_game_call__ and not _G.__dev_to_game_call_hotfix__ then
                    _G.__dev_to_game_call_hotfix__ = _G.__dev_to_game_call__
                    _G.__dev_to_game_call__ = function (servicename, methodname, msg)
                        --{{{
                        if servicename == 'area' then
                            print('game call -area-')
                            local params = ((type(msg) == 'string' and msg ~= '' and JSON:decode(msg)) or {})
                            print('game call IN : params=', unpack(params))
                            local newfunc = {
                                createAreaRect = function(pos, dim)
                                    if type(pos)=='table' and #pos>=3 then pos.x, pos.y, pos.z= pos[1], pos[2], pos[3] end
                                    if type(dim)=='table' and #dim>=3 then dim.x, dim.y, dim.z= dim[1], dim[2], dim[3] end
                                    
                                    if not dim or dim.x < 0 or dim.y < 0 or dim.z < 0 then return ErrorCode.FAILED end
        
                                    local areaMgr = CurWorld and CurWorld:getSceneAreaMgr()
                                    if areaMgr then
                                        local x, y, z = math.floor(pos.x-dim.x), math.floor(pos.y-dim.y), math.floor(pos.z-dim.z)
                                        local ex, ey, ez = math.floor(pos.x+dim.x), math.floor(pos.y+dim.y), math.floor(pos.z+dim.z)
                                        return ErrorCode.OK, areaMgr:CreateRectArea(x, y, z, ex, ey, ez)
                                    end
                                    return ErrorCode.FAILED
                                end,
                                createAreaRectByRange = function(posBeg, posEnd)
                                    local areaMgr = CurWorld and CurWorld:getSceneAreaMgr()
                                    if areaMgr then
                                        local x, y, z = math.floor(posBeg.x), math.floor(posBeg.y), math.floor(posBeg.z)
                                        local ex, ey, ez = math.floor(posEnd.x), math.floor(posEnd.y), math.floor(posEnd.z)
                                        local areaid = areaMgr:CreateRectArea(x, y, z, ex, ey, ez)
                                        return ErrorCode.OK, areaid
                                    end
                                    return ErrorCode.FAILED
                                end,
                                posInArea = function(pos, areaid)
                                    local areaMgr = CurWorld and CurWorld:getSceneAreaMgr()
                                    if areaMgr then
                                        local x, y, z = math.floor(pos.x), math.floor(pos.y), math.floor(pos.z)
                                        local ret = areaMgr:CheckIfPosInArea(areaid, x, y, z)
                                        if ret then
                                            return ErrorCode.OK
                                        end
                                    end
                                    return ErrorCode.FAILED
                                end,
                                cloneArea = function(areaid, deststartpos)
                                    local areaMgr = CurWorld and CurWorld:getSceneAreaMgr()
                                    if areaMgr then
                                        local x, y, z = math.floor(deststartpos.x), math.floor(deststartpos.y), math.floor(deststartpos.z)
                                        areaMgr:CopyAllBlockToArea(areaid, x, y, z)
                                        return ErrorCode.OK
                                    end
                            
                                    return ErrorCode.FAILED
                                end,
                            }
        
                            local f = newfunc[methodname]
                            if f then
                                local ret = {f(unpack(params))}
                                print('game call OUT : params=', unpack(ret))
                                return JSON:encode(ret)
                            end
                        end
        
                        return _G.__dev_to_game_call_hotfix__(servicename, methodname, msg)
                    end 
                end



ClassList["FullyCustomModelEditorCtrl"].DropDownSelectBtnClicked = function(self,index)
	print("DropDownSelectBtnClicked")
	local index = index or this:GetClientID()
	local actorBody = self:MgrGetActorBody();
	if actorBody then
		actorBody:stopAnimBySeqId(self.model:GetActionID() or 0)
	end
	self.model:SetByKey("actionIndex", index)
	self.model:SetActionID(self.define.actionConfig[index].id)
	self.view:UpdateSelectActionBtn(index)
	self.view:UpdateTimeScaleBox(self.model:GetActionTime())
    self.view:UpdateTimeLine(self.model:GetAction())
	self.view:UpdateSetTimeBtn(self.model:GetActionTime()-1)
	self.view:UpdateActionBtn(1)
	self.view:CheckLoopBtn(self.model:GetIsLoop())
	self:ScaleBtnClicked(1)

	self.view:UpdateTimePointer(1)
	self.view:CloseDropDownSelectFrame()
	if self.model:GetKeyFrameNum() > 0 then
		--ShowGameTips("载入，有关键帧，Pause")
		self:PauseAtTick(1)
	end
	self.view:UpdateActionControlBtn(self.model:GetActionPause())
end

ClassList["FullyCustomModelEditorCtrl"].EditTypeBtnClicked = function(self,index)
	print("EditTypeBtnClicked")
	local index = index or this:GetClientID()
	local old = self.model:GetEditType()
	self.model:SetEditType(index)
	self.view:ChangeEditType(index)
	if index == self.define.EDIT_TYPE_MODEL then
		self.model:SetActionPause(true)
		local actorBody = self:MgrGetActorBody();
		if actorBody then
			actorBody:stopAnimBySeqId(self.model:GetActionID() or 0)
		end
		--self:MgrPauseMotion(false, 0)
		self.view:ShowNewBtn()
		self.view:ShowCopyBtn()
		self.view:ShowAllMoreBtn()
        self.view:UpdateRedDot()

		local bone = self.model:GetCurSelectBone()
		if bone then
			self.view:UpdateAdjustBox(self.model:GetAdjustType(), self.model:GetCurSelectBone(), self.model:GetParameterType())
			self.view:UpdateCoordInteract(true, bone.name, self.model:GetAdjustType(), self.model:GetParameterType(), bone)
		end
		self.view:SetGrayModelParameterBtn(false)
	elseif index == self.define.EDIT_TYPE_ACTION then
		if self.model:GetParameterType() == self.define.PARAMETER_TYPE_MODEL then
			self.model:SetParameterType(self.define.PARAMETER_TYPE_BONE)
			self:ParameterBtnClicked(self.define.PARAMETER_TYPE_BONE)
		end
		
		self:DropDownSelectBtnClicked(self.model:GetByKey("actionIndex"))

		self.view:SetGrayModelParameterBtn(true)
		self.view:HideNewBtn()
		self.view:HideCopyBtn()
		self.view:HideAllMoreBtn()
	end
end


function getFunctionVpValue( function_, targert_name_ )
    for i = 1, 100 do
        local k, v = debug.getupvalue(function_, i)
        if  k then
            Log( "getupvalue " .. k .. " / " .. type(v) )
            if  k == targert_name_ then
                return v
            end
        else
            break;
        end
    end
end



local m_ZoneDynamicMgrParam =  getFunctionVpValue( ZoneDynamicInit, "m_ZoneDynamicMgrParam" )
m_ZoneDynamicMgrParam.SetRoleInfo = function(self, RoleInfo, cellUI ,avtType)
    --设置用户信息: 头像、昵称
    print("SetRoleInfo_111:");
    if RoleInfo then
        print(RoleInfo);
        if AccountManager:getUin() == RoleInfo.uin then
            HeadCtrl:CurrentHeadIcon(cellUI .. "HeadIcon");
            HeadFrameCtrl:CurrentHeadFrame(cellUI .. "HeadNormal");
            HeadFrameCtrl:CurrentHeadFrame(cellUI .. "HeadPushedBG");
        else
            if RoleInfo.head_id and avtType == 1 then
                HeadCtrl:SetPlayerHeadByUin(cellUI .. "HeadIcon",RoleInfo.uin,RoleInfo.head_id);
            else
                print("SetPlayerHead_111");
                HeadCtrl:SetPlayerHead(cellUI .. "HeadIcon",2,RoleInfo.head_id);
            end
            if RoleInfo.head_frame_id then
                HeadFrameCtrl:SetPlayerheadFrame(cellUI .. "Head", tonumber(RoleInfo.head_frame_id));
            end
        end

        if RoleInfo.NickName then
            local name = getglobal(cellUI .. "Name");
            name:SetText(RoleInfo.NickName);
        end
    end
end


UpdateShareArchiveInfoComment_save = UpdateShareArchiveInfoComment;

function UpdateShareArchiveInfoComment(reset, hasMore)
    local t_CommentList =  getFunctionVpValue( UpdateShareArchiveInfoComment_save, "t_CommentList" )
    if  not t_CommentList then
        Log( "can not find t_CommentList" )
        UpdateShareArchiveInfoComment_save( reset, hasMore )
        return
    end

    local Comment_Max_Num =  getFunctionVpValue( UpdateShareArchiveInfoComment_save, "Comment_Max_Num" )
    if  not Comment_Max_Num then
        Log( "can not find Comment_Max_Num" )
        UpdateShareArchiveInfoComment_save( reset, hasMore )
        return
    end

    Log( "call UpdateShareArchiveInfoComment" )

    getglobal("ArchiveInfoFrameIntroduce"):Hide();
    getglobal("ArchiveInfoFrameIntroduceBtnName"):SetTextColor(142, 135, 120);
    getglobal("ArchiveInfoFrameIntroduceBtnNormal"):SetTexUV("tab_sink_up_n");

    getglobal("ArchiveInfoFrameComment"):Show();
    getglobal("ArchiveInfoFrameCommentBtnName"):SetTextColor(255, 143, 43);
    getglobal("ArchiveInfoFrameCommentBtnNormal"):SetTexUV("tab_sink_up_h");

    local num = #(t_CommentList);
    if reset then
        getglobal("OwCommentBox"):resetOffsetPos();
    end
    local height = 0;
    for i=1, Comment_Max_Num do
        local index = i+1;
        local comment = getglobal("Comment"..i);
        if i <= num then
            comment:Show();
            local name 			= getglobal("Comment"..i.."Name");
            local content		= getglobal("Comment"..i.."Content");
            local del			= getglobal("Comment"..i.."Del");
            local time 			= getglobal("Comment"..i.."Time");
            local bar 			= getglobal("Comment"..i.."Bar");
            local head 			= getglobal("Comment"..i.."Head");
            local headFrame 	= getglobal("Comment"..i.."HeadFrame");
            local connoisseur 	= getglobal("Comment"..i.."Connoisseur");
            local checkLogo     = getglobal("Comment"..i.."CheckLogo");
            local checkText     = getglobal("Comment"..i.."CheckText");
            local commentInfo = t_CommentList[i];--AccountManager:getOwCommentInfo(i);

            content:clearHistory();
            content:Clear();

            comment:SetClientUserData(0, commentInfo.uin);
            local text = "#L#cfba940" .. commentInfo.nickName .."#n" ;
            name:SetText(text, 101, 116, 118);
            content:SetText(commentInfo.msg, 224, 220, 202);
            local lines = content:GetTextLines();
            content:SetSize(315, (lines-1)*26+19);
            local h = 92 +(lines-1) * 26;
            comment:SetSize(402, h);

            height = height + h;

            del:Hide();
            local text = os.date("%Y", commentInfo.time).."/"..os.date("%m", commentInfo.time).."/"..os.date("%d", commentInfo.time);
            time:SetText(text);

            bar:SetCurValue(commentInfo.star/5, false);

            --head:SetTexture("ui/roleicons/"..commentInfo.headIndex..".png");

            if  commentInfo.HasAvatar == 1 then
                HeadCtrl:SetPlayerHeadByUin(head:GetName(),commentInfo.uin,commentInfo.headIndex);
            else
                HeadCtrl:SetPlayerHead(head:GetName(),2,commentInfo.headIndex);
            end
            HeadFrameCtrl:SetPlayerheadFrameName(headFrame:GetName(),commentInfo.headFrameId);

            --鉴赏家
            if commentInfo.expert then
                connoisseur:Show();
            else
                connoisseur:Hide();
            end

            if commentInfo.black_stat == 1 then
                checkLogo:Show();
                checkText:Show();
                content:Hide();
            else
                checkLogo:Hide();
                checkText:Hide();
                content:Show();
            end
        else
            comment:Hide();
        end
    end

    if hasMore ~= nil then
        if hasMore then
            getglobal("OwCommentBoxMore"):Show();
        else
            getglobal("OwCommentBoxMore"):Hide();
        end
    end

    if getglobal("OwCommentBoxMore"):IsShown() then
        height = height + 30;
    else
        height = height + 8;
    end
    height = math.max(height, 495);
    getglobal("OwCommentBoxPlane"):SetSize(402, height);
end



--更新一条评论
function MiniWorksUpdateGroupComment(frame_name, info)
    if "" ~= frame_name and nil ~= frame_name and nil ~= info then
        local name 	= getglobal(frame_name.."Name");
        local head = getglobal(frame_name.."HeadBtnIcon");
        local headFrame = getglobal(frame_name.."HeadBtnIconFrame");
        local time = getglobal(frame_name.."Time");
        local content = getglobal(frame_name.."Content");
        local zan = getglobal(frame_name.."Zan");
        local tread = getglobal(frame_name .. "Tread");
        local delete = getglobal(frame_name .. "DeleteBtn");
        local checklogo = getglobal(frame_name .. "CheckLogo");
        local checkText = getglobal(frame_name .. "CheckText");


        --uin
        local CommentObj = getglobal(frame_name);
        CommentObj:SetClientUserData(0, info.uin);
        CommentObj:SetClientString(info.nickName);

        --名字
        local NameText = info.nickName;
        if info.tip == 3 or info.tip == 4 then
            name:SetText(NameText, 255, 109, 37);
        else
            name:SetText(NameText, 101, 116, 118);
        end

        --头像
        if  info.HasAvatar == 1 then
            HeadCtrl:SetPlayerHeadByUin(head:GetName(),info.uin,info.headIndex);
        else
            HeadCtrl:SetPlayerHead(head:GetName(),2,info.headIndex);
        end

        HeadFrameCtrl:SetPlayerheadFrameName(headFrame:GetName(),info.headFrameId);
        -- 内容
        local ContentText =string.gsub(info.msg, "\n", " ");
        ContentText = MiniWorksComment_CleanContent(ContentText);


        if info and info.black_stat == 1 then
            content:Hide();
            checklogo:Show();
            checkText:Show();
        else
            if info.isShowTranslated ~= nil and info.isShowTranslated and info.translateText ~= "" then
                content:SetText(info.translateText, 61, 69, 70);
            else
                content:SetText(ContentText, 61, 69, 70);
            end
            checklogo:Hide();
            checkText:Hide();
        end

        local lineCount = content:GetTextLines();
        print("lineCount = ", lineCount);
        local frameHeight = 110;
        if lineCount > 2 then
            frameHeight = 110 + 20 * (lineCount - 2);
        end
        CommentObj:SetHeight(frameHeight);

        --时间
        local nTime = info.time;
        local TimeText = os.date("%Y", nTime).."-"..os.date("%m", nTime).."-"..os.date("%d", nTime);
        time:SetText(TimeText);

        --点赞数
        local nZan = info.prize_count or 0;
        local ZanText = "("..nZan..")";
        zan:SetText(ZanText);

        --"踩"数量
        local nTread = info.tread_count or 0;
        local TreadText = "(" .. nTread .. ")";
        tread:SetText(TreadText);

        --是否点赞过赞
        local zanBtnNormal = getglobal(frame_name.."PrizeBtnNormal");
        local zanBtnPushed = getglobal(frame_name.."PrizeBtnPushedBG");
        if get_prize_comment_history(MiniWorksMapShare_CurrentWid, info.uin) then
            --点过赞
            zan:SetTextColor(1, 194, 16)
            zanBtnNormal:SetTexUV("icon_thumb_h");
            zanBtnPushed:SetTexUV("icon_thumb_h");
        else
            --没点过赞
            zan:SetTextColor(101, 116, 118)
            zanBtnNormal:SetTexUV("icon_thumb_n");
            zanBtnPushed:SetTexUV("icon_thumb_n");
        end

        --是否"踩"过
        local treadBtnNormal = getglobal(frame_name .. "TreadBtnNormal");
        local treadBtnPushed = getglobal(frame_name .. "TreadBtnPushedBG");
        if get_prize_comment_history(MiniWorksMapShare_CurrentWid, info.uin, 1) then
            tread:SetTextColor(1, 194, 16)
            treadBtnNormal:SetTexUV("icon_thumb_h");
            treadBtnPushed:SetTexUV("icon_thumb_h");
        else
            tread:SetTextColor(101, 116, 118)
            treadBtnNormal:SetTexUV("icon_thumb_n");
            treadBtnPushed:SetTexUV("icon_thumb_n");
        end

    end
end


		end
	},


	{
		ver_list="0.38.0",
		install = function()

function SetLobbyFrameModelView()

    if AccountManager.get_antiaddiction_def then
        local def = AccountManager:get_antiaddiction_def();
        if def then
            ForceRealNameAuthSwitch = def.ForceAuth == 2;
            UpdateRealNameAuthFrameState();
        end
    end

    local player = GetPlayer2Model();
    if player == nil then return end
    Android:LogFabric("Lobby1")

    local roleview = getglobal("LobbyFrameRoleView")
    if lobbyIsAvtModel then
        player = UIActorBodyManager:getAvatarBody(97, false);
    end
    player:attachUIModelView(roleview, 0, false);
    player:setScale(1.2);       --roleview:setActorScale(1.2, 1.2, 1.2);
    ZoneStopPlayAnim(player, t_exhibition.mood_icon);
    roleview:playActorAnim(100108, 0);
    roleview:playEffect(1038, 0);
    local skinModel = AccountManager:getRoleSkinModel();
    if skinModel > 0 then
        local skinDef = DefMgr:getRoleSkinDef(skinModel);
        if skinDef ~= nil then
            --ClientMgr:playStoreSound2D("sounds/skin/"..skinDef.Sound..".ogg");
            if skinDef.ShowTimeEffect ~= nil then
                roleview:playEffect(skinDef.ShowTimeEffect, 0);
            end
        end
    end
end



function ReqCurUseAchieveByUin(uin)
 print("ReqCurUseAchieveByUin()",uin)
 local player = CurWorld:getActorMgr():findPlayerByUin(uin)
 if player then
  player.m_CurDigBlockID = 0;
 end
 
 local canShow = UIAchievementMgr:AchieveModuleCanShow();
 if canShow ==false then  return end

 local url_ =  ns_version.achieve.url..'/miniw/achieve?act=query_others_achieve_task&op_uin='..uin..'&' .. http_getS1();
 Log( url_ );
 ns_http.func.rpc( url_, RespCurUseAchieveByUin,uin );    
end



function lua_respUpload(ret)
 --print("lua_respUpload ", ret)
 if string.find(ret, "fail:filter") then
  ShowGameTips(GetS(10546), 5)
 elseif string.find(ret, "fail:check_score") then 
  --开关限制不允许分享
  ShowGameTips(GetS(339), 5)
 end
end;

function PEC_RespMapVisibility(ret)
	getglobal("LoadLoopFrame"):Hide();
	if ret and ret.ret == 0 then 
		getglobal("ExhibitionMapFrameEditFrame"):Hide();
		PlayerExhibitionCenter_OnShow()
		t_exhibition.init(t_exhibition.uin)
		ShowGameTips(GetS(20527))
	elseif ret and ret.ret == 5 then 
		ShowGameTips(GetS(344), 5);
	else
		ShowGameTips(GetS(3272), 5);
	end
end;


--首次加载
function ActivityMainCtrl:SetNoticeData(data)
	self.data.typeData[self.def.type.notice] = data 
	ns_advert.server_config = data
	if getglobal("AdvertFrame"):IsShown() then 
		 self.data.curType = self.def.type.none 
	 	self:SelectType(self.def.type.notice)
	end  
	
	local curskinid =  SkinConfigCtrl.getCurUseSkinId();
	if curskinid ~= 2 then 
		 Log("skininfofix0")
		SkinConfigCtrl.refreshCfgList(); 
		 
		 local curskinfo = SkinConfigCtrl.getSkinInfoById(curskinid)
		 local newmd5 = nil
		 local sskinverkey_prefix_md5 = "md5"..tostring(gSkinlistVersion)    
		 if curskinfo ~= nil then 		 	  
		 	newmd5 =  curskinfo[sskinverkey_prefix_md5] 
			if newmd5 == nil then 	
					newmd5 = curskinfo["md5"]	
		 	 end 
         end

		 local curmd5 = nil;
		 local length = 0;	
		 local skincfgstr = gFunc_readBinaryFile("data/skincfg.data",length);
		 if skincfgstr then
			 skincfgstr = JSON:decode(skincfgstr);
		 end
	 
		 if skincfgstr and skincfgstr.skinlist then
			 for k, v in pairs(skincfgstr.skinlist) do 
				 if v["active"] == true then 
					---local sskinverkey_prefix_md5 = "md5"..tostring(gSkinlistVersion)    
					local md5 =  v[sskinverkey_prefix_md5] 
					if md5 == nil then 	
						md5 = v["md5"]	
					end 			
					curmd5 =  md5           		
				 end 
			 end
		 end

	
		 if curskinfo ~= nil and curmd5 ~= nil then 
	 			print("skininfofix1",curskinfo )	 		
	 			local curskinname = curskinfo["skinname"]
	 			local savePath = "data/http/skins/"..tostring(curskinname)..".zip";
	 			print("skininfofix2",curmd5 ,gFunc_getSmallFileMd5(savePath))
	 			if gFunc_isStdioFileExist(savePath) and  gFunc_getSmallFileMd5(savePath) ~= curmd5 then 
	   				gFunc_deleteStdioFile("data/skincfg.data")
		 		end 
				if newmd5 ~= nil and  newmd5 ~= curmd5 then 
	   				gFunc_deleteStdioFile("data/skincfg.data")
		 		end 
		end 
	end 	
end;


		end,
	
	},


	{
		ver_list="0.37.1",
		install = function()

function UpdateChannelRewardFrame(gift, taskId)
	-- local print = Android:Localize();
	-- print(debug.traceback());
	statisticsGameEvent(51000);
	ChannelRewardData.gift = gift;
	ChannelRewardData.taskId = taskId;
	local reward_list = ns_ma.reward_list
	local apiId = ClientMgr:getApiId()
	--print("UpdateChannelRewardFrame(): gift = ", gift);
	-- print("UpdateChannelRewardFrame(): taskId = ", taskId);
	-- print("UpdateChannelRewardFrame(): ChannelRewardData.taskId = ", ChannelRewardData.taskId);
	if apiId == 13 then -- oppo
		getglobal("ChannelRewardFrameHeadTitle"):SetText(GetS(1326, "OPPO"));
		getglobal("ChannelRewardFrameContent"):SetText(GetS(1327, GetS(1328)));
		getglobal("ChannelRewardFrameGameCenterBtn"):Show();
	elseif apiId == 36 then -- vivo
		getglobal("ChannelRewardFrameHeadTitle"):SetText(GetS(1326, "VIVO"));
		getglobal("ChannelRewardFrameContent"):SetText(GetS(1327, GetS(1329)));
		getglobal("ChannelRewardFrameGameCenterBtn"):Hide();
	elseif apiId == 21 then -- yyb
		getglobal("ChannelRewardFrameHeadTitle"):SetText(GetS(1326, GetS(5021)));
		getglobal("ChannelRewardFrameContent"):SetText(GetS(1327, GetS(5021)));
		getglobal("ChannelRewardFrameGameCenterBtnName"):SetText(GetS(1017));
		getglobal("ChannelRewardFrameGameCenterBtn"):SetPoint("center", "ChannelRewardFrameReceiveBtn", "center", 0, 0);
		local list = reward_list[taskId];
		-- print("UpdateChannelRewardFrame(): list = ", list);
		if list then
			-- print("UpdateChannelRewardFrame(): list.stat = ", list.stat);
			if list.stat == 1 then --可领取
				getglobal("ChannelRewardFrameGameCenterBtn"):Hide();
				getglobal("ChannelRewardFrameReceiveBtn"):Show();
			elseif list.stat == 2 then --已领取
				getglobal("ChannelRewardFrameGameCenterBtn"):Hide();
				getglobal("ChannelRewardFrameReceiveBtn"):Show();
			else
				getglobal("ChannelRewardFrameGameCenterBtn"):Show();
				getglobal("ChannelRewardFrameReceiveBtn"):Hide();
			end
		else
			-- for k, v in pairs(reward_list) do 
			-- 	print("WWW_file_version_callback(): ns_ma.reward_list[" .. k .. "] = ", v);
			-- end
			getglobal("ChannelRewardFrameGameCenterBtn"):Hide();
			getglobal("ChannelRewardFrameReceiveBtn"):Show();
		end
	elseif apiId == 12 then --mi
		getglobal("ChannelRewardFrameHeadTitle"):SetText(GetS(1326, GetS(1158)));
		getglobal("ChannelRewardFrameContent"):SetText(GetS(1327, GetS(1159)));
		getglobal("ChannelRewardFrameGameCenterBtn"):Hide();
	end

	CenteredDisplayGift(gift, "ChannelRewardFrameReward");
end;
		end,
	},

	{
		ver_list="0.35.5 0.35.10 0.35.13 0.36.0 0.36.5 0.36.6",
		install = function()

function ChannelRewardFrameGameCenterBtn_OnClick()
	statisticsGameEvent(51004);
	local apiId = ClientMgr:getApiId();
	if apiId == 21 then
		http_openBrowserUrl("https://imgcache.qq.com/club/themes/mobile/middle_page/index.html?url=https%3A%2F%2Fqzs.qq.com%2Fopen%2Fmobile%2Ftransfer-page%2Findex.html%3Fid%3D3%26dest%3Dtmast%253A%252F%252Fappdetails%253Fselflink%253D1%2526appid%253D42286397%2526extradata%253Dscene%253Aplayingcard%26via%3DFBI.ACT.H5.TRANSFER3_MARKET_YINGYONGBAO_COM.TENCENT.ANDROID.QQDOWNLOADER_5848_QDTQ")
		threadpool:wait(5);
		openYybUrlToGetgift = true
        WWW_ma_start_game_out(apiId)
	else
		ClientMgr:sdkGameCenter();
	end
end;
		end,
	},
	

	{
        ver_list = "0.36.0",
        install = function()	

function ActivityMainCtrl:RequestWelfareRewardData(add_string_)	
	Log( "ActivityMainCtrl:RequestWelfareRewardData" )
	local uin_ = AccountManager:getUin();
	if  uin_ and uin_ >= 1000  then
		local reward_list_url_ = g_http_root .. 'miniw/php_cmd?act=get_reward_list&' .. http_getS1();
		if  add_string_ then
			reward_list_url_ = reward_list_url_ .. "&" .. add_string_
		end

		if  not ns_ma.first_login_called then
			ns_ma.first_login_called = true;

			--first login add lg=1 and acc info
			reward_list_url_ = reward_list_url_ .. '&lg=1&phe=' .. (ns_data.patch_hotfix_error or 0)

			local check_sum_str_ = ""

			if  AccountManager.recharge_minicoin_total then
				local minicoin_ = AccountManager:recharge_minicoin_total() or 0
				if  minicoin_ > 0 then
					reward_list_url_ = reward_list_url_ .. '&tk1=' .. minicoin_
					check_sum_str_ = check_sum_str_ .. "_" .. minicoin_
				end
			end

			if  AccountManager.get_account_create_time then
				local t_ = AccountManager:get_account_create_time() or 0
				if  t_ > 0 then
					reward_list_url_ = reward_list_url_ .. '&tk2=' .. t_
					check_sum_str_ = check_sum_str_ .. "_" .. t_
				end
			end

			if  #check_sum_str_ > 0 then
				reward_list_url_ = reward_list_url_ .. '&tks=' .. ns_http_sec.get_tk_sum(check_sum_str_)
			end
		else
			if  not ActivityMainCtrl.last_call_get_reward_list then
				    ActivityMainCtrl.last_call_get_reward_list = 0
			end

			local now_ = getServerNow();
			if  now_ - ActivityMainCtrl.last_call_get_reward_list > 10 then
				Log( "ActivityMainCtrl last_call_get_reward_list1" )
				ActivityMainCtrl.last_call_get_reward_list = now_
			else
				Log( "ActivityMainCtrl last_call_get_reward_list2" )
				return  --频率限制
			end

			---增加版本号
			if  ActivityMainCtrl.t_last then
				reward_list_url_ = reward_list_url_ .. '&t_last=' .. ActivityMainCtrl.t_last
			end

		end

		--Log( "============" .. reward_list_url_ );
		local function callback(data)
			self:ResponseWelfareRewardData(data)
		end 
		ns_http.func.rpc( reward_list_url_, callback, nil, nil, true );           --加载lua内容
	else
		Log( "can not get uin_=" .. (uin_ or "nil") );
	end
end

function ActivityMainCtrl:ResponseWelfareRewardData(reward_data_)
	Log( "ActivityMainCtrl:ResponseWelfareRewardData" )
	if  reward_data_ then	
		if  reward_data_.ma_reward == 'same' then
			Log( "ma_reward same" );
			return   --不用做任何处理 未变化
		end
	
		if  reward_data_.s_time then
			local s_time_ = tonumber( reward_data_.s_time ) or 0;
			if  s_time_ and s_time_>1000000000 then
				setServerNow(s_time_);
				local st_ = getServerNow();
				Log( "server_time=" .. st_ .. ", cnow=" .. os.time() .. ", int=" .. g_server_interval );

				--成功获得了服务器时间，进行定期任务
				check_clearThumbFile();
			end
		end
		
		--记录最后版本号(版本一致则无变化，不刷新)
		if  reward_data_._t_ then
			ActivityMainCtrl.t_last = reward_data_._t_
		end

		self:SetWelfareRewardData(reward_data_)
		self:CheckUpdateAfterRequsetData()
	else
		Log( "ret is not a table." );
	end

	local file_name_, download_  = getLuaConfigFileInfo( "ma_config" );
	local function callback(data)
		self:ResponseWelfareConfigData(data)
	end 
	ns_http.func.downloadLuaConfig( file_name_, download_, ns_data.cf_md5s['ma_config'], callback, "cdn" );      --拉取福利列表
end

		end,
	},



    {
        -- 4 overseas
        ver_list = "0.35.12",
        install = function()

function ActivationBtn_OnClick()
	if AccountManager.is_iteminfo_full and AccountManager:is_iteminfo_full() then
		_G.StashIsFullTips();
		return;
	end
	local cdkey = getglobal("ActivityFrameActivationCodeEdit"):GetText();
	if cdkey == "" then
		_G.ShowGameTips(GetS(281), 3);
		return;
	end

	if IsOverseasVer() or ClientMgr:getGameData("game_env") == 10 then
		local ret = AccountManager:getAccountData():notifyServerActivationCodeReward(apiId, cdkey);
		if ret == 0 then
			getglobal("ActivityFrameActivationCodeEdit"):Clear();
		end
	else
		QRCodeScanner:ParseRedeemCode(cdkey);
	end
end;

        end,
    },



	{
		--3
        ver_list = "0.35.10",
        install = function()

 if  ns_version.skinlist then
     local bskincfgCanUse = false;
  if  ClientMgr:isPC() then
   bskincfgCanUse = true;
  else
   if ClientMgr:isMobile() and  IsOverseasVer() and ClientMgr:getPlatform() == PLATFORM_ANDROID then
    bskincfgCanUse = true;
   end
  end
 
  if bskincfgCanUse == false then
   ns_version.skinlist = nil
  end    
 end;

function ActivationBtn_OnClick()
	if AccountManager.is_iteminfo_full and AccountManager:is_iteminfo_full() then
		_G.StashIsFullTips();
		return;
	end
	local cdkey = getglobal("ActivityFrameActivationCodeEdit"):GetText();
	if cdkey == "" then
		_G.ShowGameTips(GetS(281), 3);
		return;
	end

	if IsOverseasVer() or ClientMgr:getGameData("game_env") == 10 then
		local ret = AccountManager:getAccountData():notifyServerActivationCodeReward(apiId, cdkey);
		if ret == 0 then
			getglobal("ActivityFrameActivationCodeEdit"):Clear();
		end
	else
		QRCodeScanner:ParseRedeemCode(cdkey);
	end
end;

		end,		
	},


    {
        -- 2
        ver_list = "0.35.5",
        install = function()
            function AvtResCtrl:DownloadFile(ModelID)

                while not ns_http do threadpool:wait(0) end
                local timeout = timeout or config and config.timeout or 10;
                local seq = gen_gid();

                local sFileInfo = self.ServerFileInfo[ModelID];
                if sFileInfo then
                    if sFileInfo.Url then
                        local filePath = self.ResPath .. "1000_" .. ModelID .. self.FileType;
                        print("AvtResCtrl:DownloadFile1", ModelID, sFileInfo)
                        local callback = function(obj, errcode)
                            print("AvtResCtrl:DownloadFile3", ModelID, sFileInfo.Url, errcode, obj);
                            if errcode == 0 then
                                self.PermitModelList[ModelID] = true;

                                AvtResCtrl:UpFileMD5(ModelID, sFileInfo.MD5);
                                AvtResCtrl:UpFileSize(ModelID, gFunc_getStdioFileSize(filePath));

                                AvtPartInfo:UpPartUI(ModelID);
                            end

                            threadpool:notify(seq, ErrorCode.OK, errcode)
                        end;

                        print("AvtResCtrl:DownloadFile2", ModelID, sFileInfo.Url, filePath, sFileInfo.MD5)
                        ns_http.func.downloadFile(sFileInfo.Url, filePath, sFileInfo.MD5, callback)
                    else
                        return;
                    end
                else
                    threadpool:work(function()
                        self:LoadServerFileInfo(ModelID);
                        self:DownloadFile(ModelID);
                        threadpool:notify(seq, ErrorCode.OK, errcode);
                    end)
                end

                return threadpool:wait(seq, timeout, tick);
            end;

function t_exhibition:CheckProfileBlackStat(uin)
	uin = uin or self.uin;
	uin = uin and tonumber(uin);
	if not uin then return false end
	local black_stat = nil;
	-- print("t_exhibition:CheckProfileBlackStat(): uin = ", uin);
	if self.uin_to_profile_black_stat and self.uin_to_profile_black_stat[uin] then 
		-- print("t_exhibition:CheckProfileBlackStat(): self.uin_to_profile_black_stat = ", self.uin_to_profile_black_stat);
		black_stat = self.uin_to_profile_black_stat[uin];
	elseif not self.has_requested[uin] then
		-- print("t_exhibition:CheckProfileBlackStat(): request");
		-- print("t_exhibition:CheckProfileBlackStat(): self.has_requested = ", self.has_requested);
		self.has_requested[uin] = true;
		threadpool:work(function()
			function onResponseGetProfile(ret, user_data)
				-- print("t_exhibition:CheckProfileBlackStat()#onResponseGetProfile(): uin = ", uin);
				-- print("t_exhibition:CheckProfileBlackStat()#onResponseGetProfile(): ret = ", ret);
				local t_exhibition = t_exhibition;
				t_exhibition.has_requested = t_exhibition.has_requested or {};
				t_exhibition.has_requested[uin] = false;
				t_exhibition.uin_to_profile_black_stat = t_exhibition.uin_to_profile_black_stat or {};
				t_exhibition.uin_to_profile_black_stat[uin] = ret and ret.profile and ret.profile.black_stat or 0;
				t_exhibition.retPool[uin] = ret;
				-- t_exhibition.uin_to_profile_black_stat[uin] = ret and ret.profile and (ret.profile.black_stat or 0) or nil; --针对ret和ret.profile赋nil
			end
			t_exhibition:GetPlayerProfileByUin(uin, onResponseGetProfile);
		end);
	end
	-- local black_stat = self.uin_to_profile_black_stat and self.uin_to_profile_black_stat[uin] 
	-- or (not self.has_requested[uin] and self.GetPlayerProfileByUin and self:GetPlayerProfileByUin(uin, onResponseGetProfile));
	return black_stat and (black_stat == 1 or black_stat == 2);
end;

function t_exhibition:GetPlayerProfileByUin(uin, callback, ext_callback)
    print("GetPlayerProfileByUin:");
    print("uin = " .. uin);
    if (uin<1000 or uin>=ns_const.__INT32__) and ext_callback then
        ext_callback( {ret=1} );  --号码错误
        return
    end

    local t_exhibition = self;
    if  t_exhibition.net_ok and t_exhibition.retPool and t_exhibition.retPool[uin] then
        Log( "find cache for " .. uin );
        --已经拉取该UIN的数据
        if t_exhibition.isHost and t_exhibition.self_data_dirty then
            --自己的数据已经修改，需要重新拉取
            Log("111:");
            t_exhibition.self_data_dirty = false;
        elseif callback then
            Log("222:");
            callback(t_exhibition.retPool[uin], { callback=ext_callback }  );
            return;
        end
    end
    Log("333:");
    local url_ = g_http_root_map .. 'miniw/profile?act=getProfile&op_uin=' .. uin .. "&pop=1" .. '&' .. http_getS1Map();
    Log( url_ );
    ns_http.func.rpc( url_, callback, { callback=ext_callback } );
end;

function PEC_GetPlayerProfileByUin(uin, ext_callback)
    t_exhibition:GetPlayerProfileByUin(uin, PEC_GetPlayerProfileByUin_cb, ext_callback)
end;


function PEC_GetPlayerProfileByUin_cb(ret, user_data)  --获取个人中心玩家信息回调函数
    print("PEC_GetPlayerProfileByUin_cb:");
    if user_data and user_data.callback then user_data.callback(ret) end

    local t_exhibition = t_exhibition;

    if  ret and ret.ret then
        print("ret ok:");
        if  ret.ret == 1 then
            --uin error
            ShowGameTips(GetS(3272), 3);
            return;
        elseif ret.ret == 404 then
            --新用户
        end

        -- 控制相册是否可以上传图片
        t_exhibition.close_upload = ret.close_upload or 1;
        t_exhibition.setRetToPool(ret);
        t_exhibition.net_ok	= true;

        local profile = ret.profile;
        if profile then
            print("profile ok:");
            local playerInfo = {};
            playerInfo.gender        = profile.gender        or 0;
            playerInfo.head_frame_id = profile.head_frame_id or 1;   --默认为头像1
            playerInfo.head_unlock   = profile.head_unlock   or 0;
            t_exhibition.head_unlock = profile.head_unlock   or 0;

            playerInfo.head_frames      = profile.head_frames      or {};     --已经解锁的头像
            playerInfo.head_frames_temp = profile.head_frames_temp or {};     --已经解锁的头像(30天)

            t_exhibition.first_ui = profile.first_ui or 1;			--优先展示
            t_exhibition.open_comment = profile.open_comment or 1;	--是否可评论

            --兼容旧数据(旧版本头像) 20210
            if  (profile.is_zhubo==1) and (not playerInfo.head_frames[20210]) then
                playerInfo.head_frames[20210] = { t=os.time() };
            end

            --昵称 角色 皮肤
            if  profile.RoleInfo then
                playerInfo.NickName = profile.RoleInfo.NickName or "";
                playerInfo.SkinID   = profile.RoleInfo.SkinID   or 0;
                playerInfo.Model    = profile.RoleInfo.Model    or 0;
                if  playerInfo.Model <= 0 then
                    playerInfo.Model = 2
                end
            end

            --鉴赏家
            playerInfo.expert = profile.expert or nil ;

            --好友 关注 人气值
            playerInfo.friend_count    = 0;
            playerInfo.attention_count = 0;
            playerInfo.popularity_count = 0;
            if  profile.relation then
                playerInfo.friend_count    = (profile.relation.friend_eachother   or 0) + (profile.relation.friend_oneway or 0);
                playerInfo.attention_count = (profile.relation.friend_beattention or 0);
            end
            playerInfo.popularity_count = ret.popularity or 0;

            --自定义头像
            if  profile.header and profile.header.url then
                if profile.uin and AccountManager:getUin() ~= profile.uin and profile.black_stat and (profile.black_stat == 1 or profile.black_stat == 2) then
                    playerInfo.headIndexFile = "ui/snap_jubao.png";
                    playerInfo.head_url = nil;
                else
                    playerInfo.head_checked = profile.header.checked or 0; --审核状态
                    if  playerInfo.head_checked == 2 then
                        playerInfo.head_url     = "f"       --审核失败
                    else
                        playerInfo.head_url     = profile.header.url;
                    end
                end
                PEC_SetPlayerHeadFile(playerInfo);
            else
                if  playerInfo.Model and playerInfo.SkinID then
                    playerInfo.head_url = "";
                    if profile.uin and AccountManager:getUin() ~= profile.uin and profile.black_stat and (profile.black_stat == 1 or profile.black_stat == 2) then
                        playerInfo.headIndexFile = "ui/snap_jubao.png";
                    elseif t_exhibition.isHost then
                        playerInfo.headIndexFile = "ui/roleicons/".. GetHeadIconIndex() ..".png";  	--头像文件
                    else
                        playerInfo.headIndexFile = "ui/roleicons/".. GetHeadIconIndex( playerInfo.Model, playerInfo.SkinID ) ..".png";  	--头像文件
                    end
                    PEC_SetPlayerHeadFile(playerInfo);
                end
            end

            if profile.tips and profile.tips.total then
                playerInfo.tips = profile.tips or {};
            end

            --心情描述
            print("PlayerCenter_SetMood:");
            t_exhibition.mood_icon = profile.mood_icon;
            t_exhibition.mood_icon_select = t_exhibition.mood_icon or "A100";
            t_exhibition.mood_text = unescape(profile.mood_text);
            if profile.mood_icon ==nil and profile.mood_text == nil then
                PlayerExhibitionCenterMood_Init(false);
            else
                PlayerExhibitionCenterMood_Init(true);
                PlayerCenter_SetMood(profile.mood_icon, t_exhibition.mood_text);
            end

            t_exhibition.playerinfo=playerInfo;
            PEC_ShowPlayerInfo(); --显示个人中心顶部的文字

            --设置相册
            local PhotoInfo = {};
            PhotoInfo.photo_unlock  = profile.photo_unlock  or 3;

            --t_ExhibitionCenter.photoFileList= profile.photo or {};

            t_ExhibitionCenter.photoServerIndex ={};
            local photo_index = 0;
            if profile.photo then
                for k ,v in pairs(profile.photo) do
                    if v then
                        photo_index = photo_index+1;
                        table.insert(t_ExhibitionCenter.photoServerIndex,k);
                        table.insert(t_ExhibitionCenter.photoFileList,photo_index,v);
                    end
                end
            end

            for i=1,  t_ExhibitionCenter.photoMax do
                if  t_ExhibitionCenter.photoFileList[i] then
                    t_ExhibitionCenter.photoFileList[i].filename = g_photo_root .. getHttpUrlLastPart( t_ExhibitionCenter.photoFileList[i].url );
                end
            end

            t_ExhibitionCenter.Photoinfo = PhotoInfo;

            --设置默认显示的展示中心页面
            t_ExhibitionCenter.defaultSelect = profile.first_ui or 1;
            if getglobal("ExhibitionInfoPage3CommentSlider"):IsShown() then
                PEC_ExhibitionTab(t_ExhibitionCenter.curTabIndex);
            else
                PEC_ExhibitionTab(t_ExhibitionCenter.defaultSelect);
            end

            t_exhibition.black = profile.black or 0 ;
            if not PEC_SetBlackShow(t_exhibition.black) then
                print("测试获取地图的接口")
                PEC_GetPlayerMapByUin(t_exhibition.uin,1,1);  --获取地图接口调用
            end

            --成就系统上报:好友数/粉丝数
            if t_exhibition.isHost then
                ArchievementGetInstance().func:checkFriendInfo(playerInfo.friend_count, playerInfo.attention_count, playerInfo.expert);

                --检查实名认证
                ArchievementGetInstance().func:checkRealname();
            end
        end

    else
        Log("ret is nil:PEC_GetPlayerProfileByUin_cb()");
    end
end;
        end
    },


    {
        -- 2
        ver_list = "0.34.5",
        install = function()

            function varTablePrinter(t, name)
            end

        end,
    },
	{
        -- 2
       ver_list = "0.37.1 0.37.0",
        install = function()
---------------------------------------
-------------------------
function AccelKey_Escape(isDead)
	if IgnoreEsc then
		return;
	end
	if ClientCurGame == nil then
		return;
	end

	if isEducationalVersion then--for minicode
		return;
	end

	--LLDO:录像系统窗口
	VideoRecordEscCloseFrame();
	
	if RecordPkgMgr:isRecordPlaying() then

		return;
	end

	--关闭打赏界面1
	if getglobal("ArchiveRewardFrame"):IsShown() then
		GetInst("UIManager"):GetCtrl("MapReward"):RewardFrameCloseBtnClicked();
		return;
	end

	--关闭打赏界面2
	if getglobal("MapReward"):IsShown() then
		GetInst("UIManager"):GetCtrl("MapReward"):RewardSelectFrameCloseBtnClicked();
		return;
	end

	if getglobal("SingleEditorFrame"):IsShown() then
		SingleEditorFrameCloseBtn_OnClick()
		return;
	end
	
	if getglobal("ChooseModsFrame"):IsShown() then
		ChooseModsFrameCloseBtn_OnClick();
		return;
	end
	
	if getglobal("MyModsEditorFrame"):IsShown() then
		MyModsEditorFrameCloseBtn_OnClick();
		return;
	end

	--LLTODO:关闭举报界面
	if getglobal("InformFrame"):IsShown() then
		InformFrameClose_OnClick();
		return;
	end

	if isDead then
		if getglobal("SetMenuFrame"):IsShown() then
			getglobal("SetMenuFrame"):Hide();
			ClientCurGame:setInSetting(false);
		else
			getglobal("SetMenuFrame"):Show();
			ClientCurGame:setInSetting(true);
		end
		return;
	end

	--LLTODO:关闭交互界面：好友界面
	if getglobal("FriendChatFrame"):IsShown() then
		getglobal("FriendChatFrame"):Hide();
		return;
	end
	
	if getglobal("FriendFrame"):IsShown() then
		getglobal("FriendFrame"):Hide();
		return;
	end

    --刷怪方块界面需要返回上一层 
	if getglobal("ChooseOrganismFrame"):IsShown() then
		getglobal("ChooseOrganismFrame"):Hide();
		getglobal("CreateMonsterFrame"):Show();
		return;
	end

	--传送点方块
	if getglobal("AddTransferDestinationFrame"):IsShown() then
		getglobal("AddTransferDestinationFrame"):Hide()
		getglobal("TransferFrame"):Show()
		return
	end
	--if getglobal("ChooseOriginalFrame"):IsShown() and getglobal("TransferRuleSetFrame"):IsShown() then
	--	getglobal("ChooseOriginalFrame"):Hide()
	--	getglobal("TransferRuleSetFrame"):Show()
	--	getglobal("TransferFrame"):Show()
	--	return
	--end
	if getglobal("TransferRuleSetFrame"):IsShown() and (not getglobal("ChooseOriginalFrame"):IsShown()) then
		TransferRuleSetFrameClose()
		--getglobal("TransferFrame"):Show()
		return
	end 

	if getglobal("TransferRuleSetFrame"):IsShown() and getglobal("ChooseOriginalFrame"):IsShown() then
		getglobal("ChooseOriginalFrame"):Hide()
		getglobal("TransferRuleSetFrame"):Show()
		getglobal("TransferFrame"):Show()
		return
	end

	--关闭编书台页面
	if getglobal("BookEditorFrame"):IsShown() then
		BookEditorCtrl.AntiActive()
		return
	end

	if getglobal("MultiLangEditFrame"):IsShown() then
		if getglobal("TranslatingTipsFrame"):IsShown() then
			return
		else
			MultiLangEditFrameCloseBtn_OnClick();
			return
		end
	end

	if getglobal("NpcShopFrame"):IsShown() then
		if getglobal("NpcShopBuyFrame"):IsShown() then
			getglobal("NpcShopBuyFrame"):Hide();
			return
		end
	end

	--关闭选中编辑生物界面
	if getglobal("ActorSelectEditFrame"):IsShown() then
		getglobal("ActorSelectEditFrame"):Hide();
		return
	end
	-- 关闭手持触发器界面
	if getglobal("DeveloperObjEdit"):IsShown() then
		--注意这里要用MVC形式来关闭 ui
		GetInst("UIManager"):Close("DeveloperObjEdit")
		if not CurMainPlayer:isSightMode() then
			CurMainPlayer:setSightMode(true);
		end
		return
	end
	-- 关闭开发者工具界面
	if getglobal("NewRuleSetFrame"):IsShown() then
		NewRuleSetFrameCloseBtn_OnClick()
		return
	end
	if ClientCurGame:isInGame() then
		--游戏中esc失效ui表
		local t_HideFrame = {
			"HomeChestFrame","PokedexFrame"
		}
		for _, v in pairs(t_HideFrame) do
			local hideui = getglobal(v)
			if hideui:IsShown() then
				return
			end
		end

		--工具模式:
		if CurWorld:isGameMakerMode() and CurWorld:isGameMakerToolMode() then
			--回滚
			if getglobal("ToolModeFrameRevertBtn"):IsShown() then
				press_btn("ToolModeFrameRevertBtn");
				return;
			end

			--关闭对象库
			if getglobal("ToolObjLib"):IsShown() then
				press_btn("ToolObjLibBodyCloseBtn");
				return;
			end
		end
	end

	if ClientCurGame:getName() == "SurviveGame" or ClientCurGame:getName() == "GameSurviveRecord"  then
		if CurWorld:getOWID() == NewbieWorldId then
			PlayMainFrameGuideSkip_OnClick();
		elseif ClientMgr:getGameData("hideui") == 1 then
			AccelKey_HideUIToggle();
			return;
		elseif getglobal("PaletteFrame"):IsShown() then
            getglobal("PaletteFrame"):Hide()
		elseif getglobal("LettersFrame"):IsShown() then
            getglobal("LettersFrame"):Hide()
			UIFrameMgr:setCurEditBox(nil);
		elseif getglobal("CreateBackpackFrame"):IsShown() then
			getglobal("CreateBackpackFrame"):Hide()
			UIFrameMgr:setCurEditBox(nil);
		elseif getglobal("BattleEndFrame"):IsShown() then
        	--getglobal("SetMenuFrame"):Show();
			--ClientCurGame:setInSetting(true);
			return;
		elseif getglobal("CameraFrame"):IsShown() then
            getglobal("CameraFrame"):Hide()
        elseif getglobal("InstructionParserFrame"):IsShown() then
        	getglobal("InstructionParserFrame"):Hide()
        	if getglobal("MItemTipsFrame"):IsShown() then
        		getglobal("MItemTipsFrame"):Hide()	--隐藏名字框
        	end
        elseif getglobal("SignalParserFrame"):IsShown() then
        	SignalParserFrameCloseBtn_OnClick();
        elseif getglobal("EncryptFrame"):IsShown() then
        	EncryptFrameCloseBtn_OnClick();
		elseif getglobal("SetMenuFrame"):IsShown() then
			getglobal("SetMenuFrame"):Hide()
		  	ClientCurGame:setInSetting(false);
		elseif getglobal("ActionLibraryFrame"):IsShown() then
			getglobal("ActionLibraryFrame"):Hide();
			if not CurMainPlayer:isSightMode() then
				CurMainPlayer:setSightMode(true);
			end
		elseif getglobal("BookFrame"):IsShown() then
			BookFrameCloseBtn_OnClick();		--关闭书封面
		elseif getglobal("ActivityMainFrame"):IsShown() then
			ActivityMainCtrl:AntiActive();
		else
			if ClientCurGame:isOperateUI() then
				if getglobal("RoleFrame"):IsShown() then
					getglobal("RoleFrame"):Hide();
				end

				if getglobal("ActorEditFrame"):IsShown() then
					ActorEditFrameCloseBtn_OnClick();
				end
				HideAllFrame(nil, false);				
				getglobal("RoleAttrFrame"):Hide();
				getglobal("BackpackFrameMakeFrame"):Hide();
				getglobal("EnchantFrame"):Hide();
				getglobal("CreateRoomFrame"):Hide();
			else
				--如果不是星标模式就退出星标模式
				if not CurMainPlayer:isSightMode() then
					CurMainPlayer:setSightMode(true);
				else
			   		getglobal("SetMenuFrame"):Show();
			   		ClientCurGame:setInSetting(true);
				end
				getglobal("PcGuideKeySightMode"):Hide();
			end
		end
	elseif ClientCurGame:getName() == "MainMenuStage" then
		if getglobal("SetMenuFrame"):IsShown() then
			getglobal("SetMenuFrame"):Hide()
		else
			if not IsHideMainMenuFrames() then
				getglobal("SetMenuFrame"):Show()
			end 
		end
	end
end

function ArchiveInfoFrameEditModBtn_OnClick(curOwid)
	local owid = nil 
	if ArchiveWorldDesc then
		local worldInfo = ArchiveWorldDesc;
		owid = curOwid or worldInfo.worldid;
	else
		if CurWorld and CurWorld.getOWID then 
			owid = CurWorld:getOWID()
		end
	end
	if owid then 
		Log("EditMod "..owid);

		if ModEditorMgr:ensureMapHasDefualtMod(owid) then
			if ClientCurGame:isInGame() or ModMgr:loadWorldMods(owid) then
				Log("loadWorldMods ok");

				ClearSelectedMods();
			
				for i = 1, ModMgr:getMapModCount() do
					local moddesc = ModMgr:getMapModDescByIndex(i-1);
					table.insert(MapLoadedMods, moddesc.uuid);
				end

				local uuid = ModMgr:getMapDefaultModUUID();
				Log("uuid = "..uuid);

				--LLTODO:去掉
				--FrameStack.reset("LobbyFrame");

				getglobal("ArchiveInfoFrame"):Hide();
				local args = {
					editmode = 4,
					uuid = uuid,
					isMapMod = true,
					owid=owid,
				};
				FrameStack.enterNewFrame("MyModsEditorFrame", args, OnEditModFinish, owid);
			end
		end
	end 
end

MyModsEditorFrameCloseBtn_OnClick_save = MyModsEditorFrameCloseBtn_OnClick;
function MyModsEditorFrameCloseBtn_OnClick()
	print("hotfix MyModsEditorFrameCloseBtn_OnClick")
	local IsCreateNewMod = nil
	for i = 1, 100 do
		local name, value = debug.getupvalue(MyModsEditorFrameCloseBtn_OnClick_save, i)
			if name == 'IsCreateNewMod' then 
				IsCreateNewMod = value
				break;
		end 
	end 
	if IsCreateNewMod == nil then return end

	local modName = getglobal("TabSettingFrameModNameEdit"):GetText();
	local modDesc = getglobal("TabSettingFrameModDescEdit"):GetText();

	if IsCreateNewMod then
		if modName ~= '' or modDesc ~= '' then 
			MessageBox(5, GetS(3937));
			getglobal("MessageBoxFrame"):SetClientString("确认退出编辑器");
			return;
		end
	end

	if FrameStack.cur().editmode == 1 then
		if FrameStack.cur().haveModified==true then
			local moddesc = ModEditorMgr:getCurrentEditModDesc();
			statisticsGameEvent(511, '%lls', moddesc.uuid);
		end
	end

    ModEditorMgr:requestSaveUserModAllocatedId()

	if CurWorld and CurWorld.isGodMode and CurWorld:isGodMode() then 
    	--如果是在地图中打开的插件库，关闭的时候无需返回ArchiveInfoFrame和LobbyFrame
    	local cur = FrameStack.stack[#FrameStack.stack]
		local prev = FrameStack.stack[#FrameStack.stack - 1]

		print("hotfix MyModsEditorFrameCloseBtn_OnClick prev:", type(prev), prev);
		if cur._name == "MyModsEditorFrame" and prev and (prev._name == "ArchiveInfoFrame" or prev._name == "LobbyFrame") then 
    		MyModsEditorFrame_OnLeave()
    		table.remove(FrameStack.stack, #FrameStack.stack);
			--游戏内 cur和prev对应的ui都不显示的话，要变成准星模式，并且隐藏屏幕下方的关于esc的提示
			if not getglobal("MyModsEditorFrame"):IsShown() and not getglobal(prev._name):IsShown() then
				if CurMainPlayer and not CurMainPlayer:isSightMode() then
					CurMainPlayer:setSightMode(true);
					if getglobal("PcGuideKeySightMode"):IsShown() then
						getglobal("PcGuideKeySightMode"):Hide()
					end
				end
			end
    	else
    		FrameStack.goBack()
			if cur._name == "MyModsEditorFrame" and getglobal("MyModsEditorFrame"):IsShown() then
				if CurMainPlayer and CurMainPlayer:isSightMode() then
					CurMainPlayer:setSightMode(false)
				end
			end
    	end 
    else
    	FrameStack.goBack()
    end
end

function OnEditModFinish(leavingframe, owid)
	Log("OnEditModFinish");
	if not ClientCurGame:isInGame() then
		ModMgr:unLoadCurMods(owid);
	end
end

function updateMapModCount(owid)
	if ModMgr:getMapModCount() ~= 0 and not ClientCurGame:isInGame() then
		ModMgr:unLoadCurMods(owid);
		if ModEditorMgr:ensureMapHasDefualtMod(owid) then
			if ModMgr:loadWorldMods(owid) then
			end
		end
	end
end


------------------------------------------
-----------------------------------




----------------------------------------------------
------------------------------------------------------------------------


   ScriptSupportTrigger.makeTriggerCode = function(self, event, condition, action, triggerid, toggle)
        self:resetFuncIndex()
        self:clearFuncList()
        self.triggerid = triggerid

        local codeheader = self:makeCodeHeader()
        local mainbegcode = self:makeMainBegCode()
        local mainendcode = self:makeMainEndCode(toggle)
        local conditioncode = self:makeConditionCode(condition)
        local actioncode = self:makeActionCode(action)
        local funclistcode = self:makeCodeForFuncList() -- 前面生成出的方法
        if not conditioncode or not actioncode then
            return
        end

        -- link
        local content = codeheader .. mainbegcode
        content = content .. funclistcode
        content = content .. (conditioncode .. actioncode .. mainendcode)

        -- reg events
        if toggle then
            self:clearFuncList()
            local eventcode = self:makeEventCode(event) or ''
            local funclistcode = self:makeCodeForFuncList() -- 前面生成出的方法

            content = content .. (funclistcode .. eventcode)
        end
        
        return content
    end

    ScriptSupportCtrl.cloneScript = function(self, typeSrc, typeDst)
        print('-- <cloneScript> 1--', typeSrc)
        print('-- <cloneScript> 2--', typeDst)
        if table.equal(typeSrc, typeDst) then
            return false
        end

        local config = ScriptSupportSetting:loadSettingScript(nil, typeSrc)
        if not config then
            return false
        end

        local ret, errorcode = ScriptSupportSetting:saveSettingScript(nil, typeDst, config)
        if not ret then
            self:printErrorCode(errorcode)
            return false, errorcode
        end
        return true
    end;

ClassList["DeveloperObjEditCtrl"].OpenPluginViewAndChangeTab = function(self,tabIndex)
    local info = self.model:GetIncomingParam()
 local defId = info.defId
 local objType = info.objType

 local curTableIndex = tabIndex
 local typeName = ""
 local def = nil 
 local tab = nil
 --判断地图插件库是否已经存在该插件
 if objType == -1 then
  typeName = "block"
  --def = DefMgr:getBlockDef(defId,false)
  def = info.blockDef
  tab = getglobal("ModEditorTab3")
 else
  typeName = "actor"
  def = ModEditorMgr:getMonsterDefById(defId)
  if not def then
   def = DefMgr:getMonsterDef(defId)
  end
  -- def = info.monsterdef
  tab = getglobal("ModEditorTab4")
 end
 if not (def and def.EditType and def.EditType ~= 0) then
  return ShowGameTips(GetS(15208), 3)
 end
 GongNengFramePluginLibBtn_OnClick()
 EditorTabTemplate_OnClick(tab)
 SetSingleEditorFrame(typeName,def)
 ChangeSingleEditor2Tab(curTableIndex)
end

ClassList["DeveloperEditTriggerModel"].SetCurType = function(self,type)
 if self:GetIncomingParam() then 
  self:GetIncomingParam().curType = type
  self:GetIncomingParam().curMapId = type
 end
end;
 

function ArchiveGradeFrameRewardBtnClicked()
	local bkgWidth = 720;
	local blockWidth = 126;
	local blockInterval = 36;

	local devGrade = MapRewardClass:GetAuthorClass();
	local itemTab = MapRewardClass:GetDevRewardItemID(devGrade);
	local showBlockNum = #itemTab;
	print("ArchiveGradeFrameRewardBtnClicked", blockNum, itemTab)

	for i=1, 4 do
		if i <= showBlockNum then
			local itemInfo = MapRewardClass:GetDevRewardItemInfo(itemTab[i]);
			if itemInfo then
					getglobal("MapRewardPrize" .. i .. "Text"):SetText(DefMgr:getItemDef(tonumber(itemInfo.ItemID)).Name);
					getglobal("MapRewardPrize" .. i .. "Text"):Show();
				-- if itemInfo.CostType == 0 then
				-- elseif itemInfo.CostType == 1 then
				-- elseif itemInfo.CostType == 2 then
				-- 	getglobal("MapRewardPrize" .. i .. "Text"):SetText(itemInfo.CostNum);
				-- 	getglobal("MapRewardPrize" .. i .. "Text"):Show();
				-- end
			end

			getglobal("MapRewardPrize" .. i):Show();
			getglobal("MapRewardPrize" .. i):SetPoint("top", "MapRewardTitle", "bottom", (2*i-showBlockNum -1)*(126 + 36)/2, 32);
			getglobal("MapRewardPrize" .. i .. "Block"):SetTexture("items/icon" .. itemTab[i] .. ".png", true);
		else
			getglobal("MapRewardPrize" .. i):Hide();
		end

		getglobal("MapRewardPrize" .. i .. "Shade"):Hide();
	end

	local nickName = MapRewardClass:GetNickName();
	local titleObj = getglobal("MapRewardTitleName");
	if nickName then
		titleObj:SetText(GetS(21791, nickName));
		titleObj:SetWidth(600);
	else
		titleObj:SetText(GetS(21778));
	end

	GetInst("UIManager"):Open("MapReward");
	UIFrameMgr:BringFrameAboveFrame("MapReward", "ArchiveGradeFrame");
	UIFrameMgr:BringFrameAboveFrame("RewardHelpFrame", "MapReward");
	UIFrameMgr:BringFrameAboveFrame("MapRewardMessageBox", "MapReward");
	MapRewardClass:SetElectBlockIndex(0);
	GetInst("UIManager"):GetCtrl("MapReward"):RewardBlockTemplateBtnClicked(1);	
end

function MapRewardClass:GetRewardState(wid)
	if not wid then
		return 2;
	end

	if self.RewardWidCache[wid] then
		return self.RewardWidCache[wid];
	else
		return 2;
	end
end;

	UITemplateBaseFuncMgr:registerFunc("MyModsEditorFrameCloseBtn", MyModsEditorFrameCloseBtn_OnClick, "插件库关闭按钮");
        end,
    },

 	{
      
        ver_list = "0.37.11",
        install = function()
		

	

        end,
    },

}


