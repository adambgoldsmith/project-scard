math.randomseed(os.time())

selected_card = nil
movement_lerp_factor = 5  -- Adjust this value to control the speed of movement interpolation
flip_lerp_factor = 15  -- Adjust this value to control the speed of card flipping interpolation
max_rotation = math.rad(45)  -- Maximum rotation angle in radians
previous_mouse_x = 0  -- Store previous mouse x position
ability_input_text = ""  -- Store ability input text
ability_activating = false  -- Store whether an ability is currently activating

function love.load()
    -- window size
    love.window.setMode(800, 600)

    bg_floor_boards = love.graphics.newImage("res/bg_floor_boards.png")
    bg_table = love.graphics.newImage("res/bg_table2.png")

    Timer = require("timer")
    GameManager = require("game_manager")
    Player = require("player")
    Button = require("button")
    Stack = require("stack")
    Graveyard = require("graveyard")
    Hand = require("hand")
    Candles = require("candles")
    PlayZone = require("play_zone")
    Card = require("card")
    CoinPile = require("coin_pile")
    Coin = require("coin")
    Abilities = require("abilities")

    game_manager = GameManager()

    stack = Stack(125, 350)
    for i = 1, 5 do
        stack:add_card(Card(love.graphics.newImage("res/fire_orb.png"), 125, 300, 0, Abilities.FireOrb, true))
        stack:add_card(Card(love.graphics.newImage("res/earth_orb.png"), 125, 300, 1, Abilities.Kleptomania, true))
        stack:add_card(Card(love.graphics.newImage("res/water_orb.png"), 125, 300, 2, Abilities.SageOwl, true))
        stack:add_card(Card(love.graphics.newImage("res/blood_orb.png"), 125, 300, 3, Abilities.Envy, true))
        stack:add_card(Card(love.graphics.newImage("res/reaper.png"), 125, 300, 3, Abilities.GraveRobber, true))
    end
    graveyard = Graveyard(125, 200)

    p1 = Player(1)
    p2 = Player(2)

    distribution_pile = CoinPile(625, 300)
    for i = 1, 20 do
        distribution_pile:add_coin(Coin(625, 300, math.random(0, 360)))
    end
end

function love.update(dt)
    Timer.update(dt)

    stack:update(dt)
    graveyard:update(dt)

    p1:update(dt)
    p2:update(dt)

    distribution_pile:update(dt)

    if selected_card == nil then
        previous_mouse_x = love.mouse.getX()
    end
end


function love.draw()
    love.graphics.setDefaultFilter("nearest", "nearest", 1)
    love.graphics.draw(bg_floor_boards, 0, 0)
    love.graphics.draw(bg_table, 0, 0, 0, 1, 1)

    stack:draw()
    graveyard:draw()

    if game_manager.turn == 3 then
        love.graphics.print(ability_input_text, 300, 300)
    end

    p1:draw()
    p2:draw()

    distribution_pile:draw()
end

function love.mousepressed(x, y, button, istouch)
    if game_manager.turn == 1 then
        p1.hand:click(x, y, button, istouch)

        local stack_card = stack:click(x, y, button, istouch)
        if stack_card then
            p1.hand:add_card(stack_card)
        end

        local play_zone_card = p1.play_zone:click(x, y, button, istouch)
        if play_zone_card then
            p1.hand:add_card(play_zone_card)
            for i = 0, play_zone_card.cost - 1 do
                p1.coin_pile:add_coin(distribution_pile.coins[1])
                distribution_pile:remove_coin(distribution_pile.coins[1])
            end
        end
    end

    if game_manager.turn == 3 then
        p1.hand:click(x, y, button, istouch)
        p2.hand:click(x, y, button, istouch)
    end
end
    
function love.mousereleased(x, y, button, istouch)
    if selected_card and p1.play_zone:is_mouse_over(x, y) then
        if #p1.coin_pile.coins >= selected_card.cost then
            p1.play_zone:add_card(selected_card)
            p1.hand:remove_card(selected_card)
            for i = 1, selected_card.cost do
                distribution_pile:add_coin(p1.coin_pile.coins[1])
                p1.coin_pile:remove_coin(p1.coin_pile.coins[1])
            end
            selected_card = nil
        end
    end

    p1.hand:release(x, y, button, istouch) -- Does this need to be here?
