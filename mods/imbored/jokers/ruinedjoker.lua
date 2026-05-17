
SMODS.Joker{ --Ruined Joker
    key = "ruinedjoker",
    config = {
        extra = {
        }
    },
    loc_txt = {
        ['name'] = 'Ruined Joker',
        ['text'] = {
            [1] = 'Well, this is the last time I don\'t use a protector.',
            [2] = 'Adds a card protector to all cards in your played hand.'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 3,
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
        if context.individual and context.cardarea == G.play  then
            local scored_card = context.other_card
            G.E_MANAGER:add_event(Event({
                func = function()
                    scored_card:set_seal("imbored_cardprotector", true)
                    return true
                end
            }))
        end
    end
}