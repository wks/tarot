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
	description = S("Tarot Card"),
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

	on_use = function(itemstack, player, pointed_thing)
		if pointed_thing.type ~= "node" then return end

		local under = pointed_thing.under
		local node = core.get_node(under)

		if core.get_item_group(node.name, "tarot_card") > 0 then
			-- Collect the Tarot card node into the inventory
			-- as a non-node tarot_card item.
			local new_stack = ItemStack(itemstack:get_name())
			local inv = player:get_inventory()
			if inv:room_for_item("main", new_stack) then
				inv:add_item("main", new_stack)
				core.remove_node(under)
			else
				core.chat_send_player(player:get_player_name(), "Inventory full.")
			end

			-- Don't return itemstack.
			-- New items may have been added to is by add_item.
			-- Returning itemstack will undo the adding.
		end
	end
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
