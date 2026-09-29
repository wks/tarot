-- The dimensions of a tarot card node,
-- as if it is placed on the ground towards north.
-- hz and hx are half of the z and x edge lengths.
-- y is the thickness.
local tarot_node_hz = 0.45
local tarot_node_hx = tarot_node_hz / tarot_redo.image_h * tarot_redo.image_w
local tarot_node_y = 0.02
local tarot_node_box = {
    -tarot_node_hx, -0.5, -tarot_node_hz,
    tarot_node_hx, -0.5 + tarot_node_y, tarot_node_hz
}

-- Texture sizes.
-- We need to use "[combine" to logically add paddings outside the tarot card images
-- so that the padded image is a square that covers one block face.
local card_texture_side = tarot_redo.image_h / (tarot_node_hz * 2)
local card_texture_offset_x = (card_texture_side - tarot_redo.image_w) / 2
local card_texture_offset_y = (card_texture_side - tarot_redo.image_h) / 2

local card_texture_prefix = string.format(
    "[combine:%dx%d:%d,%d=",
    card_texture_side,
    card_texture_side,
    card_texture_offset_x,
    card_texture_offset_y
)

local card_back_image = "tarot_redo_CardBacks.jpg"

function tarot_redo.make_tarot_card_node_def(card)
    local description = "Tarot Card: " .. card.title
    local front_texture = card_texture_prefix .. card.image
    local back_texture = card_texture_prefix .. card_back_image

    return {
        description = description,
        drawtype = "nodebox",
        tiles = {
            front_texture,
            back_texture,
            "blank.png",
            "blank.png",
            "blank.png",
            "blank.png",
        },
        inventory_image = front_texture,
        paramtype = "light",
        paramtype2 = "facedir",
        is_ground_content = false,
        groups = {
            tarot_card = 1,
            snappy = 1,
        },
        node_box = {
            type = "fixed",
            fixed = tarot_node_box,
        },
        selection_box = {
            type = "fixed",
            fixed = tarot_node_box,
        },
    }
end

for _, card in ipairs(tarot_redo.deck) do
    local card_id = tarot_redo.card_to_id(card)

    core.register_node("tarot_redo:tarot_card_" .. card_id,
        tarot_redo.make_tarot_card_node_def(card)
    )
end
