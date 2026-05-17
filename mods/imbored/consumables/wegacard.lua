
SMODS.Consumable {
    key = 'wegacard',
    set = 'coolswag',
    pos = { x = 0, y = 0 },
    config = { 
        extra = {
            discard_size0 = 1,
            discards0 = 1   
        } 
    },
    loc_txt = {
        name = 'wega (card)',
        text = {
            [1] = 'wega'
        }
    },
    cost = 0,
    unlocked = true,
    discovered = true,
    hidden = false,
    can_repeat_soul = false,
    atlas = 'CustomConsumables',
    use = function(self, card, area, copier)
        local used_card = copier or card
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                card_eval_status_text(used_card, 'extra', nil, nil, nil, {message = "+"..tostring(1).." Discard Size", colour = G.C.BLUE})
                
                SMODS.change_discard_limit(1)
                return true
            end
        }))
        delay(0.6)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            
            func = function()
                card_eval_status_text(used_card, 'extra', nil, nil, nil, {message = "-"..tostring(1).." Discards", colour = G.C.RED})
                
                G.GAME.round_resets.discards = G.GAME.round_resets.discards - 1
                ease_discard(-1)
                
                return true
            end
        }))
        delay(0.6)
    end,
    can_use = function(self, card)
        return true
    end
}