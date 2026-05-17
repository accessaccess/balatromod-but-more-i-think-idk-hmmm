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
SMODS.Shader = function(t) return t end
SMODS.Tag = function(t) return t end
SMODS.current_mod = { id = "imbored", path = "mods/imbored/", config = {}, save_mod_config = function() end, load_mod_config = function() end }

-- Stub probability helpers used by some jokers
SMODS.get_probability_vars = function(card, numerator, denominator, key)
    return numerator, denominator
end
SMODS.pseudorandom_probability = function(card, group, numerator, denominator, key, guaranteed)
    return pseudorandom(key) < (numerator / denominator)
end

-- Stub card-finding helpers used by some jokers at runtime
SMODS.find_card = function(key)
    if not (G and G.jokers and G.jokers.cards) then return {} end
    local result = {}
    for _, card in ipairs(G.jokers.cards) do
        if card.config and card.config.center and card.config.center.key == key then
            result[#result+1] = card
        end
    end
    return result
end

-- Stub effect helpers used by jokers with add_to_deck / calculate
SMODS.calculate_effect = function(effect, card) end
SMODS.change_play_limit = function(amount)
    if G and G.GAME and G.GAME.starting_params then
        G.GAME.starting_params.play_limit = (G.GAME.starting_params.play_limit or 5) + amount
        if G.hand then G.hand.config.card_limit = G.GAME.starting_params.play_limit end
    end
end
SMODS.add_card = function(args) return nil end

-- load_file: loads a Lua file relative to current_mod.path (for external mods)
SMODS.load_file = function(path)
    local full = (SMODS.current_mod.path or "") .. path
    local ok, chunk = pcall(love.filesystem.load, full)
    if ok and chunk then return chunk end
    return nil
end

function SMODS.Atlas(t)
    -- Support :register() chaining (some atlases call it)
    t.register = function(self) return self end
    t._mod_path = SMODS.current_mod and SMODS.current_mod.path or "mods/imbored/"
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
        local base = atlas._mod_path or "mods/imbored/"
        local path = base .. "assets/" .. scale_dir .. "/" .. atlas.path
        local ok, img = pcall(love.graphics.newImage, path, {mipmaps = true, dpiscale = scale})
        if ok and img then
            G.ASSET_ATLAS[key] = { name = key, image = img, px = atlas.px, py = atlas.py }
        end
    end

    -- Register jokers in G.P_CENTERS
    local order = 500
    for key, j in pairs(SMODS._jokers) do
        order = order + 1
        -- Clamp rarity to numeric 1-4 (custom string rarities map to common=1)
        local rarity = j.rarity
        if type(rarity) ~= 'number' or rarity < 1 or rarity > 4 then rarity = 1 end
        G.P_CENTERS[key] = {
            key = key,
            set = "Joker",
            name = (j.loc_txt and j.loc_txt.name) or key,
            cost = j.cost or 4,
            rarity = rarity,
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
        -- Add to pools so jokers appear in shop / rarity pools
        if G.P_CENTER_POOLS then
            local pool = G.P_CENTER_POOLS['Joker']
            if pool then
                local found = false
                for _, pc in ipairs(pool) do if pc.key == key then found = true; break end end
                if not found then pool[#pool+1] = G.P_CENTERS[key] end
            end
        end
        if G.P_JOKER_RARITY_POOLS then
            local rpool = G.P_JOKER_RARITY_POOLS[rarity]
            if rpool then
                local found = false
                for _, pc in ipairs(rpool) do if pc.key == key then found = true; break end end
                if not found then rpool[#rpool+1] = G.P_CENTERS[key] end
            end
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

-- Register jokers/atlases added by external mods (safe to call after _init)
function SMODS._register_new(mod_id, mod_path)
    if not (G and G.P_CENTERS) then return end
    local scale = (G.SETTINGS and G.SETTINGS.GRAPHICS and G.SETTINGS.GRAPHICS.texture_scaling) or 1
    local scale_dir = (scale == 2) and "2x" or "1x"
    -- Load any atlases not yet in G.ASSET_ATLAS
    for key, atlas in pairs(SMODS._atlases) do
        if G.ASSET_ATLAS and not G.ASSET_ATLAS[key] then
            local base = atlas._mod_path or mod_path or ""
            for _, p in ipairs({base.."assets/"..scale_dir.."/"..atlas.path, base..atlas.path}) do
                local ok, img = pcall(love.graphics.newImage, p, {mipmaps=true, dpiscale=scale})
                if ok and img then
                    G.ASSET_ATLAS[key] = {name=key, image=img, px=atlas.px, py=atlas.py}
                    break
                end
            end
        end
    end
    -- Register any jokers not yet in G.P_CENTERS
    local order = 600
    for key, j in pairs(SMODS._jokers) do
        if not G.P_CENTERS[key] then
            order = order + 1
            local rarity = j.rarity
            if type(rarity) ~= 'number' or rarity < 1 or rarity > 4 then rarity = 1 end
            G.P_CENTERS[key] = {
                key=key, set="Joker",
                name=(j.loc_txt and j.loc_txt.name) or key,
                cost=j.cost or 4, rarity=rarity,
                unlocked=(j.unlocked ~= false), start_alerted=true,
                discovered=(j.discovered ~= false), start_discovered=(j.discovered ~= false),
                blueprint_compat=(j.blueprint_compat ~= false),
                eternal_compat=(j.eternal_compat ~= false),
                perishable_compat=(j.perishable_compat ~= false),
                pos=j.pos or {x=0,y=0}, atlas=j.atlas,
                config=j.config or {}, effect="Mult", cost_mult=1.0, order=order,
            }
            if G.localization and G.localization.descriptions and G.localization.descriptions.Joker and j.loc_txt then
                G.localization.descriptions.Joker[key] = {name=j.loc_txt.name or key, text=j.loc_txt.text or {""}}
            end
            if G.P_CENTER_POOLS then
                local pool = G.P_CENTER_POOLS['Joker']
                if pool then pool[#pool+1] = G.P_CENTERS[key] end
            end
            if G.P_JOKER_RARITY_POOLS then
                local rpool = G.P_JOKER_RARITY_POOLS[rarity]
                if rpool then rpool[#rpool+1] = G.P_CENTERS[key] end
            end
        end
    end
end
