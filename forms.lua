local S = core.get_translator and core.get_translator("tarot_redo")

local elem = respec.elements

tarot_redo.form_configs = {
    ver = 8,
    w = 16,
    h = 10,
    tabw = 3,
    paddings = 0.5,
}

tarot_redo.tab_bar_items = {}
tarot_redo.tab_content_getters = {}

local function insert_tab_bar_item(tab_bar_item, tab_content_getter)
    table.insert(tarot_redo.tab_bar_items, tab_bar_item)
    table.insert(tarot_redo.tab_content_getters, tab_content_getter)
end

for _, suit in ipairs(tarot_redo.suits) do
    insert_tab_bar_item(
        { text = suit.title },
        function(player)
            return tarot_redo.get_suit_page(player, suit)
        end
    )
end

function tarot_redo.open_main_ui(player)
    local my_form = respec.Form(
        {
            ver = tarot_redo.form_configs.ver,
            w = tarot_redo.form_configs.w,
            h = tarot_redo.form_configs.h,
            paddings = tarot_redo.form_configs.paddings,
        },
        function(init)
            local index = init.tabIdx or 1
            return {
                elem.TabBar {
                    id = "main_tab_bar",
                    orientation = "vertical",
                    w = tarot_redo.form_configs.tabw,
                    h = 0, toTop = true, toBottom = true,

                    paddings = 0.5,

                    items = tarot_redo.tab_bar_items,
                    index = index,

                    listener = function(state, newIndex, fields)
                        state.tabIdx = tonumber(newIndex)
                    end
                },
                tarot_redo.tab_content_getters[index](player)
            }
        end
    )
    my_form:show(player:get_player_name())
end

function tarot_redo.get_suit_page(player, suit)
    local elements = {
        elem.Label {
            id = "suit_title",
            text = suit.title,
        },
    }

    local cat_entry = tarot_redo.catalog[suit.id]

    local rows = {}
    local cur_row = nil
    local cards_per_row = 7

    -- The Fool is number 0.
    for index = suit.first, suit.last do
        local card = cat_entry.cards[index]
        if not cur_row or #cur_row == cards_per_row then
            cur_row = {}
            table.insert(rows, cur_row)
        end
        table.insert(cur_row, card)
    end

    local last = "suit_title"
    for _, row in ipairs(rows) do
        local defs = {}
        for c, card in ipairs(row) do
            local card_id = string.format("card_%s_%d", card.suit, card.ordinal)
            table.insert(defs, {
                id = card_id,
                image = card.image,
                -- label = card.title,
                w = 2 * 300 / 527,
                h = 2,
                below = last,
            })
        end

        for i, def in ipairs(defs) do
            if i == 1 then
                def.toStart = true
            else
                def.after = defs[i - 1].id
            end
            if i == #defs then
                def.toEnd = true
            else
                def.before = defs[i + 1].id
            end
        end

        for _, def in ipairs(defs) do
            table.insert(elements, elem.ImageButton(def))
        end

        last = defs[1].id
    end

    table.insert(elements, elem.Label {
        id = "suit_end",
        text = "end",
        below = last,
    })

    return elem.ScrollContainer {
        id = "suit_page",

        w = 0, after = "main_tab_bar", toEnd = true,
        h = tarot_redo.form_configs.h - 1,

        paddings = 0.5,

        elements = elements,

        pixelBorder = "#7700ff",

    }
end
