
SMODS.Joker{ --the joker depicting the beach that makes you old that in itself may make you old
    key = "thejokerdepictingthebeachthatmakesyouoldthatinitselfmaymakeyouold",
    config = {
        extra = {
            xmult0 = 1.2
        }
    },
    loc_txt = {
        ['name'] = 'the joker depicting the beach that makes you old that in itself may make you old',
        ['text'] = {
            [1] = '{X:red,C:white}X1.2{} Mult whenever',
            [2] = 'a card is scored',
            [3] = 'makes you old'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 4,
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
    pools = { ["imbored_imbored_jokers"] = true },
    
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play  then
            return {
                Xmult = 1.2
            }
        end
    end
}
