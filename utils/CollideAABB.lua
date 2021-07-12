local type = _G.type;
local __CollideAABB = {

}

function __CollideAABB:onRecycle()
    self.pos = Vector3();
    self.dim = Vector3();
end

function __CollideAABB:setElement(x, y, z, w)
    self.x = x or 0;
    self.y = y or 0;
    self.z = z or 0;
    self.w = w or 1;
end

function __CollideAABB:setCollideAABB(collideAABB)
    if type(collideAABB) ~= "table" or collideAABB.m_szClassName ~= self.m_szClassName then
        return
    end
    self.pos:setVector(collideAABB.pos);
    self.dim:setVector(collideAABB.dim);
end

function __CollideAABB:addedWith(right)
    local result = CollideAABB();
    result.pos = self.pos + right.pos;
    result.dim = self.dim + right.dim;
    return result;
end

function __CollideAABB:subtractedFrom(right)
    local result = CollideAABB();
    result.pos = self.pos - right.pos;
    result.dim = self.dim - right.dim;
    return 
end

function __CollideAABB:multipliedBy(right)
    if type(right) == "number" then
        -- scale
        local result = CollideAABB(self)
        result.pos = result.pos * right;
        result.dim = result.dim * right;
        return result;
    end

    error(self.m_szClassName + "@" + tostring(self):sub(8) + " multiplied by an invalid value : type(right) = " + type(right))
    print(debug.traceback());
end

function __CollideAABB:dividedBy(right)
    if type(right) == "number" then
        -- scale
        local result = CollideAABB(self)
        result.pos = result.pos / right;
        result.dim = result.dim / right;
        return result;
    end

    error(self.m_szClassName + "@" + tostring(self):sub(8) + " divided by an invalid value : type(right) = " + type(right))
    print(debug.traceback());
end

function __CollideAABB:isEqualWith(right)
    if type(right) == "table" then
        return self.pos == right.pos and self.dim == right.dim;
    end

    print(self.m_szClassName + "@" + tostring(self):sub(8) + " equals with an invalid value : type(right) = " + type(right))
    print(debug.traceback());
    return false
end

function __CollideAABB.__add(left, right)
    return left:addedWith(right);
end

function __CollideAABB.__sub(left, right)
    return left:subtractedFrom(right);
end

function __CollideAABB.__mul(left, right)
    return left:multipliedBy(right);
end

function __CollideAABB.__div(left, right)
    return left:dividedBy(right);
end

function __CollideAABB.__eq(left, right)
    return left:isEqualWith(right);
end

function __CollideAABB:toString()
    return "pos = " + self.pos + ", dim = " + self.dim;
end

--------------------------------------------------------------------------------
_G.CollideAABB = function(unknown)
    local collideAABB = ClassesCache:obtain("__CollideAABB", __CollideAABB);
    if unknown then
        if type(unknown) == "table" then
            local c0 = unknown
            collideAABB:setCollideAABB(c0)
        end
    end
    return collideAABB;
end