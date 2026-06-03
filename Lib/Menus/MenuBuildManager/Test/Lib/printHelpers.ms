/*  ====================================================================================================
    SECTION 07: PRINT AND DEBUG HELPERS
    ====================================================================================================
*/


/*  Prints simplified title-key menu dictionary.
    Used only for checking source test data.
*/
function printSourceMenuDictionary dictionary_value indent:"" =
(
	if dictionary_value == undefined then
	(
		format "%source dictionary is undefined\n" indent
	)
	else if classOf dictionary_value != Dictionary then
	(
		format "%source value is not Dictionary: %\n" indent dictionary_value
	)
	else
	(
		dictionary_keys = GetDictKeys dictionary_value

		for key_name in dictionary_keys do
		(
			item_value = dictionary_value[key_name]

			if classOf item_value == Dictionary then
			(
				format "%SUBMENU: %\n" indent key_name
				printSourceMenuDictionary item_value indent:(indent + "    ")
			)
			else
			(
				format "%ITEM: % -> category: %, macro: %\n" indent key_name item_value[1] item_value[2]
			)
		)
	)

	ok -- return
)


/*  Prints saved menu items structure.
    Shows GUID keys, action data and nested submenu data.
*/
function printSavedMenuItems saved_items indent:"" =
(
	if saved_items == undefined then
	(
		format "%saved_items is undefined\n" indent
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

			if classOf item_data == Dictionary then
			(
				try
				(
					if HasDictValue item_data #items then
					(
						format "%SUBMENU GUID: %\n" indent saved_guid
						format "%    title: %\n" indent item_data[#title]
						printSavedMenuItems item_data[#items] indent:(indent + "    ")
					)
					else
					(
						format "%ITEM GUID: %\n" indent saved_guid
						format "%    title: %\n" indent item_data[#title]
						format "%    category: %\n" indent item_data[#category]
						format "%    macro: %\n" indent item_data[#macro]
					)
				)
				catch
				(
					format "%INVALID GUID: % value: %\n" indent saved_guid item_data
				)
			)
			else
			(
				format "%INVALID GUID: % value: %\n" indent saved_guid item_data
			)
		)
	)

	ok -- return
)


/*  Prints saved quad quadrant array.
    Shows quadrant title, position and item data.
*/
function printSavedQuadMenus quad_menus indent:"" =
(
	if quad_menus == undefined then
	(
		format "%quad_menus is undefined\n" indent
	)
	else if classOf quad_menus != Array then
	(
		format "%quad_menus is not array: %\n" indent quad_menus
	)
	else
	(
		for quad_index = 1 to quad_menus.count do
		(
			quad_data = quad_menus[quad_index]

			format "%QUAD INDEX: %\n" indent quad_index
			format "%    title: %\n" indent quad_data[#title]
			format "%    quad_position: %\n" indent quad_data[#quad_position]
			format "%    quad_menu_id: %\n" indent quad_data[#quad_menu_id]

			printSavedMenuItems quad_data[#items] indent:(indent + "    ")
		)
	)

	ok -- return
)


/*  Prints one saved root menu data.
    Root data contains version, id, title, type and items.
*/
function printSavedMenuData saved_menu_data indent:"" =
(
	if saved_menu_data == undefined then
	(
		format "%saved_menu_data: undefined\n" indent
	)
	else if classOf saved_menu_data != Dictionary then
	(
		format "%saved_menu_data is not Dictionary: %\n" indent saved_menu_data
	)
	else
	(
		format "%version: %\n" indent saved_menu_data[#version]
		format "%id: %\n" indent saved_menu_data[#id]
		format "%title: %\n" indent saved_menu_data[#title]
		format "%type: %\n" indent saved_menu_data[#type]
		format "%quad_context_id: %\n" indent saved_menu_data[#quad_context_id]
		format "%quad_modifier: %\n" indent saved_menu_data[#quad_modifier]
		format "%quad_position: %\n" indent saved_menu_data[#quad_position]
		format "%quad_menu_id: %\n" indent saved_menu_data[#quad_menu_id]

		if HasDictValue saved_menu_data #quad_menus then
		(
			if saved_menu_data[#quad_menus].count > 0 then
			(
				printSavedQuadMenus saved_menu_data[#quad_menus] indent:(indent + "    ")
			)
		)

		printSavedMenuItems saved_menu_data[#items] indent:(indent + "    ")
	)

	ok -- return
)


/*  Prints array of saved menu root data.
    Used after MenuBuildManager_v.run.
*/
function printSavedMenusData saved_menus_data =
(
	if saved_menus_data == undefined then
	(
		format "saved_menus_data: undefined\n"
	)
	else if classOf saved_menus_data != Array then
	(
		format "saved_menus_data is not Array: %\n" saved_menus_data
	)
	else
	(
		for menu_index = 1 to saved_menus_data.count do
		(
			format "\n===== SAVED MENU DATA % =====\n" menu_index
			printSavedMenuData saved_menus_data[menu_index] indent:"    "
		)
	)

	ok -- return
)



