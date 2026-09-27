local S = core.get_translator and core.get_translator("tarot_redo")

core.register_tool("tarot_redo:deck", {
	description = S("A Rider Waite Tarot deck"),
	inventory_image = "tarot_redo_card_ico.png",
	stack_max=1,
	on_use = function(itemstack, player, pointed_thing)
		if not player then
			return
		end

        local name = player:get_player_name()
        if name then tarot_redo.select_reading(name) end

	end,

	sound = {breaks = "default_tool_breaks"},
})

--
-- crafting
--

core.register_craft({
    output = "tarot_redo:deck",
    recipe = {
        {"dye:red", "dye:green", "default:paper"},
	    {"dye:yellow", "default:paper", "dye:black"},
	    {"default:paper", "dye:blue", "dye:violet"},
    }
})



