
SMODS.Seal {
    key = 'cardprotector',
    pos = { x = 0, y = 0 },
    config = {
        extra = {
            cardsinhand = 0,
            dollars0 = 2
        }
    },
    badge_colour = HEX('FF6B6B'),
    loc_txt = {
        name = 'Card Protector',
        label = 'Card Protector',
        text = {
            [1] = '{C:red}Discarding{} this card',
            [2] = 'will cause it to lose',
            [3] = '{C:money}$2{} of market value.',
            [4] = 'If this card is held in hand,',
            [5] = 'get {C:blue}+10{} Chips multiplied by',
            [6] = 'the amount of cards in hand,',
            [7] = 'to your current scoring hand.'
        }
    },
    atlas = 'CustomSeals',
    unlocked = true,
    discovered = true,
    no_collection = false,
    sound = { sound = "crumple2", per = 1.2, vol = 0.6 },
    loc_vars = function(self, info_queue, card)
        return {vars = {((#(G.hand and G.hand.cards or {}) or 0)) * 10}}
    end,
    calculate = function(self, card, context)
        if context.discard and context.other_card == card then
            return {
                
                func = function()
                    
                    local current_dollars = G.GAME.dollars
                    local target_dollars = G.GAME.dollars - 2
                    local dollar_value = target_dollars - current_dollars
                    ease_dollars(dollar_value)
                    card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Last Value!", colour = G.C.MONEY})
                    return true
                end
            }
        end
        if context.cardarea == G.hand and context.main_scoring then
            return {
                chips = (#(G.hand and G.hand.cards or {})) * 10
            }
        end
    end
}