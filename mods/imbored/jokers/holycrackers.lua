
SMODS.Joker{ --holy crackers
    key = "holycrackers",
    config = {
        extra = {
        }
    },
    loc_txt = {
        ['name'] = 'holy crackers',
        ['text'] = {
            [1] = 'does {s:2,C:green}something{}'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 6,
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
        if context.cardarea == G.jokers and context.joker_main  then
            if context.scoring_name == "Three of a Kind" then
                if G.GAME.blind and G.GAME.blind.boss and not G.GAME.blind.disabled then
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            G.GAME.blind:disable()
                            play_sound('timpani')
                            return true
                        end
                    }))
                    card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "holy crackers", colour = G.C.GREEN})
                end
            end
        end
    end
}