
SMODS.Joker{ --Blindfolded Joker
    key = "blindfoldedjoker",
    config = {
        extra = {
            SkippedIntoBoss = 1
        }
    },
    loc_txt = {
        ['name'] = 'Blindfolded Joker',
        ['text'] = {
            [1] = 'When {C:blue}Blind{} is {C:red}skipped{},',
            [2] = 'increments boss blind',
            [3] = 'multiplier downward,',
            [4] = 'currently,',
            [5] = '{X:black,C:red}X#1#{} Boss Blind Requirement',
            [6] = ''
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 2,
        y = 2
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
    pools = { ["imbored_imbored_jokers"] = true, ["imbored_suggestive"] = true },
    
    loc_vars = function(self, info_queue, card)
        
        return {vars = {card.ability.extra.SkippedIntoBoss}}
    end,
    
    calculate = function(self, card, context)
        if context.setting_blind  then
            if G.GAME.blind.boss then
                local SkippedIntoBoss_value = card.ability.extra.SkippedIntoBoss
                return {
                    
                    func = function()
                        if G.GAME.blind.in_blind then
                            
                            card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "X"..tostring(SkippedIntoBoss_value).." Blind Size", colour = G.C.GREEN})
                            G.GAME.blind.chips = G.GAME.blind.chips * SkippedIntoBoss_value
                            G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
                            G.HUD_blind:recalculate()
                            return true
                        end
                    end,
                    extra = {
                        func = function()
                            card.ability.extra.SkippedIntoBoss = 1
                            return true
                        end,
                        colour = G.C.BLUE
                    }
                }
            end
        end
        if context.skip_blind  then
            return {
                func = function()
                    card.ability.extra.SkippedIntoBoss = math.max(0, (card.ability.extra.SkippedIntoBoss) - 0.1)
                    return true
                end
            }
        end
    end
}