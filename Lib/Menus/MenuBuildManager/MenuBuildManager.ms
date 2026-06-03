filein( getFilenamePath(getSourceFileName()) + "/MenuJsonIO.ms" )	--"./MenuJsonIO.ms"

filein( getFilenamePath(getSourceFileName()) + "/../MenuRebuilder/MenuRebuilder.ms" )	--"./../MenuRebuilder/MenuRebuilder.ms"

global MenuBuildManager

/*  Menu definition.
    Used by MenuBuildManager_v mass build.
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

	on create do
	(
	)
)


struct MenuBuildManager_v
(
	version = 0.05,
	menu_type = #menu,
	menu_title = "_TEST_MENU",
	user_menu_data = Dictionary #string,
	menus_data = #(),
	saved_menu_data = Dictionary #name,
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
	quad_context_id = "ac7c70f8-3f86-4ff5-a510-e4fd6a9c368e",
	quad_modifier = #shiftAndControlPressed,
	quad_position = #TopRight,


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


	/*  Normalizes menu type name.
	    Accepts #menu #MENU #quad #QUAD #both #BOTH.
	*/
	function normalizeMenuType type_value =
	(
		normalized_type = #menu

		if type_value == #quad or type_value == #QUAD then
		(
			normalized_type = #quad
		)
		else if type_value == #both or type_value == #BOTH then
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

		if this.isDictionaryValue menu_definition._data then
		(
			definition_data = menu_definition._data
		)

		definition_data -- return
	),


	/*  Builds saved menu data from one MenuDefinition_v.
	    Uses MenuRebuilder_v converter.
	*/
	function buildSavedMenuDataFromDefinition menu_definition =
	(
		definition_type = this.normalizeMenuType menu_definition.type
		definition_data = this.getDefinitionData menu_definition

		menu_rebuilder = MenuRebuilder_v \
			menu_type:definition_type \
			menu_title:menu_definition.title \
			menu_items:definition_data \
			quad_context_id:menu_definition.quad_context_id \
			quad_modifier:menu_definition.quad_modifier \
			quad_position:menu_definition.quad_position

		menu_data = menu_rebuilder.buildMenuData()
		menu_data[#version] = this.version

		menu_data -- return
	),


	/*  Builds saved menu data from old single manager parameters.
	    Kept for backward compatibility.
	*/
	function buildSingleMenuDefinition =
	(
		menu_definition = MenuDefinition_v \
			type:this.menu_type \
			title:this.menu_title \
			data:this.user_menu_data \
			quad_context_id:this.quad_context_id \
			quad_modifier:this.quad_modifier \
			quad_position:this.quad_position

		menu_definition -- return
	),


	/*  Builds saved menu data array.
	    Uses menus_data array if provided, otherwise uses old single parameters.
	*/
	function buildSavedMenusData =
	(
		this.saved_menus_data = #()

		if this.menus_data.count > 0 then
		(
			for menu_definition in this.menus_data do
			(
				append this.saved_menus_data (this.buildSavedMenuDataFromDefinition menu_definition)
			)
		)
		else
		(
			menu_definition = this.buildSingleMenuDefinition()
			append this.saved_menus_data (this.buildSavedMenuDataFromDefinition menu_definition)
		)

		if this.saved_menus_data.count > 0 then
		(
			this.saved_menu_data = this.saved_menus_data[1]
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
	    #both is accepted for normal menu and quad menu.
	*/
	function isMenuCallbackData menu_data =
	(
		saved_type = this.getSavedMenuType menu_data

		saved_type == #menu or saved_type == #both -- return
	),


	/*  Checks if saved root data should be loaded by quad callback.
	    #both is accepted for normal menu and quad menu.
	*/
	function isQuadCallbackData menu_data =
	(
		saved_type = this.getSavedMenuType menu_data

		saved_type == #quad or saved_type == #both -- return
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
		this.buildSavedMenusData()

		if this.auto_register_callback then
		(
			this.registerCallback()
		)

		this.saved_menus_data -- return
	),


	/*  Saves saved menu data array to JSON file.
	    Can merge with existing JSON to avoid second run overriding first run.
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
	    Called by #cuiRegisterMenus.
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
					menu_rebuilder.loadMenuByManager menu_manager
				)
			)
		)

		ok -- return
	),


	/*  Loads all quad menus from saved_menus_data.
	    Called by #cuiRegisterQuadMenus.
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
					menu_rebuilder.loadQuadMenuByManager quad_menu_manager
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