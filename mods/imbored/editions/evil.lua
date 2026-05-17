
SMODS.Shader({ key = 'agressivelyred', path = 'agressivelyred.fs' })

SMODS.Edition {
    key = 'evil',
    shader = 'agressivelyred',
    in_shop = false,
    weight = 3.5,
    extra_cost = 5,
    apply_to_float = false,
    badge_colour = HEX('FF0000'),
    sound = { sound = "gong", per = 1.2, vol = 0.4 },
    disable_shadow = false,
    disable_base_shader = false,
    loc_txt = {
        name = 'evil',
        label = 'evil',
        text = {
            [1] = 'supa {C:red}evil{} no good'
        }
    },
    unlocked = true,
    discovered = true,
    no_collection = false,
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    calculate = function(self, card, context)
        if context.pre_joker or (context.main_scoring and context.cardarea == G.play) then
            return {
                chips = -20,
                extra = {
                    mult = 2
                }
            }
        end
    end
}