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


/*  Creates new guid string.
    Used by test data generator only.
*/
function createTestGuidString =
(
	guid_class = dotNetClass "System.Guid"
	guid_value = guid_class.NewGuid()

	guid_value.ToString() -- return
)


/*  Creates saved macro item data.
    Result is Dictionary #name with #title #category #macro.
*/
function createSavedMacroItemData item_title macro_category macro_name =
(
	item_data = Dictionary #name

	item_data[#title] = item_title
	item_data[#category] = macro_category
	item_data[#macro] = macro_name

	item_data -- return
)


/*  Creates saved submenu data.
    Result is Dictionary #name with #title #items.
*/
function createSavedSubMenuData submenu_title submenu_items =
(
	submenu_data = Dictionary #name

	submenu_data[#title] = submenu_title
	submenu_data[#items] = submenu_items

	submenu_data -- return
)


/*  Creates saved test menu data recursively.
    Top result is Dictionary #string keyed by GUID strings.
*/
function createSavedTestMenuDataLevel level_index item_count:2 submenu_count:1 nested_level_count:1 macro_counter:#(0) macro_category:"_TEST_CATEGORY" =
(
	saved_items = Dictionary #string

	for item_index = 1 to item_count do
	(
		macro_counter[1] += 1

		item_guid = createTestGuidString()
		item_title = ("Item L" + (level_index as string) + "." + (item_index as string))
		macro_name = ("_TEST_MACRO_" + (macro_counter[1] as string))

		generateMockMacroScript macro_category macro_name

		saved_items[item_guid] = createSavedMacroItemData item_title macro_category macro_name
	)

	if (level_index < nested_level_count) then
	(
		for submenu_index = 1 to submenu_count do
		(
			submenu_guid = createTestGuidString()
			submenu_title = ("Submenu L" + (level_index as string) + "." + (submenu_index as string))

			submenu_items = createSavedTestMenuDataLevel \
				(level_index + 1) \
				item_count:item_count \
				submenu_count:submenu_count \
				nested_level_count:nested_level_count \
				macro_counter:macro_counter \
				macro_category:macro_category

			saved_items[submenu_guid] = createSavedSubMenuData submenu_title submenu_items
		)
	)

	saved_items -- return
)






