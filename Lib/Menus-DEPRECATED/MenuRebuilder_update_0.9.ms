/*
    MenuRebuilder.ms
    Version: 0.09
*/


/*  ====================================================================================================
    SECTION 01: GLOBALS
    ====================================================================================================
*/

global menu_rebuilder_file_version = 0.09
global MenuRebuilder
global MenuBuildManager


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
function createTestMacroDictionaryLevel level_index item_count:2 submenu_count:1 nested_level_count:1 macro_counter:#(0) macro_category:"_MENU_REBUILDER_TEST_CATEGORY" minimum_submenu_item_count:1 =
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
		macro_name = "_MENU_REBUILDER_TEST_MACRO_" + (macro_counter[1] as string)

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
    SECTION 03: MENU DEFINITION
    ====================================================================================================
*/


/*  Menu definition.
    Data can be Dictionary #string or array of MenuDefinition_v.
*/
struct MenuDefinition_v
(
	type = #menu,
	title = "",
	data = undefined,
	_data = undefined,
	quad_modifier = #shiftAndControlPressed,
	quad_position = #TopRight,
	quad_context_id = "ac7c70f8-3f86-4ff5-a510-e4fd6a9c368e",


	/*  Checks if value is Dictionary.
	    Used before dictionary operations.
	*/
	function isDictionaryValue value =
	(
		was_dictionary = false

		if value != undefined then
		(
			if classOf value == Dictionary then
			(
				was_dictionary = true
			)
		)

		was_dictionary -- return
	),


	/*  Checks if value is array.
	    Used for quad definitions array.
	*/
	function isArrayValue value =
	(
		was_array = false

		if value != undefined then
		(
			if classOf value == Array then
			(
				was_array = true
			)
		)

		was_array -- return
	),


	/*  Reads constructor alias _data.
	    Alias exists only to support typo-safe constructor calls.
	*/
	function readDataAlias =
	(
		if this._data != undefined then
		(
			this.data = this._data
		)

		this.data -- return
	),


	/*  Ensures data property is Dictionary #string.
	    Used for normal menu content.
	*/
	function ensureMenuData =
	(
		this.readDataAlias()

		if not this.isDictionaryValue this.data then
		(
			this.data = Dictionary #string
		)

		this.data -- return
	),


	/*  Ensures data property is array.
	    Used when definition owns multiple quad definitions.
	*/
	function ensureQuadData =
	(
		this.readDataAlias()

		if not this.isArrayValue this.data then
		(
			this.data = #()
		)

		this.data -- return
	),


	/*  Adds macro item to menu data.
	    Value is #(category, macro_name).
	*/
	function addItem category macro_name title:"" =
	(
		this.ensureMenuData()

		item_title = title

		if item_title == "" then
		(
			item_title = macro_name
		)

		this.data[item_title] = #(category, macro_name)

		this -- return
	),


	/*  Adds submenu definition to menu data.
	    Returns new submenu definition instance.
	*/
	function addMenu title =
	(
		this.ensureMenuData()

		menu_definition = MenuDefinition_v \
			type:#menu \
			title:title

		this.data[title] = menu_definition.data

		menu_definition -- return
	),


	/*  Adds quad quadrant definition.
	    Parent data becomes array of MenuDefinition_v.
	*/
	function addQuad title position:#TopRight =
	(
		this.ensureQuadData()

		quad_definition = MenuDefinition_v \
			type:#quad \
			title:title \
			quad_modifier:this.quad_modifier \
			quad_position:position \
			quad_context_id:this.quad_context_id

		append this.data quad_definition

		quad_definition -- return
	),


	on create do
	(
		this.readDataAlias()

		if this.data == undefined then
		(
			this.data = Dictionary #string
		)
	)
)


/*  ====================================================================================================
    SECTION 04: MENU REBUILDER
    ====================================================================================================
*/


