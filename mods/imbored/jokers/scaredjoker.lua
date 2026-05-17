
SMODS.Joker{ --Scared Joker
    key = "scaredjoker",
    config = {
        extra = {
            xmult0 = 1.5
        }
    },
    loc_txt = {
        ['name'] = 'Scared Joker',
        ['text'] = {
            [1] = 'If another Joker triggers,',
            [2] = '{C:red}self destructs{}.',
            [3] = 'Otherwise, {X:red,C:white}X1.5{} Mult'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 3,
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
    
    calculate = function(self, card, context)
        if context.post_trigger  then
            if to_big(#G.jokers.cards) > to_big(1) then
                return {
                    func = function()
                        local target_joker = card
                        
                        if target_joker then
                            target_joker.getting_sliced = true
                            G.E_MANAGER:add_event(Event({
                                func = function()
                                    target_joker:start_dissolve({G.C.RED}, nil, 1.6)
                                    return true
                                end
                            }))
                            card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "Destroyed!", colour = G.C.RED})
                        end
                        return true
                    end
                }
            end
        end
        if context.cardarea == G.jokers and context.joker_main  then
            if to_big(#G.jokers.cards) == to_big(1) then
                return {
                    Xmult = 1.5
                }
            end
        end
    end
}