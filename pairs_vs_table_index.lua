
-----------------------------------------------------举报功能--------------------------------------------------、
--[[举报界面配置列表]]
InformDef = {
	--[[存档中举报]]
	{
		tid = 101;
		--[[举报内容]]
		content = {
			{type = 4--[[举报类型id 色情内容]], stringid = 10531--[[描述stringid]]};
			{type = 5--[[举报类型id 政治敏感内容]], stringid = 10532--[[描述stringid]]};
			{type = 3--[[举报类型id 暴力恐怖内容]], stringid = 10571--[[描述stringid]]};
			{type = 1--[[举报类型id 使用黑科技修改]], stringid = 10527--[[描述stringid]]};
			{type = 2--[[举报类型id 盗取他人的存档]], stringid = 10530--[[描述stringid]]};
		};
	};
	--[[个人中心举报玩家]]
	{
		tid = 102;
		--[[举报内容]]
		content = {
			{type = 3--[[举报类型id 色情内容]], stringid = 10531--[[描述stringid]]};
			{type = 4--[[举报类型id 政治敏感内容]], stringid = 10532--[[描述stringid]]};
			{type = 5--[[举报类型id 暴力恐怖内容]], stringid = 10571--[[描述stringid]]};
		};
	};
	--[[联机中举报玩家]]
	{
		tid = 103;
		--[[举报内容]]
		content = {
			{type = 3--[[举报类型id 色情内容]], stringid = 10531--[[描述stringid]]};
			{type = 4--[[举报类型id 政治敏感内容]], stringid = 10532--[[描述stringid]]};
			{type = 6--[[举报类型id 暴力恐怖内容]], stringid = 10571--[[描述stringid]]};
			{type = 5--[[举报类型id 攻击捣乱]], stringid = 10522--[[描述stringid]]};
			{type = 2--[[举报类型id 谩骂侮辱骚扰]], stringid = 10550--[[描述stringid]]};
			{type = 1--[[举报类型id 使用外挂]], stringid = 10521--[[描述stringid]]};
		};
	};
	--[[存档评论中举报]]
	{
		tid = 104;
		--[[举报内容]]
		content = {
			{type = 4--[[举报类型id 色情内容]], stringid = 10531--[[描述stringid]]};
			{type = 5--[[举报类型id 政治敏感内容]], stringid = 10532--[[描述stringid]]};
			{type = 6--[[举报类型id 暴力恐怖内容]], stringid = 10571--[[描述stringid]]};
			{type = 1--[[举报类型id 谩骂侮辱骚扰]], stringid = 10550--[[描述stringid]]};
			{type = 2--[[举报类型id 含广告]], stringid = 10551--[[描述stringid]]};
			{type = 3--[[举报类型id 毫无意义的内容]], stringid = 10552--[[描述stringid]]};
		};
	};
	--[[群组聊天中举报]]
	{
		tid = 105;
		--[[举报内容]]
		content = {
			{type = 1--[[举报类型id 色情内容]], stringid = 10531--[[描述stringid]]},
			{type = 2--[[举报类型id 政治敏感内容]], stringid = 10532--[[描述stringid]]},
			{type = 3--[[举报类型id 暴力恐怖内容]], stringid = 10571--[[描述stringid]]},
			{type = 4--[[举报类型id 谩骂侮辱骚扰]], stringid = 10550--[[描述stringid]]},
		};
	};
	--[[联机大厅中房间举报]]
	{
		tid = 106;
		--[[举报内容]]
		content = {
			{type = 1--[[举报类型id 色情内容]], stringid = 10531--[[描述stringid]]};
			{type = 2--[[举报类型id 政治敏感内容]], stringid = 10532--[[描述stringid]]};
			{type = 3--[[举报类型id 暴力恐怖内容]], stringid = 10571--[[描述stringid]]};
		};
	};
	--[[动态举报]]
	{
		tid = 107;
		--[[举报内容]]
		content = {
			{type = 1--[[举报类型id 色情内容]], stringid = 10531--[[描述stringid]]};
			{type = 2--[[举报类型id 政治敏感内容]], stringid = 10532--[[描述stringid]]};
			{type = 3--[[举报类型id 暴力恐怖内容]], stringid = 10571--[[描述stringid]]};
		};
	};
	--[[动态评论举报]]
	{
		tid = 108;
		--[[举报内容]]
		content = {
			{type = 1--[[举报类型id 色情内容]], stringid = 10531--[[描述stringid]]};
			{type = 2--[[举报类型id 政治敏感内容]], stringid = 10532--[[描述stringid]]};
			{type = 3--[[举报类型id 暴力恐怖内容]], stringid = 10571--[[描述stringid]]};
			{type = 4--[[举报类型id 谩骂侮辱骚扰]], stringid = 10550--[[描述stringid]]};
			{type = 5--[[举报类型id 含广告]], stringid = 10551--[[描述stringid]]};
			{type = 6--[[举报类型id 毫无意义的内容]], stringid = 10552--[[描述stringid]]};
		};
	};
}


