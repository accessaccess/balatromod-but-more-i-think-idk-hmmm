
SMODS.Back {
    key = 'hey_look_its_a_joker_wow',
    pos = { x = 1, y = 0 },
    config = {
    },
    loc_txt = {
        name = 'HEY LOOK ITS A JOKER WOW',
        text = {
            [1] = 'I HAVE NEVER SEEN A JOKER BEFORE'
        },
    },
    unlocked = true,
    discovered = true,
    no_collection = false,
    atlas = 'CustomDecks',
    calculate = function(self, card, context)
        if context.setting_blind then
            G.E_MANAGER:add_event(Event({
                func = function()
                    play_sound('timpani')
                    local new_joker = SMODS.add_card({ set = 'Joker', key = 'j_joker' })
                    if new_joker then
                        new_joker:set_edition("e_foil", true)
                        new_joker:add_sticker('eternal', true)
                    end
                    return true
                end
            }))
        end
    end,
    apply = function(self, back)
        G.GAME.starting_params.joker_slots = G.GAME.starting_params.joker_slots - 5
    end
}