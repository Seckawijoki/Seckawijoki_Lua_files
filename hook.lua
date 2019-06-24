do
    local intercepts = {}

    function intercept(f, on)
        local rv = intercepts[f]
        intercepts[f] = on
        return rv
    end

    local hookstack = {n = 0}

    local function callhook()
        local f = debug.getinfo(3, "f").func
        table.insert(hookstack, f)
        if intercepts[f] then doOnCall(f) end
    end

    local function rethook()
        local f = table.remove(hookstack)
        if intercepts[f] then doOnReturn(f) end
    end

    local case = {
        ["call"] = callhook,
        ["return"] = rethook,
        ["tail return"] = rethook
    }

    local function nothing() end

    local function myhook(what)
        (case[what] or nothing)()
    end

    debug.sethook(myhook, "cr")
end


function doOnCall(func) print "An intercepted call" end
function doOnReturn(func) print "An intercepted return" end

-- define doOnCall and doOnReturn to do whatever
-- to intercept a function:

function foo(a) print "foo" end
intercept(foo, true)

-- to intercept a function given its name (if it is a global)
a = "foo"
intercept(getfenv()[a], true)