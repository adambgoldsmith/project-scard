Class = require("class")

GameManager = Class {
    init = function(self)
        self.state = "duel"
        self.turn = 1
        self.phase = "draw"
        self.ability_input = false
    end,

    change_turn = function(self, new_turn)
        self.turn = new_turn
    end,
}

return GameManager