Class = require("class")

Coin = Class {
    init = function(self, x, y, rotation)
        self.x = x
        self.y = y
        self.width = 32
        self.height = 32
        self.img = love.graphics.newImage("res/coin.png")
        self.rotation = rotation
        self.random_x = math.random()
        self.random_y = math.random()
    end,

    draw = function(self)
        love.graphics.draw(self.img, self.x, self.y, self.rotation, 1, 1, self.width/2, self.height/2)
    end,

    click = function(self, x, y, button, istouch)
        if button == 1 then
            if x > self.x - self.width/2 and x < self.x + self.width/2 and y > self.y - self.height/2 and y < self.y + self.height/2 then
                print("Coin clicked")
            end
        end
    end,

    set_position = function(self, x, y)
        self.x = x
        self.y = y
    end,

    set_rotation = function(self, rotation)
        self.rotation = rotation
    end
}

return Coin