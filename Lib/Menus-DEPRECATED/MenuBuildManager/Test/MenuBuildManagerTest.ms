clearListener(); print("Cleared in: "+getSourceFileName())

global menu_rebuilder_file_version = 0.08
global MenuRebuilder
global MenuBuildManager


filein( getFilenamePath(getSourceFileName()) + "/Lib/printHelpers.ms" )	--"./Lib/printHelpers.ms"

filein( getFilenamePath(getSourceFileName()) + "/../MenuJsonIO.ms" )	--"./../MenuJsonIO.ms"

filein( getFilenamePath(getSourceFileName()) + "/../../MenuRebuilder/MenuRebuilder.ms" )	--"./../../MenuRebuilder/MenuRebuilder.ms"

filein( getFilenamePath(getSourceFileName()) + "/../../MenuDefinition/MenuDefinition.ms" )	--"./../../MenuDefinition/MenuDefinition.ms"

filein( getFilenamePath(getSourceFileName()) + "/../MenuBuildManager.ms" )	--"./../MenuBuildManager.ms"



--filein @"D:\Downloads\_AI\GPT\MenuRebuilder_update.ms"

filein( getFilenamePath(getSourceFileName()) + "/../../include-menus.ms" )	--"./../../include-menus.ms"


/*  ====================================================================================================
    SECTION 02: BASIC TEST HELPERS
    ====================================================================================================
*/


/*  Creates new guid string.
    Used by test helpers.
*/
function createMenuRebuilderGuidString =
(
	guid_class = dotNetClass "System.Guid"
	guid_value = guid_class.NewGuid()

	guid_value.ToString() -- return
)


/*  Generates and executes mock macroscript definition.
    Macro prints message when called from menu.
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


/*  Creates simplified test menu dictionary.
    Key is title string, value is macro array or nested submenu dictionary.
*/
function createTestMacroDictionaryLevel level_index item_count:2 submenu_count:1 nested_level_count:1 macro_counter:#(0) macro_category:"_TEST_CATEGORY" minimum_submenu_item_count:1 =
(
	dictionary_value = Dictionary #string
	level_item_count = item_count

	if level_index > 0 and level_item_count < minimum_submenu_item_count then
	(
		level_item_count = minimum_submenu_item_count
	)

	for item_index = 1 to level_item_count do
	(
		macro_counter[1] += 1

		title_string = "Item L" + (level_index as string) + "." + (item_index as string)
		macro_name = "_TEST_MACRO_" + (macro_counter[1] as string)

		generateMockMacroScript macro_category macro_name

		dictionary_value[title_string] = #(macro_category, macro_name)
	)

	if level_index < nested_level_count then
	(
		for submenu_index = 1 to submenu_count do
		(
			submenu_title_string = "Submenu L" + (level_index as string) + "." + (submenu_index as string)

			dictionary_value[submenu_title_string] = createTestMacroDictionaryLevel \
				(level_index + 1) \
				item_count:item_count \
				submenu_count:submenu_count \
				nested_level_count:nested_level_count \
				macro_counter:macro_counter \
				macro_category:macro_category \
				minimum_submenu_item_count:minimum_submenu_item_count
		)
	)

	dictionary_value -- return
)









/*  ====================================================================================================
    SECTION 08: COMPATIBILITY HELPERS
    ====================================================================================================
*/


/*  Creates saved menu data from test source dictionary.
    Compatibility helper for old createSavedTestMenuDataLevel calls.
*/
function createSavedTestMenuDataLevel level_index menu_title:"" item_count:2 submenu_count:1 nested_level_count:1 macro_counter:#(0) macro_category:"_TEST_CATEGORY" minimum_submenu_item_count:1 =
(
	source_menu_items = createTestMacroDictionaryLevel \
		level_index \
		item_count:item_count \
		submenu_count:submenu_count \
		nested_level_count:nested_level_count \
		macro_counter:macro_counter \
		macro_category:macro_category \
		minimum_submenu_item_count:minimum_submenu_item_count

	menu_definition = MenuDefinition_v \
		type:#menu \
		title:menu_title \
		data:source_menu_items

	menu_build_manager = MenuBuildManager_v menus_data:#(menu_definition)

	saved_menus_data = menu_build_manager.buildSavedMenusData()
	menu_data = undefined

	if saved_menus_data.count > 0 then
	(
		menu_data = saved_menus_data[1]
	)

	menu_data -- return
)



/*  ====================================================================================================
    SECTION 09: TESTS
    ====================================================================================================
*/


/*  Tests normal menu definition.
    Creates public MenuDefinition_v with addItem and addMenu.
*/
function createTestMenuDefinition =
(
	menu_definition = MenuDefinition_v \
		type:#menu \
		title:"_TEST_MENU_FROM_MANAGER"

	menu_definition.addItem "_TEST_CATEGORY" "_TEST_MACRO_1" title:"Menu Item 1"
	menu_definition.addItem "_TEST_CATEGORY" "_TEST_MACRO_2" title:"Menu Item 2"

	submenu_definition = menu_definition.addMenu "Submenu 1"
	submenu_definition.addItem "_TEST_CATEGORY" "_TEST_MACRO_3" title:"Submenu Item 1"

	menu_definition -- return
)


