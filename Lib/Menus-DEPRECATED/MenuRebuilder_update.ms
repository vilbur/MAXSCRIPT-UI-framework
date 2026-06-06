/*
    MenuRebuilder.ms
    Version: 0.15

    Purpose:
    - Save menu / quad definitions into one shared JSON file.
    - Rebuild all menus on 3ds Max startup.
    - Normal menus are created in main menu bar.
    - Quad menus with quad_modifier != #nonePressed are created as custom RMB modifier quads.
    - Quad menus with quad_modifier == #nonePressed inject into existing "Default Viewport Quad".
    - Before default quad injection, matching *.qmnx clear files are merged to one valid *.qmnx file.
    - The merged clear qmnx is saved to user data and loaded only once before injection.
    - The merged qmnx root is MaxQuadMenuTransformations.
    - The merged qmnx file starts with <?xml version="1.0" encoding="UTF-8"?>.
    - *.qmnx is loaded through maxOps.GetICuiQuadMenuMgr(), not maxOps.GetICuiMenuMgr().
*/


/*  ====================================================================================================
    SECTION 01: GLOBALS
    ====================================================================================================
*/

global menu_rebuilder_file_version = 0.15
global MenuBuildManager
global MenuRebuilder_qmnx_clear_guard = false


/*  ====================================================================================================
    SECTION 02: BASIC TEST HELPERS
    ====================================================================================================
*/

function createMenuRebuilderGuidString =
(
	guid_class = dotNetClass "System.Guid"
	guid_value = guid_class.NewGuid()

	guid_value.ToString() -- return
)


function generateMockMacroScript macro_category macro_name =
(
	macro_script_text = ""
	macro_script_text += "macroScript " + macro_name + " category:\"" + macro_category + "\"\n"
	macro_script_text += "(\n"
	macro_script_text += "\ton execute do\n"
	macro_script_text += "\t(\n"
	macro_script_text += "\t\tformat \"Executed mock macro: " + macro_category + " / " + macro_name + "\\n\"\n"
	macro_script_text += "\t)\n"
	macro_script_text += ")\n"

	execute macro_script_text

	ok -- return
)


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

struct MenuDefinition_v
(
	type = #menu,
	title = "",
	data = undefined,
	_data = undefined,
	quad_modifier = undefined,
	quad_position = #TopRight,
	quad_context_id = "ac7c70f8-3f86-4ff5-a510-e4fd6a9c368e",


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


	function readDataAlias =
	(
		if this._data != undefined then
		(
			this.data = this._data
		)

		this.data -- return
	),


	function ensureMenuData =
	(
		this.readDataAlias()

		if not this.isDictionaryValue this.data then
		(
			this.data = Dictionary #string
		)

		this.data -- return
	),


	function ensureQuadData =
	(
		this.readDataAlias()

		if not this.isArrayValue this.data then
		(
			this.data = #()
		)

		this.data -- return
	),


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


	function addMenu title =
	(
		this.ensureMenuData()

		menu_definition = MenuDefinition_v \
			type:#menu \
			title:title

		this.data[title] = menu_definition.data

		menu_definition -- return
	),


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

		type_text = this.type as string

		if type_text == "#menu" then
		(
			this.quad_position = undefined
		)

		if type_text == "#MENU" then
		(
			this.quad_position = undefined
		)

		if type_text == "menu" then
		(
			this.quad_position = undefined
		)

		if type_text == "MENU" then
		(
			this.quad_position = undefined
		)

		if this.data == undefined then
		(
			this.data = Dictionary #string
		)
	)
)


/*  ====================================================================================================
    SECTION 04: DEFAULT QUAD QMNX CLEAR
    ====================================================================================================
*/

global QuadDefaultQmnxClear_v

