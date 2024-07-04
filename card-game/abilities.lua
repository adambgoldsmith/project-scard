-- Card Abilities
-- These are functions that get assigned to a cards ability property. They are called when the card is activated.

-- Fire Orb
-- Steal 1 coin from the opponent
function FireOrb()
    if game_manager.turn == 1 then
        if #p2.coin_pile.coins > 0 then
            p1.coin_pile:add_coin(p2.coin_pile.coins[1])
            p2.coin_pile:remove_coin(p2.coin_pile.coins[1])
        end
    else
        if #p1.coin_pile.coins > 0 then
            p2.coin_pile:add_coin(p1.coin_pile.coins[1])
            p1.coin_pile:remove_coin(p1.coin_pile.coins[1])
        end
    end
    ability_activating = false
end

-- Kleptomania
-- Steal 1 random card from the opponent's hand
function Kleptomania()
    if game_manager.turn == 1 then
        if #p2.hand.cards > 0 then
            local random_index = love.math.random(1, #p2.hand.cards)
            local card = p2.hand.cards[random_index]
            if card.hidden then
                card:flip()
            end
            p1.hand:add_card(card)
            p2.hand:remove_card(card)
        end
    else
        if #p1.hand.cards > 0 then
            local random_index = love.math.random(1, #p1.hand.cards)
            local card = p1.hand.cards[random_index]
            if card.hidden then
                card:flip()
            end
            p2.hand:add_card(card)
            p1.hand:remove_card(card)
        end
    end
    ability_activating = false
end

-- Grave Robber
-- Remove the top card from the graveyard and add it to your hand
function GraveRobber()
    if game_manager.turn == 1 then
        if #graveyard.cards > 0 then
            local card = graveyard.cards[#graveyard.cards]
            p1.hand:add_card(card)
            graveyard:remove_card(card)
        end
    else
        if #graveyard.cards > 0 then
            local card = graveyard.cards[#graveyard.cards]
            p2.hand:add_card(card)
            graveyard:remove_card(card)
        end
    end
    ability_activating = false
end

-- Sage Owl
-- Reveal up to 3 random cards from your opponent's hand
function SageOwl()
    local opponent_hand = game_manager.turn == 1 and p2.hand.cards or p1.hand.cards

    if #opponent_hand > 0 then
        local hidden_cards = {}
        for i, card in ipairs(opponent_hand) do
            if card.hidden then
                table.insert(hidden_cards, i)
            end
        end
        
        for i = 1, math.min(#hidden_cards, 3) do
            if #hidden_cards == 0 then
                break
            end
            local random_index = love.math.random(1, #hidden_cards)
            local card_index = hidden_cards[random_index]
            local card = opponent_hand[card_index]
            -- instead of flipping, there should be a cool x-ray effect
            card:flip()
            table.remove(hidden_cards, random_index)
        end
    end
    ability_activating = false
end

-- Crowned Emperor
-- Increase the cost of all cards in your opponents hand by 1.
function CrownedEmperor()
    if game_manager.turn == 1 then
        for i, card in ipairs(p2.hand.cards) do
            card.cost = card.cost + 1
        end
    else
        for i, card in ipairs(p1.hand.cards) do
            card.cost = card.cost + 1
        end
    end
    ability_activating = false
end

-- Envy
-- Select 1 card from your opponent's hand and 1 card from your hand. Swap them.
ENVY_TABLE = {}
function Envy()
    Timer.script(function(wait)
        if game_manager.turn == 1 then
            if #p2.hand.cards > 0 and #p1.hand.cards > 0 then
                game_manager:change_turn(3)
                ability_input_text = "Select a card from your hand and a card from your opponent's hand to swap."
                repeat
                    wait(0.1)
                until #ENVY_TABLE == 2
                ability_input_text = ""
                local p1_card = ENVY_TABLE[1]
                local p2_card = ENVY_TABLE[2]
                p1.hand:remove_card(p1_card)
                p2.hand:remove_card(p2_card)
                p1.hand:add_card(p2_card)
                p2.hand:add_card(p1_card)
                ENVY_TABLE = {}
                game_manager:change_turn(1)
            end
        else
            if #p1.hand.cards > 0 and #p2.hand.cards > 0 then
                game_manager:change_turn(3)
                repeat
                    wait(0.1)
                until #ENVY_TABLE == 2
                local p2_card = ENVY_TABLE[1]
                local p1_card = ENVY_TABLE[2]
                p2.hand:remove_card(p2_card)
                p1.hand:remove_card(p1_card)
                p2.hand:add_card(p1_card)
                p1.hand:add_card(p2_card)
                ENVY_TABLE = {}
                game_manager:change_turn(2)
            end
        end
        ability_activating = false
    end)
end 
   

return {
    FireOrb = FireOrb,
    Kleptomania = Kleptomania,
    GraveRobber = GraveRobber,
    SageOwl = SageOwl,
    CrownedEmperor = CrownedEmperor,
    Envy = Envy
}