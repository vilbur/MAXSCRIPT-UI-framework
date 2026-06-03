struct MenuRebuilder_v
(
	menu_title = "_TEST_MENU",
	menu_id = "",
	menu_items = Dictionary #string,
	menu_data = Dictionary #name,
	callback_id = #testMenuRebuilderCuiRegisterMenus,
	help_menu_id = "cee8f758-2199-411b-81e7-d3ff4a80d143",


	/*  Creates new guid string.
	    Used when menu id is not loaded from saved data.
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


	/*  Checks if saved item is submenu.
	    Submenu item has #items key.
	*/
	function isSubMenuData item_data =
	(
		isDictionaryValue item_data and HasDictValue item_data #items -- return
	),


	/*  Checks if saved item is macro item.
	    Macro item has #category and #macro keys.
	*/
	function isMacroItemData item_data =
	(
		isDictionaryValue item_data and HasDictValue item_data #category and HasDictValue item_data #macro -- return
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

		menu_data[#id] = menu_id
		menu_data[#title] = menu_title
		menu_data[#items] = menu_items

		menu_data -- return
	),


	/*  Reads constructor menu_data into struct properties.
	    Supports saved root data with #id #title #items.
	*/
	function readMenuData =
	(
		if isDictionaryValue menu_data then
		(
			if HasDictValue menu_data #id then
			(
				menu_id = menu_data[#id]
			)

			if HasDictValue menu_data #title then
			(
				menu_title = menu_data[#title]
			)

			if HasDictValue menu_data #items then
			(
				if isDictionaryValue menu_data[#items] then
				(
					menu_items = menu_data[#items]
				)
			)
		)

		if menu_id == "" then
		(
			menu_id = createGuidString()
		)

		buildMenuData() -- return
	),


	/*  Deletes root menu by saved id.
	    This avoids scanning main menu items.
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
					item_title = item_data[#title]
					macro_category = item_data[#category]
					macro_name = item_data[#macro]

					parent_menu.CreateAction saved_guid macro_name macro_category item_title
				)
				else
				(
					format "MenuRebuilder_v skipped invalid item data at guid: % value: %\n" saved_guid item_data
				)
			)

			true -- return
		)
	),


	/*  Loads menu into CUI from saved data.
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


	/*  Registers CUI rebuild callback.
	    Callback uses global MenuRebuilder instance.
	*/
	function registerCallback =
	(
		callbacks.removeScripts id:callback_id
		callbacks.addScript #cuiRegisterMenus "MenuRebuilder.loadMenu()" id:callback_id

		ok -- return
	),


	/*  Removes CUI rebuild callback.
	    Existing created menu is not removed here.
	*/
	function unregisterCallback =
	(
		callbacks.removeScripts id:callback_id

		ok -- return
	),


	on create do
	(
		readMenuData()
	)
)