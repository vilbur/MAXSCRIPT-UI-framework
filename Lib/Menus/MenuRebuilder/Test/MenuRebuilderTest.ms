clearListener(); print("Cleared in: "+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/createSavedTestMenuDataLevel.ms" )	--"./createSavedTestMenuDataLevel.ms"

filein( getFilenamePath(getSourceFileName()) + "/../MenuRebuilder.ms" )	--"./../MenuRebuilder.ms"



/*  Test code.
    Creates saved menu data and rebuilds menu from it.
*/
test_macro_counter = #(0)

saved_menu_items = createSavedTestMenuDataLevel \
	0 \
	item_count:2 \
	submenu_count:1 \
	nested_level_count:1 \
	macro_counter:test_macro_counter \
	macro_category:"_TEST_CATEGORY"

format "saved_menu_items: %\n" saved_menu_items

MenuRebuilder = MenuRebuilder_v \
	menu_title:"_TEST_MENU_REBUILT" \
	menu_items:saved_menu_items

MenuRebuilder.registerCallback()

--format "Saved menu data created. Generated macros: %\n" test_macro_counter[1]
--format "Menu rebuild callback registered: %\n" MenuRebuilder.callback_id
--format "Menu title: %\n" MenuRebuilder.menu_title