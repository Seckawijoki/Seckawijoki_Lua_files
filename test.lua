print("Hello world!");
function fact(n)
  if n == 0 then
    return 1
  else 
    return n * fact(n-1)
  end
end
a=1
b=2
c={}
--[==[
print("Enter a number:");
a = io.read("*number");
c=a+c[c[i]]
print(fact(a))
--]==]

print(gcinfo());

local apiId = 300

function IsAndroidBlockark()
	return apiId == 303 or apiId == 310 or apiId == 399;
end

print(IsAndroidBlockark())

facebook = not IsAndroidBlockark()
print(facebook)

ProjectDirectoryToChineseCharactersMap = {
  ["Proj.Android.Mini"]="国内官包",
  ["Proj.Android.Oppo"]="OPPO",
  ["Proj.Android.Tencent"]="应用宝",
  ["Proj.Android.Vivo"]="vivo",
  ["Proj.Android.MiniBeta"]="国内先遣服",
  ["proj.AndroidStudio.Blockark"]="海外",
  ["Proj.Android.Anzhi"]="安智",
  ["Proj.Android.Coolpad"]="酷派",
  ["Proj.Android.Dangle"]="当乐",
  ["Proj.Android.Egame"]="爱游戏",
  ["Proj.Android.Gg "]="GG",
  ["Proj.Android.Huawei"]="华为",
  ["Proj.Android.Iqiyi "]="爱奇艺",
  ["Proj.Android.Jinli"]="金立",
  ["Proj.Android.Jrtt"]="今日头条",
  ["Proj.Android.Lenovo"]="联想",
  ["Proj.Android.Meizu"]="魅族",
  ["Proj.Android.Mi"]="小米",
  ["Proj.Android.Migu"]="咪咕",
  ["Proj.Android.Mini18183"]="cps18183",
  ["Proj.Android.Mini7723"]="cps7723",
  ["Proj.Android.MiniGGZS"]="cpsGG助手",
  ["Proj.Android.MiniJinliYY"]="cps金立应用",
  ["Proj.Android.MiniJuFeng"]="cps聚丰",
  ["Proj.Android.MiniKuaiKan"]="cps快看漫画",
  ["Proj.Android.MiniKubi"]="cps酷比",
  ["Proj.Android.MiniLeiZheng"]="cps雷震",
  ["Proj.Android.MiniMeiTu"]="cps美图",
  ["Proj.Android.MiniNubia"]="cps努比亚",
  ["Proj.Android.MiniPP"]="cpsPP助手",
  ["Proj.Android.MiniQingNing"]="cps青柠",
  ["Proj.Android.MiniScb"]="cps市场部",
  ["Proj.Android.MiniSmss"]="cps神马搜索",
  ["Proj.Android.MiniSmartisan"]="cps锤子",
  ["Proj.Android.MiniWuFan"]="cps悟饭",
  ["Proj.Android.MiniYDMM"]="cps移动MM",
  ["Proj.Android.MiniYouFang"]="cps觅途有方",
  ["Proj.Android.MiniYYH"]="cps应用汇",
  ["Proj.Android.MiniZhongXing"]="cps中兴",
  ["Proj.Android.Samsung"]="三星",
  ["Proj.Android.SougouLLQ"]="搜狗浏览器",
  ["Proj.Android.SougouSJZS"]="搜狗手机助手",
  ["Proj.Android.SougouSS"]="搜狗搜索",
  ["Proj.Android.SougouYX"]="搜狗游戏",
  ["Proj.Android.TencentQQDT"]="QQ游戏大厅",
  ["Proj.Android.uc "]="UC",
  ["Proj.Android.Wdj"]="九游",
  ["Proj.AndroidStudio.Baidu"]="百度",
  ["Proj.AndroidStudio.Qihoo"]="360",
  ["Proj.AndroidStudio.T4399"]="4399",
}

for k,v in pairs(ProjectDirectoryToChineseCharactersMap) do
  print(k, v)
end