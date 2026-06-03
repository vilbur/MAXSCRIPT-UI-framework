
struct MenuRebuilder_v
(
	version = 0.01,
	menu_type = #menu,
	menu_title = "_TEST_MENU",
	menu_id = "",
	menu_items = Dictionary #string,
	menu_data = Dictionary #name,
	callback_id = #testMenuRebuilderCuiRegisterMenus,
	quad_callback_id = #testMenuRebuilderCuiRegisterQuadMenus,
	help_menu_id = "cee8f758-2199-411b-81e7-d3ff4a80d143",
	quad_context_id = "ac7c70f8-3f86-4ff5-a510-e4fd6a9c368e",
	quad_modifier = #shiftAndControlPressed,
	quad_position = #TopRight,
	quad_menu_id = "",
	macro_action_table_id = 647394,


	/*  Creates new guid string.
	    Used when saved data has no id.
	*/
	function createGuidString =
	(
		guid_class = dotNetClass "System.Guid"
		guid_value = guid_class.NewGuid()

		guid_value.ToString() -- return
	),


	/*  Checks if value is Dictionary.
	    Prevents GetDictKeys undefined crash.
	*/
	function isDictionaryValue value =
	(
		value != undefined and classOf value == Dictionary -- return
	),


	/*  Safely checks dictionary key.
	    Prevents #name key crash on Dictionary #string.
	*/
	function hasDictValueSafe dictionary_value dictionary_key =
	(
		was_found = false

		if isDictionaryValue dictionary_value then
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


	/*  Gets dictionary key count.
	    Returns zero for non dictionary value.
	*/
	function getDictionaryKeyCount dictionary_value =
	(
		key_count = 0

		if isDictionaryValue dictionary_value then
		(
			key_count = (GetDictKeys dictionary_value).count
		)

		key_count -- return
	),


	/*  Checks if saved item is submenu.
	    Submenu item has #items key.
	*/
	function isSubMenuData item_data =
	(
		isDictionaryValue item_data and hasDictValueSafe item_data #items -- return
	),


	/*  Checks if saved item is macro item.
	    Macro item has #category and #macro keys.
	*/
	function isMacroItemData item_data =
	(
		isDictionaryValue item_data and hasDictValueSafe item_data #category and hasDictValueSafe item_data #macro -- return
	),


	/*  Checks if value is saved item data.
	    Saved item has #title and submenu or macro keys.
	*/
	function isSavedItemData item_data =
	(
		isDictionaryValue item_data and hasDictValueSafe item_data #title and (isSubMenuData item_data or isMacroItemData item_data) -- return
	),


	/*  Checks if dictionary is saved GUID item dictionary.
	    Saved values are Dictionary #name item data.
	*/
	function isSavedItemsDictionary dictionary_value =
	(
		was_found = false

		if isDictionaryValue dictionary_value then
		(
			dictionary_keys = GetDictKeys dictionary_value

			if dictionary_keys.count == 0 then
			(
				was_found = true
			)
			else
			(
				first_item_data = dictionary_value[dictionary_keys[1]]
				was_found = isSavedItemData first_item_data
			)
		)

		was_found -- return
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


	/*  Converts simple title-key dictionary to saved GUID-key dictionary.
	    Source value is macro array or submenu dictionary.
	*/
	function convertSourceItemsToSavedItems source_items =
	(
		saved_items = Dictionary #string

		if isDictionaryValue source_items then
		(
			source_key_array = GetDictKeys source_items

			for source_title in source_key_array do
			(
				source_value = source_items[source_title]
				saved_guid = createGuidString()

				if isDictionaryValue source_value then
				(
					submenu_items = convertSourceItemsToSavedItems source_value
					saved_items[saved_guid] = createSavedSubMenuData source_title submenu_items
				)
				else if classOf source_value == Array then
				(
					if source_value.count >= 2 then
					(
						saved_items[saved_guid] = createSavedMacroItemData source_title source_value[1] source_value[2]
					)
				)
			)
		)

		saved_items -- return
	),


	/*  Normalizes menu items.
	    Accepts saved GUID format or simple title-key test format.
	*/
	function normalizeMenuItems items_value =
	(
		normalized_items = Dictionary #string

		if isDictionaryValue items_value then
		(
			if isSavedItemsDictionary items_value then
			(
				normalized_items = items_value
			)
			else
			(
				normalized_items = convertSourceItemsToSavedItems items_value
			)
		)

		normalized_items -- return
	),


	/*  Builds persistent macro action id.
	    Format is macro name, backtick, category.
	*/
	function getMacroActionId macro_category macro_name =
	(
		persistent_action_id = macro_name + "`" + macro_category

		persistent_action_id -- return
	),


	/*  Creates root saved menu data.
	    Result can be saved to file and loaded on next launch.
	*/
	function buildMenuData =
	(
		menu_data = Dictionary #name

		if menu_id == "" then
		(
			menu_id = createGuidString()
		)

		if quad_menu_id == "" then
		(
			quad_menu_id = createGuidString()
		)

		menu_data[#version] = version
		menu_data[#id] = menu_id
		menu_data[#title] = menu_title
		menu_data[#type] = menu_type
		menu_data[#items] = menu_items
		menu_data[#quad_context_id] = quad_context_id
		menu_data[#quad_modifier] = quad_modifier
		menu_data[#quad_position] = quad_position
		menu_data[#quad_menu_id] = quad_menu_id

		menu_data -- return
	),


	/*  Reads saved root data into struct properties.
	    Also accepts simple title-key dictionary as menu_data.
	*/
	function readMenuData =
	(
		if isDictionaryValue menu_data and getDictionaryKeyCount menu_data > 0 then
		(
			if hasDictValueSafe menu_data #version then
			(
				version = menu_data[#version]
			)

			if hasDictValueSafe menu_data #id then
			(
				menu_id = menu_data[#id]
			)

			if hasDictValueSafe menu_data #title then
			(
				menu_title = menu_data[#title]
			)

			if hasDictValueSafe menu_data #type then
			(
				menu_type = menu_data[#type]
			)

			if hasDictValueSafe menu_data #items then
			(
				menu_items = normalizeMenuItems menu_data[#items]
			)
			else
			(
				menu_items = normalizeMenuItems menu_data
			)

			if hasDictValueSafe menu_data #quad_context_id then
			(
				quad_context_id = menu_data[#quad_context_id]
			)

			if hasDictValueSafe menu_data #quad_modifier then
			(
				quad_modifier = menu_data[#quad_modifier]
			)

			if hasDictValueSafe menu_data #quad_position then
			(
				quad_position = menu_data[#quad_position]
			)

			if hasDictValueSafe menu_data #quad_menu_id then
			(
				quad_menu_id = menu_data[#quad_menu_id]
			)
		)
		else
		(
			menu_items = normalizeMenuItems menu_items
		)

		if menu_id == "" then
		(
			menu_id = createGuidString()
		)

		if quad_menu_id == "" then
		(
			quad_menu_id = createGuidString()
		)

		buildMenuData() -- return
	),


	/*  Deletes root main menu by saved id.
	    Used only for normal menu bar menu.
	*/
	function deleteRootMenu main_menu_bar =
	(
		was_deleted = false

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


	/*  Rebuilds menu items from saved dictionary.
	    Dictionary key is reused as CUI item guid.
	*/
	function rebuildMenuItems parent_menu saved_items =
	(
		if not isDictionaryValue saved_items then
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

				if isSubMenuData item_data then
				(
					submenu_title = item_data[#title]
					submenu_items = item_data[#items]

					submenu_menu = parent_menu.CreateSubMenu saved_guid submenu_title

					if submenu_menu != undefined then
					(
						rebuildMenuItems submenu_menu submenu_items
					)
				)
				else if isMacroItemData item_data then
				(
					macro_category = item_data[#category]
					macro_name = item_data[#macro]
					persistent_action_id = getMacroActionId macro_category macro_name

					parent_menu.CreateAction saved_guid macro_action_table_id persistent_action_id
				)
				else
				(
					format "MenuRebuilder_v skipped invalid item data at guid: % value: %\n" saved_guid item_data
				)
			)

			true -- return
		)
	),


	/*  Loads normal menu into main menu bar.
	    Existing root menu is deleted by saved id before rebuild.
	*/
	function loadMenu =
	(
		menu_manager = callbacks.notificationParam()

		if menu_manager == undefined then
		(
			format "MenuRebuilder_v.loadMenu must be called from #cuiRegisterMenus callback.\n"
			false -- return
		)
		else
		(
			main_menu_bar = menu_manager.mainMenuBar

			deleteRootMenu main_menu_bar

			root_menu = main_menu_bar.CreateSubMenu menu_id menu_title beforeId:help_menu_id

			if root_menu != undefined then
			(
				rebuildMenuItems root_menu menu_items
			)

			buildMenuData() -- return
		)
	),


	/*  Gets quad context from quad menu manager.
	    Default context is main viewport right click context.
	*/
	function getQuadContext quad_menu_manager =
	(
		quad_context = undefined

		if quad_menu_manager != undefined then
		(
			try
			(
				quad_context = quad_menu_manager.GetContextById quad_context_id
			)
			catch
			(
				quad_context = undefined
			)
		)

		quad_context -- return
	),


	/*  Creates custom quad root menu.
	    Assigns it to requested right click modifier.
	*/
	function createQuadRootMenu quad_context =
	(
		quad_menu = undefined

		if quad_context != undefined then
		(
			try
			(
				quad_menu = quad_context.CreateQuadMenu menu_id menu_title

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


	/*  Creates quadrant menu inside quad root.
	    This menu receives rebuilt saved menu items.
	*/
	function createQuadPositionMenu quad_menu =
	(
		quad_position_menu = undefined

		if quad_menu != undefined then
		(
			try
			(
				quad_position_menu = quad_menu.CreateMenu quad_menu_id menu_title quad_position
			)
			catch
			(
				quad_position_menu = undefined
			)
		)

		quad_position_menu -- return
	),


	/*  Loads saved data as custom quad menu.
	    Called from #cuiRegisterQuadMenus callback.
	*/
	function loadQuadMenu =
	(
		quad_menu_manager = callbacks.notificationParam()

		if quad_menu_manager == undefined then
		(
			format "MenuRebuilder_v.loadQuadMenu must be called from #cuiRegisterQuadMenus callback.\n"
			false -- return
		)
		else
		(
			quad_context = getQuadContext quad_menu_manager
			quad_menu = createQuadRootMenu quad_context
			quad_position_menu = createQuadPositionMenu quad_menu

			if quad_position_menu != undefined then
			(
				rebuildMenuItems quad_position_menu menu_items
			)
			else
			(
				format "MenuRebuilder_v.loadQuadMenu failed. Quad position menu is undefined.\n"
			)

			buildMenuData() -- return
		)
	),


	/*  Registers normal menu callback.
	    Callback uses global MenuRebuilder instance.
	*/
	function registerMenuCallback =
	(
		callbacks.removeScripts id:callback_id
		callbacks.addScript #cuiRegisterMenus "MenuRebuilder.loadMenu()" id:callback_id

		ok -- return
	),


	/*  Registers quad menu callback.
	    Callback uses global MenuRebuilder instance.
	*/
	function registerQuadCallback =
	(
		callbacks.removeScripts id:quad_callback_id
		callbacks.addScript #cuiRegisterQuadMenus "MenuRebuilder.loadQuadMenu()" id:quad_callback_id

		ok -- return
	),


	/*  Registers callback by menu_type.
	    Supported values are #menu #quad #both.
	*/
	function registerCallback =
	(
		if menu_type == #menu then
		(
			registerMenuCallback()
		)
		else if menu_type == #quad then
		(
			registerQuadCallback()
		)
		else if menu_type == #both then
		(
			registerMenuCallback()
			registerQuadCallback()
		)

		ok -- return
	),


	/*  Removes registered CUI callbacks.
	    Existing already-created menu is not removed here.
	*/
	function unregisterCallback =
	(
		callbacks.removeScripts id:callback_id
		callbacks.removeScripts id:quad_callback_id

		ok -- return
	),


	on create do
	(
		readMenuData()
	)
)

