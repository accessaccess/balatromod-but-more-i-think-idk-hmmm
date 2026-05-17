
SMODS.Joker{ --PulseDog
    key = "pulsesog",
    config = {
        extra = {
            play_size_increase = '9999'
        }
    },
    loc_txt = {
        ['name'] = 'PulseDog',
        ['text'] = {
            [1] = 'My {C:gold}Glorious King{} Pulsedog',
            [2] = '{C:green}Disables{} the effect of any {C:red}Boss Blind{}',
            [3] = '{C:green}Any amount{} of {C:blue}cards{} can be played at a time',
            [4] = '{C:lightgrey}(this card was made out of a legal obligation){}'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 0,
        y = 0
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 16,
    rarity = 4,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',
    pools = { ["imbored_imbored_jokers"] = true },
    in_pool = function(self, args)
        return (
            not args 
            or args.source ~= 'sho' and args.source ~= 'jud' and args.source ~= 'sou' 
            or args.source == 'buf' or args.source == 'rif' or args.source == 'rta' or args.source == 'uta' or args.source == 'wra'
        )
        and true
    end,
    
    calculate = function(self, card, context)
        
        if G.GAME.blind and G.GAME.blind.boss and not G.GAME.blind.disabled then
            G.GAME.blind:disable()
            play_sound('timpani')
            SMODS.calculate_effect({ message = localize('ph_boss_disabled') }, card)
        end
    end,
    
    add_to_deck = function(self, card, from_debuff)
        card.ability.extra.original_play_size = G.GAME.starting_params.play_limit or 0
        local difference = 9999 - G.GAME.starting_params.play_limit
        SMODS.change_play_limit(difference)
        
        if G.GAME.blind and G.GAME.blind.boss and not G.GAME.blind.disabled then
            G.GAME.blind:disable()
            play_sound('timpani')
            SMODS.calculate_effect({ message = localize('ph_boss_disabled') }, card)
        end
        
    end,
    
    remove_from_deck = function(self, card, from_debuff)
        if card.ability.extra.original_play_size then
            local difference = card.ability.extra.original_play_size - G.GAME.starting_params.play_limit
            SMODS.change_play_limit(difference)
        end
    end
}