InformDef2 = {
	--[[存档中举报]]
	[101] = {
		--[[举报内容]]
		content = {
			{type = 4--[[举报类型id 色情内容]], stringid = 10531--[[描述stringid]]};
			{type = 5--[[举报类型id 政治敏感内容]], stringid = 10532--[[描述stringid]]};
			{type = 3--[[举报类型id 暴力恐怖内容]], stringid = 10571--[[描述stringid]]};
			{type = 1--[[举报类型id 使用黑科技修改]], stringid = 10527--[[描述stringid]]};
			{type = 2--[[举报类型id 盗取他人的存档]], stringid = 10530--[[描述stringid]]};
		};
	};
	--[[个人中心举报玩家]]
	[102] = {
		--[[举报内容]]
		content = {
			{type = 3--[[举报类型id 色情内容]], stringid = 10531--[[描述stringid]]};
			{type = 4--[[举报类型id 政治敏感内容]], stringid = 10532--[[描述stringid]]};
			{type = 5--[[举报类型id 暴力恐怖内容]], stringid = 10571--[[描述stringid]]};
		};
	};
	--[[联机中举报玩家]]
	[103] = {
		--[[举报内容]]
		content = {
			{type = 3--[[举报类型id 色情内容]], stringid = 10531--[[描述stringid]]};
			{type = 4--[[举报类型id 政治敏感内容]], stringid = 10532--[[描述stringid]]};
			{type = 6--[[举报类型id 暴力恐怖内容]], stringid = 10571--[[描述stringid]]};
			{type = 5--[[举报类型id 攻击捣乱]], stringid = 10522--[[描述stringid]]};
			{type = 2--[[举报类型id 谩骂侮辱骚扰]], stringid = 10550--[[描述stringid]]};
			{type = 1--[[举报类型id 使用外挂]], stringid = 10521--[[描述stringid]]};
		};
	};
	--[[存档评论中举报]]
	[104] = {
		--[[举报内容]]
		content = {
			{type = 4--[[举报类型id 色情内容]], stringid = 10531--[[描述stringid]]};
			{type = 5--[[举报类型id 政治敏感内容]], stringid = 10532--[[描述stringid]]};
			{type = 6--[[举报类型id 暴力恐怖内容]], stringid = 10571--[[描述stringid]]};
			{type = 1--[[举报类型id 谩骂侮辱骚扰]], stringid = 10550--[[描述stringid]]};
			{type = 2--[[举报类型id 含广告]], stringid = 10551--[[描述stringid]]};
			{type = 3--[[举报类型id 毫无意义的内容]], stringid = 10552--[[描述stringid]]};
		};
	};
	--[[群组聊天中举报]]
	[105] = {
		--[[举报内容]]
		content = {
			{type = 1--[[举报类型id 色情内容]], stringid = 10531--[[描述stringid]]},
			{type = 2--[[举报类型id 政治敏感内容]], stringid = 10532--[[描述stringid]]},
			{type = 3--[[举报类型id 暴力恐怖内容]], stringid = 10571--[[描述stringid]]},
			{type = 4--[[举报类型id 谩骂侮辱骚扰]], stringid = 10550--[[描述stringid]]},
		};
	};
	--[[联机大厅中房间举报]]
	[106] = {
		--[[举报内容]]
		content = {
			{type = 1--[[举报类型id 色情内容]], stringid = 10531--[[描述stringid]]};
			{type = 2--[[举报类型id 政治敏感内容]], stringid = 10532--[[描述stringid]]};
			{type = 3--[[举报类型id 暴力恐怖内容]], stringid = 10571--[[描述stringid]]};
		};
	};
	--[[动态举报]]
	[107] = {
		--[[举报内容]]
		content = {
			{type = 1--[[举报类型id 色情内容]], stringid = 10531--[[描述stringid]]};
			{type = 2--[[举报类型id 政治敏感内容]], stringid = 10532--[[描述stringid]]};
			{type = 3--[[举报类型id 暴力恐怖内容]], stringid = 10571--[[描述stringid]]};
		};
	};
	--[[动态评论举报]]
	[108] = {
		--[[举报内容]]
		content = {
			{type = 1--[[举报类型id 色情内容]], stringid = 10531--[[描述stringid]]};
			{type = 2--[[举报类型id 政治敏感内容]], stringid = 10532--[[描述stringid]]};
			{type = 3--[[举报类型id 暴力恐怖内容]], stringid = 10571--[[描述stringid]]};
			{type = 4--[[举报类型id 谩骂侮辱骚扰]], stringid = 10550--[[描述stringid]]};
			{type = 5--[[举报类型id 含广告]], stringid = 10551--[[描述stringid]]};
			{type = 6--[[举报类型id 毫无意义的内容]], stringid = 10552--[[描述stringid]]};
		};
	};
}

