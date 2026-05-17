SMODS.Rarity {
    key = "creation_of_madness",
    pools = {
        ["Joker"] = true
    },
    default_weight = 0,
    badge_colour = HEX('350000'),
    loc_txt = {
        name = "CREATION OF MADNESS"
    },
    get_weight = function(self, weight, object_type)
        return weight
    end,
}