Class = require("class")

Card = Class {
    init = function(self, img, x, y, cost, ability, hidden)
        self.name = "Card"
        self.x = x
        self.y = y
        self.width = 64
        self.height = 96
        self.rotation = 0
        self.x_offset = 0
        self.y_offset = 0
        self.image = img
        self.image_back = love.graphics.newImage("res/card_back.png")
        self.stack = nil
        self.cost = cost
        self.ability = ability

        self.hidden = hidden
        self.current_image = self.hidden and self.image_back or self.image
        self.flip_x_scale = 1
        self.is_flipping = false
    end,

    update = function(self, dt)
        if selected_card == self then
            local target_x = love.mouse.getX() + self.x_offset
            local target_y = love.mouse.getY() + self.y_offset
            -- Apply linear interpolation
            self.x = lerp(self.x, target_x, movement_lerp_factor * dt)
            self.y = lerp(self.y, target_y, movement_lerp_factor * dt)
            
            -- Calculate rotation angle based on mouse movement direction
            local current_mouse_x, _ = love.mouse.getPosition()
            local delta_mouse_x = current_mouse_x - previous_mouse_x
            
            -- Update rotation angle and return to zero based on distance from mouse
            local distance = get_distance_between_mouse_and_card(self.x, self.y, self.x_offset, self.y_offset)
            self.rotation = lerp(self.rotation + delta_mouse_x * math.rad(0.1), 0, distance / 1000)
            
            -- Constrain rotation within -max_rotation to max_rotation
            self.rotation = math.min(max_rotation, math.max(-max_rotation, self.rotation))
            
            previous_mouse_x = current_mouse_x
        end

        if self.is_flipping then
            self.flip_x_scale = lerp(self.flip_x_scale, 0, flip_lerp_factor * dt)
            if self.flip_x_scale < 0.01 then
                self:swap_image()
                self.flip_x_scale = 0
                self.is_flipping = false
            end
        else
            self.flip_x_scale = lerp(self.flip_x_scale, 1, flip_lerp_factor * dt)
        end
    end,

    draw = function(self)
        love.graphics.draw(self.current_image, self.x, self.y, self.rotation, self.flip_x_scale, 1, self.width/2, self.height/2)
    end,

    activate = function(self)
        if self.ability then
            self.ability(self)
        end
    end,

    is_mouse_over = function(self, x, y)
        return x > self.x - self.width/2 and x < self.x + self.width/2 and y > self.y - self.height/2 and y < self.y + self.height/2
    end,

    info_display = function(self)
        love.graphics.print(self.name, self.x - 64, self.y)
        love.graphics.print("Cost: " .. self.cost, self.x - 64, self.y + 16)
        -- love.graphics.print("Ability: " .. self.ability, self.x - 64, self.y + 32)
    end,

    click = function(self, x, y, button, istouch)
        if game_manager.turn == 1 and button == 1 and selected_card == nil and self:is_mouse_over(x, y) then
            selected_card = self
            self.x_offset = self.x - x
            self.y_offset = self.y - y
        end
        if game_manager.turn == 3 and button == 1 and self:is_mouse_over(x, y) then
            print("Clicked card during ability input")
            table.insert(ENVY_TABLE, self)
        end
    end,

    release = function(self, x, y, button, istouch)
        if button == 1 and selected_card == self then
            selected_card = nil
            self.x_offset = 0
            self.y_offset = 0
        end
    end,

    set_stack = function(self, stack)
        self.stack = stack
    end,

    flip = function(self)
        self.is_flipping = not self.is_flipping
        -- this may be a problem in the future
        self.hidden = not self.hidden
    end,

    swap_image = function(self)
        if self.current_image == self.image then
            self.current_image = self.image_back
        elseif self.current_image == self.image_back then
            self.current_image = self.image
        end
        self.is_image_swapped = true
    end,

    set_position = function(self, x, y)
        self.x = x
        self.y = y
    end,

    set_rotation = function(self, rotation)
        self.rotation = rotation
    end
}

return Card