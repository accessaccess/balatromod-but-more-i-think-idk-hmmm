
SMODS.Joker{ --fish
    key = "fish",
    config = {
        extra = {
        }
    },
    loc_txt = {
        ['name'] = 'fish',
        ['text'] = {
            [1] = 'does {s:3,C:green}almost{} nothing'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 3,
        y = 0
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 1,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',
    pools = { ["imbored_imbored_jokers"] = true },
    
    calculate = function(self, card, context)
        if context.post_trigger  then
            if to_big(#G.jokers.cards) == to_big(2) then
                return {
                    func = function()
                        local target_joker = G.jokers.cards[2] or nil
                        
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
                        return true
                    end
                }
            end
        end
    end
}