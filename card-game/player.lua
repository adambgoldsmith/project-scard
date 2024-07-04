Class = require("class")
Hand = require("hand")
Candles = require("candles")
PlayZone = require("play_zone")
CoinPile = require("coin_pile")

local positions = {
    {hand = {x = 400, y = 500}, 
    candles = {x = 75, y = 500}, 
    play_zone = {x = 175, y = 300}, 
    coin_pile = {x = 625, y = 500}},
    {hand = {x = 400, y = 100},
    candles = {x = 75, y = 0},
    play_zone = {x = 175, y = 100},
    coin_pile = {x = 625, y = 100}
    }
}

Player = Class {
    init = function(self, id)
        self.id = id
        self.hand = Hand(positions[id].hand.x, positions[id].hand.y)
        self.candles = Candles(positions[id].candles.x, positions[id].candles.y)
        self.play_zone = PlayZone(positions[id].play_zone.x, positions[id].play_zone.y)
        self.coin_pile = CoinPile(positions[id].coin_pile.x, positions[id].coin_pile.y)
        self.health = 100
    end,

    update = function(self, dt)
        self.hand:update(dt)
        self.play_zone:update(dt)
        self.coin_pile:update(dt)
    end,

    draw = function(self)
        self.hand:draw()
        self.candles:draw(self.health)
        self.play_zone:draw()
        self.coin_pile:draw()
    end,

    take_damage = function(self, damage)
        self.health = self.health - damage
    end
}

return Player