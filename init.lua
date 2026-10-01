local path = core.get_modpath(core.get_current_modname()) .. "/"
local S = core.get_translator and core.get_translator("tarot_redo")

tarot_redo = {
    image_w = 300,
    image_h = 527,
}

dofile(path .. "utils.lua")
dofile(path .. "dictionary.lua")
dofile(path .. "catalog.lua")
dofile(path .. "forms.lua")
dofile(path .. "placement.lua")
dofile(path .. "nodes.lua")
dofile(path .. "crafts.lua")

local function has_value(array, val)
    for index, value in ipairs(array) do
        if value == val then
            return true
        end
    end

    return false
end

local function randomize_cards(name)
    local number_of_cards = 78

    --randomize the seat
    local t = {}
    local i = 0
    for i = 1, number_of_cards do
        table.insert(t, i)
    end
    for i = 1, #t * 2 do
        local a = math.random(#t)
        local b = math.random(#t)
        t[a], t[b] = t[b], t[a]
    end

    --core.chat_send_all(dump(t))
    local player = core.get_player_by_name(name)
    local player_pos = player:get_pos()
    local x = math.floor(player_pos.x)
    local y = math.floor(player_pos.y)
    local z = math.floor(player_pos.z)

    -- Combine coordinates into a single seed value.
    local seed = (x * y) + (y * z) + (z * x)

    math.randomseed(seed * core.get_us_time())
    local seededRandomInt = math.random(1, number_of_cards) -- Random integer between 1 and 78
    local index = t[seededRandomInt]
    --core.chat_send_all(dump(t))
    return index
end

function tarot_redo.get_one_card(name, cards_to_ignore)
    cards_to_ignore = cards_to_ignore or {}
    local index = randomize_cards(name)
    while has_value(cards_to_ignore, index) do
        index = randomize_cards(name)
    end
    return index
end

core.register_chatcommand("tarot_ui", {
    description = S("Open the Tarot Book user interface."),
    func = function(name)
        local player = core.get_player_by_name(name)
        tarot_redo.open_main_ui(player)
    end
})
