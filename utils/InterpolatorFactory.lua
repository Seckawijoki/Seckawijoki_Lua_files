-------------------------LinearInterpolator-------------------------
local LinearInterpolator = {

}

function LinearInterpolator:getInterpolation(percentage)
    return percentage
end
-------------------------AccelerateDecelerateInterpolator-------------------------
local AccelerateDecelerateInterpolator = {
    funcCos = math.cos,
    PI = math.pi,
}
function AccelerateDecelerateInterpolator:getInterpolation(percentage)
    return self.funcCos((percentage + 1) * self.PI) / 2 + 0.5
end

---------------------------------------InterpolatorFactory---------------------------------------
local InterpolatorFactory = {

}
_G.InterpolatorFactory = InterpolatorFactory;

function InterpolatorFactory:newLinearInterpolator()
    return LinearInterpolator
end

function InterpolatorFactory:newAccelerateDecelerateInterpolator()
    return AccelerateDecelerateInterpolator
end