Class = require("class")
CardCollection = require("card_collection")

Graveyard = Class {
    __includes = CardCollection,
    init = function(self, x, y)
        CardCollection.init(self, x, y)
        self.width = 64
        self.height = 96
        self.image = love.graphics.newImage("res/stack.png")
        self.max_cards = 1024
    end,

    update = function(self, dt)
        for i, card in ipairs(self.cards) do
            card:update(dt)
            if card ~= selected_card then
                local target_x = self.x
                local target_y = self.y
                card.x = lerp(card.x, target_x, movement_lerp_factor * dt)
                card.y = lerp(card.y, target_y, movement_lerp_factor * dt)
            end
        end
    end,

    draw = function(self)
        love.graphics.draw(self.image, self.x, self.y, 0, 1, 1, self.image:getWidth()/2, self.image:getHeight()/2)
        for i, card in ipairs(self.cards) do
            card:draw()
        end
    end,
}

return Graveyard
