local S = minetest.get_translator and minetest.get_translator("tarot")

core.register_tool("tarot:deck", {
	description = S("A Rider Waite Tarot deck"),
	inventory_image = "card_ico.png",
	stack_max=1,
	on_use = function(itemstack, player, pointed_thing)
		if not player then
			return
		end

        local name = player:get_player_name()
        if name then tarot.select_reading(name) end

	end,

	sound = {breaks = "default_tool_breaks"},
})

--
-- crafting
--

minetest.register_craft({
    output = "tarot:deck",
    recipe = {
	    {"default:paper", "dye:blue", "dye:violet"},
	    {"dye:yellow", "default:paper", "dye:black"},
        {"dye:red", "dye:green", "default:paper"},
    }
})



