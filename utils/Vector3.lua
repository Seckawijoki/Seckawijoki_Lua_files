local type = _G.type;
local __Vector3 = {

}

function __Vector3:onRecycle()
    self.x = 0;
    self.y = 0;
    self.z = 0;
end

function __Vector3:setElement(x, y, z)
    self.x = x or 0;
    self.y = y or 0;
    self.z = z or 0;
end

function __Vector3:setVector(v)
    if type(v) ~= "table" or v.m_szClassName ~= self.m_szClassName then
        return
    end
    self.x = v.x;
    self.y = v.y;
    self.z = v.z;
end

function __Vector3:addedWith(right)
    if type(right) == "number" then
        local result = Vector3(self)
        -- translate
        result.x = result.x + right;
        result.y = result.y + right;
        result.z = result.z + right;
        return result;
    end
        
    if type(right) == "table" then
        if right.m_szClassName == self.m_szClassName then
            local result = Vector3(self)
            -- addition
            result.x = result.x + right.x;
            result.y = result.y + right.y;
            result.z = result.z + right.z;
            return result;
        end
    end

    error(self.m_szClassName + "@" + tostring(self):sub(8) + " added with an invalid value : type(right) = " + type(right))
    print(debug.traceback());
end

function __Vector3:subtractedFrom(right)
    if type(right) == "number" then
        -- translate
        local result = Vector3(self)
        result.x = result.x - right;
        result.y = result.y - right;
        result.z = result.z - right;
        return result;
    end
        
    if type(right) == "table" then
        if right.m_szClassName == self.m_szClassName then
            -- subtraction
            local result = Vector3(self)
            result.x = result.x - right.x;
            result.y = result.y - right.y;
            result.z = result.z - right.z;
            return result;
        end
    end

    error(self.m_szClassName + "@" + tostring(self):sub(8) + " subtracted from an invalid value : type(right) = " + type(right))
    print(debug.traceback());
end

function __Vector3:multipliedBy(right)
    if type(right) == "number" then
        -- scale
        local result = Vector3(self)
        result.x = result.x * right;
        result.y = result.y * right;
        result.z = result.z * right;
        return result;
    end
        
    if type(right) == "table" then
        if right.m_szClassName == self.m_szClassName then
            -- dot product
            local abs = self.x * right.x + self.y * right.y + self.z * right.z;
            return abs;
        end
    end

    error(self.m_szClassName + "@" + tostring(self):sub(8) + " multiplied by an invalid value : type(right) = " + type(right))
    print(debug.traceback());
end

function __Vector3:dividedBy(right)
    if type(right) == "number" then
        -- scale
        local result = Vector3(self)
        result.x = result.x / right;
        result.y = result.y / right;
        result.z = result.z / right;
        return result;
    end

    error(self.m_szClassName + "@" + tostring(self):sub(8) + " divided by an invalid value : type(right) = " + type(right))
    print(debug.traceback());
end

function __Vector3:isEqualWith(right)
    if type(right) == "table" and right.m_szClassName == self.m_szClassName then
        return self.x == right.x and self.y == right.y and self.z == right.z;
    end

    print(self.m_szClassName + "@" + tostring(self):sub(8) + " equals with an invalid value : type(right) = " + type(right))
    print(debug.traceback());
    return false
end

function __Vector3.__add(left, right)
    return left:addedWith(right);
end

function __Vector3.__sub(left, right)
    return left:subtractedFrom(right);
end

function __Vector3.__mul(left, right)
    return left:multipliedBy(right);
end

function __Vector3.__div(left, right)
    return left:dividedBy(right);
end

function __Vector3.__eq(left, right)
    return left:isEqualWith(right);
end

function __Vector3:toString()
    return "(" + self.x + ", " + self.y + ", " + self.z + ")";
end

--------------------------------------------------------------------------------
function Vector3(unknown, y, z)
    local v = ClassesCache:obtain("__Vector3", __Vector3);
    if unknown then
        if type(unknown) == "number" and y and z then
            local x = unknown
            v:setElement(x, y, z);
        elseif type(unknown) == "table" then
            local v0 = unknown
            v:setVector(v0)
        end
    end
    return v;
end