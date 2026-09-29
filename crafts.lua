local S = core.get_translator and core.get_translator("tarot_redo")

core.register_tool("tarot_redo:deck", {
	description = S("A Rider Waite Tarot deck"),
	inventory_image = "tarot_redo_card_ico.png",
	stack_max = 1,
	on_use = function(itemstack, player, pointed_thing)
		if not player then
			return
		end

		local name = player:get_player_name()
		if name then tarot_redo.open_main_ui(player) end
	end,

	sound = { breaks = "default_tool_breaks" },
})

core.register_craftitem("tarot_redo:tarot_card", {
	description = S("A Tarot Card"),
	inventory_image = "tarot_redo_card_ico.png",
	stack_max = #tarot_redo.deck, -- We all know how many cards a Tarot deck has. :)
	on_place = function(itemstack, player, pointed_thing)
		local random_ordinal = math.random(#tarot_redo.deck)
		local card = tarot_redo.deck[random_ordinal]
		local fakestack = ItemStack(tarot_redo.card_to_node_name(card))
		local result = core.item_place(fakestack, player, pointed_thing)
		if result and result:is_empty() then
			itemstack:take_item()
		end

		return itemstack
	end,
})

--
-- crafting
--

core.register_craft({
	output = "tarot_redo:tarot_card 78",
	recipe = {
		{ "dye:red",       "dye:green",     "default:paper" },
		{ "dye:yellow",    "default:paper", "dye:black" },
		{ "default:paper", "dye:blue",      "dye:violet" },
	}
})