InformDef3 = {
	--[[存档中举报]]
	[101] = {
		[1] = 10527, --使用黑科技修改
		[2] = 10530, --盗取他人的存档
		[3] = 10571, --暴力恐怖内容
		[4] = 10531, --色情内容
		[5] = 10532, --政治敏感内容
	};
	--[[个人中心举报玩家]]
	[102] = {
		[3] = 10531, --色情内容
		[4] = 10532, --政治敏感内容
		[5] = 10571, --暴力恐怖内容
	};
	--[[联机中举报玩家]]
	[103] = {
		[1] = 10521, --使用外挂
		[2] = 10550, --谩骂侮辱骚扰
		[3] = 10531, --色情内容
		[4] = 10532, --政治敏感内容
		[5] = 10522, --攻击捣乱
		[6] = 10571, --暴力恐怖内容
	};
	--[[存档评论中举报]]
	[104] = {
		[1] = 10521, --谩骂侮辱骚扰
		[2] = 10551, --含广告
		[3] = 10552, --毫无意义的内容
		[4] = 10531, --色情内容
		[5] = 10532, --政治敏感内容
		[6] = 10571, --暴力恐怖内容
	};
	--[[群组聊天中举报]]
	[105] = {
		[1] = 10521, --谩骂侮辱骚扰
		[2] = 10551, --含广告
		[3] = 10552, --毫无意义的内容
		[4] = 10531, --色情内容
		[5] = 10532, --政治敏感内容
		[6] = 10571, --暴力恐怖内容
		--[[举报内容]]
		content = {
			{type = 1--[[举报类型id 色情内容]], stringid = 10531--[[描述stringid]]},
			{type = 2--[[举报类型id 政治敏感内容]], stringid = 10532--[[描述stringid]]},
			{type = 3--[[举报类型id 暴力恐怖内容]], stringid = 10571--[[描述stringid]]},
			{type = 4--[[举报类型id 谩骂侮辱骚扰]], stringid = 10550--[[描述stringid]]},
		};
	};
	--[[联机大厅中房间举报]]
	[106] = {
		--[[举报内容]]
		content = {
			{type = 1--[[举报类型id 色情内容]], stringid = 10531--[[描述stringid]]};
			{type = 2--[[举报类型id 政治敏感内容]], stringid = 10532--[[描述stringid]]};
			{type = 3--[[举报类型id 暴力恐怖内容]], stringid = 10571--[[描述stringid]]};
		};
	};
	--[[动态举报]]
	[107] = {
		--[[举报内容]]
		content = {
			{type = 1--[[举报类型id 色情内容]], stringid = 10531--[[描述stringid]]};
			{type = 2--[[举报类型id 政治敏感内容]], stringid = 10532--[[描述stringid]]};
			{type = 3--[[举报类型id 暴力恐怖内容]], stringid = 10571--[[描述stringid]]};
		};
	};
	--[[动态评论举报]]
	[108] = {
		--[[举报内容]]
		content = {
			{type = 1--[[举报类型id 色情内容]], stringid = 10531--[[描述stringid]]};
			{type = 2--[[举报类型id 政治敏感内容]], stringid = 10532--[[描述stringid]]};
			{type = 3--[[举报类型id 暴力恐怖内容]], stringid = 10571--[[描述stringid]]};
			{type = 4--[[举报类型id 谩骂侮辱骚扰]], stringid = 10550--[[描述stringid]]};
			{type = 5--[[举报类型id 含广告]], stringid = 10551--[[描述stringid]]};
			{type = 6--[[举报类型id 毫无意义的内容]], stringid = 10552--[[描述stringid]]};
		};
	};
}

local totalCount = 10000000;
local starttime;
local targetExistentTid = 104;
local targetInexistentTid = 109;
local saveContent;

print("Existence test: ")
starttime = os.clock();
for i=1, totalCount do 
    for k, v in pairs(InformDef) do 
        if v.tid and v.tid == targetExistentTid then 
            saveContent = v.content;
        end
    end
end
print(os.clock() - starttime);

starttime = os.clock();
for i=1, totalCount do 
    if InformDef2[targetExistentTid] and InformDef2[targetExistentTid].content then 
        saveContent = InformDef2[targetExistentTid].content;
    end
end
print(os.clock() - starttime);

print("Inexistence test: ")
starttime = os.clock();
for i=1, totalCount do 
    for k, v in pairs(InformDef) do 
        if v.tid and v.tid == targetInexistentTid then 
            saveContent = v.content;
        end
    end
end
print(os.clock() - starttime);

starttime = os.clock();
for i=1, totalCount do 
    if InformDef2[targetInexistentTid] and InformDef2[targetInexistentTid].content then 
        saveContent = InformDef2[targetInexistentTid].content;
    end
end
print(os.clock() - starttime);
