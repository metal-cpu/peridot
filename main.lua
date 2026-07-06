SMODS.Atlas({
    key = "modicon", 
    path = "ModIcon.png", 
    px = 34,
    py = 34,
    atlas_table = "ASSET_ATLAS"
})

SMODS.Atlas({
    key = "balatro", 
    path = "balatro.png", 
    px = 333,
    py = 216
})


SMODS.Atlas({
    key = "PeridotJokers", 
    path = "PeridotJokers.png", 
    px = 71,
    py = 95
})

assert(SMODS.load_file('src/peridotjokers.lua'))()
--assert(SMODS.load_file("src/sounds.lua"))()

SMODS.current_mod.optional_features = function()
    return {
        cardareas = {} 
    }
end
