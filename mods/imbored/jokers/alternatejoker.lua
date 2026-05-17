
SMODS.Joker{ --Alternate Joker
    key = "alternatejoker",
    config = {
        extra = {
        }
    },
    loc_txt = {
        ['name'] = 'Alternate Joker',
        ['text'] = {
            [1] = '{C:green}Copies{} Joker to the right,',
            [2] = 'after hand is scored,',
            [3] = 'removes {C:green}copied{} joker.',
            [4] = 'There is not enough room for the two of us.',
            [5] = 'There is not enough room for the two of us.',
            [6] = 'There is not enough room for the two of us.',
            [7] = 'There is not enough room for the two of us.',
            [8] = 'There is not enough room for the two of us.',
            [9] = 'There is not enough room for the two of us.',
            [10] = 'There is not enough room for the two of us.',
            [11] = 'There is not enough room for the two of us.'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 4,
        y = 2
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 5,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',
    pools = { ["imbored_imbored_jokers"] = true },
    
    calculate = function(self, card, context)
        if context.after and context.cardarea == G.jokers  then
            return {
                func = function()
                    local my_pos = nil
                    for i = 1, #G.jokers.cards do
                        if G.jokers.cards[i] == card then
                            my_pos = i
                            break
                        end
                    end
                    local target_joker = nil
                    if my_pos and my_pos < #G.jokers.cards then
                        local joker = G.jokers.cards[my_pos + 1]
                        if not SMODS.is_eternal(joker) and not joker.getting_sliced then
                            target_joker = joker
                        end
                    end
                    
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
        
        local target_joker = nil
        
        local my_pos = nil
        for i = 1, #G.jokers.cards do
            if G.jokers.cards[i] == card then
                my_pos = i
                break
            end
        end
        target_joker = (my_pos and my_pos < #G.jokers.cards) and G.jokers.cards[my_pos + 1] or nil
        
        local ret = SMODS.blueprint_effect(card, target_joker, context)
        if ret then
            SMODS.calculate_effect(ret, card)
        end
    end
}