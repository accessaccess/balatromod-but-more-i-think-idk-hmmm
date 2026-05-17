
SMODS.Voucher {
    key = 'you_shouldnt_have_bought_that_cloud_hater',
    pos = { x = 1, y = 0 },
    config = { 
        extra = {
            hands0 = 1,
            play_size0 = 1
        } 
    },
    loc_txt = {
        name = 'you shouldnt have bought that cloud hater',
        text = {
            [1] = '',
            [2] = '',
            [3] = '',
            [4] = '{s:11}dumbass{}',
            [5] = '',
            [6] = ''
        },
        unlock = {
            [1] = 'Unlocked by default.'
        }
    },
    cost = 1,
    unlocked = true,
    discovered = true,
    no_collection = false,
    can_repeat_soul = false,
    requires = {'fuck_that_cloud'},
    atlas = 'CustomVouchers',
    redeem = function(self, card)
        G.SETTINGS.GAMESPEED = 0.5
        G.GAME.round_resets.hands = 1
        ease_hands_played(1 - G.GAME.current_round.hands_left)
        return {
            
            G.E_MANAGER:add_event(Event({
                func = function()
                    
                    
                    local current_play_size = (G.GAME.starting_params.play_limit or 0)
                    local target_play_size = 1
                    local difference = target_play_size - current_play_size
                    SMODS.change_play_limit(difference)
                    return true
                end
            }))
        }
    end
}