/*  Menu rebuilder.
    Pure worker: rebuilds saved menu_data into passed menu manager or quad menu manager.
*/
struct MenuRebuilder_v
(
	version = 0.09,
	menu_data = Dictionary #name,
	help_menu_id = "cee8f758-2199-411b-81e7-d3ff4a80d143",
	macro_action_table_id = 647394,


	/*  Checks if value is Dictionary.
	    Prevents dictionary operation crashes.
	*/
	function isDictionaryValue value =
	(
		was_dictionary = false

		if value != undefined then
		(
			if classOf value == Dictionary then
			(
				was_dictionary = true
			)
		)

		was_dictionary -- return
	),


	/*  Checks if value is array.
	    Used for quad quadrant array.
	*/
	function isArrayValue value =
	(
		was_array = false

		if value != undefined then
		(
			if classOf value == Array then
			(
				was_array = true
			)
		)

		was_array -- return
	),


	/*  Creates new guid string.
	    Used only as fallback when saved data is incomplete.
	*/
	function createGuidString =
	(
		guid_class = dotNetClass "System.Guid"
		guid_value = guid_class.NewGuid()

		guid_value.ToString() -- return
	),


	/*  Safely checks dictionary key.
	    Prevents #name key crash on Dictionary #string.
	*/
	function hasDictValueSafe dictionary_value dictionary_key =
	(
		was_found = false

		if this.isDictionaryValue dictionary_value then
		(
			try
			(
				was_found = HasDictValue dictionary_value dictionary_key
			)
			catch
			(
				was_found = false
			)
		)

		was_found -- return
	),


	/*  Gets root data value safely.
	    Returns default value when key is missing.
	*/
	function getMenuDataValue dictionary_key default_value =
	(
		value = default_value

		if this.hasDictValueSafe this.menu_data dictionary_key then
		(
			value = this.menu_data[dictionary_key]
		)

		value -- return
	),


	/*  Gets saved menu id.
	    Same id is used to delete and recreate main menu or quad root.
	*/
	function getMenuId =
	(
		menu_id = this.getMenuDataValue #id ""

		if menu_id == "" then
		(
			menu_id = this.createGuidString()
			this.menu_data[#id] = menu_id
		)

		menu_id -- return
	),


	/*  Gets saved menu title.
	    Empty title means menu is invalid and must not be created.
	*/
	function getMenuTitle =
	(
		this.getMenuDataValue #title "" -- return
	),


	/*  Checks if saved menu has valid title.
	    No title means no menu creation.
	*/
	function hasValidMenuTitle =
	(
		menu_title = this.getMenuTitle()

		menu_title != "" -- return
	),


	/*  Gets saved menu items.
	    Used for normal menu or single quadrant quad menu.
	*/
	function getMenuItems =
	(
		menu_items = this.getMenuDataValue #items (Dictionary #string)

		if not this.isDictionaryValue menu_items then
		(
			menu_items = Dictionary #string
		)

		menu_items -- return
	),


	/*  Gets saved quad context id.
	    Default is viewport context.
	*/
	function getQuadContextId =
	(
		this.getMenuDataValue #quad_context_id "ac7c70f8-3f86-4ff5-a510-e4fd6a9c368e" -- return
	),


	/*  Gets saved quad modifier.
	    Used by quad rebuild only.
	*/
	function getQuadModifier =
	(
		this.getMenuDataValue #quad_modifier #shiftAndControlPressed -- return
	),


	/*  Gets saved quad position.
	    Used by single quadrant quad rebuild only.
	*/
	function getQuadPosition =
	(
		this.getMenuDataValue #quad_position #TopRight -- return
	),


	/*  Gets saved quad quadrant id.
	    Used by single quadrant quad rebuild only.
	*/
	function getQuadMenuId =
	(
		quad_menu_id = this.getMenuDataValue #quad_menu_id ""

		if quad_menu_id == "" then
		(
			quad_menu_id = this.createGuidString()
			this.menu_data[#quad_menu_id] = quad_menu_id
		)

		quad_menu_id -- return
	),


	/*  Gets saved quad quadrant array.
	    Used for multi-quadrant quad menus.
	*/
	function getQuadMenus =
	(
		quad_menus = this.getMenuDataValue #quad_menus #()

		if not this.isArrayValue quad_menus then
		(
			quad_menus = #()
		)

		quad_menus -- return
	),


	/*  Checks if saved item is submenu.
	    Submenu item has #items key.
	*/
	function isSubMenuData item_data =
	(
		was_found = false

		if this.isDictionaryValue item_data then
		(
			was_found = this.hasDictValueSafe item_data #items
		)

		was_found -- return
	),


	/*  Checks if saved item is macro item.
	    Macro item has #category and #macro keys.
	*/
	function isMacroItemData item_data =
	(
		was_found = false

		if this.isDictionaryValue item_data then
		(
			was_found = this.hasDictValueSafe item_data #category

			if was_found then
			(
				was_found = this.hasDictValueSafe item_data #macro
			)
		)

		was_found -- return
	),


	/*  Builds persistent macro action id.
	    Format is macro name, backtick, category.
	*/
	function getMacroActionId macro_category macro_name =
	(
		persistent_action_id = macro_name + "`" + macro_category

		persistent_action_id -- return
	),


	/*  Rebuilds menu items from saved dictionary.
	    Dictionary key is reused as CUI item guid.
	*/
	function rebuildMenuItems parent_menu saved_items =
	(
		if not this.isDictionaryValue saved_items then
		(
			format "MenuRebuilder_v.rebuildMenuItems skipped. saved_items is not Dictionary: %\n" saved_items
			false -- return
		)
		else
		(
			saved_guid_array = GetDictKeys saved_items

			for saved_guid in saved_guid_array do
			(
				item_data = saved_items[saved_guid]

				if this.isSubMenuData item_data then
				(
					submenu_title = item_data[#title]
					submenu_items = item_data[#items]

					submenu_menu = parent_menu.CreateSubMenu saved_guid submenu_title

					if submenu_menu != undefined then
					(
						this.rebuildMenuItems submenu_menu submenu_items
					)
				)
				else if this.isMacroItemData item_data then
				(
					macro_category = item_data[#category]
					macro_name = item_data[#macro]
					persistent_action_id = this.getMacroActionId macro_category macro_name

					parent_menu.CreateAction saved_guid this.macro_action_table_id persistent_action_id
				)
				else
				(
					format "MenuRebuilder_v skipped invalid item data at guid: % value: %\n" saved_guid item_data
				)
			)

			true -- return
		)
	),


	/*  Deletes root main menu by saved id.
	    This is only for normal menu bar menu.
	*/
	function deleteMainMenu main_menu_bar =
	(
		was_deleted = false
		menu_id = this.getMenuId()

		if menu_id != "" then
		(
			try
			(
				was_deleted = main_menu_bar.DeleteItem menu_id
			)
			catch
			(
				was_deleted = false
			)
		)

		was_deleted -- return
	),


	/*  Rebuilds saved data as normal menu bar menu.
	    This must be called only from #cuiRegisterMenus.
	*/
	function rebuildAsMainMenu menu_manager =
	(
		if not this.hasValidMenuTitle() then
		(
			format "MenuRebuilder_v.rebuildAsMainMenu skipped. Missing menu title.\n"
			false -- return
		)
		else if menu_manager == undefined then
		(
			format "MenuRebuilder_v.rebuildAsMainMenu failed. menu_manager is undefined.\n"
			false -- return
		)
		else
		(
			main_menu_bar = menu_manager.mainMenuBar
			menu_id = this.getMenuId()
			menu_title = this.getMenuTitle()
			menu_items = this.getMenuItems()

			this.deleteMainMenu main_menu_bar

			root_menu = main_menu_bar.CreateSubMenu menu_id menu_title beforeId:this.help_menu_id

			if root_menu != undefined then
			(
				this.rebuildMenuItems root_menu menu_items
			)

			true -- return
		)
	),


	/*  Gets quad context from quad menu manager.
	    This must be called only from #cuiRegisterQuadMenus.
	*/
	function getQuadContext quad_menu_manager =
	(
		quad_context = undefined

		if quad_menu_manager != undefined then
		(
			try
			(
				quad_context = quad_menu_manager.GetContextById (this.getQuadContextId())
			)
			catch
			(
				quad_context = undefined
			)
		)

		quad_context -- return
	),


	/*  Creates custom quad root menu.
	    This does not touch normal menu bar.
	*/
	function createQuadRootMenu quad_context =
	(
		quad_menu = undefined

		if not this.hasValidMenuTitle() then
		(
			format "MenuRebuilder_v.createQuadRootMenu skipped. Missing menu title.\n"
		)
		else if quad_context != undefined then
		(
			try
			(
				quad_menu = quad_context.CreateQuadMenu (this.getMenuId()) (this.getMenuTitle())

				if quad_menu != undefined then
				(
					quad_context.SetRightClickModifiers quad_menu (this.getQuadModifier())
				)
			)
			catch
			(
				quad_menu = undefined
			)
		)

		quad_menu -- return
	),


	/*  Rebuilds one quad quadrant.
	    Quad menu position menu receives saved item dictionary.
	*/
	function rebuildQuadPositionMenu quad_menu quad_title quad_position_value quad_menu_id_value quad_items_value =
	(
		quad_position_menu = undefined

		if quad_menu != undefined then
		(
			try
			(
				quad_position_menu = quad_menu.CreateMenu quad_menu_id_value quad_title quad_position_value
			)
			catch
			(
				quad_position_menu = undefined
			)

			if quad_position_menu != undefined then
			(
				this.rebuildMenuItems quad_position_menu quad_items_value
			)
		)

		quad_position_menu -- return
	),


	/*  Rebuilds saved data as quad menu.
	    This must be called only from #cuiRegisterQuadMenus.
	*/
	function rebuildAsQuadMenu quad_menu_manager =
	(
		if not this.hasValidMenuTitle() then
		(
			format "MenuRebuilder_v.rebuildAsQuadMenu skipped. Missing menu title.\n"
			false -- return
		)
		else if quad_menu_manager == undefined then
		(
			format "MenuRebuilder_v.rebuildAsQuadMenu failed. quad_menu_manager is undefined.\n"
			false -- return
		)
		else
		(
			quad_context = this.getQuadContext quad_menu_manager
			quad_menu = this.createQuadRootMenu quad_context
			quad_menus = this.getQuadMenus()

			if quad_menu != undefined then
			(
				if quad_menus.count > 0 then
				(
					for quad_data in quad_menus do
					(
						quad_title = quad_data[#title]
						quad_position_value = quad_data[#quad_position]
						quad_menu_id_value = quad_data[#quad_menu_id]
						quad_items_value = quad_data[#items]

						this.rebuildQuadPositionMenu quad_menu quad_title quad_position_value quad_menu_id_value quad_items_value
					)
				)
				else
				(
					this.rebuildQuadPositionMenu quad_menu (this.getMenuTitle()) (this.getQuadPosition()) (this.getQuadMenuId()) (this.getMenuItems())
				)
			)

			true -- return
		)
	),


	on create do
	(
		ok
	)
)


/*  ====================================================================================================
    SECTION 05: JSON IO
    ====================================================================================================
*/


struct MenuJsonIO_v
(
	json_text = "",
	json_position = 1,
	json_length = 0,


	/*  Checks if value is Dictionary.
	    Used before dictionary operations.
	*/
	function isDictionaryValue value =
	(
		was_dictionary = false

		if value != undefined then
		(
			if classOf value == Dictionary then
			(
				was_dictionary = true
			)
		)

		was_dictionary -- return
	),


	/*  Safely checks dictionary key.
	    Key type must match dictionary type.
	*/
	function hasDictValueSafe dictionary_value dictionary_key =
	(
		was_found = false

		if this.isDictionaryValue dictionary_value then
		(
			try
			(
				was_found = HasDictValue dictionary_value dictionary_key
			)
			catch
			(
				was_found = false
			)
		)

		was_found -- return
	),


	/*  Gets JSON object string key value.
	    Returns default value if key is missing.
	*/
	function getJsonValue json_object key_string default_value =
	(
		result_value = default_value

		if this.hasDictValueSafe json_object key_string then
		(
			result_value = json_object[key_string]
		)

		result_value -- return
	),


	/*  Converts name value to clean string.
	    Removes leading # from name string.
	*/
	function nameToText name_value default_text:"" =
	(
		text_value = default_text

		if name_value != undefined then
		(
			text_value = name_value as string

			if text_value.count > 0 then
			(
				if substring text_value 1 1 == "#" then
				(
					text_value = substring text_value 2 (text_value.count - 1)
				)
			)
		)

		text_value -- return
	),


	/*  Converts string to menu type name.
	    Used after loading JSON.
	*/
	function textToMenuType text_value =
	(
		menu_type_value = #menu

		if text_value == "quad" then
		(
			menu_type_value = #quad
		)
		else if text_value == "#quad" then
		(
			menu_type_value = #quad
		)
		else if text_value == "QUAD" then
		(
			menu_type_value = #quad
		)
		else if text_value == "#QUAD" then
		(
			menu_type_value = #quad
		)
		else if text_value == "both" then
		(
			menu_type_value = #both
		)
		else if text_value == "#both" then
		(
			menu_type_value = #both
		)
		else if text_value == "BOTH" then
		(
			menu_type_value = #both
		)
		else if text_value == "#BOTH" then
		(
			menu_type_value = #both
		)

		menu_type_value -- return
	),


	/*  Converts string to quad modifier name.
	    Used after loading JSON.
	*/
	function textToQuadModifier text_value =
	(
		modifier_value = #shiftAndControlPressed

		if text_value == "nonePressed" then
		(
			modifier_value = #nonePressed
		)
		else if text_value == "shiftPressed" then
		(
			modifier_value = #shiftPressed
		)
		else if text_value == "controlPressed" then
		(
			modifier_value = #controlPressed
		)
		else if text_value == "altPressed" then
		(
			modifier_value = #altPressed
		)
		else if text_value == "shiftAndControlPressed" then
		(
			modifier_value = #shiftAndControlPressed
		)

		modifier_value -- return
	),


	/*  Converts string to quad position name.
	    Used after loading JSON.
	*/
	function textToQuadPosition text_value =
	(
		position_value = #TopRight

		if text_value == "TopLeft" then
		(
			position_value = #TopLeft
		)
		else if text_value == "TopRight" then
		(
			position_value = #TopRight
		)
		else if text_value == "BottomLeft" then
		(
			position_value = #BottomLeft
		)
		else if text_value == "BottomRight" then
		(
			position_value = #BottomRight
		)

		position_value -- return
	),


	/*  Escapes string for JSON.
	    Used by JSON writer.
	*/
	function escapeJsonString source_string =
	(
		escaped_string = source_string

		if escaped_string == undefined then
		(
			escaped_string = ""
		)

		escaped_string = escaped_string as string
		escaped_string = substituteString escaped_string "\\" "\\\\"
		escaped_string = substituteString escaped_string "\"" "\\\""
		escaped_string = substituteString escaped_string "\t" "\\t"
		escaped_string = substituteString escaped_string "\n" "\\n"
		escaped_string = substituteString escaped_string "\r" "\\r"

		escaped_string -- return
	),


	/*  Writes JSON string value.
	    Adds quotes and escaping.
	*/
	function stringToJson source_string =
	(
		"\"" + this.escapeJsonString source_string + "\"" -- return
	),


	/*  Serializes saved item dictionary to JSON.
	    Saved item is macro item or submenu item.
	*/
	function savedItemToJson item_data indent:"" =
	(
		json_value = ""

		if this.hasDictValueSafe item_data #items then
		(
			json_value += indent + "{\n"
			json_value += indent + "\t\"title\": " + this.stringToJson item_data[#title] + ",\n"
			json_value += indent + "\t\"items\": "
			json_value += this.savedItemsToJson item_data[#items] indent:(indent + "\t")
			json_value += "\n" + indent + "}"
		)
		else
		(
			json_value += indent + "{\n"
			json_value += indent + "\t\"title\": " + this.stringToJson item_data[#title] + ",\n"
			json_value += indent + "\t\"category\": " + this.stringToJson item_data[#category] + ",\n"
			json_value += indent + "\t\"macro\": " + this.stringToJson item_data[#macro] + "\n"
			json_value += indent + "}"
		)

		json_value -- return
	),


	/*  Serializes saved items dictionary to JSON.
	    Dictionary keys are saved CUI GUID strings.
	*/
	function savedItemsToJson saved_items indent:"" =
	(
		json_value = "{\n"

		if this.isDictionaryValue saved_items then
		(
			saved_guid_array = GetDictKeys saved_items

			for saved_index = 1 to saved_guid_array.count do
			(
				saved_guid = saved_guid_array[saved_index]
				item_data = saved_items[saved_guid]

				json_value += indent + "\t" + this.stringToJson saved_guid + ": "
				json_value += this.savedItemToJson item_data indent:(indent + "\t")

				if saved_index < saved_guid_array.count then
				(
					json_value += ","
				)

				json_value += "\n"
			)
		)

		json_value += indent + "}"

		json_value -- return
	),


	/*  Serializes quad quadrant data to JSON.
	    Quad data contains title, position, id and items.
	*/
	function quadMenuToJson quad_data indent:"" =
	(
		json_value = ""

		json_value += indent + "{\n"
		json_value += indent + "\t\"title\": " + this.stringToJson quad_data[#title] + ",\n"
		json_value += indent + "\t\"quad_position\": " + this.stringToJson (this.nameToText quad_data[#quad_position] default_text:"TopRight") + ",\n"
		json_value += indent + "\t\"quad_menu_id\": " + this.stringToJson quad_data[#quad_menu_id] + ",\n"
		json_value += indent + "\t\"items\": "
		json_value += this.savedItemsToJson quad_data[#items] indent:(indent + "\t")
		json_value += "\n" + indent + "}"

		json_value -- return
	),


	/*  Serializes quad quadrant array to JSON.
	    Used by multi-quadrant quad menu data.
	*/
	function quadMenusToJson quad_menus indent:"" =
	(
		json_value = "[\n"

		for quad_index = 1 to quad_menus.count do
		(
			json_value += this.quadMenuToJson quad_menus[quad_index] indent:(indent + "\t")

			if quad_index < quad_menus.count then
			(
				json_value += ","
			)

			json_value += "\n"
		)

		json_value += indent + "]"

		json_value -- return
	),


	/*  Serializes saved root menu data to JSON.
	    This is one menu object.
	*/
	function menuDataToJson menu_data =
	(
		json_value = "{\n"

		json_value += "\t\"version\": " + (menu_data[#version] as string) + ",\n"
		json_value += "\t\"id\": " + this.stringToJson menu_data[#id] + ",\n"
		json_value += "\t\"title\": " + this.stringToJson menu_data[#title] + ",\n"
		json_value += "\t\"type\": " + this.stringToJson (this.nameToText menu_data[#type] default_text:"menu") + ",\n"
		json_value += "\t\"quad_context_id\": " + this.stringToJson menu_data[#quad_context_id] + ",\n"
		json_value += "\t\"quad_modifier\": " + this.stringToJson (this.nameToText menu_data[#quad_modifier] default_text:"shiftAndControlPressed") + ",\n"
		json_value += "\t\"quad_position\": " + this.stringToJson (this.nameToText menu_data[#quad_position] default_text:"TopRight") + ",\n"
		json_value += "\t\"quad_menu_id\": " + this.stringToJson menu_data[#quad_menu_id] + ",\n"

		if this.hasDictValueSafe menu_data #quad_menus then
		(
			json_value += "\t\"quad_menus\": "
			json_value += this.quadMenusToJson menu_data[#quad_menus] indent:"\t"
			json_value += ",\n"
		)
		else
		(
			json_value += "\t\"quad_menus\": [],\n"
		)

		json_value += "\t\"items\": "
		json_value += this.savedItemsToJson menu_data[#items] indent:"\t"
		json_value += "\n}"

		json_value -- return
	),


	/*  Serializes multiple saved menu data dictionaries to JSON.
	    JSON root contains array named menus.
	*/
	function menusDataToJson menus_data_array =
	(
		json_value = "{\n"

		json_value += "\t\"version\": 0.09,\n"
		json_value += "\t\"menus\": [\n"

		for menu_index = 1 to menus_data_array.count do
		(
			json_value += this.menuDataToJson menus_data_array[menu_index]

			if menu_index < menus_data_array.count then
			(
				json_value += ","
			)

			json_value += "\n"
		)

		json_value += "\t]\n"
		json_value += "}"

		json_value -- return
	),


	/*  Saves multiple saved menu data dictionaries to JSON file.
	    Used by MenuBuildManager_v.
	*/
	function saveMenusDataToJsonFile menus_data_array json_file_path =
	(
		json_value = this.menusDataToJson menus_data_array

		json_file = createFile json_file_path
		format "%" json_value to:json_file
		close json_file

		json_file_path -- return
	),


	/*  Saves single saved root menu data to JSON file.
	    Backward compatibility helper.
	*/
	function saveMenuDataToJsonFile menu_data json_file_path =
	(
		this.saveMenusDataToJsonFile #(menu_data) json_file_path -- return
	),


	/*  Reads entire text file.
	    Used by JSON loader.
	*/
	function readTextFile file_path =
	(
		file_text = ""

		if doesFileExist file_path then
		(
			text_file = openFile file_path mode:"rt"

			if text_file != undefined then
			(
				while not eof text_file do
				(
					file_text += readLine text_file

					if not eof text_file then
					(
						file_text += "\n"
					)
				)

				close text_file
			)
		)

		file_text -- return
	),


	/*  Initializes JSON parser.
	    Sets parser text and cursor position.
	*/
	function setJsonText source_text =
	(
		this.json_text = source_text
		this.json_position = 1
		this.json_length = this.json_text.count

		ok -- return
	),


	/*  Gets one character at current parser position.
	    Returns empty string at end.
	*/
	function getCurrentChar =
	(
		char_value = ""

		if this.json_position <= this.json_length then
		(
			char_value = substring this.json_text this.json_position 1
		)

		char_value -- return
	),


	/*  Skips whitespace in JSON.
	    Used before parsing every value.
	*/
	function skipJsonWhitespace =
	(
		while this.json_position <= this.json_length and findString " \t\r\n" this.getCurrentChar() != undefined do
		(
			this.json_position += 1
		)

		ok -- return
	),


	/*  Parses JSON string.
	    Supports common escape sequences.
	*/
	function parseJsonString =
	(
		result_string = ""

		if this.getCurrentChar() == "\"" then
		(
			this.json_position += 1

			while this.json_position <= this.json_length and this.getCurrentChar() != "\"" do
			(
				current_char = this.getCurrentChar()

				if current_char == "\\" then
				(
					this.json_position += 1
					escape_char = this.getCurrentChar()

					if escape_char == "\"" then
					(
						result_string += "\""
					)
					else if escape_char == "\\" then
					(
						result_string += "\\"
					)
					else if escape_char == "/" then
					(
						result_string += "/"
					)
					else if escape_char == "t" then
					(
						result_string += "\t"
					)
					else if escape_char == "n" then
					(
						result_string += "\n"
					)
					else if escape_char == "r" then
					(
						result_string += "\r"
					)
					else
					(
						result_string += escape_char
					)
				)
				else
				(
					result_string += current_char
				)

				this.json_position += 1
			)

			if this.getCurrentChar() == "\"" then
			(
				this.json_position += 1
			)
		)

		result_string -- return
	),


	/*  Parses JSON number.
	    Returns float.
	*/
	function parseJsonNumber =
	(
		number_text = ""

		while this.json_position <= this.json_length and findString "-+0123456789.eE" this.getCurrentChar() != undefined do
		(
			number_text += this.getCurrentChar()
			this.json_position += 1
		)

		number_value = number_text as float

		number_value -- return
	),


	/*  Parses JSON literal.
	    Supports true false null.
	*/
	function parseJsonLiteral =
	(
		result_value = undefined
		rest_text = substring this.json_text this.json_position (this.json_length - this.json_position + 1)

		if matchPattern rest_text pattern:"true*" then
		(
			this.json_position += 4
			result_value = true
		)
		else if matchPattern rest_text pattern:"false*" then
		(
			this.json_position += 5
			result_value = false
		)
		else if matchPattern rest_text pattern:"null*" then
		(
			this.json_position += 4
			result_value = undefined
		)

		result_value -- return
	),


	/*  Parses JSON array.
	    Returned as MaxScript array.
	*/
	function parseJsonArray =
	(
		array_value = #()

		if this.getCurrentChar() == "[" then
		(
			this.json_position += 1
			this.skipJsonWhitespace()

			while this.json_position <= this.json_length and this.getCurrentChar() != "]" do
			(
				append array_value (this.parseJsonValue())
				this.skipJsonWhitespace()

				if this.getCurrentChar() == "," then
				(
					this.json_position += 1
					this.skipJsonWhitespace()
				)
			)

			if this.getCurrentChar() == "]" then
			(
				this.json_position += 1
			)
		)

		array_value -- return
	),


	/*  Parses JSON object.
	    Returned as Dictionary #string.
	*/
	function parseJsonObject =
	(
		object_value = Dictionary #string

		if this.getCurrentChar() == "{" then
		(
			this.json_position += 1
			this.skipJsonWhitespace()

			while this.json_position <= this.json_length and this.getCurrentChar() != "}" do
			(
				key_string = this.parseJsonString()
				this.skipJsonWhitespace()

				if this.getCurrentChar() == ":" then
				(
					this.json_position += 1
				)

				this.skipJsonWhitespace()

				object_value[key_string] = this.parseJsonValue()

				this.skipJsonWhitespace()

				if this.getCurrentChar() == "," then
				(
					this.json_position += 1
					this.skipJsonWhitespace()
				)
			)

			if this.getCurrentChar() == "}" then
			(
				this.json_position += 1
			)
		)

		object_value -- return
	),


	/*  Parses any JSON value.
	    Returns string, float, bool, undefined, array or Dictionary #string.
	*/
	function parseJsonValue =
	(
		this.skipJsonWhitespace()

		current_char = this.getCurrentChar()
		result_value = undefined

		if current_char == "{" then
		(
			result_value = this.parseJsonObject()
		)
		else if current_char == "[" then
		(
			result_value = this.parseJsonArray()
		)
		else if current_char == "\"" then
		(
			result_value = this.parseJsonString()
		)
		else if findString "-+0123456789" current_char != undefined then
		(
			result_value = this.parseJsonNumber()
		)
		else
		(
			result_value = this.parseJsonLiteral()
		)

		result_value -- return
	),


	/*  Converts JSON item dictionary to saved item data.
	    Output item uses Dictionary #name keys.
	*/
	function jsonItemToSavedItem json_item =
	(
		item_data = Dictionary #name

		item_data[#title] = this.getJsonValue json_item "title" ""

		if this.hasDictValueSafe json_item "items" then
		(
			item_data[#items] = this.jsonItemsToSavedItems json_item["items"]
		)
		else
		(
			item_data[#category] = this.getJsonValue json_item "category" ""
			item_data[#macro] = this.getJsonValue json_item "macro" ""
		)

		item_data -- return
	),


	/*  Converts JSON items dictionary to saved items.
	    Output dictionary is Dictionary #string keyed by GUID.
	*/
	function jsonItemsToSavedItems json_items =
	(
		saved_items = Dictionary #string

		if this.isDictionaryValue json_items then
		(
			json_guid_array = GetDictKeys json_items

			for json_guid in json_guid_array do
			(
				saved_items[json_guid] = this.jsonItemToSavedItem json_items[json_guid]
			)
		)

		saved_items -- return
	),


	/*  Converts JSON quad quadrant object to Dictionary #name.
	    Used when loading multi-quadrant quad data.
	*/
	function jsonQuadMenuToData json_quad =
	(
		quad_data = Dictionary #name

		quad_data[#title] = this.getJsonValue json_quad "title" ""
		quad_data[#quad_position] = this.textToQuadPosition (this.getJsonValue json_quad "quad_position" "TopRight")
		quad_data[#quad_menu_id] = this.getJsonValue json_quad "quad_menu_id" ""
		quad_data[#items] = this.jsonItemsToSavedItems (this.getJsonValue json_quad "items" (Dictionary #string))

		quad_data -- return
	),


	/*  Converts JSON quad quadrant array to MaxScript array.
	    Each array item is Dictionary #name.
	*/
	function jsonQuadMenusToData json_quad_menus =
	(
		quad_menus = #()

		if classOf json_quad_menus == Array then
		(
			for json_quad in json_quad_menus do
			(
				append quad_menus (this.jsonQuadMenuToData json_quad)
			)
		)

		quad_menus -- return
	),


	/*  Converts parsed JSON root to saved menu data.
	    Missing title returns undefined.
	*/
	function jsonRootToMenuData json_root =
	(
		menu_data = undefined

		if this.isDictionaryValue json_root then
		(
			menu_title = this.getJsonValue json_root "title" ""

			if menu_title != "" then
			(
				menu_data = Dictionary #name

				menu_data[#version] = this.getJsonValue json_root "version" 0.09
				menu_data[#id] = this.getJsonValue json_root "id" ""
				menu_data[#title] = menu_title
				menu_data[#type] = this.textToMenuType (this.getJsonValue json_root "type" "menu")
				menu_data[#quad_context_id] = this.getJsonValue json_root "quad_context_id" "ac7c70f8-3f86-4ff5-a510-e4fd6a9c368e"
				menu_data[#quad_modifier] = this.textToQuadModifier (this.getJsonValue json_root "quad_modifier" "shiftAndControlPressed")
				menu_data[#quad_position] = this.textToQuadPosition (this.getJsonValue json_root "quad_position" "TopRight")
				menu_data[#quad_menu_id] = this.getJsonValue json_root "quad_menu_id" ""
				menu_data[#items] = this.jsonItemsToSavedItems (this.getJsonValue json_root "items" (Dictionary #string))

				if this.hasDictValueSafe json_root "quad_menus" then
				(
					menu_data[#quad_menus] = this.jsonQuadMenusToData json_root["quad_menus"]
				)
				else
				(
					menu_data[#quad_menus] = #()
				)
			)
		)

		menu_data -- return
	),


	/*  Converts parsed JSON root to array of saved menu data.
	    Supports multi-menu JSON and old single-menu JSON.
	*/
	function jsonRootToMenusData json_root =
	(
		menus_data_array = #()

		if this.isDictionaryValue json_root then
		(
			if this.hasDictValueSafe json_root "menus" then
			(
				json_menus_array = json_root["menus"]

				if classOf json_menus_array == Array then
				(
					for json_menu_data in json_menus_array do
					(
						menu_data = this.jsonRootToMenuData json_menu_data

						if menu_data != undefined then
						(
							append menus_data_array menu_data
						)
					)
				)
			)
			else
			(
				menu_data = this.jsonRootToMenuData json_root

				if menu_data != undefined then
				(
					append menus_data_array menu_data
				)
			)
		)

		menus_data_array -- return
	),


	/*  Loads multiple saved menu data dictionaries from JSON file.
	    Empty or missing file returns empty array.
	*/
	function loadMenusDataFromJsonFile json_file_path =
	(
		menus_data_array = #()

		if doesFileExist json_file_path then
		(
			source_text = this.readTextFile json_file_path

			if source_text.count > 0 then
			(
				this.setJsonText source_text

				json_root = this.parseJsonValue()
				menus_data_array = this.jsonRootToMenusData json_root
			)
		)

		menus_data_array -- return
	),


	/*  Loads first saved menu data dictionary from JSON file.
	    Backward compatibility helper.
	*/
	function loadMenuDataFromJsonFile json_file_path =
	(
		menus_data_array = this.loadMenusDataFromJsonFile json_file_path
		menu_data = Dictionary #name

		if menus_data_array.count > 0 then
		(
			menu_data = menus_data_array[1]
		)

		menu_data -- return
	),


	on create do
	(
		ok
	)
)


/*  ====================================================================================================
    SECTION 06: MENU BUILD MANAGER
    ====================================================================================================
*/


/*  Menu build manager.
    Owns definitions, saved JSON data, startup loader and callback routing.
*/
struct MenuBuildManager_v
(
	version = 0.09,
	menus_data = #(),
	saved_menus_data = #(),
	data_file_name = "MenuRebuilder_data.json",
	startup_file_name = "MenuRebuilder_startup.ms",
	data_file_path = "",
	startup_file_path = "",
	rebuilder_file_path = "",
	auto_register_callback = true,
	merge_existing_data = true,
	callback_id = #menuBuildManagerCuiRegisterMenus,
	quad_callback_id = #menuBuildManagerCuiRegisterQuadMenus,


	/*  Creates new guid string.
	    Used for saved root, menu item and quad ids.
	*/
	function createGuidString =
	(
		guid_class = dotNetClass "System.Guid"
		guid_value = guid_class.NewGuid()

		guid_value.ToString() -- return
	),


	/*  Checks if value is Dictionary.
	    Used before dictionary operations.
	*/
	function isDictionaryValue value =
	(
		was_dictionary = false

		if value != undefined then
		(
			if classOf value == Dictionary then
			(
				was_dictionary = true
			)
		)

		was_dictionary -- return
	),


	/*  Checks if value is array.
	    Used for MenuDefinition_v data arrays.
	*/
	function isArrayValue value =
	(
		was_array = false

		if value != undefined then
		(
			if classOf value == Array then
			(
				was_array = true
			)
		)

		was_array -- return
	),


	/*  Safely checks dictionary key.
	    Prevents #name key crash on Dictionary #string.
	*/
	function hasDictValueSafe dictionary_value dictionary_key =
	(
		was_found = false

		if this.isDictionaryValue dictionary_value then
		(
			try
			(
				was_found = HasDictValue dictionary_value dictionary_key
			)
			catch
			(
				was_found = false
			)
		)

		was_found -- return
	),


	/*  Gets default startup directory.
	    JSON data and startup loader are written there.
	*/
	function getDefaultStartupDirectory =
	(
		startup_directory = ""

		try
		(
			startup_directory = getDir #userStartupScripts
		)
		catch
		(
			startup_directory = getDir #userScripts + "\\startup"
		)

		try
		(
			makeDir startup_directory all:true
		)
		catch
		(
			ok
		)

		startup_directory -- return
	),


	/*  Gets current source file path.
	    Startup loader needs this to fileIn MenuRebuilder.ms.
	*/
	function getCurrentSourceFilePath =
	(
		source_file_path = ""

		try
		(
			source_file_path = getSourceFileName()
		)
		catch
		(
			source_file_path = ""
		)

		source_file_path -- return
	),


	/*  Normalizes menu type.
	    Accepts names and strings.
	*/
	function normalizeMenuType type_value =
	(
		normalized_type = #menu
		type_text = type_value as string

		if type_text == "#quad" then
		(
			normalized_type = #quad
		)
		else if type_text == "quad" then
		(
			normalized_type = #quad
		)
		else if type_text == "#QUAD" then
		(
			normalized_type = #quad
		)
		else if type_text == "QUAD" then
		(
			normalized_type = #quad
		)
		else if type_text == "#both" then
		(
			normalized_type = #both
		)
		else if type_text == "both" then
		(
			normalized_type = #both
		)
		else if type_text == "#BOTH" then
		(
			normalized_type = #both
		)
		else if type_text == "BOTH" then
		(
			normalized_type = #both
		)

		normalized_type -- return
	),


	/*  Gets data from MenuDefinition_v.
	    Supports both data: and _data: constructor names.
	*/
	function getDefinitionData menu_definition =
	(
		definition_data = menu_definition.data

		if menu_definition._data != undefined then
		(
			definition_data = menu_definition._data
		)

		definition_data -- return
	),


	/*  Creates saved macro item data.
	    Saved macro item contains #title #category #macro.
	*/
	function createSavedMacroItemData item_title macro_category macro_name =
	(
		item_data = Dictionary #name

		item_data[#title] = item_title
		item_data[#category] = macro_category
		item_data[#macro] = macro_name

		item_data -- return
	),


	/*  Creates saved submenu data.
	    Saved submenu contains #title #items.
	*/
	function createSavedSubMenuData submenu_title submenu_items =
	(
		submenu_data = Dictionary #name

		submenu_data[#title] = submenu_title
		submenu_data[#items] = submenu_items

		submenu_data -- return
	),


	/*  Checks if saved item is submenu.
	    Submenu item has #items key.
	*/
	function isSubMenuData item_data =
	(
		was_found = false

		if this.isDictionaryValue item_data then
		(
			was_found = this.hasDictValueSafe item_data #items
		)

		was_found -- return
	),


	/*  Checks if saved item is macro item.
	    Macro item has #category and #macro keys.
	*/
	function isMacroItemData item_data =
	(
		was_found = false

		if this.isDictionaryValue item_data then
		(
			was_found = this.hasDictValueSafe item_data #category

			if was_found then
			(
				was_found = this.hasDictValueSafe item_data #macro
			)
		)

		was_found -- return
	),


	/*  Checks if value is saved item data.
	    Saved item has #title and submenu or macro keys.
	*/
	function isSavedItemData item_data =
	(
		was_found = false

		if this.isDictionaryValue item_data then
		(
			was_found = this.hasDictValueSafe item_data #title

			if was_found then
			(
				if this.isSubMenuData item_data then
				(
					was_found = true
				)
				else
				(
					was_found = this.isMacroItemData item_data
				)
			)
		)

		was_found -- return
	),


	/*  Checks if dictionary is saved GUID item dictionary.
	    Saved values are Dictionary #name item data.
	*/
	function isSavedItemsDictionary dictionary_value =
	(
		was_found = false

		if this.isDictionaryValue dictionary_value then
		(
			dictionary_keys = GetDictKeys dictionary_value

			if dictionary_keys.count == 0 then
			(
				was_found = true
			)
			else
			(
				first_item_data = dictionary_value[dictionary_keys[1]]
				was_found = this.isSavedItemData first_item_data
			)
		)

		was_found -- return
	),


	/*  Converts simple title-key dictionary to saved GUID-key dictionary.
	    Source value is macro array or submenu dictionary.
	*/
	function convertSourceItemsToSavedItems source_items =
	(
		saved_items = Dictionary #string

		if this.isDictionaryValue source_items then
		(
			source_key_array = GetDictKeys source_items

			for source_title in source_key_array do
			(
				source_value = source_items[source_title]
				saved_guid = this.createGuidString()

				if this.isDictionaryValue source_value then
				(
					submenu_items = this.convertSourceItemsToSavedItems source_value
					saved_items[saved_guid] = this.createSavedSubMenuData source_title submenu_items
				)
				else if classOf source_value == Array then
				(
					if source_value.count >= 2 then
					(
						saved_items[saved_guid] = this.createSavedMacroItemData source_title source_value[1] source_value[2]
					)
				)
			)
		)

		saved_items -- return
	),


	/*  Normalizes menu items.
	    Accepts saved GUID format or simple title-key format.
	*/
	function normalizeMenuItems items_value =
	(
		normalized_items = Dictionary #string

		if this.isDictionaryValue items_value then
		(
			if this.isSavedItemsDictionary items_value then
			(
				normalized_items = items_value
			)
			else
			(
				normalized_items = this.convertSourceItemsToSavedItems items_value
			)
		)

		normalized_items -- return
	),


	/*  Builds empty saved root menu data.
	    Empty title returns undefined and no menu is generated.
	*/
	function createSavedRootData menu_definition definition_type =
	(
		root_data = undefined

		if menu_definition.title == "" then
		(
			format "MenuBuildManager_v.createSavedRootData skipped. Missing menu title.\n"
		)
		else
		(
			root_data = Dictionary #name

			root_data[#version] = this.version
			root_data[#id] = this.createGuidString()
			root_data[#title] = menu_definition.title
			root_data[#type] = definition_type
			root_data[#items] = Dictionary #string
			root_data[#quad_context_id] = menu_definition.quad_context_id
			root_data[#quad_modifier] = menu_definition.quad_modifier
			root_data[#quad_position] = menu_definition.quad_position
			root_data[#quad_menu_id] = this.createGuidString()
			root_data[#quad_menus] = #()
		)

		root_data -- return
	),


	/*  Builds one quad quadrant data from child MenuDefinition_v.
	    Output is Dictionary #name used inside #quad_menus array.
	*/
	function buildSavedQuadDataFromDefinition quad_definition =
	(
		quad_source_data = this.getDefinitionData quad_definition
		quad_data = Dictionary #name

		quad_data[#title] = quad_definition.title
		quad_data[#quad_position] = quad_definition.quad_position
		quad_data[#quad_menu_id] = this.createGuidString()
		quad_data[#items] = this.normalizeMenuItems quad_source_data

		quad_data -- return
	),


	/*  Builds saved quad root menu with multiple quadrants.
	    Definition data must be array of MenuDefinition_v.
	*/
	function buildSavedQuadRootDataFromDefinition menu_definition =
	(
		root_data = this.createSavedRootData menu_definition #quad

		if root_data != undefined then
		(
			root_data[#items] = Dictionary #string
			root_data[#quad_menus] = #()

			quad_definition_array = this.getDefinitionData menu_definition

			for quad_definition in quad_definition_array do
			(
				append root_data[#quad_menus] (this.buildSavedQuadDataFromDefinition quad_definition)
			)
		)

		root_data -- return
	),


	/*  Builds saved single menu or single quadrant quad root data.
	    Used when definition data is Dictionary #string.
	*/
	function buildSavedSingleRootDataFromDefinition menu_definition definition_type =
	(
		root_data = this.createSavedRootData menu_definition definition_type

		if root_data != undefined then
		(
			definition_data = this.getDefinitionData menu_definition

			root_data[#items] = this.normalizeMenuItems definition_data
			root_data[#quad_menus] = #()
		)

		root_data -- return
	),


	/*  Builds saved menu data from one MenuDefinition_v.
	    Empty title returns undefined.
	*/
	function buildSavedMenuDataFromDefinition menu_definition =
	(
		menu_data = undefined
		definition_type_value = menu_definition.type
		definition_type = this.normalizeMenuType definition_type_value
		definition_data = this.getDefinitionData menu_definition

		if definition_type == #quad then
		(
			if this.isArrayValue definition_data then
			(
				menu_data = this.buildSavedQuadRootDataFromDefinition menu_definition
			)
			else
			(
				menu_data = this.buildSavedSingleRootDataFromDefinition menu_definition #quad
			)
		)
		else
		(
			menu_data = this.buildSavedSingleRootDataFromDefinition menu_definition definition_type
		)

		if menu_data != undefined then
		(
			menu_data[#version] = this.version
		)

		menu_data -- return
	),


	/*  Builds saved menu data array from menus_data.
	    Invalid menu definitions with empty title are skipped.
	*/
	function buildSavedMenusData =
	(
		this.saved_menus_data = #()

		for menu_definition in this.menus_data do
		(
			menu_data = this.buildSavedMenuDataFromDefinition menu_definition

			if menu_data != undefined then
			(
				append this.saved_menus_data menu_data
			)
		)

		this.saved_menus_data -- return
	),


	/*  Loads saved menu data array from JSON.
	    Missing file returns empty array.
	*/
	function loadSavedMenusDataFromJson =
	(
		json_io = MenuJsonIO_v()
		json_io.loadMenusDataFromJsonFile this.data_file_path -- return
	),


	/*  Saves given menu data array to shared JSON file.
	    This is low level write method.
	*/
	function writeSavedMenusDataToJson menus_data_array =
	(
		json_io = MenuJsonIO_v()
		json_io.saveMenusDataToJsonFile menus_data_array this.data_file_path

		this.data_file_path -- return
	),


	/*  Clears shared JSON file.
	    File stays valid and contains empty menus array.
	*/
	function clearJsonFile =
	(
		this.saved_menus_data = #()
		this.writeSavedMenusDataToJson this.saved_menus_data

		format "Menu JSON file cleared:\n%\n" this.data_file_path

		this.saved_menus_data -- return
	),


	/*  Deletes all menus from JSON file.
	    Alias for clearJsonFile.
	*/
	function deleteAllMenusFromJson =
	(
		this.clearJsonFile() -- return
	),


	/*  Gets saved menu type from root data.
	    Defaults to #menu.
	*/
	function getSavedMenuType menu_data =
	(
		saved_type = #menu

		if this.isDictionaryValue menu_data then
		(
			if this.hasDictValueSafe menu_data #type then
			(
				saved_type = this.normalizeMenuType menu_data[#type]
			)
		)

		saved_type -- return
	),


	/*  Gets saved menu title.
	    Empty title means invalid menu data.
	*/
	function getSavedMenuTitle menu_data =
	(
		menu_title = ""

		if this.isDictionaryValue menu_data then
		(
			if this.hasDictValueSafe menu_data #title then
			(
				menu_title = menu_data[#title]
			)
		)

		menu_title -- return
	),


	/*  Checks if saved menu data has title.
	    Invalid data is skipped.
	*/
	function isValidSavedMenuData menu_data =
	(
		this.getSavedMenuTitle menu_data != "" -- return
	),


	/*  Checks if saved root data should be loaded by menu callback.
	    Only #menu and #both are allowed here.
	*/
	function isMenuCallbackData menu_data =
	(
		saved_type = this.getSavedMenuType menu_data

		if not this.isValidSavedMenuData menu_data then
		(
			false -- return
		)
		else if saved_type == #menu then
		(
			true -- return
		)
		else if saved_type == #both then
		(
			true -- return
		)
		else
		(
			false -- return
		)
	),


	/*  Checks if saved root data should be loaded by quad callback.
	    Only #quad and #both are allowed here.
	*/
	function isQuadCallbackData menu_data =
	(
		saved_type = this.getSavedMenuType menu_data

		if not this.isValidSavedMenuData menu_data then
		(
			false -- return
		)
		else if saved_type == #quad then
		(
			true -- return
		)
		else if saved_type == #both then
		(
			true -- return
		)
		else
		(
			false -- return
		)
	),


	/*  Gets signature for merge and delete.
	    Same type and same title replaces previous saved definition.
	*/
	function getMenuDataSignature menu_data =
	(
		signature = ""

		if this.isValidSavedMenuData menu_data then
		(
			menu_type_text = this.getSavedMenuType menu_data as string
			menu_title_text = this.getSavedMenuTitle menu_data

			signature = menu_type_text + "|" + menu_title_text
		)

		signature -- return
	),


	/*  Checks if string exists in array.
	    Used by JSON delete methods.
	*/
	function isStringInArray string_array string_value =
	(
		was_found = false

		for item_string in string_array while not was_found do
		(
			if item_string == string_value then
			(
				was_found = true
			)
		)

		was_found -- return
	),


	/*  Merges old and new saved menu data arrays.
	    New data replaces old data with same type and title.
	*/
	function mergeSavedMenusData old_menus_data new_menus_data =
	(
		merged_menus_data = #()

		for old_menu_data in old_menus_data do
		(
			old_signature = this.getMenuDataSignature old_menu_data

			if old_signature != "" then
			(
				append merged_menus_data old_menu_data
			)
		)

		for new_menu_data in new_menus_data do
		(
			new_signature = this.getMenuDataSignature new_menu_data

			if new_signature != "" then
			(
				replace_index = 0

				for menu_index = 1 to merged_menus_data.count while replace_index == 0 do
				(
					if this.getMenuDataSignature merged_menus_data[menu_index] == new_signature then
					(
						replace_index = menu_index
					)
				)

				if replace_index > 0 then
				(
					merged_menus_data[replace_index] = new_menu_data
				)
				else
				(
					append merged_menus_data new_menu_data
				)
			)
		)

		merged_menus_data -- return
	),


	/*  Deletes menu entries from JSON by signatures.
	    Signatures are built from type and title.
	*/
	function deleteMenusFromJsonBySignatures signatures =
	(
		old_menus_data = this.loadSavedMenusDataFromJson()
		new_menus_data = #()

		for menu_data in old_menus_data do
		(
			menu_signature = this.getMenuDataSignature menu_data

			if not this.isStringInArray signatures menu_signature then
			(
				append new_menus_data menu_data
			)
		)

		this.saved_menus_data = new_menus_data
		this.writeSavedMenusDataToJson this.saved_menus_data

		this.saved_menus_data -- return
	),


	/*  Builds current saved menu data.
	    No callbacks are registered here.
	*/
	function buildMenus =
	(
		if this.saved_menus_data.count == 0 then
		(
			this.buildSavedMenusData()
		)

		this.saved_menus_data -- return
	),


	/*  Saves saved menu data array to JSON file.
	    Existing JSON is merged by default so separate tools can add own menus.
	*/
	function saveJsonData =
	(
		json_io = MenuJsonIO_v()

		if this.saved_menus_data.count == 0 then
		(
			this.buildSavedMenusData()
		)

		if this.merge_existing_data then
		(
			old_menus_data = json_io.loadMenusDataFromJsonFile this.data_file_path
			this.saved_menus_data = this.mergeSavedMenusData old_menus_data this.saved_menus_data
		)

		json_io.saveMenusDataToJsonFile this.saved_menus_data this.data_file_path

		format "Menu JSON data saved to:\n%\n" this.data_file_path

		this.data_file_path -- return
	),


	/*  Creates startup loader script text.
	    Loader reads all menus from JSON and registers manager callbacks.
	*/
	function createStartupScriptText =
	(
		startup_text = ""

		startup_text += "/*\n"
		startup_text += "    Auto generated menu startup loader.\n"
		startup_text += "    Data file: " + this.data_file_path + "\n"
		startup_text += "*/\n\n"

		startup_text += "global MenuBuildManager\n\n"

		if this.rebuilder_file_path != "" then
		(
			startup_text += "try\n"
			startup_text += "(\n"
			startup_text += "\tfileIn @\"" + this.rebuilder_file_path + "\"\n"
			startup_text += ")\n"
			startup_text += "catch\n"
			startup_text += "(\n"
			startup_text += "\tformat \"Failed to fileIn MenuRebuilder file.\\n\"\n"
			startup_text += ")\n\n"
		)

		startup_text += "try\n"
		startup_text += "(\n"
		startup_text += "\tmenu_json_io = MenuJsonIO_v()\n"
		startup_text += "\tsaved_menus_data = menu_json_io.loadMenusDataFromJsonFile @\"" + this.data_file_path + "\"\n"
		startup_text += "\tMenuBuildManager = MenuBuildManager_v saved_menus_data:saved_menus_data merge_existing_data:false\n"
		startup_text += "\tMenuBuildManager.registerCallback()\n"
		startup_text += "\tformat \"Menu build manager callbacks registered from JSON data.\\n\"\n"
		startup_text += ")\n"
		startup_text += "catch\n"
		startup_text += "(\n"
		startup_text += "\tformat \"Menu rebuild from JSON failed.\\n\"\n"
		startup_text += ")\n"

		startup_text -- return
	),


	/*  Saves startup loader script.
	    Startup file contains code only, data stays in JSON.
	*/
	function saveStartupScript =
	(
		startup_text = this.createStartupScriptText()

		startup_file = createFile this.startup_file_path
		format "%" startup_text to:startup_file
		close startup_file

		format "Startup loader saved to:\n%\n" this.startup_file_path

		this.startup_file_path -- return
	),


	/*  Loads all normal menus from saved_menus_data.
	    Called only by #cuiRegisterMenus.
	*/
	function loadAllMenus =
	(
		menu_manager = callbacks.notificationParam()

		if menu_manager == undefined then
		(
			format "MenuBuildManager_v.loadAllMenus failed. menu_manager is undefined.\n"
		)
		else
		(
			for menu_data in this.saved_menus_data do
			(
				if this.isMenuCallbackData menu_data then
				(
					menu_rebuilder = MenuRebuilder_v menu_data:menu_data
					menu_rebuilder.rebuildAsMainMenu menu_manager
				)
			)
		)

		ok -- return
	),


	/*  Loads all quad menus from saved_menus_data.
	    Called only by #cuiRegisterQuadMenus.
	*/
	function loadAllQuadMenus =
	(
		quad_menu_manager = callbacks.notificationParam()

		if quad_menu_manager == undefined then
		(
			format "MenuBuildManager_v.loadAllQuadMenus failed. quad_menu_manager is undefined.\n"
		)
		else
		(
			for menu_data in this.saved_menus_data do
			(
				if this.isQuadCallbackData menu_data then
				(
					menu_rebuilder = MenuRebuilder_v menu_data:menu_data
					menu_rebuilder.rebuildAsQuadMenu quad_menu_manager
				)
			)
		)

		ok -- return
	),


	/*  Checks if manager needs normal menu callback.
	    True if any saved data type is #menu or #both.
	*/
	function hasMenuCallbackData =
	(
		was_found = false

		for menu_data in this.saved_menus_data while not was_found do
		(
			was_found = this.isMenuCallbackData menu_data
		)

		was_found -- return
	),


	/*  Checks if manager needs quad menu callback.
	    True if any saved data type is #quad or #both.
	*/
	function hasQuadCallbackData =
	(
		was_found = false

		for menu_data in this.saved_menus_data while not was_found do
		(
			was_found = this.isQuadCallbackData menu_data
		)

		was_found -- return
	),


	/*  Registers manager callbacks.
	    One callback handles all normal menus, one callback handles all quad menus.
	*/
	function registerCallback =
	(
		global MenuBuildManager

		if this.saved_menus_data.count == 0 then
		(
			this.buildSavedMenusData()
		)

		MenuBuildManager = this

		callbacks.removeScripts id:this.callback_id
		callbacks.removeScripts id:this.quad_callback_id

		if this.hasMenuCallbackData() then
		(
			callbacks.addScript #cuiRegisterMenus "MenuBuildManager.loadAllMenus()" id:this.callback_id
		)

		if this.hasQuadCallbackData() then
		(
			callbacks.addScript #cuiRegisterQuadMenus "MenuBuildManager.loadAllQuadMenus()" id:this.quad_callback_id
		)

		ok -- return
	),


	/*  Removes manager callbacks.
	    Existing already-created menus are not removed here.
	*/
	function unregisterCallback =
	(
		callbacks.removeScripts id:this.callback_id
		callbacks.removeScripts id:this.quad_callback_id

		ok -- return
	),


	/*  Builds menus, merges them into JSON, registers callbacks and saves startup loader.
	    Main manager entry point for all tools.
	*/
	function run =
	(
		this.buildMenus()
		this.saveJsonData()

		if this.auto_register_callback then
		(
			this.registerCallback()
		)

		this.saveStartupScript()

		this.saved_menus_data -- return
	),


	on create do
	(
		startup_directory = this.getDefaultStartupDirectory()

		if this.data_file_path == "" then
		(
			this.data_file_path = startup_directory + "\\" + this.data_file_name
		)

		if this.startup_file_path == "" then
		(
			this.startup_file_path = startup_directory + "\\" + this.startup_file_name
		)

		if this.rebuilder_file_path == "" then
		(
			this.rebuilder_file_path = this.getCurrentSourceFilePath()
		)
	)
)


/*  ====================================================================================================
    SECTION 07: JSON MANAGER ROLLOUT
    ====================================================================================================
*/


rollout MenuBuildManagerJsonRollout "Menu JSON Manager" width:470 height:390
(
	local json_manager = undefined
	local menu_title_array = #()
	local menu_signature_array = #()
	local quad_title_array = #()
	local quad_signature_array = #()

	label json_path_label "JSON:" pos:[10,10] width:440 height:16
	editText json_path_text "" pos:[10,28] width:450 height:18 readOnly:true

	groupBox menu_group "Menus from JSON" pos:[10,55] width:220 height:250
	multiListBox menu_multilist "" pos:[20,75] width:200 height:13 items:#()

	groupBox quad_group "Quad Menus from JSON" pos:[240,55] width:220 height:250
	multiListBox quad_multilist "" pos:[250,75] width:200 height:13 items:#()

	button refresh_button "Refresh" pos:[10,315] width:105 height:28
	button delete_selected_button "Delete Selected From JSON" pos:[125,315] width:165 height:28
	button delete_all_button "Delete All From JSON" pos:[300,315] width:160 height:28
	button clear_json_button "Clear JSON File" pos:[10,350] width:450 height:28


	/*  Creates rollout manager instance.
	    Uses default shared JSON file path.
	*/
	function getManager =
	(
		if json_manager == undefined then
		(
			json_manager = MenuBuildManager_v()
		)

		json_manager -- return
	),


	/*  Refreshes multilistboxes from JSON file.
	    Lists normal menus and quad menus separately.
	*/
	function refreshLists =
	(
		manager_value = this.getManager()
		json_path_text.text = manager_value.data_file_path

		menu_title_array = #()
		menu_signature_array = #()
		quad_title_array = #()
		quad_signature_array = #()

		menus_data_array = manager_value.loadSavedMenusDataFromJson()

		for menu_data in menus_data_array do
		(
			menu_title = manager_value.getSavedMenuTitle menu_data
			menu_type = manager_value.getSavedMenuType menu_data
			menu_signature = manager_value.getMenuDataSignature menu_data

			if menu_title != "" then
			(
				if menu_type == #menu or menu_type == #both then
				(
					append menu_title_array menu_title
					append menu_signature_array menu_signature
				)

				if menu_type == #quad or menu_type == #both then
				(
					append quad_title_array menu_title
					append quad_signature_array menu_signature
				)
			)
		)

		menu_multilist.items = menu_title_array
		menu_multilist.selection = #{}

		quad_multilist.items = quad_title_array
		quad_multilist.selection = #{}

		ok -- return
	),


	/*  Gets selected menu signatures from both multilistboxes.
	    Signatures are used to delete JSON entries.
	*/
	function getSelectedSignatures =
	(
		selected_signatures = #()

		for menu_index in menu_multilist.selection do
		(
			if menu_index > 0 and menu_index <= menu_signature_array.count then
			(
				append selected_signatures menu_signature_array[menu_index]
			)
		)

		for quad_index in quad_multilist.selection do
		(
			if quad_index > 0 and quad_index <= quad_signature_array.count then
			(
				append selected_signatures quad_signature_array[quad_index]
			)
		)

		selected_signatures -- return
	),


	/*  Deletes selected JSON entries.
	    Current already-created UI menus are not removed until CUI rebuild/restart.
	*/
	function deleteSelectedFromJson =
	(
		selected_signatures = this.getSelectedSignatures()

		if selected_signatures.count == 0 then
		(
			messageBox "No menu selected." title:"Menu JSON Manager"
		)
		else
		(
			manager_value = this.getManager()
			manager_value.deleteMenusFromJsonBySignatures selected_signatures
			this.refreshLists()
		)

		ok -- return
	),


	/*  Deletes all JSON entries.
	    JSON file remains valid with empty menus array.
	*/
	function deleteAllFromJson =
	(
		if queryBox "Delete all menu and quad menu entries from JSON file?" title:"Menu JSON Manager" then
		(
			manager_value = this.getManager()
			manager_value.deleteAllMenusFromJson()
			this.refreshLists()
		)

		ok -- return
	),


	on MenuBuildManagerJsonRollout open do
	(
		this.refreshLists()
	)

	on refresh_button pressed do
	(
		this.refreshLists()
	)

	on delete_selected_button pressed do
	(
		this.deleteSelectedFromJson()
	)

	on delete_all_button pressed do
	(
		this.deleteAllFromJson()
	)

	on clear_json_button pressed do
	(
		this.deleteAllFromJson()
	)
)


/*  Opens menu JSON manager rollout.
    Lists menus and quad menus stored in shared JSON file.
*/
function openMenuBuildManagerJsonRollout =
(
	try
	(
		destroyDialog MenuBuildManagerJsonRollout
	)
	catch
	(
		ok
	)

	createDialog MenuBuildManagerJsonRollout

	ok -- return
)


/*  ====================================================================================================
    SECTION 08: PRINT AND DEBUG HELPERS
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


/*  ====================================================================================================
    SECTION 09: COMPATIBILITY HELPERS
    ====================================================================================================
*/


/*  Creates saved menu data from test source dictionary.
    Compatibility helper for old createSavedTestMenuDataLevel calls.
*/
function createSavedTestMenuDataLevel level_index menu_title:"" item_count:2 submenu_count:1 nested_level_count:1 macro_counter:#(0) macro_category:"_MENU_REBUILDER_TEST_CATEGORY" minimum_submenu_item_count:1 =
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
    SECTION 10: TESTS
    ====================================================================================================
*/


/*  Tests normal menu definition.
    Creates public MenuDefinition_v with addItem and addMenu.
*/
function createTestMenuDefinition =
(
	menu_definition = MenuDefinition_v \
		type:#menu \
		title:"_MENU_REBUILDER_TEST_MENU"

	menu_definition.addItem "_MENU_REBUILDER_TEST_CATEGORY" "_MENU_REBUILDER_TEST_MACRO_1" title:"Menu Item 1"
	menu_definition.addItem "_MENU_REBUILDER_TEST_CATEGORY" "_MENU_REBUILDER_TEST_MACRO_2" title:"Menu Item 2"

	submenu_definition = menu_definition.addMenu "Submenu 1"
	submenu_definition.addItem "_MENU_REBUILDER_TEST_CATEGORY" "_MENU_REBUILDER_TEST_MACRO_3" title:"Submenu Item 1"

	menu_definition -- return
)


/*  Tests quad menu definition.
    Quad definition data is array of MenuDefinition_v quadrants.
*/
function createTestQuadDefinition =
(
	quad_definition = MenuDefinition_v \
		type:#quad \
		title:"_MENU_REBUILDER_TEST_QUAD"

	quad_definition.data = #()

	quad_top_right = quad_definition.addQuad "Top Right" position:#TopRight
	quad_top_right.addItem "_MENU_REBUILDER_TEST_CATEGORY" "_MENU_REBUILDER_TEST_MACRO_4" title:"Top Right Item"

	quad_top_left = quad_definition.addQuad "Top Left" position:#TopLeft
	quad_top_left.addItem "_MENU_REBUILDER_TEST_CATEGORY" "_MENU_REBUILDER_TEST_MACRO_5" title:"Top Left Item"

	quad_bottom_left = quad_definition.addQuad "Bottom Left" position:#BottomLeft
	quad_bottom_left.addItem "_MENU_REBUILDER_TEST_CATEGORY" "_MENU_REBUILDER_TEST_MACRO_6" title:"Bottom Left Item"

	quad_bottom_right = quad_definition.addQuad "Bottom Right" position:#BottomRight
	quad_bottom_right.addItem "_MENU_REBUILDER_TEST_CATEGORY" "_MENU_REBUILDER_TEST_MACRO_7" title:"Bottom Right Item"

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
		macro_category:"_MENU_REBUILDER_TEST_CATEGORY" \
		minimum_submenu_item_count:1

	test_macro_counter = #(0)

	simple_user_menu_data_quad = createTestMacroDictionaryLevel \
		0 \
		item_count:2 \
		submenu_count:1 \
		nested_level_count:1 \
		macro_counter:test_macro_counter \
		macro_category:"_MENU_REBUILDER_TEST_CATEGORY" \
		minimum_submenu_item_count:1

	menu_definition = MenuDefinition_v \
		type:#menu \
		title:"_MENU_REBUILDER_TEST_GENERATED_MENU" \
		data:simple_user_menu_data

	quad_definition = MenuDefinition_v \
		type:#quad \
		title:"_MENU_REBUILDER_TEST_GENERATED_QUAD"

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

	MenuBuildManager = MenuBuildManager_v()
	saved_menus_data = MenuBuildManager.loadSavedMenusDataFromJson()

	MenuBuildManager.saved_menus_data = saved_menus_data
	MenuBuildManager.merge_existing_data = false
	MenuBuildManager.registerCallback()

	saved_menus_data -- return
)


/*  Tests adding separate tool menus into same JSON file.
    Each run merges into shared JSON.
*/
function testMenuBuildManagerMultipleTools =
(
	first_menu_definition = MenuDefinition_v \
		type:#menu \
		title:"_MENU_REBUILDER_TOOL_A_MENU"

	first_menu_definition.addItem "_MENU_REBUILDER_TEST_CATEGORY" "_MENU_REBUILDER_TEST_MACRO_1" title:"Tool A Item"

	first_manager = MenuBuildManager_v menus_data:#(first_menu_definition)
	first_manager.run()

	second_menu_definition = MenuDefinition_v \
		type:#menu \
		title:"_MENU_REBUILDER_TOOL_B_MENU"

	second_menu_definition.addItem "_MENU_REBUILDER_TEST_CATEGORY" "_MENU_REBUILDER_TEST_MACRO_2" title:"Tool B Item"

	second_manager = MenuBuildManager_v menus_data:#(second_menu_definition)
	saved_menus_data = second_manager.run()

	saved_menus_data -- return
)


/*  ====================================================================================================
    SECTION 11: MANUAL TEST CALLS
    ====================================================================================================

    saved_menus_data = testMenuBuildManagerMass()
    printSavedMenusData saved_menus_data

    saved_menus_data = testMenuBuildManagerGenerated()
    printSavedMenusData saved_menus_data

    saved_menus_data = testMenuBuildManagerFromJson()
    printSavedMenusData saved_menus_data

    saved_menus_data = testMenuBuildManagerMultipleTools()
    printSavedMenusData saved_menus_data

    openMenuBuildManagerJsonRollout()

    menu_manager = MenuBuildManager_v()
    menu_manager.clearJsonFile()

*/