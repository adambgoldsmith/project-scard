Class = require("class")

Button = Class {
    init = function(self, img, x, y, width, height)
        self.x = x
        self.y = y
        self.width = width
        self.height = height
        self.image = img
    end,

    update = function(self, dt)
        
    end,

    draw = function(self)
        love.graphics.draw(self.image, self.x, self.y, 0, 1, 1, self.width / 2, self.height / 2)
    end,

    click = function(self, x, y, button, istouch)
        if button == 1 then
            if x > self.x - self.width/2 and x < self.x + self.width/2 and y > self.y - self.height/2 and y < self.y + self.height/2 then
                print("Button clicked")
            end
        end
    end,
}

return Button