end

function love.keypressed(key, scancode, isrepeat)
    -- temporary key to end player one's turn
    if key == "space" then
        Timer.script(function(wait)
            for i, card in ipairs(p1.play_zone.cards) do
                ability_activating = true
                card:activate()
                repeat
                    wait(0.1)
                until not ability_activating
                wait(2)
            end
            for i = 1, #p1.play_zone.cards do
                graveyard:add_card(p1.play_zone.cards[1])
                p1.play_zone:remove_card(p1.play_zone.cards[1])
                wait(0.25)
            end
            wait(1)
            for i, coin in ipairs(distribution_pile.coins) do
                p2.coin_pile:add_coin(coin)
            end
            distribution_pile.coins = {}
            wait(1)
            -- this should happen at the start of the next turn
            stack:deal_card(p1.hand, 1)
            game_manager:change_turn(2)
            simulate_p2_turn()
        end)
    end
    -- temporary key to start the game
    if key == "d" then
        stack:shuffle()
        distribute_coins()
        distribute_cards()
    end
    -- temporary key to switch turns
    if key == "t" then
        if game_manager.turn == 1 then
            game_manager:change_turn(2)
            simulate_p2_turn()
        else
            game_manager:change_turn(1)
        end
    end
end

function lerp(a, b, t)
    return a + (b - a) * t
end

function get_distance_between_mouse_and_card(x, y, x_offset, y_offset)
    return math.sqrt(((x - x_offset) - love.mouse.getX())^2 + ((y - y_offset) - love.mouse.getY())^2)
end

function distribute_coins()
    local count = #distribution_pile.coins
    Timer.every(0.1, function()
        if #distribution_pile.coins > 0 then
            if #distribution_pile.coins % 2 == 0 then
                p1.coin_pile:add_coin(distribution_pile.coins[1])
            else
                p2.coin_pile:add_coin(distribution_pile.coins[1])
            end
            distribution_pile:remove_coin(distribution_pile.coins[1])
        end
    end, count)
end

function distribute_cards()
    local count = 10
    Timer.every(0.25, function()
        if #stack.cards > 0 then
            if #stack.cards % 2 == 0 then
                p1.hand:add_card(stack.cards[1])
                stack.cards[1]:flip()
            else
                p2.hand:add_card(stack.cards[1])
            end
            stack:remove_card(stack.cards[1])
        end
    end, count)
end

function simulate_p2_turn()
    Timer.script(function(wait)
        wait(2)
        print("simulating p2's turn")
        -- pick several random cards from p2's hand and play them
        for i = 1, math.random(1, 3) do
            local card_count = #p2.hand.cards
            local card = p2.hand.cards[math.random(1, card_count)]
            if #p2.coin_pile.coins >= card.cost then
                p2.play_zone:add_card(card)
                p2.hand:remove_card(card)
                if card.hidden then
                    card:flip()
                end
                for i = 1, card.cost do
                    distribution_pile:add_coin(p2.coin_pile.coins[1])
                    p2.coin_pile:remove_coin(p2.coin_pile.coins[1])
                end
            end
        end
        wait(1)
        -- end p2's turn
        for i, card in ipairs(p2.play_zone.cards) do
            card:activate()
            wait(2)
        end
        for i = 1, #p2.play_zone.cards do
            graveyard:add_card(p2.play_zone.cards[1])
            p2.play_zone:remove_card(p2.play_zone.cards[1])
            wait(0.25)
        end
        wait(1)
        for i, coin in ipairs(distribution_pile.coins) do
            p1.coin_pile:add_coin(coin)
        end
        distribution_pile.coins = {}
        wait(1)
        -- this should happen at the start of the next turn
        stack:deal_card(p2.hand, 1)
        game_manager:change_turn(1)
    end)
end