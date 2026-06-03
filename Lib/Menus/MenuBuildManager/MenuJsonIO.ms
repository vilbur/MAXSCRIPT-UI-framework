struct MenuJsonIO_v
(
	json_text = "",
	json_position = 1,
	json_length = 0,
	
	/*  Serializes multiple saved menu data dictionaries to JSON.
		JSON root contains array named menus.
	*/
	function menusDataToJson menus_data_array =
	(
		json_value = "{\n"
	
		json_value += "\t\"version\": 0.05,\n"
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
	
	
	/*  Converts parsed JSON root to array of saved menu data.
		Supports new multi-menu JSON and old single-menu JSON.
	*/
	function jsonRootToMenusData json_root =
	(
		menus_data_array = #()
	
		if this.hasDictValueSafe json_root "menus" then
		(
			json_menus_array = json_root["menus"]
	
			if classOf json_menus_array == Array then
			(
				for json_menu_data in json_menus_array do
				(
					append menus_data_array (this.jsonRootToMenuData json_menu_data)
				)
			)
		)
		else
		(
			append menus_data_array (this.jsonRootToMenuData json_root)
		)
	
		menus_data_array -- return
	),
	
	
	/*  Loads multiple saved menu data dictionaries from JSON file.
		Converts JSON back to array of Dictionary #name roots.
	*/
	function loadMenusDataFromJsonFile json_file_path =
	(
		source_text = this.readTextFile json_file_path
		this.setJsonText source_text
	
		json_root = this.parseJsonValue()
		menus_data_array = this.jsonRootToMenusData json_root
	
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


	/*  Safely checks Dictionary key.
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
		else if text_value == "both" then
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
		json_string = "\"" + (this.escapeJsonString source_string) + "\""

		json_string -- return
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
			json_value += indent + "\t\"title\": " + (this.stringToJson item_data[#title]) + ",\n"
			json_value += indent + "\t\"items\": "
			json_value += this.savedItemsToJson item_data[#items] indent:(indent + "\t")
			json_value += "\n" + indent + "}"
		)
		else
		(
			json_value += indent + "{\n"
			json_value += indent + "\t\"title\": " + (this.stringToJson item_data[#title]) + ",\n"
			json_value += indent + "\t\"category\": " + (this.stringToJson item_data[#category]) + ",\n"
			json_value += indent + "\t\"macro\": " + (this.stringToJson item_data[#macro]) + "\n"
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

				json_value += indent + "\t" + (this.stringToJson saved_guid) + ": "
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


	/*  Serializes saved root menu data to JSON.
	    This is content of MenuRebuilder_data.json.
	*/
	function menuDataToJson menu_data =
	(
		json_value = "{\n"

		json_value += "\t\"version\": " + (menu_data[#version] as string) + ",\n"
		json_value += "\t\"id\": " + (this.stringToJson menu_data[#id]) + ",\n"
		json_value += "\t\"title\": " + (this.stringToJson menu_data[#title]) + ",\n"
		json_value += "\t\"type\": " + (this.stringToJson (this.nameToText menu_data[#type] default_text:"menu")) + ",\n"
		json_value += "\t\"quad_context_id\": " + (this.stringToJson menu_data[#quad_context_id]) + ",\n"
		json_value += "\t\"quad_modifier\": " + (this.stringToJson (this.nameToText menu_data[#quad_modifier] default_text:"shiftAndControlPressed")) + ",\n"
		json_value += "\t\"quad_position\": " + (this.stringToJson (this.nameToText menu_data[#quad_position] default_text:"TopRight")) + ",\n"
		json_value += "\t\"quad_menu_id\": " + (this.stringToJson menu_data[#quad_menu_id]) + ",\n"
		json_value += "\t\"items\": "
		json_value += this.savedItemsToJson menu_data[#items] indent:"\t"
		json_value += "\n}"

		json_value -- return
	),


	/*  Saves saved root menu data to JSON file.
	    JSON file contains only data, no executable code.
	*/
	function saveMenuDataToJsonFile menu_data json_file_path =
	(
		json_value = this.menuDataToJson menu_data

		json_file = createFile json_file_path
		format "%" json_value to:json_file
		close json_file

		json_file_path -- return
	),


	/*  Reads entire text file.
	    Used by JSON loader.
	*/
	function readTextFile file_path =
	(
		file_text = ""
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
		while this.json_position <= this.json_length do
		(
			current_char = this.getCurrentChar()

			if findString " \t\r\n" current_char == undefined then
			(
				exit
			)

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
	    Returns float value.
	*/
	function parseJsonNumber =
	(
		number_text = ""

		while this.json_position <= this.json_length do
		(
			current_char = this.getCurrentChar()

			if findString "-+0123456789.eE" current_char == undefined then
			(
				exit
			)

			number_text += current_char
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


	/*  Converts parsed JSON root to saved menu data.
	    Output root uses Dictionary #name keys.
	*/
	function jsonRootToMenuData json_root =
	(
		menu_data = Dictionary #name

		menu_data[#version] = this.getJsonValue json_root "version" 0.04
		menu_data[#id] = this.getJsonValue json_root "id" ""
		menu_data[#title] = this.getJsonValue json_root "title" "_TEST_MENU"
		menu_data[#type] = this.textToMenuType (this.getJsonValue json_root "type" "menu")
		menu_data[#quad_context_id] = this.getJsonValue json_root "quad_context_id" "ac7c70f8-3f86-4ff5-a510-e4fd6a9c368e"
		menu_data[#quad_modifier] = this.textToQuadModifier (this.getJsonValue json_root "quad_modifier" "shiftAndControlPressed")
		menu_data[#quad_position] = this.textToQuadPosition (this.getJsonValue json_root "quad_position" "TopRight")
		menu_data[#quad_menu_id] = this.getJsonValue json_root "quad_menu_id" ""
		menu_data[#items] = this.jsonItemsToSavedItems (this.getJsonValue json_root "items" (Dictionary #string))

		menu_data -- return
	),


	/*  Loads saved menu data from JSON file.
	    Converts JSON back to Dictionary #name / Dictionary #string structure.
	*/
	function loadMenuDataFromJsonFile json_file_path =
	(
		source_text = this.readTextFile json_file_path
		this.setJsonText source_text

		json_root = this.parseJsonValue()
		menu_data = this.jsonRootToMenuData json_root

		menu_data -- return
	)
)



