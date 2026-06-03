struct MenuRebuilder_v
(
	version = 0.04,
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


	/*  Gets dictionary key count.
	    Returns zero for non dictionary value.
	*/
	function getDictionaryKeyCount dictionary_value =
	(
		key_count = 0

		if this.isDictionaryValue dictionary_value then
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
		was_submenu = false

		if this.isDictionaryValue item_data then
		(
			was_submenu = this.hasDictValueSafe item_data #items
		)

		was_submenu -- return
	),


	/*  Checks if saved item is macro item.
	    Macro item has #category and #macro keys.
	*/
	function isMacroItemData item_data =
	(
		was_macro_item = false

		if this.isDictionaryValue item_data then
		(
			if this.hasDictValueSafe item_data #category then
			(
				if this.hasDictValueSafe item_data #macro then
				(
					was_macro_item = true
				)
			)
		)

		was_macro_item -- return
	),


	/*  Checks if value is saved item data.
	    Saved item has #title and submenu or macro keys.
	*/
	function isSavedItemData item_data =
	(
		was_saved_item = false

		if this.isDictionaryValue item_data then
		(
			if this.hasDictValueSafe item_data #title then
			(
				if this.isSubMenuData item_data then
				(
					was_saved_item = true
				)
				else if this.isMacroItemData item_data then
				(
					was_saved_item = true
				)
			)
		)

		was_saved_item -- return
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
	    Accepts saved GUID format or simple title-key test format.
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
		if this.menu_id == "" then
		(
			this.menu_id = this.createGuidString()
		)

		if this.quad_menu_id == "" then
		(
			this.quad_menu_id = this.createGuidString()
		)

		this.menu_data = Dictionary #name
		this.menu_data[#version] = this.version
		this.menu_data[#id] = this.menu_id
		this.menu_data[#title] = this.menu_title
		this.menu_data[#type] = this.menu_type
		this.menu_data[#items] = this.menu_items
		this.menu_data[#quad_context_id] = this.quad_context_id
		this.menu_data[#quad_modifier] = this.quad_modifier
		this.menu_data[#quad_position] = this.quad_position
		this.menu_data[#quad_menu_id] = this.quad_menu_id

		this.menu_data -- return
	),


	/*  Reads saved root data into struct properties.
	    Also accepts simple title-key dictionary as menu_data.
	*/
	function readMenuData =
	(
		menu_data_key_count = 0

		if this.isDictionaryValue this.menu_data then
		(
			menu_data_key_count = this.getDictionaryKeyCount this.menu_data
		)

		if menu_data_key_count > 0 then
		(
			if this.hasDictValueSafe this.menu_data #version then
			(
				this.version = this.menu_data[#version]
			)

			if this.hasDictValueSafe this.menu_data #id then
			(
				this.menu_id = this.menu_data[#id]
			)

			if this.hasDictValueSafe this.menu_data #title then
			(
				this.menu_title = this.menu_data[#title]
			)

			if this.hasDictValueSafe this.menu_data #type then
			(
				this.menu_type = this.menu_data[#type]
			)

			if this.hasDictValueSafe this.menu_data #items then
			(
				this.menu_items = this.normalizeMenuItems this.menu_data[#items]
			)
			else
			(
				this.menu_items = this.normalizeMenuItems this.menu_data
			)

			if this.hasDictValueSafe this.menu_data #quad_context_id then
			(
				this.quad_context_id = this.menu_data[#quad_context_id]
			)

			if this.hasDictValueSafe this.menu_data #quad_modifier then
			(
				this.quad_modifier = this.menu_data[#quad_modifier]
			)

			if this.hasDictValueSafe this.menu_data #quad_position then
			(
				this.quad_position = this.menu_data[#quad_position]
			)

			if this.hasDictValueSafe this.menu_data #quad_menu_id then
			(
				this.quad_menu_id = this.menu_data[#quad_menu_id]
			)
		)
		else
		(
			this.menu_items = this.normalizeMenuItems this.menu_items
		)

		if this.menu_id == "" then
		(
			this.menu_id = this.createGuidString()
		)

		if this.quad_menu_id == "" then
		(
			this.quad_menu_id = this.createGuidString()
		)

		this.buildMenuData() -- return
	),


	/*  Deletes root main menu by saved id.
	    Used only for normal menu bar menu.
	*/
	function deleteRootMenu main_menu_bar =
	(
		was_deleted = false

		if this.menu_id != "" then
		(
			try
			(
				was_deleted = main_menu_bar.DeleteItem this.menu_id
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

			this.deleteRootMenu main_menu_bar

			root_menu = main_menu_bar.CreateSubMenu this.menu_id this.menu_title beforeId:this.help_menu_id

			if root_menu != undefined then
			(
				this.rebuildMenuItems root_menu this.menu_items
			)

			this.buildMenuData() -- return
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
				quad_context = quad_menu_manager.GetContextById this.quad_context_id
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
				quad_menu = quad_context.CreateQuadMenu this.menu_id this.menu_title

				if quad_menu != undefined then
				(
					quad_context.SetRightClickModifiers quad_menu this.quad_modifier
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
				quad_position_menu = quad_menu.CreateMenu this.quad_menu_id this.menu_title this.quad_position
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
			quad_context = this.getQuadContext quad_menu_manager
			quad_menu = this.createQuadRootMenu quad_context
			quad_position_menu = this.createQuadPositionMenu quad_menu

			if quad_position_menu != undefined then
			(
				this.rebuildMenuItems quad_position_menu this.menu_items
			)
			else
			(
				format "MenuRebuilder_v.loadQuadMenu failed. Quad position menu is undefined.\n"
			)

			this.buildMenuData() -- return
		)
	),


	/*  Registers normal menu callback.
	    Callback uses global MenuRebuilder instance.
	*/
	function registerMenuCallback =
	(
		callbacks.removeScripts id:this.callback_id
		callbacks.addScript #cuiRegisterMenus "MenuRebuilder.loadMenu()" id:this.callback_id

		ok -- return
	),


	/*  Registers quad menu callback.
	    Callback uses global MenuRebuilder instance.
	*/
	function registerQuadCallback =
	(
		callbacks.removeScripts id:this.quad_callback_id
		callbacks.addScript #cuiRegisterQuadMenus "MenuRebuilder.loadQuadMenu()" id:this.quad_callback_id

		ok -- return
	),


	/*  Registers callback by menu_type.
	    Supported values are #menu #quad #both.
	*/
	function registerCallback =
	(
		if this.menu_type == #menu then
		(
			this.registerMenuCallback()
		)
		else if this.menu_type == #quad then
		(
			this.registerQuadCallback()
		)
		else if this.menu_type == #both then
		(
			this.registerMenuCallback()
			this.registerQuadCallback()
		)

		ok -- return
	),


	/*  Removes registered CUI callbacks.
	    Existing already-created menu is not removed here.
	*/
	function unregisterCallback =
	(
		callbacks.removeScripts id:this.callback_id
		callbacks.removeScripts id:this.quad_callback_id

		ok -- return
	),


	on create do
	(
		this.readMenuData()
	)
)


