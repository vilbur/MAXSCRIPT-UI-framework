

/*  Menu build manager.
    Owns definitions, saved JSON data, startup loader and callback routing.
*/
struct MenuBuildManager_v
(
	version = 0.08,
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


	/*  Checks if saved root data should be loaded by menu callback.
	    Only #menu and #both are allowed here.
	*/
	function isMenuCallbackData menu_data =
	(
		saved_type = this.getSavedMenuType menu_data

		if saved_type == #menu then
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

		if saved_type == #quad then
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


	/*  Gets signature for merge.
	    Same type and same title replaces previous saved definition.
	*/
	function getMenuDataSignature menu_data =
	(
		signature = ""

		if this.isDictionaryValue menu_data then
		(
			menu_type_text = this.getSavedMenuType menu_data as string
			menu_title_text = ""

			if this.hasDictValueSafe menu_data #title then
			(
				menu_title_text = menu_data[#title]
			)

			signature = menu_type_text + "|" + menu_title_text
		)

		signature -- return
	),


	/*  Merges old and new saved menu data arrays.
	    New data replaces old data with same type and title.
	*/
	function mergeSavedMenusData old_menus_data new_menus_data =
	(
		merged_menus_data = #()

		for old_menu_data in old_menus_data do
		(
			append merged_menus_data old_menu_data
		)

		for new_menu_data in new_menus_data do
		(
			new_signature = this.getMenuDataSignature new_menu_data
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

		merged_menus_data -- return
	),


	/*  Builds current session callbacks.
	    One manager callback owns all menu definitions.
	*/
	function buildMenus =
	(
		if this.saved_menus_data.count == 0 then
		(
			this.buildSavedMenusData()
		)

		if this.auto_register_callback then
		(
			this.registerCallback()
		)

		this.saved_menus_data -- return
	),


	/*  Saves saved menu data array to JSON file.
	    Can merge with existing JSON to avoid overrides.
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
			if doesFileExist this.data_file_path then
			(
				old_menus_data = json_io.loadMenusDataFromJsonFile this.data_file_path
				this.saved_menus_data = this.mergeSavedMenusData old_menus_data this.saved_menus_data
			)
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


	/*  Builds menus, saves JSON data, saves startup loader.
	    Main manager entry point.
	*/
	function run =
	(
		this.buildMenus()
		this.saveJsonData()
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



