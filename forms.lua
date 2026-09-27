local S = core.get_translator and core.get_translator("tarot_redo")

local elem = respec.elements

tarot_redo.form_configs = {
    ver = 5,
    w = 16,
    h = 10,
    tabw = 3,
    paddings = 0.5,
}

function tarot_redo.make_tab_bar_items()
    local items = {}
    for _, suit in ipairs(tarot_redo.suits) do
        table.insert(items, {
            text = suit.title,
        })
    end
    return items
end

function tarot_redo.open_main_ui(player)
    local my_form = respec.Form(
        {
            ver = tarot_redo.form_configs.ver,
            w = tarot_redo.form_configs.w,
            h = tarot_redo.form_configs.h,
            paddings = tarot_redo.form_configs.padding,
        },
        function(init)
            return {
                elem.TabBar {
                    id = "tabbar",
                    orientation = "vertical",
                    w = tarot_redo.form_configs.tabw,
                    h = tarot_redo.form_configs.h,
                    padding = 0.5,

                    items = tarot_redo.make_tab_bar_items(),

                    index = init.tabIdx or 1,

                    listener = function(state, value, fields)
                        state.tabIdx = tonumber(value)
                    end
                },
                elem.Label {
                    text = "Selected tab index = " .. (init.tabIdx or 1),
                    after = "tabbar",
                    toEnd = true,
                }
            }
        end
    )
    my_form:show(player:get_player_name())
end
