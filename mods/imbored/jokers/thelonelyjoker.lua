
SMODS.Joker{ --The Lonely Joker
    key = "thelonelyjoker",
    config = {
        extra = {
            checkchips = 20,
            checkmult = 10,
            chips0_min = -10,
            chips0_max = 10,
            xchips0_min = 0.1,
            xchips0_max = 1.5,
            mult0_min = -10,
            mult0_max = 10,
            xmult0_min = 0.1,
            xmult0_max = 1.5
        }
    },
    loc_txt = {
        ['name'] = 'The Lonely Joker',
        ['text'] = {
            [1] = 'When {C:red}alone{}, does {C:attention}random{}',
            [2] = 'effects for {X:black,C:green}STIM-U-LAT-ION.{}',
            [3] = 'When {C:green}with another{} joker,',
            [4] = 'shuffles all jokers and',
            [5] = 'swaps {C:blue}Chips{} and {C:red}Mult{}.'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 0,
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
    
    loc_vars = function(self, info_queue, card)
        
        return {vars = {card.ability.extra.checkchips, card.ability.extra.checkmult}}
    end,
    
    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.joker_main  then
            if to_big(#G.jokers.cards) == to_big(1) then
                return {
                    chips = pseudorandom('RANGE:-10|10', -10, 10),
                    extra = {
                        x_chips = pseudorandom('RANGE:0.1|1.5', 0.1, 1.5),
                        colour = G.C.DARK_EDITION,
                        extra = {
                            mult = pseudorandom('RANGE:-10|10', -10, 10),
                            extra = {
                                Xmult = pseudorandom('RANGE:0.1|1.5', 0.1, 1.5)
                            }
                        }
                    }
                }
            elseif to_big(#G.jokers.cards) > to_big(1) then
                if #G.jokers.cards > 1 then
                    G.jokers:unhighlight_all()
                    G.E_MANAGER:add_event(Event({
                        trigger = 'before',
                        func = function()
                            G.E_MANAGER:add_event(Event({
                                func = function()
                                    G.jokers:shuffle('aajk')
                                    play_sound('cardSlide1', 0.85)
                                    return true
                                end,
                            }))
                            delay(0.15)
                            G.E_MANAGER:add_event(Event({
                                func = function()
                                    G.jokers:shuffle('aajk')
                                    play_sound('cardSlide1', 1.15)
                                    return true
                                end
                            }))
                            delay(0.15)
                            G.E_MANAGER:add_event(Event({
                                func = function()
                                    G.jokers:shuffle('aajk')
                                    play_sound('cardSlide1', 1)
                                    return true
                                end
                            }))
                            delay(0.5)
                            return true
                        end
                    }))
                end
                return {
                    extra = {
                        message = "STIMULATION.",
                        colour = G.C.ORANGE,
                        extra = {
                            swap = true,
                            colour = G.C.CHIPS
                        }
                    }
                }
            end
        end
    end
}