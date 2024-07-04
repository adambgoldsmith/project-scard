Class = require("class")
CardCollection = require("card_collection")

Stack = Class {
    __includes = CardCollection,
    init = function(self, x, y)
        CardCollection.init(self, x, y)
        self.width = 64
        self.height = 96
        self.image = love.graphics.newImage("res/stack.png")
        self.max_cards = 64
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

    click = function(self, x, y, button, istouch)
        if button == 1 then
            if x > self.x - self.width/2 and x < self.x + self.width/2 and y > self.y - self.height/2 and y < self.y + self.height/2 then
                if #self.cards > 0 then
                    local card = self.cards[#self.cards]
                    table.remove(self.cards, #self.cards)
                    return card
                end
            end
        end
    end,

    shuffle = function(self)
        for i = 1, #self.cards do
            local j = love.math.random(i, #self.cards)
            self.cards[i], self.cards[j] = self.cards[j], self.cards[i]
        end
    end,

    deal_card = function(self, hand, amount)
        for i = 1, amount do
            if #self.cards > 0 then
                local card = self.cards[#self.cards]
                -- change card collection remove method to the built-in table.remove like so:
                table.remove(self.cards, #self.cards)
                hand:add_card(card)
                if hand == p1.hand then
                    card:flip()
                end
            end
        end
    end
}

return Stack