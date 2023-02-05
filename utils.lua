function setup_instance(inst, class)
    assert(class ~= nil)
    setmetatable(inst, {__index = class})
end

function setup_class(name, super)
    if (super == nil) then
        super = Object
    end
    local template = _G[name]
    setmetatable(template, {__index = super})
    template.type = function(obj) return name end
end

function moved(pos, vel)
    res = {}
    for axis, speed in pairs(vel) do
        res[axis] = pos[axis] + speed
    end
    return res
end

function shallowcopy(tab)
    res = {}
    for k, v in pairs(tab) do
        res[k] = v
    end
    return res
end

function remove_value(list, value_to_remove)
    local i = get_key(list, value_to_remove)
    if i ~= nil then
        table.remove(list, i)
    end
end

function get_key(tab, value)
    for k,v in pairs(tab) do
        if v == value then
            return k
        end
    end
    return nil
end

function round(num)
    return math.floor(num + 0.5)
end

function draw_centred_text(text, x, y, color)
    color = color or {1, 1, 1}
    x = x - font:getWidth(text) / 2
    love.graphics.print({color, text}, x, y)
end

function reverse(x)
    local rev = {}
    for i=#x, 1, -1 do
        rev[#rev+1] = x[i]
    end
    return rev
end