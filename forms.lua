local S = minetest.get_translator and minetest.get_translator("tarot")

--valida o indice das cartas
local function validate_index(index)
    index = index or 1
    if type(index) ~= "number" then index = 1 end
    if index > 78 then index = 78 end
    return index
end

--retorna um objeto carta
local function get_a_card(index)
    local card = {}
    card.image = "tarot_CardBacks.jpg"
    card.title = ""
    card.meaning = ""
    card.answer = ""
    if index > 0 then
        card = tarot.deck[validate_index(index)]
    end
    return card
end

--exibe form de uma cunica carta
function tarot.show_card(name, index)
    local card = get_a_card(index)
    --core.chat_send_all(dump(card))
    local image = card.image --"tarot_01-TheMagician.jpg"
    local title = card.title --"The Magician"
    local meaning = card.meaning --"blablabla"
    local answer = card.answer --"Yes"
    local basic_form = table.concat({
	    "formspec_version[4]",
	    "size[16,10]",
	    "background[-0.7,-0.5;17.5,11.5;tarot_balloon.png]",
        "image[1,1;5,8;"..image.."]",
        "textarea[7,1.4;8,7.6;meaning;"..title..";"..meaning.."]",
        "label[12,9.6;Yes/No:]",
        "label[13.6,9.6;"..answer.."]",
    }, "")

    core.show_formspec(name, "tarot:show_card", basic_form)
end

--listagem de cartas simples para conferencia
function tarot.select_card(name)
    local card_list = "textlist[1,1;6.0,3.5;cards;"
    for i, v in ipairs(tarot.deck) do
        card_list = card_list..v.title..","
    end
    card_list = card_list..";1;true]"

    local basic_form = table.concat({
        "formspec_version[4]",
        "size[8,5]",
        "background[-0.7,-0.5;9.5,6.5;tarot_balloon_2.png]",
        card_list,
    }, "")

    core.show_formspec(name, "tarot:select_card", basic_form)
end

--leitura minha situação
function tarot.my_situation(name, index_array)
    index_array = index_array or {0,0,0}
    local card1 = get_a_card(index_array[1])
    local card2 = get_a_card(index_array[2])
    local card3 = get_a_card(index_array[3])

    --`image_button[<X>,<Y>;<W>,<H>;<texture name>;<name>;<label>;<noclip>;<drawborder>;<pressed texture name>]`
    local basic_form = table.concat({
        "formspec_version[4]",
        "size[16,10]",
        "background[-0.7,-0.5;17.5,11.5;tarot_balloon.png]",
        "label[2,1.5;Think on your Question and click each card.]",
        "image_button[2.0,4;3,4.5;"..card1.image..";you;;false;true;]",
        "image_button[6.5,4;3,4.5;"..card2.image..";your_perception;;false;true;]",
        "image_button[11.0,4;3,4.5;"..card3.image..";the_truth;;false;true;]",
        "label[2.1,3;You!]",
        "label[6.5,3;Your perceptions]",
        "label[11,3;The truth of]",
        "label[11,3.4;your situation]",
        "field[2,11;2,1;index1;;"..index_array[1].."]",
        "field[3,11;2,1;index2;;"..index_array[2].."]",
        "field[4,11;2,1;index3;;"..index_array[3].."]",
    }, "")
    if index_array[1] > 0 then
        basic_form = table.concat({basic_form, "tooltip[you;"..card1.title.."\n"..card1.meaning..";#FFFFFF;#000000]"}, "")
    end
    if index_array[2] > 0 then
        basic_form = table.concat({basic_form, "tooltip[your_perception;"..card2.title.."\n"..card2.meaning..";#FFFFFF;#000000]"}, "")
    end
    if index_array[3] > 0 then
        basic_form = table.concat({basic_form, "tooltip[the_truth;"..card3.title.."\n"..card3.meaning..";#FFFFFF;#000000]"}, "")
    end

    core.show_formspec(name, "tarot:my_situation", basic_form)
end

--listagem das leituras disponiveis
function tarot.select_reading(name)
    local basic_form = table.concat({
        "formspec_version[4]",
        "size[8,5]",
        "background[-0.7,-0.5;9.5,6.5;tarot_balloon_2.png]",
        "button[1,1;6,1;one_card;Just one card, please]",
        "button[1,2;6,1;my_situation;I need to understand my situation]",
        "button[1,3;6,1;list;I want to know the cards]",
    }, "")

    core.show_formspec(name, "tarot:select_reading", basic_form)
end

core.register_on_player_receive_fields(function(player, formname, fields)
    if not player then return end
    local name = player:get_player_name()
    if not name then
        return
    end

    if formname == "tarot:select_reading" then
        if fields.one_card then
            local index = tarot.get_one_card(name)
            tarot.show_card(name, index)
        end

	    if fields.my_situation then
            tarot.my_situation(name)
	    end

	    if fields.list then
            tarot.select_card(name)
	    end
        
        core.close_formspec(name, "tarot:select_reading")
    end

    if formname == "tarot:select_card" then
	    if fields.cards then
            local selected_index_str = fields.cards
            if selected_index_str and selected_index_str ~= "" then
                if selected_index_str:sub(1,3) == "CHG" then
                    local selected_index = tonumber(selected_index_str:sub(5))
                    --core.chat_send_all(dump(selected_index))
                    core.close_formspec(name, "tarot:select_card")
                    tarot.show_card(name, selected_index)
                end
            end
	    end
    end

    if formname == "tarot:my_situation" then
        local index1 = 0
        local index2 = 0
        local index3 = 0
        local index_str = fields.index1
        if index_str and index_str ~= "" then
            index1 = tonumber(index_str)
        end
        index_str = fields.index2
        if index_str and index_str ~= "" then
            index2 = tonumber(index_str)
        end
        index_str = fields.index3
        if index_str and index_str ~= "" then
            index3 = tonumber(index_str)
        end

	    if fields.you then
            if index1 == 0 then
                index1 = tarot.get_one_card(name, {index1, index2, index3})
                core.close_formspec(name, "tarot:my_situation")
                tarot.my_situation(name, {index1, index2, index3})
            end
	    end
	    if fields.your_perception then
            if index2 == 0 then
                index2 = tarot.get_one_card(name, {index1, index2, index3})
                core.close_formspec(name, "tarot:my_situation")
                tarot.my_situation(name, {index1, index2, index3})
            end
	    end
	    if fields.the_truth then
            if index3 == 0 then
                index3 = tarot.get_one_card(name, {index1, index2, index3})
                core.close_formspec(name, "tarot:my_situation")
                tarot.my_situation(name, {index1, index2, index3})
            end
	    end
    end
end)

