
SMODS.Joker{ --Melted Joker
    key = "meltedjoker",
    config = {
        extra = {
            xmult0 = 1.2
        }
    },
    loc_txt = {
        ['name'] = 'Melted Joker',
        ['text'] = {
            [1] = '{E:1}glurrg.....{}',
            [2] = '{X:red,C:white}X1.2{} Mult'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 7,
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
        if context.cardarea == G.jokers and context.joker_main  then
            return {
                Xmult = 1.2
            }
        end
    end
}