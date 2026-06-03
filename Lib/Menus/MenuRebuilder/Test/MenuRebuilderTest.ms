clearListener(); print("Cleared in: "+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/createSavedTestMenuDataLevel.ms" )	--"./createSavedTestMenuDataLevel.ms"

filein( getFilenamePath(getSourceFileName()) + "/../MenuRebuilder.ms" )	--"./../MenuRebuilder.ms"

/*  Prints saved menu items structure.
    Shows GUID keys, item titles, macros and nested submenu items.
*/
function printSavedMenuItemsStructure saved_items indent:"" =
(
	if saved_items == undefined then
	(
		format "%saved_items: undefined\n" indent
	)
	else if classOf saved_items != Dictionary then
	(
		format "%saved_items is not Dictionary: %\n" indent saved_items
	)
	else
	(
		saved_guid_array = GetDictKeys saved_items

		for saved_guid in saved_guid_array do
		(
			item_data = saved_items[saved_guid]

			if classOf item_data == Dictionary and HasDictValue item_data #items then
			(
				format "%SUBMENU GUID: %\n" indent saved_guid
				format "%    title: %\n" indent item_data[#title]

				printSavedMenuItemsStructure item_data[#items] indent:indent + "    "
			)
			else if classOf item_data == Dictionary and HasDictValue item_data #macro then
			(
				format "%ITEM GUID: %\n" indent saved_guid
				format "%    title: %\n" indent item_data[#title]
				format "%    category: %\n" indent item_data[#category]
				format "%    macro: %\n" indent item_data[#macro]
			)
			else
			(
				format "%INVALID GUID: % value: %\n" indent saved_guid item_data
			)
		)
	)

	ok -- return
)



/*  Test code.
    Creates saved menu data and rebuilds menu from it.
*/
saved_menu_items = createSavedTestMenuDataLevel \
	0 \
	item_count:2 \
	submenu_count:2 \
	nested_level_count:3 \
	macro_category:"_TEST_CATEGORY"

format "saved_menu_items: %\n" saved_menu_items

--printSavedMenuItemsStructure saved_menu_items

MenuRebuilder = MenuRebuilder_v \
	menu_title:"_TEST_MENU_REBUILT" \
	menu_items:saved_menu_items

MenuRebuilder.registerCallback()

--format "Saved menu data created. Generated macros: %\n" test_macro_counter[1]
--format "Menu rebuild callback registered: %\n" MenuRebuilder.callback_id
--format "Menu title: %\n" MenuRebuilder.menu_title