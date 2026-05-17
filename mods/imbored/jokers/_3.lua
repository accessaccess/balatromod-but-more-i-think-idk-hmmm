
SMODS.Joker{ --3
    key = "_3",
    config = {
        extra = {
            chips0 = 3
        }
    },
    loc_txt = {
        ['name'] = '3',
        ['text'] = {
            [1] = '{C:chips}+3{} Chips per hand'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 0,
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
    
    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.joker_main  then
            return {
                chips = 3,
                message = "3"
            }
        end
    end
}