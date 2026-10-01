local function is_on_rightclick_suppressed(player)
    if not player or not player:is_player() then return false end
    local control = player:get_player_control()
    -- It is hard to use sneak if the player can fly, so we include aux1.
    return control.sneak or control.aux1
end

function tarot_redo.place_tarot_card(itemstack, player, pointed_thing)
    if pointed_thing.type ~= "node" then return end

    local under_pos = pointed_thing.under
    local under_node = core.get_node_or_nil(under_pos)
    local under_def = under_node and core.registered_nodes[under_node.name]
    core.debug("under", under_pos, under_node.name)
    if not under_def then return end

    -- Give it a chance to respond to rightclick.
    if under_def.on_rightclick and not is_on_rightclick_suppressed(player) then
        return under_def.on_rightclick(under_pos, under_node, player, itemstack, pointed_thing)
    end

    -- Ignore if the node above is not air.
    -- Tarot cards cannot replace buildable_to nodes.
    local above_pos = pointed_thing.above
    local above_node = core.get_node(above_pos)
    core.debug("above", above_pos, above_node.name)
    if above_node.name ~= "air" then return end

    if core.is_protected(above_pos, player:get_player_name()) then return end

    local tarot_pos = above_pos

    local vec_out = above_pos - under_pos
    core.debug("vec_out:", vec_out)

    local look_dir = player:get_look_dir()
    local look_yaw = player:get_look_horizontal()
    core.debug("look_dir:", look_dir, "look_yaw:", look_yaw)

    local facedir = 8
    if vec_out.y > 0 then
        -- Tarot card faces up (+Y).  Rotate the card to the player's look yaw.
        -- The look yaw is right-handed rotation from +N w.r.t. upward axis,
        -- but the facedir is left-hand rotation from +N w.r.t. upward axis.
        if look_yaw < math.pi / 4 then
            facedir = 0
        elseif look_yaw < math.pi * 3 / 4 then
            facedir = 3
        elseif look_yaw < math.pi * 5 / 4 then
            facedir = 2
        elseif look_yaw < math.pi * 7 / 4 then
            facedir = 1
        else
            facedir = 0
        end
    elseif vec_out.y < 0 then
        -- Tarot card faces down (-Y).  Rotate the card to the player's look yaw.
        -- Both the look_dir yaw and the facedir are right-handed rotation from +N w.r.t. upward axis.
        -- But the card should still look upright from the player's perspective.
        -- It means if the player is facing north, the card's top should point to south.
        -- So a 180 degree phase is added to the facedir.
        if look_yaw < math.pi / 4 then
            facedir = 2
        elseif look_yaw < math.pi * 3 / 4 then
            facedir = 3
        elseif look_yaw < math.pi * 5 / 4 then
            facedir = 0
        elseif look_yaw < math.pi * 7 / 4 then
            facedir = 1
        else
            facedir = 2
        end
        facedir = facedir + 5 * 4 -- 5 in the high bits means -Y.
    elseif vec_out.x > 0 then
        -- East (+X), on the wall.  Put the card upward and face east.
        -- 3*4 is obtained by rotating 0 by 90 degrees around the Z axis,
        -- so when facedir == 3 * 4, the head is towards north.
        -- We rotate 270 degrees left-handed around +X.
        facedir = 3 * 4 + 3
    elseif vec_out.x < 0 then
        -- west (-X)
        -- 4*4 is obtained by rotating 0 by 90 deg around Z.  Top points north.
        -- Rotate 90 degrees left-handed around -X.
        facedir = 4 * 4 + 1
    elseif vec_out.z > 0 then
        -- north (+Z)
        -- 1*4 is obtained by rotating 0 by 90 deg around X.  Top points down.
        -- Rotate 180 degrees
        facedir = 1 * 4 + 2
    elseif vec_out.z < 0 then
        -- south (-Z)
        -- 2*4 is obtained by rotating 0 by 90 deg around X.  Is still upright.
        facedir = 2 * 4
    else
        -- This should be unreachable.  It is an error if this happens.
        -- Log the error and fall back to 0
        core.debug("Unexpected vec_out: ", vec_out)
        facedir = 0
    end

    local node_name = itemstack:get_name()
    if node_name == "tarot_redo:tarot_card" then
        -- If it is the unrevealed Tarot Card item, draw a concrete card.
        local random_ordinal = math.random(#tarot_redo.deck)
        local card = tarot_redo.deck[random_ordinal]
        node_name = tarot_redo.card_to_node_name(card)
    end

    core.set_node(tarot_pos, {
        name = node_name,
        param1 = 0,
        param2 = facedir,
    })

    itemstack:take_item()

    return itemstack
end
