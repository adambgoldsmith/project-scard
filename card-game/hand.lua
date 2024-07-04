Class = require("class")
CardCollection = require("card_collection")

Hand = Class {
    __includes = CardCollection,
    init = function(self, x, y)
        CardCollection.init(self, x, y)
        self.max_cards = 10
        self.hovered_card = nil
    end,

    update = function(self, dt)
        self.hovered_card = nil
        for i, card in ipairs(self.cards) do
            card:update(dt)
            if card ~= selected_card then
                local middle_of_hand = #self.cards / 2
                local target_x = self.x + (i - middle_of_hand - 0.5) * 50
                local target_y = self.y + math.abs(i - middle_of_hand) * 10
                local target_rotation = (i - middle_of_hand - 0.5) * 0.1
                if card:is_mouse_over(love.mouse.getX(), love.mouse.getY()) and selected_card == nil then
                    target_y = target_y - 32
                    target_rotation = 0
                    self.hovered_card = card
                end
                card.x = lerp(card.x, target_x, movement_lerp_factor * dt)
                card.y = lerp(card.y, target_y, movement_lerp_factor * dt)
                card.rotation = lerp(card.rotation, target_rotation, movement_lerp_factor * dt)
            end
        end
    end,


    draw = function(self)
        for i, card in ipairs(self.cards) do
            card:draw()
        end
        if self.hovered_card then
            self.hovered_card:info_display()
        end
    end,
}

return Hand