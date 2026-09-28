local tarot_node_h = 0.45
local tarot_node_w = tarot_node_h / tarot_redo.image_h * tarot_redo.image_w
local tarot_node_y = 0.02
local tarot_node_box = {
    -tarot_node_w, -0.5, -tarot_node_h,
    tarot_node_w, -0.5 + tarot_node_y, tarot_node_h }

core.register_node("tarot_redo:tarot_card", {
    description = "Tarot card in world",
    drawtype = "nodebox",
    tiles = {
        "[combine:586x586:143,30=tarot_redo_00-TheFool.jpg",
        "[combine:586x586:143,30=tarot_redo_CardBacks.jpg",
        "blank.png",
        "blank.png",
        "blank.png",
        "blank.png",
    },
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
})
