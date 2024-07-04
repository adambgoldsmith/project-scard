Class = require("class")
Coin = require("coin")

CoinPile = Class {
    init = function(self, x, y)
        self.x = x
        self.y = y
        self.width = 96
        self.height = 96
        self.coins = {}
    end,

    update = function(self, dt)
        for i, coin in ipairs(self.coins) do
            local target_x = self.x + coin.random_x * 96
            local target_y = self.y + coin.random_y * 96
            coin.x = lerp(coin.x, target_x, movement_lerp_factor * dt)
            coin.y = lerp(coin.y, target_y, movement_lerp_factor * dt)
        end
    end,

    draw = function(self)
        for i, coin in ipairs(self.coins) do
            coin:draw()
        end
    end,

    click = function(self, x, y, button, istouch)
        if button == 1 then
            if x > self.x - self.width/2 and x < self.x + self.width/2 and y > self.y - self.height/2 and y < self.y + self.height/2 then
                print("Coin pile clicked")
            end
        end
    end,

    add_coin = function(self, new_coin)
        table.insert(self.coins, new_coin)
    end,

    remove_coin = function(self, coin)
        for i, c in ipairs(self.coins) do
            if c == coin then
                table.remove(self.coins, i)
                break
            end
        end
    end,
}

return CoinPile