/*
MenuItem.ms
Version: 0.13
*/

struct MenuItem_v
(
	title = "",
	id = "",
	action_id = "",
	action_table_id = "",
	category = "",
	macro_name = "",
	class_name = "",
	index = 0,
	is_separator = false,
	is_action = false,
	is_submenu = false,
	source_item = undefined,

	/*
	Test if property exists on CUI object.
	Used before reading wrapper properties.
	*/
	function hasProperty source_object property_name =
	(
		(isProperty source_object property_name) -- return
	),

	/*
	Read property from CUI object.
	Returns undefined when property is not available.
	*/
	function getObjectProperty source_object property_name =
	(
		value = undefined

		if (hasProperty source_object property_name) then
		(
			value = getProperty source_object property_name
		)

		value -- return
	),

	/*
	Read first available string property from CUI object.
	*/
	function getFirstStringProperty source_object property_names =
	(
		result_string = ""

		for property_name in property_names while (result_string == "") do
		(
			value = getObjectProperty source_object property_name

			if (value != undefined) then
			(
				result_string = value as string
			)
		)

		result_string -- return
	),

	/*
	Read first available boolean property from CUI object.
	*/
	function getBooleanProperty source_object property_names =
	(
		result_value = false

		for property_name in property_names while (result_value == false) do
		(
			value = getObjectProperty source_object property_name

			if (value != undefined) then
			(
				result_value = value
			)
		)

		result_value -- return
	),

	/*
	Read menu item title from CUI item.
	*/
	function readTitleFromCuiItem cui_item =
	(
		result_title = getFirstStringProperty cui_item #(#title, #name, #label, #text, #buttonText)

		if (result_title == "") then
		(
			result_title = classOf cui_item as string
		)

		result_title -- return
	),

	/*
	Read item id from CUI item.
	Id is important for qmnx DeleteItem transformation.
	*/
	function readIdFromCuiItem cui_item =
	(
		result_id = getFirstStringProperty cui_item #(#id, #guid, #actionId, #persistentActionId, #persistentId)

		result_id -- return
	),

	/*
	Fill this struct from one CUI menu item.
	*/
	function readFromCuiItem cui_item item_index:0 =
	(
		source_item = cui_item
		index = item_index

		title = readTitleFromCuiItem cui_item
		id = readIdFromCuiItem cui_item
		action_id = getFirstStringProperty cui_item #(#actionId, #persistentActionId)
		action_table_id = getFirstStringProperty cui_item #(#actionTableId, #tableId)
		category = getFirstStringProperty cui_item #(#category, #macroCategory)
		macro_name = getFirstStringProperty cui_item #(#macroName, #macroScriptName)
		class_name = classOf cui_item as string

		is_separator = getBooleanProperty cui_item #(#isSeparator, #separator)
		is_action = getBooleanProperty cui_item #(#isAction, #action)
		is_submenu = getBooleanProperty cui_item #(#isSubMenu, #isSubmenu, #submenu)

		this -- return
	),

	/*
	Return compact debug line.
	Useful for listener tests.
	*/
	function asString =
	(
		("MenuItem_v title:\"" + title + "\" id:\"" + id + "\" action_id:\"" + action_id + "\"") -- return
	),

	on create do
	(
		if (source_item != undefined) then
		(
			readFromCuiItem source_item item_index:index
		)
	)
)