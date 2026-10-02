local modname = core.get_current_modname()
local S = core.get_translator(modname)

tarot_redo.settings_list = {}
tarot_redo.settings_map = {}

local function make_bool_setting(name, title, description, default)
    local def = {
        name = name,
        key = modname .. ":" .. name,
        title = title,
        description = description,
        default = default,
        get = function(self, player)
            local meta = player:get_meta()
            local value = meta:get(self.key)
            if value then
                return value == "true"
            else
                return self.default
            end
        end,
        set = function(self, player, new_value)
            local meta = player:get_meta()
            local value = new_value and "true" or "false"
            meta:set_string(self.key, value)
        end,
        reset = function(self, player)
            local meta = player:get_meta()
            meta:set_string(self.key, "")
        end,
    }
    table.insert(tarot_redo.settings_list, def)
    tarot_redo.settings_map[name] = def
end

make_bool_setting("allow_reversed",
    S("Allow reversed cards when drawing"),
    table.concat({
        S("When true, a card drawn at random has a 50% chance to be placed upside down."),
        S("When false, all drawn cards will be placed upright."),
    }, "\n"),
    true)

make_bool_setting("major_arcana_only",
    S("Only draw cards from major arcana"),
    table.concat({
        S("When true, only draw cards from major arcana."),
        S("When false, draw cards from the whole deck."),
    }, "\n"),
    false)

make_bool_setting("warn_table_too_large",
    S("Show warning if the table is too large."),
    table.concat({
        S("When true, placing a card on an area that is too large will receive warning and show highlighting."),
        S("When false, no warning is shown."),
    }, "\n"),
    true)
