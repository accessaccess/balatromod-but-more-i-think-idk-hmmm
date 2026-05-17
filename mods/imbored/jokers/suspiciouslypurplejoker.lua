
SMODS.Joker{ --Suspiciously Purple Joker
    key = "suspiciouslypurplejoker",
    config = {
        extra = {
            sell_value0 = 1,
            odds = 8
        }
    },
    loc_txt = {
        ['name'] = 'Suspiciously Purple Joker',
        ['text'] = {
            [1] = 'When {C:blue}hand{} is played,',
            [2] = 'add {C:money}$1{} of sell value.',
            [3] = '{C:green}1/8{} chance for something.'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 5,
        y = 2
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 4,
    rarity = 1,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',
    pools = { ["imbored_imbored_jokers"] = true },
    
    loc_vars = function(self, info_queue, card)
        
        local new_numerator, new_denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'j_imbored_suspiciouslypurplejoker') 
        return {vars = {new_numerator, new_denominator}}
    end,
    
    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.joker_main  then
            if true then
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
                    message = "+"..tostring(1).." Sell Value"
                    ,
                    func = function()
                        if SMODS.pseudorandom_probability(card, 'group_0_a1f5e33f', 1, card.ability.extra.odds, 'j_imbored_suspiciouslypurplejoker', false) then
                            card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "Something.", colour = G.C.WHITE})
                        end
                        return true
                    end
                }
            end
        end
    end
}