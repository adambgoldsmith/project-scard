Class = require("class")

Candles = Class {
    init = function(self, x, y)
        self.x = x
        self.y = y
        self.width = 64
        self.height = 96
        self.image = love.graphics.newImage("res/candle.png")
    end,

    update = function(self, dt)
        
    end,

    draw = function(self)
        for i = 1, 3 do
            love.graphics.draw(self.image, self.x + (i - 1) * 32, self.y)
        end
    end,
}

return Candles