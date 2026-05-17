
SMODS.Joker{ --sowee
    key = "sowee",
    config = {
        extra = {
            discards0 = 1,
            hands0 = 1,
            ante_value0 = 8,
            dollars0 = 200,
            xmult0 = 0.9,
            odds = 2
        }
    },
    loc_txt = {
        ['name'] = 'sowee',
        ['text'] = {
            [1] = 'i so sowee'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 1,
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
    pools = { ["imbored_imbored_jokers"] = true, ["imbored_imbored_boosters"] = true },
    
    loc_vars = function(self, info_queue, card)
        
        local new_numerator, new_denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'j_imbored_sowee') 
        return {vars = {new_numerator, new_denominator}}
    end,
    
    calculate = function(self, card, context)
        if context.buying_card and context.card.config.center.key == self.key and context.cardarea == G.jokers  then
            return {
                
                func = function()
                    card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "Set to "..tostring(1).." Discards", colour = G.C.BLUE})
                    
                    G.GAME.round_resets.discards = 1
                    ease_discard(1 - G.GAME.current_round.discards_left)
                    
                    return true
                end,
                extra = {
                    
                    func = function()
                        card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "Set to "..tostring(1).." Hands", colour = G.C.BLUE})
                        
                        G.GAME.round_resets.hands = 1
                        ease_hands_played(1 - G.GAME.current_round.hands_left)
                        
                        return true
                    end,
                    colour = G.C.GREEN,
                    extra = {
                        
                        func = function()
                            
                            local mod = 8 - G.GAME.round_resets.ante
                            ease_ante(mod)
                            G.E_MANAGER:add_event(Event({
                                func = function()
                                    G.GAME.round_resets.blind_ante = 8
                                    return true
                                end,
                            }))
                            return true
                        end,
                        message = "Ante set to " .. 8 .. "!",
                        colour = G.C.YELLOW,
                        extra = {
                            
                            func = function()
                                
                                local current_dollars = G.GAME.dollars
                                local target_dollars = 200
                                local dollar_value = target_dollars - current_dollars
                                ease_dollars(dollar_value)
                                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "sowee", colour = G.C.MONEY})
                                return true
                            end,
                            colour = G.C.MONEY
                        }
                    }
                }
            }
        end
        if context.cardarea == G.jokers and context.joker_main  then
            if true then
                return {
                    Xmult = 0.9,
                    message = "sowee"
                    ,
                    func = function()
                        if SMODS.pseudorandom_probability(card, 'group_0_75bb4996', 1, card.ability.extra.odds, 'j_imbored_sowee', false) then
                            local created_joker = true
                            G.E_MANAGER:add_event(Event({
                                func = function()
                                    local joker_card = SMODS.add_card({ set = 'imbored_laughatyou' })
                                    if joker_card then
                                        
                                        
                                    end
                                    
                                    return true
                                end
                            }))
                            local created_joker = true
                            G.E_MANAGER:add_event(Event({
                                func = function()
                                    local joker_card = SMODS.add_card({ set = 'imbored_laughatyou' })
                                    if joker_card then
                                        
                                        
                                    end
                                    
                                    return true
                                end
                            }))
                            local created_joker = true
                            G.E_MANAGER:add_event(Event({
                                func = function()
                                    local joker_card = SMODS.add_card({ set = 'imbored_laughatyou' })
                                    if joker_card then
                                        
                                        
                                    end
                                    
                                    return true
                                end
                            }))
                            local created_joker = true
                            G.E_MANAGER:add_event(Event({
                                func = function()
                                    local joker_card = SMODS.add_card({ set = 'imbored_laughatyou' })
                                    if joker_card then
                                        
                                        
                                    end
                                    
                                    return true
                                end
                            }))
                            card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = created_joker and localize('k_plus_joker') or nil, colour = G.C.BLUE})
                            card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = created_joker and localize('k_plus_joker') or nil, colour = G.C.BLUE})
                            card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = created_joker and localize('k_plus_joker') or nil, colour = G.C.BLUE})
                            card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = created_joker and localize('k_plus_joker') or nil, colour = G.C.BLUE})
                        end
                        return true
                    end
                }
            end
        end
        if context.selling_self  then
            return {
                message = "sorry",
                extra = {
                    func = function()
                        
                        local created_joker = true
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                local joker_card = SMODS.add_card({ set = 'imbored_laughatyou' })
                                if joker_card then
                                    
                                    joker_card:add_sticker('eternal', true)
                                end
                                
                                return true
                            end
                        }))
                        
                        if created_joker then
                            card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_plus_joker'), colour = G.C.BLUE})
                        end
                        return true
                    end,
                    colour = G.C.BLUE
                }
            }
        end
    end,
    
    add_to_deck = function(self, card, from_debuff)
        -- Showman effect enabled (allow duplicate cards)
    end,
    
    remove_from_deck = function(self, card, from_debuff)
        -- Showman effect disabled
    end
}

local check_for_buy_space_ref = G.FUNCS.check_for_buy_space
G.FUNCS.check_for_buy_space = function(card)
    if card.config.center.key == "j_imbored_sowee" then -- ignore slot limit when bought
        return true
    end
    return check_for_buy_space_ref(card)
end

local can_select_card_ref = G.FUNCS.can_select_card
G.FUNCS.can_select_card = function(e)
    	if e.config.ref_table.config.center.key == "j_imbored_sowee" then
        		e.config.colour = G.C.GREEN
        		e.config.button = "use_card"
    	else
        		can_select_card_ref(e)
    	end
end


local smods_showman_ref = SMODS.showman
function SMODS.showman(card_key)
    if next(SMODS.find_card("j_imbored_sowee")) then
        return true
    end
    return smods_showman_ref(card_key)
end