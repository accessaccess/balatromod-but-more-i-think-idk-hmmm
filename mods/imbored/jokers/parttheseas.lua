
SMODS.Joker{ --PART THE SEAS
    key = "parttheseas",
    config = {
        extra = {
            mult0 = 50
        }
    },
    loc_txt = {
        ['name'] = 'PART THE SEAS',
        ['text'] = {
            [1] = '{C:red}+50{} Mult whenever a Two Pair is played'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 1,
        y = 1
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
            if context.scoring_name == "Two Pair" then
                return {
                    mult = 50
                }
            end
        end
    end
}