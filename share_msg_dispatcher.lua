
	local shareMsgHandleDispatcher = {};

	shareMsgHandleDispatcher[0] = {};
	shareMsgHandleDispatcher[0].handle = URLShareMsgHandle;
	shareMsgHandleDispatcher[0].callback = function(szUiMsgFrameName)
		getglobal(szUiMsgFrameName .. "URLFrame"):Show();
		return 149;
	end;

	shareMsgHandleDispatcher[1] = {};
	shareMsgHandleDispatcher[1].handle = SkinShareMsgHandle;
	shareMsgHandleDispatcher[1].callback = function(szUiMsgFrameName)
		getglobal(szUiMsgFrameName .. "ShareFrame"):Show();
		return 149;
	end;

	shareMsgHandleDispatcher[2] = {};
	shareMsgHandleDispatcher[2].handle = RideShareMsgHandle;
	shareMsgHandleDispatcher[2].callback = function(szUiMsgFrameName)
		getglobal(szUiMsgFrameName .. "ShareFrame"):Show();
		return 149;
	end;

	shareMsgHandleDispatcher[3] = {};
	shareMsgHandleDispatcher[3].handle = RoleShareMsgHandle;
	shareMsgHandleDispatcher[3].callback = function(szUiMsgFrameName)
		getglobal(szUiMsgFrameName .. "ShareFrame"):Show();
		return 149;
	end;

	shareMsgHandleDispatcher[4] = {};
	shareMsgHandleDispatcher[4].handle = AchieveShareMsgHandle;
	shareMsgHandleDispatcher[4].callback = function(szUiMsgFrameName)
		getglobal(szUiMsgFrameName .. "ShareAchieveFrame"):Show();
		return 149;
	end;

	shareMsgHandleDispatcher[5] = {};
	shareMsgHandleDispatcher[5].handle = AvatarShareMsgHandle;
	shareMsgHandleDispatcher[5].callback = function(szUiMsgFrameName)
		getglobal(szUiMsgFrameName .. "ShareFrame"):Show();
		getglobal(szUiMsgFrameName .. "ShareFrameMoreBtn"):Show();
		return 149;
	end;

	shareMsgHandleDispatcher[6] = {};
	shareMsgHandleDispatcher[6].handle = VictoryMapShareMsgHandle;
	shareMsgHandleDispatcher[6].callback = function(szUiMsgFrameName)
		getglobal(szUiMsgFrameName .. "ShareMapFrame"):Show();
		getglobal(szUiMsgFrameName .. "ShareMapFrameTopText"):Show();
		getglobal(szUiMsgFrameName .. "ShareMapFrameBottomText"):Hide();
		return 149;
	end;

	shareMsgHandleDispatcher[7] = {};
	shareMsgHandleDispatcher[7].handle = FailureMapShareMsgHandle;
	shareMsgHandleDispatcher[7].callback = function(szUiMsgFrameName)
		getglobal(szUiMsgFrameName .. "ShareMapFrame"):Show();
		getglobal(szUiMsgFrameName .. "ShareMapFrameTopText"):Show();
		getglobal(szUiMsgFrameName .. "ShareMapFrameBottomText"):Hide();
		return 149;
	end;

	shareMsgHandleDispatcher[8] = {};
	shareMsgHandleDispatcher[8].handle = MapShareMsgHandle;
	shareMsgHandleDispatcher[8].callback = function(szUiMsgFrameName)
		getglobal(szUiMsgFrameName .. "ShareMapFrame"):Show();
		getglobal(szUiMsgFrameName .. "ShareMapFrameTopText"):Hide();
		getglobal(szUiMsgFrameName .. "ShareMapFrameBottomText"):Hide();
		return 136 - 57;
	end;

	shareMsgHandleDispatcher[9] = {};
	shareMsgHandleDispatcher[9].handle = InviteJoinRoomMsgHandle;
	shareMsgHandleDispatcher[9].callback = function(szUiMsgFrameName)
		getglobal(szUiMsgFrameName .. "InviteJoinRoom"):Show();
		return 100;
	end;