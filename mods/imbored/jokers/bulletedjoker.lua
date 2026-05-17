
SMODS.Joker{ --Bulleted Joker
    key = "bulletedjoker",
    config = {
        extra = {
            BulletedMult = 2,
            odds = 2,
            xmult0 = 2
        }
    },
    loc_txt = {
        ['name'] = 'Bulleted Joker',
        ['text'] = {
            [1] = 'Oh No! He\'s been Bulleted!',
            [2] = '{C:green}1/2{} Chance for {X:black,C:red}X2{} Blind Requirement',
            [3] = '{C:green}1/2{} Chance for {X:red,C:white}2X{} Mult'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 7,
        y = 1
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 4,
    rarity = 1,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',
    pools = { ["imbored_imbored_jokers"] = true },
    
    loc_vars = function(self, info_queue, card)
        
        local new_numerator, new_denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'j_imbored_bulletedjoker') 
        return {vars = {card.ability.extra.BulletedMult, new_numerator, new_denominator}}
    end,
    
    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.joker_main  then
            if true then
                card.ability.extra.BulletedMult = 2
                if SMODS.pseudorandom_probability(card, 'group_0_3638f8ed', 1, card.ability.extra.odds, 'j_imbored_bulletedjoker', false) then
                    card.ability.extra.BulletedMult = 1
                    SMODS.calculate_effect({Xmult = 2}, card)
                end
            end
        end
        if context.pseudorandom_result  then
            if (context.identifier == "j_imbored_bulletedjoker" and not context.result) then
                return {
                    
                    func = function()
                        if G.GAME.blind.in_blind then
                            
                            card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "X"..tostring(card.ability.extra.BulletedMult).." Blind Size", colour = G.C.GREEN})
                            G.GAME.blind.chips = G.GAME.blind.chips * card.ability.extra.BulletedMult
                            G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
                            G.HUD_blind:recalculate()
                            return true
                        end
                    end
                }
            end
        end
    end
}