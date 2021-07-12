local type = _G.type;
local __Quaternion = {

}

function __Quaternion:onRecycle()
    self.x = 0;
    self.y = 0;
    self.z = 0;
    self.w = 1;
end

function __Quaternion:setElement(x, y, z, w)
    self.x = x or 0;
    self.y = y or 0;
    self.z = z or 0;
    self.w = w or 1;
end

function __Quaternion:setQuaternion(q)
    if type(q) ~= "table" or q.m_szClassName ~= self.m_szClassName then
        return
    end
    self.x = q.x;
    self.y = q.y;
    self.z = q.z;
    self.w = q.w;
end

function __Quaternion:addedWith(right)
    if type(right) =="number" then
        local result = Quaternion(self)
        -- translate
        result.x = result.x + right;
        result.y = result.y + right;
        result.z = result.z + right;
        result.w = result.w + right;
        return result;
    end
        
    if type(right) =="table" then
        if right.m_szClassName == self.m_szClassName then
            local result = Quaternion(self)
            -- addition
            result.x = result.x + right.x;
            result.y = result.y + right.y;
            result.z = result.z + right.z;
            result.w = result.w + right.w;
            return result;
        end
    end

    error(self.m_szClassName + "@" + tostring(self):sub(8) + " added with an invalid value : type(right) = " + type(right))
    print(debug.traceback());
end

function __Quaternion:subtractedFrom(right)
    if type(right) == "number" then
        -- translate
        local result = Quaternion(self)
        result.x = result.x - right;
        result.y = result.y - right;
        result.z = result.z - right;
        result.w = result.w - right;
        return result;
    end
        
    if type(right) == "table" then
        if right.m_szClassName == self.m_szClassName then
            -- subtraction
            local result = Quaternion(self)
            result.x = result.x - right.x;
            result.y = result.y - right.y;
            result.z = result.z - right.z;
            result.w = result.w - right.w;
            return result;
        end
    end

    error(self.m_szClassName + "@" + tostring(self):sub(8) + " subtracted from an invalid value : type(right) = " + type(right))
    print(debug.traceback());
end

function __Quaternion:multipliedBy(right)
    if type(right) =="number" then
        -- scale
        local result = Quaternion(self)
        result.x = result.x * right;
        result.y = result.y * right;
        result.z = result.z * right;
        result.w = result.w * right;
        return result;
    end
        
    if type(right) =="table" then
        if right.m_szClassName == self.m_szClassName then
            -- dot product
            local abs = self.x * right.x + self.y * right.y + self.z * right.z;
            return abs;
        end
    end

    error(self.m_szClassName + "@" + tostring(self):sub(8) + " multiplied by an invalid value : type(right) = " + type(right))
    print(debug.traceback());
end

function __Quaternion:dividedBy(right)
    if type(right) =="number" then
        -- scale
        local result = Quaternion(self)
        result.x = result.x / right;
        result.y = result.y / right;
        result.z = result.z / right;
        result.w = result.w / right;
        return result;
    end

    error(self.m_szClassName + "@" + tostring(self):sub(8) + " divided by an invalid value : type(right) = " + type(right))
    print(debug.traceback());
end

function __Quaternion:isEqualWith(right)
    if type(right) =="table" and right.m_szClassName == self.m_szClassName then
        return self.x == right.x and self.y == right.y and self.z == right.z and self.w == right.w;
    end

    print(self.m_szClassName + "@" + tostring(self):sub(8) + " equals with an invalid value : type(right) = " + type(right))
    print(debug.traceback());
    return false
end

function __Quaternion.__add(left, right)
    return left:addedWith(right);
end

function __Quaternion.__sub(left, right)
    return left:subtractedFrom(right);
end

function __Quaternion.__mul(left, right)
    return left:multipliedBy(right);
end

function __Quaternion.__div(left, right)
    return left:dividedBy(right);
end

function __Quaternion.__eq(left, right)
    return left:isEqualWith(right);
end

function __Quaternion:toString()
    return "(" + self.x + ", " + self.y + ", " + self.z + ", " + self.w + ")";
end

--------------------------------------------------------------------------------
_G.Quaternion = function(unknown, y, z, w)
    local q = ClassesCache:obtain("__Quaternion", __Quaternion);
    if unknown then
        if type(unknown) == "number" and y and z then
            local x = unknown
            q:setElement(x, y, z, w);
        elseif type(unknown) == "table" then
            local v0 = unknown
            q:setQuaternion(v0)
        end
    end
    return q;
end