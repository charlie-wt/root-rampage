require "sprite"
require "utils"
require "roots.node"

TreeSpot = {
    RADIUS = 16,
    TIME = 5,
    TOOLTIP = "Grow tree",

    SPRITES = sprite.make_set("assets/tree/", { "tree 1.png", "tree 2.png", "tree 3.png" }),

    GROW_DURATION = 2,
    WITHER_DURATION = 1,

    x = nil,
    y = nil,
    node = nil,
    roots = nil,
    t_grown = never,
    t_cut = never,
}
setup_class("TreeSpot")

function TreeSpot.new(x, y)
    local obj = {}
    setup_instance(obj, TreeSpot)
    assert(x ~= nil)
    assert(y ~= nil)

    obj.x = x
    obj.y = y

    return obj
end

function TreeSpot:create_node(parent)
    assert(self.node == nil)
    self.node = Node.new(self.x, self.y, parent, self.roots)
    self.node.is_tree = true
    return self.node
end

function TreeSpot:update(dt)
    if self.node ~= nil and self.node.is_dead then
        self.node = nil
        self.t_grown = never
        self.t_cut = t
    end

    if self.node ~= nil and self.t_grown == never then
        self.t_grown = t
        self.t_cut = never
    end

    if self.roots.prospective.selection ~= nil and
           self.roots.prospective.message == nil and
           (self.x - self.roots.prospective.mouse_x) ^ 2 + (self.y - self.roots.prospective.mouse_y) ^ 2 < TreeSpot.RADIUS ^ 2 then
        self.roots.prospective.message = TreeSpot.TOOLTIP
    end
end

function TreeSpot:age()
    if self.t_grown == never then
        return 0
    end
    return t - self.t_grown
end

function TreeSpot:since_cut()
    if self.t_cut == never then
        return 0
    end
    return t - self.t_cut
end

function TreeSpot:sprite()
    if self.node ~= nil and self.t_grown ~= never then
        return sprite.sequence(TreeSpot.SPRITES, TreeSpot.GROW_DURATION, self.t_grown)
    end

    if self.t_cut ~= never and self:since_cut() < TreeSpot.WITHER_DURATION then
        return sprite.sequence(reverse(TreeSpot.SPRITES), TreeSpot.WITHER_DURATION, self.t_cut)
    end

    return nil
end

function TreeSpot:draw()
    love.graphics.setLineWidth(1)
    love.graphics.setColor({0.2, 0.4, 0, 0.2})
    love.graphics.circle("line", self.x, self.y, TreeSpot.RADIUS)

    local sprite = self:sprite()
    if sprite == nil then
        -- once we have a 'not-yet-grown-patch' sprite, this should never happen
        love.graphics.setColor({0.2, 0.4, 0, 1})
        love.graphics.circle("fill", self.x, self.y, TreeSpot.RADIUS * 0.5)
        return
    end

    local ox = sprite:getWidth() / 2
    local oy = sprite:getHeight() / 2

    -- want to draw the sprite slightly above centre, since the 'ground' bit is near
    -- the bottom
    oy = oy + 5

    love.graphics.setColor({1, 1, 1, 1})
    love.graphics.draw(sprite, self.x, self.y, 0, 1, 1, ox, oy)
end