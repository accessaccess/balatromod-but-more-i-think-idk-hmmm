
SMODS.Joker{ --RTX Joker
    key = "rtxjoker",
    config = {
        extra = {
            mult0 = 4
        }
    },
    loc_txt = {
        ['name'] = 'RTX Joker',
        ['text'] = {
            [1] = 'so cool',
            [2] = '{C:red}+4{} Mult',
            [3] = '{C:tarot}-4{} Integrity'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 6,
        y = 2
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
        if context.cardarea == G.jokers and context.joker_main  then
            return {
                mult = 4
            }
        end
    end
}