-- Minimal SMODS stub for Android (no lovely/native required)
SMODS = SMODS or {}
SMODS._jokers = {}   -- keyed by full key "j_imbored_X"
SMODS._atlases = {}  -- keyed by atlas key
SMODS._initialized = false

-- Stub no-ops for types we don't implement yet
SMODS.ObjectType = function(t) return t end
SMODS.Rarity = function(t) return t end
SMODS.Consumable = function(t) return t end
SMODS.ConsumableType = function(t) return t end
SMODS.Back = function(t) return t end
SMODS.Edition = function(t) return t end
SMODS.Enhancement = function(t) return t end
SMODS.Seal = function(t) return t end
SMODS.Voucher = function(t) return t end
SMODS.Booster = function(t) return t end
SMODS.Challenge = function(t) return t end
SMODS.Stake = function(t) return t end
SMODS.Sound = function(t) return t end
SMODS.current_mod = { config = {}, save_mod_config = function() end, load_mod_config = function() end }

-- Stub probability helpers used by some jokers
SMODS.get_probability_vars = function(card, numerator, denominator, key)
    return numerator, denominator
end
SMODS.pseudorandom_probability = function(card, group, numerator, denominator, key, guaranteed)
    return pseudorandom(key) < (numerator / denominator)
end

function SMODS.Atlas(t)
    -- Support :register() chaining (some atlases call it)
    t.register = function(self) return self end
    SMODS._atlases[t.key] = t
    return t
end

function SMODS.Joker(t)
    local full_key = "j_imbored_" .. t.key
    t._full_key = full_key
    SMODS._jokers[full_key] = t
    return t
end

function SMODS._init()
    if SMODS._initialized then return end
    SMODS._initialized = true

    -- Load atlases into G.ASSET_ATLAS
    local scale = (G.SETTINGS and G.SETTINGS.GRAPHICS and G.SETTINGS.GRAPHICS.texture_scaling) or 1
    local scale_dir = (scale == 2) and "2x" or "1x"
    for key, atlas in pairs(SMODS._atlases) do
        local path = "mods/imbored/assets/" .. scale_dir .. "/" .. atlas.path
        local ok, img = pcall(love.graphics.newImage, path, {mipmaps = true, dpiscale = scale})
        if ok and img then
            G.ASSET_ATLAS[key] = { name = key, image = img, px = atlas.px, py = atlas.py }
        end
    end

    -- Register jokers in G.P_CENTERS
    local order = 500
    for key, j in pairs(SMODS._jokers) do
        order = order + 1
        G.P_CENTERS[key] = {
            key = key,
            set = "Joker",
            name = (j.loc_txt and j.loc_txt.name) or key,
            cost = j.cost or 4,
            rarity = j.rarity or 1,
            unlocked = (j.unlocked ~= false),
            start_alerted = true,
            discovered = (j.discovered ~= false),
            start_discovered = (j.discovered ~= false),
            blueprint_compat = (j.blueprint_compat ~= false),
            eternal_compat = (j.eternal_compat ~= false),
            perishable_compat = (j.perishable_compat ~= false),
            pos = j.pos or {x=0, y=0},
            atlas = j.atlas,
            config = j.config or {},
            effect = "Mult",
            cost_mult = 1.0,
            order = order,
        }
        -- Localization
        if G.localization and G.localization.descriptions and G.localization.descriptions.Joker and j.loc_txt then
            G.localization.descriptions.Joker[key] = {
                name = j.loc_txt.name or key,
                text = j.loc_txt.text or {""}
            }
        end
    end

    -- Patch Card:calculate_joker to dispatch to SMODS jokers
    local _orig = Card.calculate_joker
    function Card:calculate_joker(context)
        local ckey = self.config and self.config.center and self.config.center.key
        if ckey and SMODS._jokers[ckey] then
            local jdef = SMODS._jokers[ckey]
            if jdef.calculate then
                local ok, ret = pcall(jdef.calculate, jdef, self, context)
                if ok and ret then
                    if type(ret) == "table" and ret.func then
                        pcall(ret.func)
                        return nil
                    end
                    return ret
                end
            end
            return nil
        end
        return _orig(self, context)
    end
end