struct QuadDefaultQmnxClear_v
(
	qmnx_clear_directory = "",
	qmnx_user_data_directory = "",
	xsd_file_path = "",
	forced_root_name = "MaxQuadMenuTransformations",
	merged_clear_file_name = "MenuRebuilder_DefaultViewportQuad_Clear_Merged.qmnx",
	top_left_clear_file = "topLeft-clear.qmnx",
	top_right_clear_file = "topRight-clear.qmnx",
	bottom_left_clear_file = "bottomLeft-clear.qmnx",
	bottom_right_clear_file = "bottomRight-clear.qmnx",
	invalid_helper_root_names = #(),


	function getCurrentSourceDirectory =
	(
		source_directory = ""

		try
		(
			source_file_path = getSourceFileName()

			if source_file_path != undefined and source_file_path != "" then
			(
				source_directory = getFilenamePath source_file_path
			)
		)
		catch
		(
			source_directory = ""
		)

		source_directory -- return
	),


	function normalizePath path_value =
	(
		normalized_path = path_value

		if normalized_path != undefined then
		(
			normalized_path = normalized_path as string
			normalized_path = substituteString normalized_path "/" "\\"
			normalized_path = substituteString normalized_path "\\\\" "\\"
		)

		normalized_path -- return
	),


	function getDefaultClearDirectory =
	(
		source_directory = this.getCurrentSourceDirectory()

		candidate_paths = #()

		if source_directory != "" then
		(
			append candidate_paths (source_directory + "qmnx")
			append candidate_paths (source_directory + "MenuRebuilder\\qmnx")
		)

		append candidate_paths (getDir #userScripts + "\\MAXSCRIPT-MenuBuilder\\MenuRebuilder\\qmnx")
		append candidate_paths (getDir #userScripts + "\\MenuRebuilder\\qmnx")

		clear_directory = candidate_paths[candidate_paths.count]

		for candidate_path in candidate_paths while clear_directory == candidate_paths[candidate_paths.count] do
		(
			if doesDirectoryExist candidate_path then
			(
				clear_directory = candidate_path
			)
		)

		this.normalizePath clear_directory -- return
	),


	function ensureClearDirectory =
	(
		if this.qmnx_clear_directory == "" then
		(
			this.qmnx_clear_directory = this.getDefaultClearDirectory()
		)

		this.qmnx_clear_directory = this.normalizePath this.qmnx_clear_directory

		this.qmnx_clear_directory -- return
	),


	function getUserDataRootDirectory =
	(
		user_data_directory = ""

		try
		(
			user_data_directory = getDir #userData
		)
		catch
		(
			user_data_directory = ""
		)

		if user_data_directory == "" then
		(
			try
			(
				user_data_directory = getDir #userScripts
			)
			catch
			(
				user_data_directory = ""
			)
		)

		if user_data_directory == "" then
		(
			user_data_directory = this.getDefaultClearDirectory()
		)

		this.normalizePath user_data_directory -- return
	),


	function ensureUserDataDirectory =
	(
		if this.qmnx_user_data_directory == "" then
		(
			this.qmnx_user_data_directory = this.getUserDataRootDirectory() + "\\MenuRebuilder\\qmnx"
		)

		this.qmnx_user_data_directory = this.normalizePath this.qmnx_user_data_directory

		try
		(
			makeDir this.qmnx_user_data_directory all:true
		)
		catch
		(
			ok
		)

		this.qmnx_user_data_directory -- return
	),


	function getMergedQmnxFilePath =
	(
		user_data_directory = this.ensureUserDataDirectory()
		merged_file_path = user_data_directory + "\\" + this.merged_clear_file_name

		this.normalizePath merged_file_path -- return
	),


	function getMenuTransformationsSchemaPath =
	(
		schema_path = this.xsd_file_path

		if schema_path == "" then
		(
			try
			(
				max_root = getDir #maxRoot
				schema_path = max_root + "\\UI_LN\\CUI\\XSD\\MenuTransformationsSchema.xsd"
			)
			catch
			(
				schema_path = ""
			)
		)

		schema_path = this.normalizePath schema_path

		schema_path -- return
	),


	function normalizeQuadPosition position_value =
	(
		position_name = #TopRight
		position_text = position_value as string

		if position_text == "#TopLeft" then position_name = #TopLeft
		if position_text == "TopLeft" then position_name = #TopLeft

		if position_text == "#TopRight" then position_name = #TopRight
		if position_text == "TopRight" then position_name = #TopRight

		if position_text == "#BottomLeft" then position_name = #BottomLeft
		if position_text == "BottomLeft" then position_name = #BottomLeft

		if position_text == "#BottomRight" then position_name = #BottomRight
		if position_text == "BottomRight" then position_name = #BottomRight

		position_name -- return
	),


	function getClearFileNameByPosition position_value =
	(
		position_name = this.normalizeQuadPosition position_value
		file_name = ""

		if position_name == #TopLeft then file_name = this.top_left_clear_file
		if position_name == #TopRight then file_name = this.top_right_clear_file
		if position_name == #BottomLeft then file_name = this.bottom_left_clear_file
		if position_name == #BottomRight then file_name = this.bottom_right_clear_file

		file_name -- return
	),


	function getClearFilePathByPosition position_value =
	(
		clear_directory = this.ensureClearDirectory()
		file_name = this.getClearFileNameByPosition position_value
		file_path = clear_directory + "\\" + file_name

		this.normalizePath file_path -- return
	),


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


	function getUniqueClearFilePaths positions =
	(
		clear_file_paths = #()

		for position_value in positions do
		(
			clear_file_path = this.getClearFilePathByPosition position_value

			if doesFileExist clear_file_path then
			(
				if not this.isStringInArray clear_file_paths clear_file_path then
				(
					append clear_file_paths clear_file_path
				)
			)
			else
			(
				format "QuadDefaultQmnxClear_v: missing qmnx clear file: %\n" clear_file_path
			)
		)

		clear_file_paths -- return
	),


	function isInvalidHelperRootName root_name =
	(
		was_found = false

		for invalid_root_name in this.invalid_helper_root_names while not was_found do
		(
			if root_name == invalid_root_name then
			(
				was_found = true
			)
		)

		was_found -- return
	),


	function getAllowedRootNamesFromSchema =
	(
		root_names = #()
		schema_path = this.getMenuTransformationsSchemaPath()

		if doesFileExist schema_path then
		(
			try
			(
				xml_document = dotNetObject "System.Xml.XmlDocument"
				xml_document.Load schema_path

				element_nodes = xml_document.SelectNodes "/*[local-name()='schema']/*[local-name()='element']"

				for node_index = 0 to element_nodes.Count - 1 do
				(
					element_node = element_nodes.Item node_index
					name_attribute = element_node.Attributes.GetNamedItem "name"

					if name_attribute != undefined then
					(
						root_name = name_attribute.Value

						if not this.isStringInArray root_names root_name then
						(
							append root_names root_name
						)
					)
				)
			)
			catch
			(
				format "QuadDefaultQmnxClear_v: failed to read schema root names: %\n" schema_path
			)
		)
		else
		(
			format "QuadDefaultQmnxClear_v: schema file not found: %\n" schema_path
		)

		root_names -- return
	),


	function getPreferredRootName =
	(
		preferred_root_name = this.forced_root_name

		if preferred_root_name == "" then
		(
			preferred_root_name = "MaxQuadMenuTransformations"
		)

		preferred_root_name -- return
	),

	function isRootNameAllowed root_name =
	(
		was_allowed = false

		if root_name == "MaxQuadMenuTransformations" then
		(
			was_allowed = true
		)
		else
		(
			allowed_root_names = this.getAllowedRootNamesFromSchema()

			if allowed_root_names.count > 0 then
			(
				was_allowed = this.isStringInArray allowed_root_names root_name
			)
		)

		was_allowed -- return
	),

	function printQmnxRoot file_path =
	(
		if doesFileExist file_path then
		(
			try
			(
				xml_document = dotNetObject "System.Xml.XmlDocument"
				xml_document.Load file_path

				format "QMNX root: %\n" xml_document.DocumentElement.Name
				format "File: %\n" file_path
			)
			catch
			(
				format "QuadDefaultQmnxClear_v.printQmnxRoot failed: %\n" file_path
			)
		)
		else
		(
			format "QMNX file missing: %\n" file_path
		)

		ok -- return
	),


	function printAllowedQmnxRootNames =
	(
		root_names = this.getAllowedRootNamesFromSchema()

		if not this.isStringInArray root_names "MaxQuadMenuTransformations" then
		(
			append root_names "MaxQuadMenuTransformations"
		)

		format "Allowed qmnx root names:\n"

		for root_name in root_names do
		(
			format "    %\n" root_name
		)

		root_names -- return
	),


	function ensureXmlDeclaration xml_document =
	(
		try
		(
			first_child = xml_document.FirstChild
			has_declaration = false

			if first_child != undefined then
			(
				if first_child.NodeType.ToString() == "XmlDeclaration" then
				(
					has_declaration = true
				)
			)

			if not has_declaration then
			(
				xml_declaration = xml_document.CreateXmlDeclaration "1.0" "UTF-8" undefined
				xml_document.InsertBefore xml_declaration xml_document.DocumentElement
			)
		)
		catch
		(
			format "QuadDefaultQmnxClear_v.ensureXmlDeclaration failed.\n"
		)

		xml_document -- return
	),


	function appendElementChildren target_document target_root source_root =
	(
		for child_index = 0 to source_root.ChildNodes.Count - 1 do
		(
			source_child = source_root.ChildNodes.Item child_index
			node_type_text = source_child.NodeType.ToString()

			if node_type_text == "Element" then
			(
				imported_child = target_document.ImportNode source_child true
				target_root.AppendChild imported_child
			)
		)

		ok -- return
	),


	function createEmptyQmnxDocument root_name =
	(
		xml_document = dotNetObject "System.Xml.XmlDocument"
		xml_document.PreserveWhitespace = true

		xml_declaration = xml_document.CreateXmlDeclaration "1.0" "UTF-8" undefined
		xml_document.AppendChild xml_declaration

		xml_root = xml_document.CreateElement root_name
		xml_document.AppendChild xml_root

		xml_document -- return
	),

	function createValidBaseDocumentFromSource source_file_path =
	(
		source_document = dotNetObject "System.Xml.XmlDocument"
		source_document.PreserveWhitespace = true
		source_document.Load source_file_path

		source_root = source_document.DocumentElement
		source_root_name = source_root.Name
		preferred_root_name = this.getPreferredRootName()

		if source_root_name == preferred_root_name then
		(
			base_document = source_document
			this.ensureXmlDeclaration base_document
		)
		else
		(
			format "QuadDefaultQmnxClear_v: output qmnx root forced to '%'. Source root was '%'.\n" preferred_root_name source_root_name
			format "Source: %\n" source_file_path

			base_document = this.createEmptyQmnxDocument preferred_root_name
			base_root = base_document.DocumentElement

			this.appendElementChildren base_document base_root source_root
		)

		base_document -- return
	),

	function appendQmnxFileToBaseDocument base_document source_file_path =
	(
		base_root = base_document.DocumentElement
		base_root_name = base_root.Name

		source_document = dotNetObject "System.Xml.XmlDocument"
		source_document.PreserveWhitespace = true
		source_document.Load source_file_path

		source_root = source_document.DocumentElement
		source_root_name = source_root.Name

		if this.isRootNameAllowed source_root_name then
		(
			if source_root_name != base_root_name then
			(
				format "QuadDefaultQmnxClear_v: source qmnx root differs from output root. Children imported into MaxQuadMenuTransformations.\n"
				format "Output root: %\n" base_root_name
				format "Source root: %\n" source_root_name
				format "Source: %\n" source_file_path
			)
		)
		else
		(
			format "QuadDefaultQmnxClear_v: source qmnx helper root '%' will not be written to output. Children imported only.\n" source_root_name
			format "Source: %\n" source_file_path
		)

		this.appendElementChildren base_document base_root source_root

		ok -- return
	),


	function mergeQmnxFilesToSingleFile source_file_paths merged_file_path =
	(
		was_merged = false

		if source_file_paths.count == 0 then
		(
			false -- return
		)
		else
		(
			try
			(
				if doesFileExist merged_file_path then
				(
					deleteFile merged_file_path
				)
			)
			catch
			(
				ok
			)

			try
			(
				base_document = this.createValidBaseDocumentFromSource source_file_paths[1]

				for file_index = 2 to source_file_paths.count do
				(
					this.appendQmnxFileToBaseDocument base_document source_file_paths[file_index]
				)

				this.ensureXmlDeclaration base_document
				base_document.Save merged_file_path

				merged_document = dotNetObject "System.Xml.XmlDocument"
				merged_document.Load merged_file_path
				merged_root_name = merged_document.DocumentElement.Name

				if this.isInvalidHelperRootName merged_root_name then
				(
					format "QuadDefaultQmnxClear_v: refused to save invalid helper root to merged qmnx: %\n" merged_root_name
					deleteFile merged_file_path
					was_merged = false
				)
				else
				(
					format "QuadDefaultQmnxClear_v: merged qmnx root: %\n" merged_root_name
					format "QuadDefaultQmnxClear_v: merged qmnx clear file saved to: %\n" merged_file_path
					was_merged = true
				)
			)
			catch
			(
				format "QuadDefaultQmnxClear_v.mergeQmnxFilesToSingleFile failed.\n"
				was_merged = false
			)
		)

		was_merged -- return
	),


	function loadQmnxConfiguration qmnx_file_path =
	(
		was_loaded = false

		if doesFileExist qmnx_file_path then
		(
			try
			(
				cui_quad_menu_manager = maxOps.GetICuiQuadMenuMgr()
				cui_quad_menu_manager.LoadConfiguration qmnx_file_path

				format "QuadDefaultQmnxClear_v: loaded merged qmnx clear file through CuiQuadMenuMgr: %\n" qmnx_file_path

				was_loaded = true
			)
			catch
			(
				format "QuadDefaultQmnxClear_v.loadQmnxConfiguration failed: %\n" qmnx_file_path
				was_loaded = false
			)
		)
		else
		(
			format "QuadDefaultQmnxClear_v.loadQmnxConfiguration missing file: %\n" qmnx_file_path
		)

		was_loaded -- return
	),


	function clearPositions positions =
	(
		global MenuRebuilder_qmnx_clear_guard

		was_loaded = false

		if MenuRebuilder_qmnx_clear_guard then
		(
			format "QuadDefaultQmnxClear_v.clearPositions skipped. QMNX clear guard is active.\n"
			false -- return
		)
		else
		(
			clear_file_paths = this.getUniqueClearFilePaths positions

			if clear_file_paths.count == 0 then
			(
				format "QuadDefaultQmnxClear_v.clearPositions skipped. No qmnx clear files found.\n"
			)
			else
			(
				merged_file_path = this.getMergedQmnxFilePath()
				was_merged = this.mergeQmnxFilesToSingleFile clear_file_paths merged_file_path

				if was_merged then
				(
					MenuRebuilder_qmnx_clear_guard = true

					try
					(
						was_loaded = this.loadQmnxConfiguration merged_file_path
					)
					catch
					(
						format "QuadDefaultQmnxClear_v.clearPositions failed while loading merged qmnx.\n"
						was_loaded = false
					)

					MenuRebuilder_qmnx_clear_guard = false
				)
			)

			was_loaded -- return
		)
	)
)


/*  ====================================================================================================
    SECTION 05: MENU REBUILDER
    ====================================================================================================
*/

struct MenuRebuilder_v
(
	version = 0.15,
	menu_data = Dictionary #name,
	skip_default_qmnx_clear = false,
	help_menu_id = "cee8f758-2199-411b-81e7-d3ff4a80d143",
	macro_action_table_id = 647394,


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


	function createGuidString =
	(
		guid_class = dotNetClass "System.Guid"
		guid_value = guid_class.NewGuid()

		guid_value.ToString() -- return
	),


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


	function getMenuDataValue dictionary_key default_value =
	(
		value = default_value

		if this.hasDictValueSafe this.menu_data dictionary_key then
		(
			value = this.menu_data[dictionary_key]
		)

		value -- return
	),


	function normalizeQuadModifier modifier_value =
	(
		normalized_modifier = undefined
		modifier_text = ""

		if modifier_value != undefined then
		(
			modifier_text = modifier_value as string
		)

		if modifier_text == "#nonePressed" then normalized_modifier = #nonePressed
		if modifier_text == "nonePressed" then normalized_modifier = #nonePressed
		if modifier_text == "#nonePresses" then normalized_modifier = #nonePressed
		if modifier_text == "nonePresses" then normalized_modifier = #nonePressed

		if modifier_text == "#shiftPressed" then normalized_modifier = #shiftPressed
		if modifier_text == "shiftPressed" then normalized_modifier = #shiftPressed

		if modifier_text == "#controlPressed" then normalized_modifier = #controlPressed
		if modifier_text == "controlPressed" then normalized_modifier = #controlPressed

		if modifier_text == "#altPressed" then normalized_modifier = #altPressed
		if modifier_text == "altPressed" then normalized_modifier = #altPressed

		if modifier_text == "#shiftAndControlPressed" then normalized_modifier = #shiftAndControlPressed
		if modifier_text == "shiftAndControlPressed" then normalized_modifier = #shiftAndControlPressed

		normalized_modifier -- return
	),


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


	function getMenuTitle =
	(
		this.getMenuDataValue #title "" -- return
	),


	function hasValidMenuTitle =
	(
		menu_title = this.getMenuTitle()

		menu_title != "" -- return
	),


	function getMenuItems =
	(
		menu_items = this.getMenuDataValue #items (Dictionary #string)

		if not this.isDictionaryValue menu_items then
		(
			menu_items = Dictionary #string
		)

		menu_items -- return
	),


	function getQuadContextId =
	(
		this.getMenuDataValue #quad_context_id "ac7c70f8-3f86-4ff5-a510-e4fd6a9c368e" -- return
	),


	function getQuadModifier =
	(
		this.normalizeQuadModifier (this.getMenuDataValue #quad_modifier undefined) -- return
	),


	function getQuadPosition =
	(
		this.getMenuDataValue #quad_position #TopRight -- return
	),


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


	function getQuadMenus =
	(
		quad_menus = this.getMenuDataValue #quad_menus #()

		if not this.isArrayValue quad_menus then
		(
			quad_menus = #()
		)

		quad_menus -- return
	),


	function getQmnxClearDirectory =
	(
		this.getMenuDataValue #qmnx_clear_directory "" -- return
	),


	function isDefaultQuadInjectionMode =
	(
		this.getQuadModifier() == #nonePressed -- return
	),


	function isSubMenuData item_data =
	(
		was_found = false

		if this.isDictionaryValue item_data then
		(
			was_found = this.hasDictValueSafe item_data #items
		)

		was_found -- return
	),


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


	function getMacroActionId macro_category macro_name =
	(
		persistent_action_id = macro_name + "`" + macro_category

		persistent_action_id -- return
	),


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


	function createCustomQuadRootMenu quad_context =
	(
		quad_menu = undefined
		quad_modifier = this.getQuadModifier()

		if not this.hasValidMenuTitle() then
		(
			format "MenuRebuilder_v.createCustomQuadRootMenu skipped. Missing menu title.\n"
		)
		else if quad_modifier == undefined then
		(
			format "MenuRebuilder_v.createCustomQuadRootMenu skipped. quad_modifier is undefined.\n"
		)
		else if quad_context != undefined then
		(
			try
			(
				quad_menu = quad_context.CreateQuadMenu (this.getMenuId()) (this.getMenuTitle())

				if quad_menu != undefined then
				(
					quad_context.SetRightClickModifiers quad_menu quad_modifier
				)
			)
			catch
			(
				quad_menu = undefined
			)
		)

		quad_menu -- return
	),


	function getDefaultViewportQuadMenu quad_context =
	(
		default_quad = undefined

		if quad_context != undefined then
		(
			try
			(
				default_quad = quad_context.GetRightClickMenuByModifiers #nonePressed
			)
			catch
			(
				default_quad = undefined
			)
		)

		default_quad -- return
	),


	function rebuildCustomQuadPositionMenu quad_menu quad_title quad_position_value quad_menu_id_value quad_items_value =
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


	function injectDefaultQuadPositionMenu default_quad quad_position_value quad_items_value =
	(
		quad_position_menu = undefined

		if default_quad != undefined then
		(
			try
			(
				quad_position_menu = default_quad.GetMenuByPos quad_position_value
			)
			catch
			(
				quad_position_menu = undefined
			)

			if quad_position_menu != undefined then
			(
				this.rebuildMenuItems quad_position_menu quad_items_value
			)
			else
			(
				format "MenuRebuilder_v.injectDefaultQuadPositionMenu failed. Quad position not found: %\n" quad_position_value
			)
		)

		quad_position_menu -- return
	),


	function collectDefaultQuadClearPositions =
	(
		clear_positions = #()
		quad_menus = this.getQuadMenus()

		if quad_menus.count > 0 then
		(
			for quad_data in quad_menus do
			(
				if this.hasDictValueSafe quad_data #quad_position then
				(
					append clear_positions quad_data[#quad_position]
				)
			)
		)
		else
		(
			append clear_positions (this.getQuadPosition())
		)

		clear_positions -- return
	),


	function clearDefaultViewportQuadByQmnx =
	(
		was_loaded = false

		if this.isDefaultQuadInjectionMode() then
		(
			clear_positions = this.collectDefaultQuadClearPositions()

			qmnx_clear = QuadDefaultQmnxClear_v \
				qmnx_clear_directory:(this.getQmnxClearDirectory())

			was_loaded = qmnx_clear.clearPositions clear_positions
		)

		was_loaded -- return
	),


	function rebuildAsCustomModifierQuad quad_menu_manager =
	(
		if quad_menu_manager == undefined then
		(
			format "MenuRebuilder_v.rebuildAsCustomModifierQuad failed. quad_menu_manager is undefined.\n"
			false -- return
		)
		else
		(
			quad_context = this.getQuadContext quad_menu_manager
			quad_menu = this.createCustomQuadRootMenu quad_context
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

						this.rebuildCustomQuadPositionMenu quad_menu quad_title quad_position_value quad_menu_id_value quad_items_value
					)
				)
				else
				(
					this.rebuildCustomQuadPositionMenu quad_menu (this.getMenuTitle()) (this.getQuadPosition()) (this.getQuadMenuId()) (this.getMenuItems())
				)
			)

			true -- return
		)
	),


	function injectAsDefaultViewportQuad quad_menu_manager =
	(
		if quad_menu_manager == undefined then
		(
			format "MenuRebuilder_v.injectAsDefaultViewportQuad failed. quad_menu_manager is undefined.\n"
			false -- return
		)
		else
		(
			if not this.skip_default_qmnx_clear then
			(
				this.clearDefaultViewportQuadByQmnx()
			)

			quad_context = this.getQuadContext quad_menu_manager
			default_quad = this.getDefaultViewportQuadMenu quad_context
			quad_menus = this.getQuadMenus()

			if default_quad == undefined then
			(
				format "MenuRebuilder_v.injectAsDefaultViewportQuad failed. Default viewport quad not found.\n"
				false -- return
			)
			else
			(
				if quad_menus.count > 0 then
				(
					for quad_data in quad_menus do
					(
						quad_position_value = quad_data[#quad_position]
						quad_items_value = quad_data[#items]

						this.injectDefaultQuadPositionMenu default_quad quad_position_value quad_items_value
					)
				)
				else
				(
					this.injectDefaultQuadPositionMenu default_quad (this.getQuadPosition()) (this.getMenuItems())
				)

				format "MenuRebuilder_v: injected menu '%' into Default Viewport Quad.\n" (this.getMenuTitle())

				true -- return
			)
		)
	),


	function rebuildAsQuadMenu quad_menu_manager =
	(
		if not this.hasValidMenuTitle() then
		(
			format "MenuRebuilder_v.rebuildAsQuadMenu skipped. Missing menu title.\n"
			false -- return
		)
		else if this.isDefaultQuadInjectionMode() then
		(
			this.injectAsDefaultViewportQuad quad_menu_manager -- return
		)
		else
		(
			this.rebuildAsCustomModifierQuad quad_menu_manager -- return
		)
	),


	on create do
	(
		ok
	)
)


/*  ====================================================================================================
    SECTION 06: JSON IO
    ====================================================================================================
*/

struct MenuJsonIO_v
(
	json_text = "",
	json_position = 1,
	json_length = 0,


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


	function getJsonValue json_object key_string default_value =
	(
		result_value = default_value

		if this.hasDictValueSafe json_object key_string then
		(
			result_value = json_object[key_string]
		)

		result_value -- return
	),


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


	function textToMenuType text_value =
	(
		menu_type_value = #menu

		if text_value == "quad" then menu_type_value = #quad
		if text_value == "#quad" then menu_type_value = #quad
		if text_value == "QUAD" then menu_type_value = #quad
		if text_value == "#QUAD" then menu_type_value = #quad

		if text_value == "both" then menu_type_value = #both
		if text_value == "#both" then menu_type_value = #both
		if text_value == "BOTH" then menu_type_value = #both
		if text_value == "#BOTH" then menu_type_value = #both

		menu_type_value -- return
	),


	function textToQuadModifier text_value =
	(
		modifier_value = undefined

		if text_value == "nonePressed" then modifier_value = #nonePressed
		if text_value == "#nonePressed" then modifier_value = #nonePressed
		if text_value == "nonePresses" then modifier_value = #nonePressed
		if text_value == "#nonePresses" then modifier_value = #nonePressed

		if text_value == "shiftPressed" then modifier_value = #shiftPressed
		if text_value == "#shiftPressed" then modifier_value = #shiftPressed

		if text_value == "controlPressed" then modifier_value = #controlPressed
		if text_value == "#controlPressed" then modifier_value = #controlPressed

		if text_value == "altPressed" then modifier_value = #altPressed
		if text_value == "#altPressed" then modifier_value = #altPressed

		if text_value == "shiftAndControlPressed" then modifier_value = #shiftAndControlPressed
		if text_value == "#shiftAndControlPressed" then modifier_value = #shiftAndControlPressed

		modifier_value -- return
	),


	function textToQuadPosition text_value =
	(
		position_value = #TopRight

		if text_value == "TopLeft" then position_value = #TopLeft
		if text_value == "#TopLeft" then position_value = #TopLeft

		if text_value == "TopRight" then position_value = #TopRight
		if text_value == "#TopRight" then position_value = #TopRight

		if text_value == "BottomLeft" then position_value = #BottomLeft
		if text_value == "#BottomLeft" then position_value = #BottomLeft

		if text_value == "BottomRight" then position_value = #BottomRight
		if text_value == "#BottomRight" then position_value = #BottomRight

		position_value -- return
	),


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


	function stringToJson source_string =
	(
		"\"" + this.escapeJsonString source_string + "\"" -- return
	),


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


	function menuDataToJson menu_data =
	(
		json_value = "{\n"

		json_value += "\t\"version\": " + (menu_data[#version] as string) + ",\n"
		json_value += "\t\"id\": " + this.stringToJson menu_data[#id] + ",\n"
		json_value += "\t\"title\": " + this.stringToJson menu_data[#title] + ",\n"
		json_value += "\t\"type\": " + this.stringToJson (this.nameToText menu_data[#type] default_text:"menu") + ",\n"
		json_value += "\t\"quad_context_id\": " + this.stringToJson menu_data[#quad_context_id] + ",\n"
		json_value += "\t\"quad_modifier\": " + this.stringToJson (this.nameToText menu_data[#quad_modifier] default_text:"") + ",\n"
		json_value += "\t\"quad_position\": " + this.stringToJson (this.nameToText menu_data[#quad_position] default_text:"") + ",\n"
		json_value += "\t\"quad_menu_id\": " + this.stringToJson menu_data[#quad_menu_id] + ",\n"
		json_value += "\t\"qmnx_clear_directory\": " + this.stringToJson menu_data[#qmnx_clear_directory] + ",\n"

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


	function menusDataToJson menus_data_array =
	(
		json_value = "{\n"

		json_value += "\t\"version\": 0.13,\n"
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


	function saveMenusDataToJsonFile menus_data_array json_file_path =
	(
		json_value = this.menusDataToJson menus_data_array

		json_file = createFile json_file_path
		format "%" json_value to:json_file
		close json_file

		json_file_path -- return
	),


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


	function setJsonText source_text =
	(
		this.json_text = source_text
		this.json_position = 1
		this.json_length = this.json_text.count

		ok -- return
	),


	function getCurrentChar =
	(
		char_value = ""

		if this.json_position <= this.json_length then
		(
			char_value = substring this.json_text this.json_position 1
		)

		char_value -- return
	),


	function skipJsonWhitespace =
	(
		while this.json_position <= this.json_length and findString " \t\r\n" (this.getCurrentChar()) != undefined do
		(
			this.json_position += 1
		)

		ok -- return
	),


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

					if escape_char == "\"" then result_string += "\""
					else if escape_char == "\\" then result_string += "\\"
					else if escape_char == "/" then result_string += "/"
					else if escape_char == "t" then result_string += "\t"
					else if escape_char == "n" then result_string += "\n"
					else if escape_char == "r" then result_string += "\r"
					else result_string += escape_char
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


	function parseJsonNumber =
	(
		number_text = ""

		while this.json_position <= this.json_length and findString "-+0123456789.eE" (this.getCurrentChar()) != undefined do
		(
			number_text += this.getCurrentChar()
			this.json_position += 1
		)

		number_value = number_text as float

		number_value -- return
	),


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


	function jsonQuadMenuToData json_quad =
	(
		quad_data = Dictionary #name

		quad_data[#title] = this.getJsonValue json_quad "title" ""
		quad_data[#quad_position] = this.textToQuadPosition (this.getJsonValue json_quad "quad_position" "TopRight")
		quad_data[#quad_menu_id] = this.getJsonValue json_quad "quad_menu_id" ""
		quad_data[#items] = this.jsonItemsToSavedItems (this.getJsonValue json_quad "items" (Dictionary #string))

		quad_data -- return
	),


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


	function jsonRootToMenuData json_root =
	(
		menu_data = undefined

		if this.isDictionaryValue json_root then
		(
			menu_title = this.getJsonValue json_root "title" ""

			if menu_title != "" then
			(
				menu_data = Dictionary #name

				menu_data[#version] = this.getJsonValue json_root "version" 0.15
				menu_data[#id] = this.getJsonValue json_root "id" ""
				menu_data[#title] = menu_title
				menu_type = this.textToMenuType (this.getJsonValue json_root "type" "menu")
				menu_data[#type] = menu_type
				menu_data[#quad_context_id] = this.getJsonValue json_root "quad_context_id" "ac7c70f8-3f86-4ff5-a510-e4fd6a9c368e"
				menu_data[#quad_modifier] = this.textToQuadModifier (this.getJsonValue json_root "quad_modifier" "")

				if menu_type == #menu then
				(
					menu_data[#quad_position] = undefined
				)
				else
				(
					menu_data[#quad_position] = this.textToQuadPosition (this.getJsonValue json_root "quad_position" "TopRight")
				)

				menu_data[#quad_menu_id] = this.getJsonValue json_root "quad_menu_id" ""
				menu_data[#qmnx_clear_directory] = this.getJsonValue json_root "qmnx_clear_directory" ""
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


	on create do
	(
		ok
	)
)


/*  ====================================================================================================
    SECTION 07: MENU BUILD MANAGER
    ====================================================================================================
*/

struct MenuBuildManager_v
(
	version = 0.15,
	menus_data = #(),
	saved_menus_data = #(),
	data_file_name = "MenuRebuilder_data.json",
	startup_file_name = "MenuRebuilder_startup.ms",
	data_file_path = "",
	startup_file_path = "",
	rebuilder_file_path = "",
	qmnx_clear_directory = "",
	auto_register_callback = true,
	merge_existing_data = true,
	callback_id = #menuBuildManagerCuiRegisterMenus,
	quad_callback_id = #menuBuildManagerCuiRegisterQuadMenus,


	function createGuidString =
	(
		guid_class = dotNetClass "System.Guid"
		guid_value = guid_class.NewGuid()

		guid_value.ToString() -- return
	),


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


	function normalizeMenuType type_value =
	(
		normalized_type = #menu
		type_text = type_value as string

		if type_text == "#quad" then normalized_type = #quad
		if type_text == "quad" then normalized_type = #quad
		if type_text == "#QUAD" then normalized_type = #quad
		if type_text == "QUAD" then normalized_type = #quad

		if type_text == "#both" then normalized_type = #both
		if type_text == "both" then normalized_type = #both
		if type_text == "#BOTH" then normalized_type = #both
		if type_text == "BOTH" then normalized_type = #both

		normalized_type -- return
	),


	function normalizeQuadModifier modifier_value =
	(
		menu_rebuilder = MenuRebuilder_v()
		menu_rebuilder.normalizeQuadModifier modifier_value -- return
	),


	function getDefinitionData menu_definition =
	(
		definition_data = menu_definition.data

		if menu_definition._data != undefined then
		(
			definition_data = menu_definition._data
		)

		definition_data -- return
	),


	function createSavedMacroItemData item_title macro_category macro_name =
	(
		item_data = Dictionary #name

		item_data[#title] = item_title
		item_data[#category] = macro_category
		item_data[#macro] = macro_name

		item_data -- return
	),


	function createSavedSubMenuData submenu_title submenu_items =
	(
		submenu_data = Dictionary #name

		submenu_data[#title] = submenu_title
		submenu_data[#items] = submenu_items

		submenu_data -- return
	),


	function isSubMenuData item_data =
	(
		was_found = false

		if this.isDictionaryValue item_data then
		(
			was_found = this.hasDictValueSafe item_data #items
		)

		was_found -- return
	),


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
			root_data[#quad_modifier] = this.normalizeQuadModifier menu_definition.quad_modifier

			if definition_type == #menu then
			(
				root_data[#quad_position] = undefined
			)
			else
			(
				root_data[#quad_position] = menu_definition.quad_position
			)

			root_data[#quad_menu_id] = this.createGuidString()
			root_data[#qmnx_clear_directory] = this.qmnx_clear_directory
			root_data[#quad_menus] = #()
		)

		root_data -- return
	),


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


	function loadSavedMenusDataFromJson =
	(
		json_io = MenuJsonIO_v()
		json_io.loadMenusDataFromJsonFile this.data_file_path -- return
	),


	function writeSavedMenusDataToJson menus_data_array =
	(
		json_io = MenuJsonIO_v()
		json_io.saveMenusDataToJsonFile menus_data_array this.data_file_path

		this.data_file_path -- return
	),


	function clearJsonFile =
	(
		this.saved_menus_data = #()
		this.writeSavedMenusDataToJson this.saved_menus_data

		format "Menu JSON file cleared:\n%\n" this.data_file_path

		this.saved_menus_data -- return
	),


	function deleteAllMenusFromJson =
	(
		this.clearJsonFile() -- return
	),


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


	function getSavedQuadModifier menu_data =
	(
		quad_modifier = undefined

		if this.isDictionaryValue menu_data then
		(
			if this.hasDictValueSafe menu_data #quad_modifier then
			(
				quad_modifier = this.normalizeQuadModifier menu_data[#quad_modifier]
			)
		)

		quad_modifier -- return
	),


	function getSavedQmnxClearDirectory menu_data =
	(
		clear_directory = ""

		if this.isDictionaryValue menu_data then
		(
			if this.hasDictValueSafe menu_data #qmnx_clear_directory then
			(
				clear_directory = menu_data[#qmnx_clear_directory]
			)
		)

		clear_directory -- return
	),


	function isValidSavedMenuData menu_data =
	(
		this.getSavedMenuTitle menu_data != "" -- return
	),


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


	function isDefaultQuadInjectionData menu_data =
	(
		was_found = false

		if this.isQuadCallbackData menu_data then
		(
			if this.getSavedQuadModifier menu_data == #nonePressed then
			(
				was_found = true
			)
		)

		was_found -- return
	),


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


	function collectDefaultQuadClearPositionsFromMenuData menu_data =
	(
		clear_positions = #()

		if this.hasDictValueSafe menu_data #quad_menus then
		(
			quad_menus = menu_data[#quad_menus]

			if classOf quad_menus == Array and quad_menus.count > 0 then
			(
				for quad_data in quad_menus do
				(
					if this.hasDictValueSafe quad_data #quad_position then
					(
						append clear_positions quad_data[#quad_position]
					)
				)
			)
			else
			(
				if this.hasDictValueSafe menu_data #quad_position then
				(
					append clear_positions menu_data[#quad_position]
				)
			)
		)
		else
		(
			if this.hasDictValueSafe menu_data #quad_position then
			(
				append clear_positions menu_data[#quad_position]
			)
		)

		clear_positions -- return
	),


	function clearDefaultQuadPositionsForAllData =
	(
		clear_positions = #()
		clear_directory = this.qmnx_clear_directory

		for menu_data in this.saved_menus_data do
		(
			if this.isDefaultQuadInjectionData menu_data then
			(
				if clear_directory == "" then
				(
					clear_directory = this.getSavedQmnxClearDirectory menu_data
				)

				menu_clear_positions = this.collectDefaultQuadClearPositionsFromMenuData menu_data

				for position_value in menu_clear_positions do
				(
					append clear_positions position_value
				)
			)
		)

		if clear_positions.count > 0 then
		(
			qmnx_clear = QuadDefaultQmnxClear_v qmnx_clear_directory:clear_directory
			qmnx_clear.clearPositions clear_positions
		)

		clear_positions -- return
	),


	function buildMenus =
	(
		if this.saved_menus_data.count == 0 then
		(
			this.buildSavedMenusData()
		)

		this.saved_menus_data -- return
	),


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


	function createStartupScriptText =
	(
		startup_text = ""

		startup_text += "/*\n"
		startup_text += "    Auto generated menu startup loader.\n"
		startup_text += "    Data file: " + this.data_file_path + "\n"
		startup_text += "*/\n\n"

		startup_text += "global MenuBuildManager\n"
		startup_text += "global MenuRebuilder_qmnx_clear_guard = false\n\n"

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
		startup_text += "\tMenuBuildManager = MenuBuildManager_v saved_menus_data:saved_menus_data merge_existing_data:false qmnx_clear_directory:@\"" + this.qmnx_clear_directory + "\"\n"
		startup_text += "\tMenuBuildManager.registerCallback()\n"
		startup_text += "\tformat \"MenuBuildManager callbacks registered from JSON data.\\n\"\n"
		startup_text += ")\n"
		startup_text += "catch\n"
		startup_text += "(\n"
		startup_text += "\tformat \"Menu rebuild from JSON failed.\\n\"\n"
		startup_text += ")\n"

		startup_text -- return
	),


	function saveStartupScript =
	(
		startup_text = this.createStartupScriptText()

		startup_file = createFile this.startup_file_path
		format "%" startup_text to:startup_file
		close startup_file

		format "Startup loader saved to:\n%\n" this.startup_file_path

		this.startup_file_path -- return
	),


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


	function loadAllQuadMenus =
	(
		global MenuRebuilder_qmnx_clear_guard

		if MenuRebuilder_qmnx_clear_guard then
		(
			format "MenuBuildManager_v.loadAllQuadMenus skipped. QMNX clear guard is active.\n"
			ok -- return
		)
		else
		(
			quad_menu_manager = callbacks.notificationParam()

			if quad_menu_manager == undefined then
			(
				format "MenuBuildManager_v.loadAllQuadMenus failed. quad_menu_manager is undefined.\n"
			)
			else
			(
				this.clearDefaultQuadPositionsForAllData()

				for menu_data in this.saved_menus_data do
				(
					if this.isQuadCallbackData menu_data then
					(
						menu_rebuilder = MenuRebuilder_v \
							menu_data:menu_data \
							skip_default_qmnx_clear:true

						menu_rebuilder.rebuildAsQuadMenu quad_menu_manager
					)
				)
			)

			ok -- return
		)
	),


	function hasMenuCallbackData =
	(
		was_found = false

		for menu_data in this.saved_menus_data while not was_found do
		(
			was_found = this.isMenuCallbackData menu_data
		)

		was_found -- return
	),


	function hasQuadCallbackData =
	(
		was_found = false

		for menu_data in this.saved_menus_data while not was_found do
		(
			was_found = this.isQuadCallbackData menu_data
		)

		was_found -- return
	),


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


	function unregisterCallback =
	(
		callbacks.removeScripts id:this.callback_id
		callbacks.removeScripts id:this.quad_callback_id

		ok -- return
	),


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
    SECTION 08: JSON MANAGER ROLLOUT
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


	function getManager =
	(
		if json_manager == undefined then
		(
			json_manager = MenuBuildManager_v()
		)

		json_manager -- return
	)


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
	)


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
	)


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
	)


	function deleteAllFromJson =
	(
		if queryBox "Delete all menu and quad menu entries from JSON file?" title:"Menu JSON Manager" then
		(
			manager_value = this.getManager()
			manager_value.deleteAllMenusFromJson()
			this.refreshLists()
		)

		ok -- return
	)


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
    SECTION 09: TESTS
    ====================================================================================================
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


function createTestDefaultViewportQuadInjectionDefinition =
(
	quad_definition = MenuDefinition_v \
		type:#quad \
		title:"_MENU_REBUILDER_DEFAULT_QUAD_INJECT" \
		quad_modifier:#nonePressed

	quad_definition.data = #()

	quad_top_right = quad_definition.addQuad "Top Right" position:#TopRight
	quad_top_right.addItem "_MENU_REBUILDER_TEST_CATEGORY" "_MENU_REBUILDER_TEST_MACRO_4" title:"Injected Top Right"

	quad_bottom_right = quad_definition.addQuad "Bottom Right" position:#BottomRight
	quad_bottom_right.addItem "_MENU_REBUILDER_TEST_CATEGORY" "_MENU_REBUILDER_TEST_MACRO_5" title:"Injected Bottom Right"

	quad_definition -- return
)


function createTestCustomModifierQuadDefinition =
(
	quad_definition = MenuDefinition_v \
		type:#quad \
		title:"_MENU_REBUILDER_CUSTOM_SHIFT_CTRL_QUAD" \
		quad_modifier:#shiftAndControlPressed

	quad_definition.data = #()

	quad_top_right = quad_definition.addQuad "Top Right" position:#TopRight
	quad_top_right.addItem "_MENU_REBUILDER_TEST_CATEGORY" "_MENU_REBUILDER_TEST_MACRO_6" title:"Custom Quad Item"

	quad_definition -- return
)


function testMenuBuildManagerDefaultQuadInject =
(
	global MenuBuildManager

	for macro_index = 1 to 6 do
	(
		generateMockMacroScript "_MENU_REBUILDER_TEST_CATEGORY" ("_MENU_REBUILDER_TEST_MACRO_" + (macro_index as string))
	)

	menu_definition = createTestMenuDefinition()
	quad_definition = createTestDefaultViewportQuadInjectionDefinition()

	menus_data = #(menu_definition, quad_definition)

	MenuBuildManager = MenuBuildManager_v menus_data:menus_data

	saved_menus_data = MenuBuildManager.run()

	saved_menus_data -- return
)


function testMenuBuildManagerCustomModifierQuad =
(
	global MenuBuildManager

	for macro_index = 1 to 6 do
	(
		generateMockMacroScript "_MENU_REBUILDER_TEST_CATEGORY" ("_MENU_REBUILDER_TEST_MACRO_" + (macro_index as string))
	)

	quad_definition = createTestCustomModifierQuadDefinition()

	MenuBuildManager = MenuBuildManager_v menus_data:#(quad_definition)

	saved_menus_data = MenuBuildManager.run()

	saved_menus_data -- return
)


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


/*  ====================================================================================================
    SECTION 10: MANUAL TEST CALLS
    ====================================================================================================

    -- Injects into existing Default Viewport Quad:
    saved_menus_data = testMenuBuildManagerDefaultQuadInject()

    -- Creates custom Ctrl+Shift+RMB quad:
    saved_menus_data = testMenuBuildManagerCustomModifierQuad()

    -- Reload from JSON:
    saved_menus_data = testMenuBuildManagerFromJson()

    -- Open JSON manager:
    openMenuBuildManagerJsonRollout()

    -- Clear JSON:
    menu_manager = MenuBuildManager_v()
    menu_manager.clearJsonFile()

    -- Debug qmnx roots:
    qmnx_clear = QuadDefaultQmnxClear_v()
    qmnx_clear.printQmnxRoot @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2026 - 64bit\ENU\scripts\MAXSCRIPT-MenuBuilder\MenuRebuilder\qmnx\topRight-clear.qmnx"
    qmnx_clear.printQmnxRoot @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2026 - 64bit\ENU\scripts\MAXSCRIPT-MenuBuilder\MenuRebuilder\qmnx\bottomRight-clear.qmnx"

*/