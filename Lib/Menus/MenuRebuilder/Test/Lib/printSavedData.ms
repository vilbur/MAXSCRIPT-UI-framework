
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
				printSourceMenuDictionary item_value indent:indent + "    "
			)
			else
			(
				format "%ITEM: % -> category: %, macro: %\n" indent key_name item_value[1] item_value[2]
			)
		)
	)

	ok -- return
)


/*  Prints saved menu item dictionary.
    Shows GUID, title, category, macro and nested submenu items.
*/
function printSavedMenuItems saved_items indent:"" =
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

			if classOf item_data == Dictionary and MenuRebuilder.hasDictValueSafe item_data #items then
			(
				format "%SUBMENU GUID: %\n" indent saved_guid
				format "%    title: %\n" indent item_data[#title]

				printSavedMenuItems item_data[#items] indent:indent + "    "
			)
			else if classOf item_data == Dictionary and MenuRebuilder.hasDictValueSafe item_data #macro then
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


/*  Prints saved root menu data.
    Root data contains version, id, title, type and items.
*/
function printSavedMenuData saved_menu_data =
(
	if saved_menu_data == undefined then
	(
		format "saved_menu_data: undefined\n"
	)
	else if classOf saved_menu_data != Dictionary then
	(
		format "saved_menu_data is not Dictionary: %\n" saved_menu_data
	)
	else
	(
		format "version: %\n" saved_menu_data[#version]
		format "id: %\n" saved_menu_data[#id]
		format "title: %\n" saved_menu_data[#title]
		format "type: %\n" saved_menu_data[#type]
		format "quad_context_id: %\n" saved_menu_data[#quad_context_id]
		format "quad_modifier: %\n" saved_menu_data[#quad_modifier]
		format "quad_position: %\n" saved_menu_data[#quad_position]
		format "quad_menu_id: %\n" saved_menu_data[#quad_menu_id]

		printSavedMenuItems saved_menu_data[#items]
	)

	ok -- return
)


