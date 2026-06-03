/*  Creates new guid string.
    Used as saved CUI item id.
*/
function createTestGuidString =
(
	guid_class = dotNetClass "System.Guid"
	guid_value = guid_class.NewGuid()

	guid_value.ToString() -- return
)


/*  Generates and executes mock macroscript definition.
    Macro prints message when called from created menu.
*/
function generateMockMacroScript macro_category macro_name =
(
	macro_script_text = ""
	macro_script_text += "macroScript " + macro_name + " category:\"" + macro_category + "\"\n"
	macro_script_text += "(\n"
	macro_script_text += "\tprint \"Executed mock macro: " + macro_category + " / " + macro_name + "\"\n"
	macro_script_text += ")\n"

	execute macro_script_text

	ok -- return
)


/*  Creates saved macro item data.
    Item data contains #title #category #macro.
*/
function createSavedMacroItemData item_title macro_category macro_name =
(
	item_data = Dictionary #name

	item_data[#title] = item_title
	item_data[#category] = macro_category
	item_data[#macro] = macro_name

	item_data -- return
)


/*  Creates test menu level data.
    Every submenu level contains at least one action item.
*/
function createTestMacroDictionaryLevel level_index menu_title:"_TEST_MENU" item_count:2 submenu_count:1 nested_level_count:1 macro_counter:#(0) macro_category:"_TEST_CATEGORY" minimum_submenu_item_count:1 =
(
	menu_level_data = Dictionary #name
	menu_items = Dictionary #string

	menu_level_data[#title] = menu_title
	menu_level_data[#items] = menu_items

	level_item_count = item_count

	if level_index > 0 and level_item_count < minimum_submenu_item_count then
	(
		level_item_count = minimum_submenu_item_count
	)

	for item_index = 1 to level_item_count do
	(
		macro_counter[1] += 1

		item_guid = createTestGuidString()
		item_title = "Item L" + (level_index as string) + "." + (item_index as string)
		macro_name = "_TEST_MACRO_" + (macro_counter[1] as string)

		generateMockMacroScript macro_category macro_name

		menu_items[item_guid] = createSavedMacroItemData item_title macro_category macro_name
	)

	if level_index < nested_level_count then
	(
		for submenu_index = 1 to submenu_count do
		(
			submenu_guid = createTestGuidString()
			submenu_title = "Submenu L" + (level_index as string) + "." + (submenu_index as string)

			menu_items[submenu_guid] = createTestMacroDictionaryLevel \
				(level_index + 1) \
				menu_title:submenu_title \
				item_count:item_count \
				submenu_count:submenu_count \
				nested_level_count:nested_level_count \
				macro_counter:macro_counter \
				macro_category:macro_category \
				minimum_submenu_item_count:minimum_submenu_item_count
		)
	)

	menu_level_data -- return
)