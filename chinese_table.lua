ns_ma = {
    ["运营活动"] = {
        ["爱心公益"] = {
    
        },
    
        ["植树节"] = {
    
        },
    },
}

for k, v in pairs(ns_ma["运营活动"]) do 
    print(k, v);
end

print(ns_ma["运营活动"]["爱心公益"]);
print(ns_ma["运营活动"]["植树节"]);