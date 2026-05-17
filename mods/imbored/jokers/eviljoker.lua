
SMODS.Joker{ --EVIL joker
    key = "eviljoker",
    config = {
        extra = {
            chips0 = 10,
            mult0 = 10
        }
    },
    loc_txt = {
        ['name'] = 'EVIL joker',
        ['text'] = {
            [1] = 'yah........ im like, {C:red}evil and fucked up{} like that'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 2,
        y = 0
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 14,
    rarity = 3,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',
    pools = { ["imbored_imbored_jokers"] = true },
    
    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.joker_main  then
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
            local target_joker = G.jokers.cards[1] or nil
            
            if target_joker and #G.jokers.cards + G.GAME.joker_buffer < G.jokers.config.card_limit then
                G.GAME.joker_buffer = G.GAME.joker_buffer + 1
                G.E_MANAGER:add_event(Event({
                    func = function()
                        local copied_joker = copy_card(target_joker, nil, nil, nil, target_joker.edition and target_joker.edition.negative)
                        
                        copied_joker:add_to_deck()
                        G.jokers:emplace(copied_joker)
                        G.GAME.joker_buffer = 0
                        return true
                    end
                }))
                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_duplicated_ex'), colour = G.C.GREEN})
            end
            return {
                message = "evil",
                extra = {
                    chips = 10,
                    colour = G.C.CHIPS,
                    extra = {
                        mult = 10
                    }
                }
            }
        end
    end
}