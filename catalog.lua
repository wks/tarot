local modname = core.get_current_modname()
local S = core.get_translator(modname)

tarot_redo.suits = {
    { id = "major",     title = S("Major Arcana") },
    { id = "wands",     title = S("Wands") },
    { id = "cups",      title = S("Cups") },
    { id = "swords",    title = S("Swords") },
    { id = "pentacles", title = S("Pentacles") },
}

tarot_redo.catalog = {}

for _, suit in ipairs(tarot_redo.suits) do
    local cat_entry = {
        id = suit.id,
        title = suit.title,
        cards = {},
    }
    tarot_redo.catalog[suit.id] = cat_entry
end

function tarot_redo.card_to_id(card)
    return card.suit .. tostring(card.ordinal)
end

tarot_redo.id_to_card = {}

for _, card in ipairs(tarot_redo.deck) do
    table.insert(tarot_redo.catalog[card.suit].cards, card)
    local card_id = tarot_redo.card_to_id(card)
    tarot_redo.id_to_card[card_id] = card
end

-- Assign global ordinal to each card.
-- The global ordinal is just its index in the tarot_redo.deck table.
for global_ordinal, card in ipairs(tarot_redo.deck) do
    card.global_ordinal = global_ordinal
end
