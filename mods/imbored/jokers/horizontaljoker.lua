
SMODS.Joker{ --Horizontal Joker
    key = "horizontaljoker",
    config = {
        extra = {
            chips0 = 40
        }
    },
    loc_txt = {
        ['name'] = 'Horizontal Joker',
        ['text'] = {
            [1] = '{C:blue}+40{} Chips'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 5,
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
                chips = 40
            }
        end
    end
}