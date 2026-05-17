
SMODS.Voucher {
    key = 'fuck_that_cloud',
    pos = { x = 0, y = 0 },
    config = { 
        extra = {
            winner_ante_value0 = 16
        } 
    },
    loc_txt = {
        name = 'fuck that cloud',
        text = {
            [1] = '',
            [2] = '{s:5}i hate that cloud{}'
        },
        unlock = {
            [1] = 'Unlocked by default.'
        }
    },
    cost = 10,
    unlocked = true,
    discovered = true,
    no_collection = false,
    can_repeat_soul = false,
    atlas = 'CustomVouchers',
    redeem = function(self, card)
        return {
            func = function()
                
                G.E_MANAGER:add_event(Event({
                    func = function()
                        G.GAME.win_ante = 16
                        return true
                    end
                }))
                return true
            end,
            message = "Winner Ante set to " .. 16 .. "!"
        }
    end
}