function create(name, id)
    local obj = {
        SetName = nil, 
        GetName = nil,
        SetId = nil,
        GetId = nil,
        GetId2 = nil,
        
        name = name,
        id = id,
        SetName = function(self, name)
            self.name = name
        end,
        GetName = function(self)
            return self.name
        end,
        SetId = function(self, id)
            self.id = id
        end,
        GetId = function(self)
            return self.id
        end,
        GetId2 = function(self)
            return self:GetId()
        end,
    }
    return obj
end

o1 = create("Sam", 001)
o2 = create("Bob", 007)
o1:SetId(100)
print("o1's id:", o1:GetId(), "o2's id:",
	o2:GetId())
o2:SetName("Lucy")
print("o1's name:", o1:GetName(),
    "o2's name:", o2:GetName())
    
print(o2:GetId2())