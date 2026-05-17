
SMODS.Joker{ --bullseye
    key = "bullseye",
    config = {
        extra = {
            dollars0 = 1,
            sell_value0 = 1,
            chips0 = -1,
            mult0 = 0.1
        }
    },
    loc_txt = {
        ['name'] = 'bullseye',
        ['text'] = {
            [1] = '{s:2}right in the middle{}',
            [2] = 'does a lot of things whenever a card is scored'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 8,
        y = 0
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 4,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',
    pools = { ["imbored_imbored_jokers"] = true },
    
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play  then
            local my_pos = nil
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] == card then
                    my_pos = i
                    break
                end
            end
            local target_card = G.jokers.cards[my_pos]
            target_card.ability.extra_value = (card.ability.extra_value or 0) + 1
            target_card:set_cost()
            return {
                
                func = function()
                    
                    local current_dollars = G.GAME.dollars
                    local target_dollars = G.GAME.dollars - 1
                    local dollar_value = target_dollars - current_dollars
                    ease_dollars(dollar_value)
                    card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "-"..tostring(1), colour = G.C.MONEY})
                    return true
                end,
                extra = {
                    message = "+"..tostring(1).." Sell Value",
                    colour = G.C.MONEY,
                    extra = {
                        chips = -1,
                        colour = G.C.CHIPS,
                        extra = {
                            mult = 0.1
                        }
                    }
                }
            }
        end
    end
}