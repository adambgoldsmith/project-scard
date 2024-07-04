Class = require("class")

CardCollection = Class {
    init = function(self, x, y)
        self.width = 0
        self.height = 0
        self.x = x
        self.y = y
        self.cards = {}
        self.max_cards = 0
    end,

    update = function(self, dt)
        for i, card in ipairs(self.cards) do
            card:update(dt)
        end
    end,

    draw = function(self)
        for i, card in ipairs(self.cards) do
            card:draw()
        end
    end,

    click = function(self, x, y, button, istouch)
        for i, card in ipairs(self.cards) do
            card:click(x, y, button, istouch)
        end
    end,

    release = function(self, x, y, button, istouch)
        for i, card in ipairs(self.cards) do
            card:release(x, y, button, istouch)
        end
    end,

    add_card = function(self, card)
        if #self.cards < self.max_cards then
            table.insert(self.cards, card)
        end
    end,

    remove_card = function(self, card)
        for i, c in ipairs(self.cards) do
            if c == card then
                table.remove(self.cards, i)
                break
            end
        end
    end,
}

return CardCollection