/*  Tests quad menu definition.
    Quad definition data is array of MenuDefinition_v quadrants.
*/
function createTestQuadDefinition =
(
	quad_definition = MenuDefinition_v \
		type:#quad \
		title:"_TEST_QUAD_FROM_MANAGER"

	quad_definition.data = #()

	quad_top_right = quad_definition.addQuad "Top Right" position:#TopRight
	quad_top_right.addItem "_TEST_CATEGORY" "_TEST_MACRO_4" title:"Top Right Item"

	quad_top_left = quad_definition.addQuad "Top Left" position:#TopLeft
	quad_top_left.addItem "_TEST_CATEGORY" "_TEST_MACRO_5" title:"Top Left Item"

	quad_bottom_left = quad_definition.addQuad "Bottom Left" position:#BottomLeft
	quad_bottom_left.addItem "_TEST_CATEGORY" "_TEST_MACRO_6" title:"Bottom Left Item"

	quad_bottom_right = quad_definition.addQuad "Bottom Right" position:#BottomRight
	quad_bottom_right.addItem "_TEST_CATEGORY" "_TEST_MACRO_7" title:"Bottom Right Item"

	quad_definition -- return
)


/*  Tests mass menu build manager.
    Builds normal menu and quad menu together.
*/
function testMenuBuildManagerMass =
(
	global MenuBuildManager

	menu_definition = createTestMenuDefinition()
	quad_definition = createTestQuadDefinition()

	menus_data = #(menu_definition, quad_definition)

	MenuBuildManager = MenuBuildManager_v menus_data:menus_data

	saved_menus_data = MenuBuildManager.run()

	saved_menus_data -- return
)


/*  Tests generated dictionary menu and quad definitions.
    Uses createTestMacroDictionaryLevel for both.
*/
function testMenuBuildManagerGenerated =
(
	global MenuBuildManager

	test_macro_counter = #(0)

	simple_user_menu_data = createTestMacroDictionaryLevel \
		0 \
		item_count:2 \
		submenu_count:1 \
		nested_level_count:1 \
		macro_counter:test_macro_counter \
		macro_category:"_TEST_CATEGORY" \
		minimum_submenu_item_count:1

	test_macro_counter = #(0)

	simple_user_menu_data_quad = createTestMacroDictionaryLevel \
		0 \
		item_count:2 \
		submenu_count:1 \
		nested_level_count:1 \
		macro_counter:test_macro_counter \
		macro_category:"_TEST_CATEGORY" \
		minimum_submenu_item_count:1

	menu_definition = MenuDefinition_v \
		type:#menu \
		title:"_TEST_MENU_FROM_MANAGER" \
		data:simple_user_menu_data

	quad_definition = MenuDefinition_v \
		type:#quad \
		title:"_TEST_QUAD_FROM_MANAGER"

	quad_definition.data = #()

	quad_top_right = quad_definition.addQuad "Top Right" position:#TopRight
	quad_top_right.data = simple_user_menu_data_quad

	menus_data = #(menu_definition, quad_definition)

	MenuBuildManager = MenuBuildManager_v menus_data:menus_data

	saved_menus_data = MenuBuildManager.run()

	saved_menus_data -- return
)


/*  Tests rebuild from JSON file.
    Loads saved data and registers manager callbacks.
*/
function testMenuBuildManagerFromJson =
(
	global MenuBuildManager

	json_io = MenuJsonIO_v()
	startup_directory = getDir #userStartupScripts
	json_file_path = startup_directory + "\\MenuRebuilder_data.json"

	saved_menus_data = json_io.loadMenusDataFromJsonFile json_file_path

	MenuBuildManager = MenuBuildManager_v \
		saved_menus_data:saved_menus_data \
		merge_existing_data:false

	MenuBuildManager.registerCallback()

	saved_menus_data -- return
)
/** Test menu build manager
 */
function testMenuBuildManager =
(
	--format "\n"; print ".testMenuBuildManager()"
	global MenuBuildManager

	test_macro_counter = #(0)

	simple_user_menu_data = createTestMacroDictionaryLevel \
		0 \
		item_count:2 \
		submenu_count:1 \
		nested_level_count:1 \
		macro_counter:test_macro_counter \
		macro_category:"_TEST_CATEGORY" \
		minimum_submenu_item_count:1


	menu_definition = MenuDefinition_v \
		type:#menu \
		title:"_TEST_MENU_FROM_MANAGER" \
		data:simple_user_menu_data


	MenuBuildManager = MenuBuildManager_v menus_data:#(menu_definition)

	saved_menus_data = MenuBuildManager.run()

	saved_menus_data -- return
)


/*  ====================================================================================================
    SECTION 10: MANUAL TEST CALLS
    ====================================================================================================

    saved_menus_data = testMenuBuildManagerMass()
    printSavedMenusData saved_menus_data

    saved_menus_data = testMenuBuildManagerGenerated()
    printSavedMenusData saved_menus_data

    saved_menus_data = testMenuBuildManagerFromJson()
    printSavedMenusData saved_menus_data

*/


--	testMenuBuildManager()
--
   testMenuBuildManagerMass()
--
--    testMenuBuildManagerGenerated()
--
--    testMenuBuildManagerFromJson()

	