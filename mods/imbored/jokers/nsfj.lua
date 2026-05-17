
SMODS.Joker{ --NSFJ
    key = "nsfj",
    config = {
        extra = {
        }
    },
    loc_txt = {
        ['name'] = 'NSFJ',
        ['text'] = {
            [1] = 'When a hand is played,',
            [2] = '{C:green}creates{} a random {C:tarot}suggestive{} joker.'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 6,
        y = 1
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 6,
    rarity = 3,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',
    pools = { ["imbored_imbored_jokers"] = true, ["imbored_suggestive"] = true },
    
    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.joker_main  then
            local created_joker = false
            if #G.jokers.cards + G.GAME.joker_buffer < G.jokers.config.card_limit then
                created_joker = true
                G.GAME.joker_buffer = G.GAME.joker_buffer + 1
                G.E_MANAGER:add_event(Event({
                    func = function()
                        local joker_card = SMODS.add_card({ set = 'imbored_suggestive' })
                        if joker_card then
                            
                            
                        end
                        G.GAME.joker_buffer = 0
                        return true
                    end
                }))
            end
            return {
                message = created_joker and localize('k_plus_joker') or nil
            }
        end
    end
}