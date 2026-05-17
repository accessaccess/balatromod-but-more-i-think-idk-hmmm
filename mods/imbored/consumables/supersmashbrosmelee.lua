
SMODS.Consumable {
    key = 'supersmashbrosmelee',
    set = 'coolswag',
    pos = { x = 1, y = 0 },
    config = { 
        extra = {
            odds = 2   
        } 
    },
    loc_txt = {
        name = 'Super Smash Bros. Melee',
        text = {
            [1] = '{C:green}1/2{} chance to spawn a {X:green,C:white}joker{}',
            [2] = 'from the mod this comes from.'
        }
    },
    cost = 3,
    unlocked = true,
    discovered = true,
    hidden = false,
    can_repeat_soul = false,
    atlas = 'CustomConsumables',
    use = function(self, card, area, copier)
        local used_card = copier or card
        if SMODS.pseudorandom_probability(card, 'group_0_a673e7e1', 1, card.ability.extra.odds, 'j_imbored_supersmashbrosmelee', false) then
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function()
                    play_sound('timpani')
                    if #G.jokers.cards + G.GAME.joker_buffer < G.jokers.config.card_limit then
                        G.GAME.joker_buffer = G.GAME.joker_buffer + 1
                        local new_joker = SMODS.add_card({ set = 'imbored_imbored_jokers' })
                        if new_joker then
                        end
                        G.GAME.joker_buffer = 0
                    end
                    used_card:juice_up(0.3, 0.5)
                    return true
                end
            }))
            delay(0.6)
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Success", colour = G.C.SECONDARY_SET.Tarot})
        end
    end,
    can_use = function(self, card)
        return true
    end
}