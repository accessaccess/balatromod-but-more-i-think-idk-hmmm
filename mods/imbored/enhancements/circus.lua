
SMODS.Enhancement {
    key = 'circus',
    pos = { x = 0, y = 0 },
    loc_txt = {
        name = 'Circus',
        text = {
            [1] = 'If this card is played',
            [2] = 'and if your played hand',
            [3] = 'is your least played hand',
            [4] = 'and only your least played hand',
            [5] = '{C:green}Swap{} {C:blue}Chips{} and {C:red}Mult{}'
        }
    },
    atlas = 'CustomEnhancements',
    any_suit = true,
    replace_base_card = false,
    no_rank = false,
    no_suit = false,
    always_scores = false,
    unlocked = true,
    discovered = true,
    no_collection = false,
    weight = 5,
    calculate = function(self, card, context)
        if context.main_scoring and context.cardarea == G.play then
            return {
                swap = true,
                message = "SWAP!"
            }
        end
    end
}