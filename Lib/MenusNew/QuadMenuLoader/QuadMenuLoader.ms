/*
QuadMenu.ms
Version: 0.14
*/

struct QuadMenuLoader_v
(
	menu_name = "Default Viewport Quad",
	
	context_title = "",
	right_click = #nonePressed,
	quad_menu_manager = undefined,
	quad_context = undefined,
	quad_menu = undefined,
	Quads = undefined,

	quad_keys = #("top_right", "top_left", "bottom_left", "bottom_right"),

	/*
	Fill Quads dictionary from ICuiQuadMenuMgr objects.
	No XML parsing is used here.
	*/
	function fillQuads =
	(
		Quads = Dictionary #string
		
		quad_menu = this.findQuadMenuByTitle()

		if (quad_menu == undefined) then
		(
			format "Quad menu was not found: %\n" menu_name
		)
		else
		(
			for quad_index = 1 to quad_keys.count do
			(
				cui_menu = this.getQuadMenuByIndex quad_index
				format "cui_menu: %\n" cui_menu

				quad = if (cui_menu != undefined) then ( this.createMenuDictionary cui_menu) else (Dictionary #string)
				format "quad: %\n" quad
					
				Quads[quad_keys[quad_index]] = quad
			)
		)

		Quads -- return
	),
	/*
	Get one quadrant menu by index.
	*/
	function getQuadMenuByIndex quad_index =
	(
		result_menu = undefined
		quad_collection = undefined

		if (quad_menu != undefined) then
		(
			quad_collection = this.getCollectionByProperties quad_menu #(#quads, #menus, #quadMenus) -- return

			if (quad_collection != undefined) then
			(
				if (quad_index <= quad_collection.count) then
				(
					result_menu = quad_collection[quad_index]
				)
			)
		)

		result_menu -- return
	),
	
	/*
	Get collection from possible wrapper properties.
	Used because MaxScript CUI wrappers expose collections as properties.
	*/
	function getCollectionByProperties source_object property_names =
	(
		result_collection = undefined

		for property_name in property_names while (result_collection == undefined) do
		(
			if (isProperty source_object property_name) then
			(
				value = getProperty source_object property_name
	
				if (value != undefined) then
				(
					result_collection = value
				)
			)
		)

		result_collection -- return
	),

	/*
	Parse one CUI menu wrapper recursively.
	Items become MenuItem_v. Submenus become nested Dictionary #string.
	*/
	function createMenuDictionary cui_menu =
	(
		format "\n"; print "QuadMenu_v.createMenuDictionary()"
		/*
		Create unique dictionary key.
		Needed because menu titles can be duplicated.
		*/
		function getUniqueDictionaryKey dictionary key =
		(
			new_key = key
			key_index = 1
	
			while (HasDictValue dictionary new_key) do
			(
				key_index += 1
				new_key = key + " [" + (key_index as string) + "]"
			)
	
			new_key -- return
		)
		
		
		result_dictionary = Dictionary #string
		item_collection = this.getCollectionByProperties cui_menu #(#items, #menuItems, #children, #entries) -- return

		if (item_collection != undefined) then
		(
			for item_index = 1 to item_collection.count do
			(
				cui_item = item_collection[item_index]
				
				sub_menu = this.getSubMenuFromItem cui_item

				if (sub_menu != undefined) then
				(
					sub_menu_title = this._getCuiTitle sub_menu

					if (sub_menu_title == "") then
					(
						sub_menu_title = this._getCuiTitle cui_item
					)

					if (sub_menu_title == "") then
					(
						sub_menu_title = "submenu_" + (item_index as string)
					)

					dictionary_key = getUniqueDictionaryKey result_dictionary sub_menu_title
					
					result_dictionary[dictionary_key] = this.createMenuDictionary sub_menu
				)
				else
				(
					menu_item = MenuItem_v source_item:cui_item index:item_index
					
					dictionary_key = getUniqueDictionaryKey result_dictionary menu_item.title
					
					result_dictionary[dictionary_key] = menu_item
				)
			)
		)

		result_dictionary -- return
	),



	/*
	Find quad menu by title in quad menu manager contexts.
	Uses manager.contexts[i].quadmenus[j].
	*/
	function findQuadMenuByTitle =
	(
		found_menu = undefined
		found_context = undefined

		quad_menu_manager = maxops.getICUiQuadMenuMgr() 

		for context_index = 1 to quad_menu_manager.contexts.count while (found_menu == undefined) do
		(
			current_context = quad_menu_manager.contexts[context_index]
			current_context_title = this._getCuiTitle current_context

			if ((context_title == "") or (current_context_title == context_title) or (stringContains current_context_title context_title)) then
			(
				for menu_index = 1 to current_context.quadmenus.count while (found_menu == undefined) do
				(
					current_menu = current_context.quadmenus[menu_index]

					if (this.isMatchingQuadMenu current_menu) then
					(
						found_menu = current_menu
						found_context = current_context
					)
				)
			)
		)

		quad_context = found_context
		found_menu -- return
	),
	
	/*
	Check if CUI quad menu title matches requested menu name.
	*/
	function isMatchingQuadMenu cui_quad_menu =
	(
		result = false
		title_value = this._getCuiTitle cui_quad_menu

		if (title_value == menu_name) then
		(
			result = true
		)

		if (result == false) then
		(
			result = stringContains title_value menu_name
		)

		result -- return
	),

	/*
	Get readable title from CUI object.
	*/
	function _getCuiTitle cui_object =
	(
		/*
		Read first available string property from CUI object.
		*/
		function getFirstStringProperty source_object property_names =
		(
			result_string = ""
	
			for property_name in property_names while (result_string == "") do
			(
				if (isProperty source_object property_name) then
				(
					value = getProperty source_object property_name
		
					if (value != undefined) then
					(
						result_string = value as string
					)
				)
			)
	
			result_string -- return
		)
		
		
		getFirstStringProperty cui_object #(#title, #name, #label, #text) -- return
	),
	
	
	



	
	
	/*
	Set dictionary value.
	Uses native MaxScript Dictionary functions.
	*/
	function setDictionaryValue dictionary key value =
	(
		SetDictValue dictionary key value
		value -- return
	),


	



	/*
	Test if string contains pattern.
	Comparison is case insensitive.
	*/
	function stringContains source_string pattern_string =
	(
		result = false

		if ((source_string != undefined) and (pattern_string != undefined)) then
		(
			result = ((findString (toLower (source_string as string)) (toLower (pattern_string as string))) != undefined)
		)

		result -- return
	),




	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	


	/*
	Get submenu object from CUI menu item wrapper.
	*/
	function getSubMenuFromItem cui_item =
	(
		sub_menu = undefined

		if (isProperty cui_item #subMenu) then
		(
			sub_menu = getProperty cui_item #subMenu
		)

		if ((sub_menu == undefined) and (isProperty cui_item #submenu)) then
		(
			sub_menu = getProperty cui_item #submenu
		)

		sub_menu -- return
	),

	/*
	Print properties exposed by one CUI wrapper.
	Use this to discover exact property names in current 3ds Max build.
	*/
	function printCuiProperties cui_object title:"CUI object" =
	(
		format "\n% properties:\n" title
		property_names = getPropNames cui_object

		for property_name in property_names do
		(
			format "    %\n" property_name
		)

		ok -- return
	),

	/*
	Print all quad contexts and quad menus.
	This verifies title and right click modifier binding.
	*/
	function printAvailableQuadMenus =
	(
		quad_menu_manager = maxops.getICUiQuadMenuMgr() 

		for context_index = 1 to quad_menu_manager.contexts.count do
		(
			current_context = quad_menu_manager.contexts[context_index]
			format "Context %:\n" current_context.title

			for menu_index = 1 to current_context.quadmenus.count do
			(
				current_menu = current_context.quadmenus[menu_index]
				format "    menu: % modifiers: %\n" current_menu.title (current_context.getRightClickModifiers current_menu)
			)
		)

		ok -- return
	),

	/*
	Print diagnostics for current quad menu object.
	Use when quadrant dictionaries are empty.
	*/
	function printDiagnostics =
	(
		if (quad_menu_manager == undefined) then
		(
			quad_menu_manager = maxops.getICUiQuadMenuMgr() 
		)

		format "\nQuad menu manager contexts: %\n" quad_menu_manager.contexts.count

		if (quad_context != undefined) then
		(
			printCuiProperties quad_context title:"Quad context"
		)

		if (quad_menu != undefined) then
		(
			printCuiProperties quad_menu title:"Quad menu"
			format "Quad menu title: %\n" (this._getCuiTitle quad_menu)
		)

		ok -- return
	),

	/*
	Print dictionary tree.
	MenuItem_v prints title and id. Nested dictionaries print recursively.
	*/
	function printDictionary dictionary indent:"" =
	(
		keys = GetDictKeys dictionary

		for key in keys do
		(
			value = GetDictValue dictionary key

			if ((classOf value) == Dictionary) then
			(
				format "%[%]\n" indent key
				printDictionary value indent:(indent + "    ")
			)
			else
			(
				format "%% | id:% | action:%\n" indent value.title value.id value.action_id
			)
		)

		ok -- return
	),

	/*
	Print quad menu tree.
	*/
	function printReport =
	(
		format "Quad menu: %\n" menu_name

		if (quad_menu == undefined) then
		(
			format "Quad menu object was not found.\n"
		)
		else
		(
			printDictionary Quads indent:""
		)

		ok -- return
	),

	on create do
	(
		fillQuads()
	)
)