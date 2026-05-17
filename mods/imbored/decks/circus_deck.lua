
SMODS.Back {
    key = 'circus_deck',
    pos = { x = 3, y = 0 },
    config = {
    },
    loc_txt = {
        name = 'Circus Deck',
        text = {
            [1] = 'Every card is a {C:attention}Circus{} card.'
        },
    },
    unlocked = true,
    discovered = true,
    no_collection = false,
    atlas = 'CustomDecks',
    apply = function(self, back)
        G.E_MANAGER:add_event(Event({
            func = function()
                for k, v in pairs(G.playing_cards) do
                    v:set_ability(G.P_CENTERS['m_imbored_circus'])
                end
                G.GAME.starting_deck_size = #G.playing_cards
                return true
            end
        }))
    end
}