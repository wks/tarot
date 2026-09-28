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
    local tab_bar_def = {
        min_w = 3,
    }

    for _, suit in ipairs(tarot_redo.suits) do
        table.insert(tab_bar_def, gui.Button {
            label = suit.title,
            on_event = function(player, ctx)
                ctx.page = suit.id
                return true
            end
        })
    end

    local tab_bar = gui.VBox(tab_bar_def)

    local page = ctx.page or "major"

    local right_pane_def = {
        name = "right_pane_" .. page, -- Each page has different scroll position.
        min_w = 13,
    }

    tarot_redo.populate_right_pane(player, ctx, right_pane_def)

    local right_pane = gui.ScrollableVBox(right_pane_def)

    return gui.HBox {
        min_w = 16,
        min_h = 10,
        tab_bar,
        right_pane,
    }
end)

function tarot_redo.open_main_ui(player)
    my_gui:show(player)
end

function tarot_redo.populate_right_pane(player, ctx, right_pane_def)
    local page = ctx.page or "major"

    local cat_entry = tarot_redo.catalog[page]

    return tarot_redo.populate_suit_page(player, cat_entry, right_pane_def)
end

function tarot_redo.populate_suit_page(player, cat_entry, right_pane_def)
    table.insert(right_pane_def, gui.Label {
        label = cat_entry.title
    })

    table.insert(right_pane_def, gui.Label {
        label = S("Click a card to show details."),
    })

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

    local card_w = right_pane_def.min_w / cards_per_row
    local card_h = card_w / 300 * 527 -- Keep the aspect ratio

    for _, row in ipairs(rows) do
        local defs = {}

        for c, card in ipairs(row) do
            local card_id = string.format("card_%s_%d", card.suit, card.ordinal)
            table.insert(defs, gui.ImageButton {
                texture_name = card.image,
                w = card_w,
                h = card_h,
            })
        end
        table.insert(right_pane_def, gui.HBox(defs))
    end
end
