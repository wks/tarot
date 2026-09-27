tarot_redo.suits = {
    { id = "major",     title = "Major Arcana", first = 0, last = 21 },
    { id = "wands",     title = "Wands",        first = 1, last = 14 },
    { id = "cups",      title = "Cups",         first = 1, last = 14 },
    { id = "swords",    title = "Swords",       first = 1, last = 14 },
    { id = "pentacles", title = "Pentacles",    first = 1, last = 14 },
}

tarot_redo.catalog = {}

for _, suit in ipairs(tarot_redo.suits) do
    local cat_entry = {
        id = suit.id,
        title = suit.title,
        first = suit.first,
        last = suit.last,
        cards = {},
    }
    tarot_redo.catalog[suit.id] = cat_entry
end

for _, card in ipairs(tarot_redo.deck) do
    tarot_redo.catalog[card.suit].cards[card.ordinal] = card
end
