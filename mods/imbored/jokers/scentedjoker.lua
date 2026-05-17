
SMODS.Joker{ --Scented Joker
    key = "scentedjoker",
    config = {
        extra = {
            jokercount = 0,
            xmult0 = 3
        }
    },
    loc_txt = {
        ['name'] = 'Scented Joker',
        ['text'] = {
            [1] = 'A revolution in joker technol.....',
            [2] = 'Who took a bite?!',
            [3] = '{C:blue}+#1#{} Chips, scales with jokers owned',
            [4] = 'If the card resembling Jimbo is owned,',
            [5] = '{X:mult,C:white}x3{} Mult'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 2,
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
        
        return {vars = {(#(G.jokers and (G.jokers and G.jokers.cards or {}) or {})) * 10}}
    end,
    
    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.joker_main  then
            if (function()
                for i, v in pairs(G.jokers.cards) do
                    if v.config.center.key == "j_joker" then 
                        return true
                    end
                end
            end)() then
                return {
                    Xmult = 3
                }
            else
                return {
                    chips = (#(G.jokers and G.jokers.cards or {})) * 10
                }
            end
        end
    end
}