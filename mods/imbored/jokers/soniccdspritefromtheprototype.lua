
SMODS.Joker{ --sonic cd sprite from the prototype
    key = "soniccdspritefromtheprototype",
    config = {
        extra = {
            source_rank_type = 'face_cards',
            source_ranks = '{}',
            target_rank = '"A"',
            hands_change = '1',
            discards_change = '1'
        }
    },
    loc_txt = {
        ['name'] = 'sonic cd sprite from the prototype',
        ['text'] = {
            [1] = '',
            [2] = '{s:5}You say!{}',
            [3] = '',
            [4] = '',
            [5] = 'makes all face cards considered an ace'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 9,
        y = 0
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
    pools = { ["imbored_imbored_jokers"] = true },
    
    calculate = function(self, card, context)
    end,
    
    add_to_deck = function(self, card, from_debuff)
        -- Combine ranks effect enabled
        card.ability.extra.original_hands = G.GAME.round_resets.hands
        G.GAME.round_resets.hands = 1
        card.ability.extra.original_discards = G.GAME.round_resets.discards
        G.GAME.round_resets.discards = 1
    end,
    
    remove_from_deck = function(self, card, from_debuff)
        -- Combine ranks effect disabled
        if card.ability.extra.original_hands then
            G.GAME.round_resets.hands = card.ability.extra.original_hands
        end
        if card.ability.extra.original_discards then
            G.GAME.round_resets.discards = card.ability.extra.original_discards
        end
    end
}


local card_get_id_ref = Card.get_id
function Card:get_id()
    local original_id = card_get_id_ref(self)
    if not original_id then return original_id end

    if next(SMODS.find_card("j_imbored_soniccdspritefromtheprototype")) then
        if original_id >= 11 and original_id <= 13 then return 14 end
    end
    return original_id
end
