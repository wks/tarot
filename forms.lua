local S = core.get_translator and core.get_translator("tarot_redo")

local gui = flow.widgets

tarot_redo.form_configs = {
    ver = 8,
    w = 16,
    h = 10,
    tabw = 3,
    paddings = 0.5,
}

local my_gui = flow.make_gui(function(player, ctx)
    local tab_bar_items = {}

    for _, suit in ipairs(tarot_redo.suits) do
        table.insert(tab_bar_items, gui.Button {
            label = suit.title,
            on_event = function(player, ctx)
                ctx.page = suit.id
                return true
            end
        })
    end

    local tab_bar = gui.VBox(tab_bar_items)

    return gui.HBox {
        tab_bar,
        tarot_redo.get_right_page(player, ctx),
    }
end)

function tarot_redo.open_main_ui(player)
    my_gui:show(player)
end

function tarot_redo.get_right_page(player, ctx)
    local page = ctx.page or "major"

    local cat_entry = tarot_redo.catalog[page]

    return tarot_redo.get_suit_page(player, cat_entry)
end

function tarot_redo.get_suit_page(player, cat_entry)
    local elements = {
        gui.Label {
            label = cat_entry.title
        },
    }

    local rows = {}
    local cur_row = nil
    local cards_per_row = 7

    -- The Fool is number 0.
    for index = cat_entry.first, cat_entry.last do
        local card = cat_entry.cards[index]
        if not cur_row or #cur_row == cards_per_row then
            cur_row = {}
            table.insert(rows, cur_row)
        end
        table.insert(cur_row, card)
    end

    for _, row in ipairs(rows) do
        local defs = {}
        for c, card in ipairs(row) do
            local card_id = string.format("card_%s_%d", card.suit, card.ordinal)
            table.insert(defs, gui.ImageButton {
                texture_name = card.image,
                -- label = card.title,
                w = 2 * 300 / 527,
                h = 2,
            })
        end
        table.insert(elements, gui.HBox(defs))
    end

    table.insert(elements, gui.Label {
        label = "end",
    })

    return gui.VBox(elements)
end
