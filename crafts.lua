local S = core.get_translator and core.get_translator("tarot_redo")

core.register_tool("tarot_redo:tarot_book", {
	description = S("Tarot Book"),
	_tt_help = table.concat({
		S("A reference book for Tarot cards."),
		S('Press the dig button (left mouse button) on a surface to highlight "table" area.'),
		S("Press the place button (right mouse button) to open user interface."),
		S("Note: The UI can also be opened using the '/tarot_ui' chat command."),
	}, "\n"),
	inventory_image = "tarot_redo_tarot_book.png",
	stack_max = 1,

	on_use = function(itemstack, player, pointed_thing)
		if not player or not player:is_player() then return end
		local player_name = player:get_player_name()

		local highlighted = tarot_redo.highlight_table(itemstack, player, pointed_thing)
		if highlighted then
			core.chat_send_player(player_name, S("Table area highlighted."))
		else
			core.chat_send_player(player_name, S('Use on a surface to highlight the "table" area.'))
		end
	end,

	on_place = function(itemstack, player, pointed_thing)
		local handled, result = tarot_redo.try_process_rightclick(itemstack, player, pointed_thing)
		if handled then return result end

		if not player or not player:is_player() then return end
		tarot_redo.open_main_ui(player)
	end,

	on_secondary_use = function(itemstack, player, pointed_thing)
		if not player or not player:is_player() then return end
		tarot_redo.open_main_ui(player)
	end,
})

core.register_craftitem("tarot_redo:tarot_card", {
	description = S("Tarot Card"),
	_tt_help = table.concat({
		S("Unrevealed.  You don't know which card it is, yet."),
		S("When placed in the world, it becomes a random Tarot card."),
		S("Hold this item and dig placed Tarot cards to collect them back."),
		S("Max stack: @1", #tarot_redo.deck),
	}, "\n"),
	inventory_image = "tarot_redo_card_ico.png",
	stack_max = #tarot_redo.deck, -- We all know how many cards a Tarot deck has. :)\

	on_place = function(itemstack, player, pointed_thing)
		return tarot_redo.place_tarot_card(itemstack, player, pointed_thing)
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

core.register_craft({
	output = "tarot_redo:tarot_book",
	recipe = {
		{ "dye:red",    "dye:green",    "" },
		{ "dye:yellow", "default:book", "dye:black" },
		{ "",           "dye:blue",     "dye:violet" },
	}
})

-- Concrete cards can be converted back to the abstract Tarot Card.
core.register_craft({
	type = "shapeless",
	output = "tarot_redo:tarot_card",
	recipe = { "group:tarot_card" },
})
