
SMODS.Back {
    key = 'wega',
    pos = { x = 0, y = 0 },
    config = {
    },
    loc_txt = {
        name = 'wega',
        text = {
            [1] = 'wega'
        },
    },
    unlocked = true,
    discovered = true,
    no_collection = false,
    atlas = 'CustomDecks',
    calculate = function(self, card, context)
        if context.end_of_round and context.game_over == false and context.main_eval then
            for i = 1, 1 do
                G.E_MANAGER:add_event(Event({
                    func = function()
                        
                        play_sound('timpani')
                        SMODS.add_card({ set = 'coolswag', key = 'c_imbored_wegacard'
                        })
                        return true
                    end
                }))
            end
        end
        if context.setting_blind then
            for i = 1, 1 do
                G.E_MANAGER:add_event(Event({
                    func = function()
                        
                        play_sound('timpani')
                        SMODS.add_card({ set = 'coolswag', key = 'c_imbored_wegacard'
                        })
                        return true
                    end
                }))
            end
        end
        if context.skip_blind then
            for i = 1, 1 do
                G.E_MANAGER:add_event(Event({
                    func = function()
                        
                        play_sound('timpani')
                        SMODS.add_card({ set = 'coolswag', key = 'c_imbored_wegacard'
                        })
                        return true
                    end
                }))
            end
        end
        if context.end_of_round and context.main_eval and G.GAME.blind.boss then
            for i = 1, 1 do
                G.E_MANAGER:add_event(Event({
                    func = function()
                        
                        play_sound('timpani')
                        SMODS.add_card({ set = 'coolswag', key = 'c_imbored_wegacard'
                        })
                        return true
                    end
                }))
            end
        end
        if context.starting_shop then
            for i = 1, 1 do
                G.E_MANAGER:add_event(Event({
                    func = function()
                        
                        play_sound('timpani')
                        SMODS.add_card({ set = 'coolswag', key = 'c_imbored_wegacard'
                        })
                        return true
                    end
                }))
            end
        end
        if context.ending_shop then
            for i = 1, 1 do
                G.E_MANAGER:add_event(Event({
                    func = function()
                        
                        play_sound('timpani')
                        SMODS.add_card({ set = 'coolswag', key = 'c_imbored_wegacard'
                        })
                        return true
                    end
                }))
            end
        end
        if context.open_booster then
            for i = 1, 1 do
                G.E_MANAGER:add_event(Event({
                    func = function()
                        
                        play_sound('timpani')
                        SMODS.add_card({ set = 'coolswag', key = 'c_imbored_wegacard'
                        })
                        return true
                    end
                }))
            end
        end
        if context.skipping_booster then
            for i = 1, 1 do
                G.E_MANAGER:add_event(Event({
                    func = function()
                        
                        play_sound('timpani')
                        SMODS.add_card({ set = 'coolswag', key = 'c_imbored_wegacard'
                        })
                        return true
                    end
                }))
            end
        end
    end,
    apply = function(self, back)
        for i = 1, 1 do
            G.E_MANAGER:add_event(Event({
                func = function()
                    
                    play_sound('timpani')
                    SMODS.add_card({ set = 'coolswag', key = 'c_imbored_wegacard'
                    })
                    return true
                end
            }))
        end
    end
}