clearListener(); print("Cleared in: "+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../MenuCreator.ms" )	--"./../MenuCreator.ms"

--menu_items_json = ( getFilenamePath(getSourceFileName()) + "menu_items.json" )	--"./menu_items.json"


/*  Generates and executes mock macroscript definition.
    Macro prints message when called from created menu.
*/
function generateMockMacroScript macro_category macro_name =
(
	macro_script_text = ""
	macro_script_text += ("macroScript " + macro_name + " category:\"" + macro_category + "\"\n")
	macro_script_text += "(\n"
	macro_script_text += ("\tprint \"Executed mock macro: " + macro_category + " / " + macro_name + "\"\n")
	macro_script_text += ")\n"

	execute macro_script_text

	ok -- return
)


/*  Creates test macro dictionary level.
    Value is either #(category, macro_name) or submenu dictionary.
*/
function createTestMacroDictionaryLevel level_index item_count:2 submenu_count:1 nested_level_count:1 macro_counter:#(0) macro_category:"_TEST_CATEGORY" =
(
	dictionary_value = Dictionary #string

	for item_index = 1 to item_count do
	(
		macro_counter[1] += 1

		title_string = ("Item L" + (level_index as string) + "." + (item_index as string))
		macro_name = ("_TEST_MACRO_" + (macro_counter[1] as string))

		generateMockMacroScript macro_category macro_name

		dictionary_value[title_string] = #(macro_category, macro_name)
	)

	if (level_index < nested_level_count) then
	(
		for submenu_index = 1 to submenu_count do
		(
			submenu_title_string = ("Submenu L" + (level_index as string) + "." + (submenu_index as string))

			dictionary_value[submenu_title_string] = createTestMacroDictionaryLevel \
				(level_index + 1) \
				item_count:item_count \
				submenu_count:submenu_count \
				nested_level_count:nested_level_count \
				macro_counter:macro_counter \
				macro_category:macro_category
		)
	)

	dictionary_value -- return
)

/*  Test code.
    Creates dictionary result and creates MenuCreator_v instance from it.
*/
test_macro_counter = #(0)

test_cui_macro_dictionary = createTestMacroDictionaryLevel \
	0 \
	item_count:2 \
	submenu_count:1 \
	nested_level_count:1 \
	macro_counter:test_macro_counter \
	macro_category:"_TEST_CATEGORY"

Menu = MenuCreator_v menu_items:test_cui_macro_dictionary


Menu.registerCallback()


format "Dictionary created. Generated macros: %\n" test_macro_counter[1]
format "Menu callback registered: %\n" Menu.callback_id
format "Restart 3ds Max or force CUI menu rebuild to see menu: %\n" Menu.menu_title