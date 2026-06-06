

/*  Menu rebuilder.
    Pure worker: rebuilds saved menu_data into passed menu manager or quad menu manager.
*/
struct MenuRebuilder_v
(
	version = 0.08,
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



