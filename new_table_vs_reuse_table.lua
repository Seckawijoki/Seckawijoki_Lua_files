t_share_data = {
	platformName = {},
	--{{{ 每次分享时调用 SetShareData 同时刷新以下值
	imgPath = nil,
	url = nil,
	title = nil,
	text = nil,
	--}}}

	--{{{埋点预设数据
	shareScene = nil,		-- 分享场景
	shareModelId = "",		-- 分享皮肤、角色、坐骑的id
	--}}}

	--{{{ 地图分享时作者的信息
	worldName = "",
	authorNmae = "",
	authorUin = "",
	thumb_md5 = "",
	--}}}
	MAX_PLATFORM_COUNT = 9,

	--{{{游戏内分享
	tShareParams ={},

	-- 游戏内分享类型
	ShareType = {
		TEXT=0,
		MAP=1,
		SKIN=2,
		RIDE=3,
		ROLE=4,
		AVATAR=5,
		SCREENSHOT =6,
		BATTLE_VICTORY=7,
		BATTLE_FAILURE=8,
		URL=9,
		ACHIEVE = 10,
	},
	---}}}
}

function t_share_data:NewMiniShareParameters()
	local tShareParams = {

    };
	-- tShareParams.nickname = AccountManager:getNickName();
    self.tShareParams = tShareParams;
	return tShareParams;
end

function t_share_data:GetMiniShareParameters()
	local tShareParams = self.tShareParams;
	-- tShareParams.nickname = AccountManager:getNickName();
	tShareParams.shareType = self.ShareType.TEXT;

	tShareParams.fromowid = nil;

	tShareParams.skinId = nil;

	tShareParams.rideId = nil;
	tShareParams.rideLevel = nil;

	tShareParams.roleIndex = nil;

	tShareParams.avatarId = nil;
	tShareParams.seatInfo = nil;

	tShareParams.id = nil;
	tShareParams.level = nil;
	tShareParams.title = nil;

	tShareParams.url = nil;
	tShareParams.imageUrl = nil;
	tShareParams.title = nil;
	tShareParams.content = nil;

	return tShareParams;
end

function t_share_data:SetMiniShareParameters(shareParams)
	self.tShareParams = shareParams;
end

local tShareParams;

local start = os.clock();
for i=1, 1000000, 1 do 
    tShareParams = {};
    t_share_data:SetMiniShareParameters(tShareParams);
end
print(os.clock() - start);

local start = os.clock();
for i=1, 1000000, 1 do 
    tShareParams = t_share_data:NewMiniShareParameters();
    t_share_data:SetMiniShareParameters(tShareParams);
end
print(os.clock() - start);

local start = os.clock();
for i=1, 1000000, 1 do 
    tShareParams = t_share_data:GetMiniShareParameters();
    t_share_data:SetMiniShareParameters(tShareParams);
end
print(os.clock() - start);

