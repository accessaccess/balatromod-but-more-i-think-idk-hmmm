
SMODS.Joker{ --who farted
    key = "whofarted",
    config = {
        extra = {
            odds = 8
        }
    },
    loc_txt = {
        ['name'] = 'who farted',
        ['text'] = {
            [1] = 'i can smell you'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 9,
        y = 1
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
    
    loc_vars = function(self, info_queue, card)
        
        local new_numerator, new_denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'j_imbored_whofarted') 
        return {vars = {new_numerator, new_denominator}}
    end,
    
    calculate = function(self, card, context)
        if context.destroy_card and context.destroy_card.should_destroy  then
            return { remove = true }
        end
        if context.individual and context.cardarea == G.play  then
            context.other_card.should_destroy = false
            if true then
                return {
                    message = "sniff"
                    ,
                    func = function()
                        if SMODS.pseudorandom_probability(card, 'group_0_3b97e572', 1, card.ability.extra.odds, 'j_imbored_whofarted', false) then
                            context.other_card.should_destroy = true
                            card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "YOU.", colour = G.C.RED})
                        end
                        return true
                    end
                }
            end
        end
    end
}