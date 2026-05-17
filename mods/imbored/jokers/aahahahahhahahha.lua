
SMODS.Joker{ --AAHAHAHAHHAHAHHA
    key = "aahahahahhahahha",
    config = {
        extra = {
            xchips0 = 0.5,
            xmult0 = 0.5,
            odds = 40
        }
    },
    loc_txt = {
        ['name'] = 'AAHAHAHAHHAHAHHA',
        ['text'] = {
            [1] = 'fuck you hahahahahhahahaahhahahaha'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 5,
        y = 0
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = -50,
    rarity = "imbored_creation_of_madness",
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',
    pools = { ["imbored_laughatyou"] = true },
    in_pool = function(self, args)
        return (
            not args 
            or args.source ~= 'sho' and args.source ~= 'buf' and args.source ~= 'jud' 
            or args.source == 'rif' or args.source == 'rta' or args.source == 'sou' or args.source == 'uta' or args.source == 'wra'
        )
        and true
    end,
    
    loc_vars = function(self, info_queue, card)
        
        local new_numerator, new_denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'j_imbored_aahahahahhahahha') 
        return {vars = {new_numerator, new_denominator}}
    end,
    
    set_ability = function(self, card, initial)
        card:set_eternal(true)
    end,
    
    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.joker_main  then
            if true then
                return {
                    x_chips = 0.5,
                    extra = {
                        Xmult = 0.5
                    }
                    ,
                    func = function()
                        if SMODS.pseudorandom_probability(card, 'group_0_2ccf9002', 1, card.ability.extra.odds, 'j_imbored_aahahahahhahahha', false) then
                            error("EasternFarmer Was Here")
                            
                        end
                        return true
                    end
                }
            end
        end
    end
}

local check_for_buy_space_ref = G.FUNCS.check_for_buy_space
G.FUNCS.check_for_buy_space = function(card)
    if card.config.center.key == "j_imbored_aahahahahhahahha" then -- ignore slot limit when bought
        return true
    end
    return check_for_buy_space_ref(card)
end

local can_select_card_ref = G.FUNCS.can_select_card
G.FUNCS.can_select_card = function(e)
    	if e.config.ref_table.config.center.key == "j_imbored_aahahahahhahahha" then
        		e.config.colour = G.C.GREEN
        		e.config.button = "use_card"
    	else
        		can_select_card_ref(e)
    	end
end