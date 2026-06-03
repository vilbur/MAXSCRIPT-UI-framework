clearListener(); print("Cleared in: "+getSourceFileName())


filein( getFilenamePath(getSourceFileName()) + "/Lib/createSavedTestMenuDataLevel.ms" )	--"./Lib/createSavedTestMenuDataLevel.ms"
filein( getFilenamePath(getSourceFileName()) + "/Lib/printSavedData.ms" )	--"./Lib/printSavedData.ms"
--
--filein( getFilenamePath(getSourceFileName()) + "/../MenuRebuilder.ms" )	--"./../MenuRebuilder.ms"

filein( getFilenamePath(getSourceFileName()) + "/../../MenuBuildManager/MenuBuildManager.ms" )	--"./../../MenuBuildManager/MenuBuildManager.ms"



/*  Test normal menu.
    Builds source dictionary, converts it to saved data, and registers menu callback.
*/
function testMenuRebuilderMenu test_cui_macro_dictionary =
(
	MenuRebuilder = MenuRebuilder_v \
		menu_type:#menu \
		menu_title:"_TEST_MENU" \
		menu_items:test_cui_macro_dictionary

	saved_menu_data = MenuRebuilder.buildMenuData()

	format "Generated macro count: %\n" test_macro_counter[1]
	format "Menu id: %\n" saved_menu_data[#id]
	format "Menu title: %\n" saved_menu_data[#title]

	MenuRebuilder.registerCallback()

	saved_menu_data -- return
)


/*  Test quad menu.
    Builds source dictionary, converts it to saved data, and registers quad callback.
*/
function testMenuRebuilderQuad test_cui_macro_dictionary =
(
	MenuRebuilder = MenuRebuilder_v \
		menu_type:#quad \
		menu_title:"_TEST_QUAD_MENU" \
		menu_items:test_cui_macro_dictionary \
		quad_modifier:#shiftAndControlPressed \
		quad_position:#TopRight

	saved_menu_data = MenuRebuilder.buildMenuData()

	format "Generated macro count: %\n" test_macro_counter[1]
	format "Quad menu id: %\n" saved_menu_data[#id]
	format "Quad menu title: %\n" saved_menu_data[#title]

	MenuRebuilder.registerCallback()

	saved_menu_data -- return
)


/*  Test rebuild from saved data.
    Use saved data returned by testMenuRebuilderMenu or loaded from file.
*/
function testMenuRebuilderFromSavedData saved_menu_data =
(
	MenuRebuilder = MenuRebuilder_v menu_data:saved_menu_data

	MenuRebuilder.registerCallback()

	MenuRebuilder.buildMenuData() -- return
)

/*------------------------------------------------------------------------------
	GENERATE TET DATA
--------------------------------------------------------------------------------*/
test_macro_counter = #(0)

simple_user_menu_data = createTestMacroDictionaryLevel 0 item_count:2 submenu_count:1 nested_level_count:1 macro_counter:test_macro_counter macro_category:"_TEST_CATEGORY" minimum_submenu_item_count:1

test_macro_counter = #(0)
simple_user_menu_data_quad = createTestMacroDictionaryLevel 0 item_count:2 submenu_count:1 nested_level_count:1 macro_counter:test_macro_counter macro_category:"_TEST_CATEGORY" minimum_submenu_item_count:1


menus_data = #(
	MenuDefinition_v type:#menu title:"_TEST_MENU_FROM_MANAGER" data:simple_user_menu_data,
	MenuDefinition_v type:#quad title:"_TEST_QUAD_FROM_MANAGER" data:simple_user_menu_data_quad quad_modifier:#shiftAndControlPressed quad_position:#TopRight
)

menu_build_manager = MenuBuildManager_v menus_data:menus_data

saved_menus_data = menu_build_manager.run()


simple_user_menu_data

--
--
--/*  Test MenuBuildManager_v for quad menu.
--    Builds quad menu callback and saves startup rebuild file.
--*/
--
--menu_build_manager = MenuBuildManager_v \
--	menu_type:#menu \
--	menu_title:"_TEST_MENU_FROM_MANAGER" \
--	user_menu_data:simple_user_menu_data \
--
--saved_quad_menu_data = menu_build_manager.run()
--
--#(  )
--
----menu_build_manager = MenuBuildManager_v \
----	menu_type:#quad \
----	menu_title:"_TEST_QUAD_FROM_MANAGER" \
----	user_menu_data:simple_user_menu_data_quad \
----	quad_modifier:#shiftAndControlPressed \
----	quad_position:#TopRight
----
----saved_quad_menu_data = menu_build_manager.run()
----
--
--
----printSavedMenuData saved_quad_menu_data
--
