
SMODS.Back {
    key = 'i_think_its_antimatter_deck',
    pos = { x = 2, y = 0 },
    config = {
    },
    loc_txt = {
        name = 'i think its antimatter deck?',
        text = {
            [1] = 'I honestly {C:red}cant{} tell',
            [2] = 'creates a {X:purple,C:white}modded{} consumable, or maybe joker sometimes i think?',
            [3] = 'is that what it does in cryptid?'
        },
    },
    unlocked = true,
    discovered = true,
    no_collection = false,
    atlas = 'CustomDecks',
    calculate = function(self, card, context)
        if context.setting_blind then
            if (to_big(#G.playing_cards) >= to_big(52) and to_big(G.GAME.dollars) >= to_big(0) and to_big(G.hand.config.card_limit) >= to_big(8)) then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('timpani')
                        if #G.jokers.cards + G.GAME.joker_buffer < G.jokers.config.card_limit then
                            G.GAME.joker_buffer = G.GAME.joker_buffer + 1
                            local new_joker = SMODS.add_card({ set = 'imbored_imbored_jokers' })
                            if new_joker then
                            end
                            G.GAME.joker_buffer = 0
                        end
                        return true
                    end
                }))
            end
        end
    end,
    
}