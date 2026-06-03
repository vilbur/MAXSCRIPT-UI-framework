filein( getFilenamePath(getSourceFileName()) + "/MenuJsonIO.ms" )	--"./MenuJsonIO.ms"

filein( getFilenamePath(getSourceFileName()) + "/../MenuRebuilder/MenuRebuilder.ms" )	--"./../MenuRebuilder/MenuRebuilder.ms"


struct MenuBuildManager_v
(
	version = 0.03,
	menu_type = #menu,
	menu_title = "_TEST_MENU",
	user_menu_data = Dictionary #string,
	saved_menu_data = Dictionary #name,
	data_file_name = "MenuRebuilder_data.json",
	startup_file_name = "MenuRebuilder_startup.ms",
	data_file_path = "",
	startup_file_path = "",
	rebuilder_file_path = "",
	auto_register_callback = true,
	quad_context_id = "ac7c70f8-3f86-4ff5-a510-e4fd6a9c368e",
	quad_modifier = #shiftAndControlPressed,
	quad_position = #TopRight,


	/*  Checks if value is Dictionary.
	    Used before dictionary operations.
	*/
	function isDictionaryValue value =
	(
		value != undefined and classOf value == Dictionary -- return
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


	/*  Builds saved menu data from simple user menu data.
	    Uses MenuRebuilder_v converter.
	*/
	function buildSavedMenuData =
	(
		global MenuRebuilder

		MenuRebuilder = MenuRebuilder_v \
			menu_type:menu_type \
			menu_title:menu_title \
			menu_items:user_menu_data \
			quad_context_id:quad_context_id \
			quad_modifier:quad_modifier \
			quad_position:quad_position

		saved_menu_data = MenuRebuilder.buildMenuData()
		saved_menu_data[#version] = version

		saved_menu_data -- return
	),


	/*  Builds current session menu callback.
	    Returns saved menu data.
	*/
	function buildMenus =
	(
		global MenuRebuilder

		buildSavedMenuData()

		if auto_register_callback then
		(
			MenuRebuilder.registerCallback()
		)

		saved_menu_data -- return
	),


	/*  Saves saved menu data to JSON file.
	    Data is separated from startup MaxScript code.
	*/
	function saveJsonData =
	(
		if not isDictionaryValue saved_menu_data then
		(
			buildSavedMenuData()
		)

		json_io = MenuJsonIO_v()
		json_io.saveMenuDataToJsonFile saved_menu_data data_file_path

		format "Menu JSON data saved to:\n%\n" data_file_path

		data_file_path -- return
	),


	/*  Creates startup loader script text.
	    Loader reads JSON and rebuilds menus on launch.
	*/
	function createStartupScriptText =
	(
		startup_text = ""

		startup_text += "/*\n"
		startup_text += "    Auto generated menu startup loader.\n"
		startup_text += "    Data file: " + data_file_path + "\n"
		startup_text += "*/\n\n"

		startup_text += "global MenuRebuilder\n\n"

		if rebuilder_file_path != "" then
		(
			startup_text += "try\n"
			startup_text += "(\n"
			startup_text += "\tfileIn @\"" + rebuilder_file_path + "\"\n"
			startup_text += ")\n"
			startup_text += "catch\n"
			startup_text += "(\n"
			startup_text += "\tformat \"Failed to fileIn MenuRebuilder file.\\n\"\n"
			startup_text += ")\n\n"
		)

		startup_text += "try\n"
		startup_text += "(\n"
		startup_text += "\tmenu_json_io = MenuJsonIO_v()\n"
		startup_text += "\tsaved_menu_data = menu_json_io.loadMenuDataFromJsonFile @\"" + data_file_path + "\"\n"
		startup_text += "\tMenuRebuilder = MenuRebuilder_v menu_data:saved_menu_data\n"
		startup_text += "\tMenuRebuilder.registerCallback()\n"
		startup_text += "\tformat \"Menu rebuild callback registered from JSON data.\\n\"\n"
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
		startup_text = createStartupScriptText()

		startup_file = createFile startup_file_path
		format "%" startup_text to:startup_file
		close startup_file

		format "Startup loader saved to:\n%\n" startup_file_path

		startup_file_path -- return
	),


	/*  Builds menu, saves JSON data, saves startup loader.
	    Main manager entry point.
	*/
	function run =
	(
		buildMenus()
		saveJsonData()
		saveStartupScript()

		saved_menu_data -- return
	),


	on create do
	(
		startup_directory = getDefaultStartupDirectory()

		if data_file_path == "" then
		(
			data_file_path = startup_directory + "\\" + data_file_name
		)

		if startup_file_path == "" then
		(
			startup_file_path = startup_directory + "\\" + startup_file_name
		)

		if rebuilder_file_path == "" then
		(
			rebuilder_file_path = getCurrentSourceFilePath()
		)
	)
)