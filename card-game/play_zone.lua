Class = require("class")
CardCollection = require("card_collection")

PlayZone = Class {
    __includes = CardCollection,
    init = function(self, x, y)
        CardCollection.init(self, x, y)
        self.width = 400
        self.height = 100
        self.max_cards = 64
    end,

    update = function(self, dt)
        for i, card in ipairs(self.cards) do
            card:update(dt)
            if card ~= selected_card then
                local middle_of_zone = #self.cards / 2
                local target_x = (self.x + self.width / 2) - (i - middle_of_zone - 0.5) * 70
                local target_y = self.y + self.height / 2
                card.x = lerp(card.x, target_x, movement_lerp_factor * dt)
                card.y = lerp(card.y, target_y, movement_lerp_factor * dt)
            end
        end
    end,

    draw = function(self)
        love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
        for i, card in ipairs(self.cards) do
            card:draw()
        end
    end,

    is_mouse_over = function(self, x, y)
        return x > self.x and x < self.x + self.width and y > self.y and y < self.y + self.height
    end,

    click = function(self, x, y, button, istouch)
        if button == 1 then
            if self:is_mouse_over(x, y) then
                if #self.cards > 0 then
                    local card = self.cards[#self.cards]
                    table.remove(self.cards, #self.cards)
                    return card
                end
            end
        end
    end,
}

return PlayZone