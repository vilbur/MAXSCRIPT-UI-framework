

struct MenuCreator_v
(
	menu_title = "_TEST_MENU",
	menu_items = Dictionary #string,
	callback_id = #testMenuCuiRegisterMenus,
	root_menu_id = "0C296CB3-72F1-4761-8992-64F65B2F03FA",
	help_menu_id = "cee8f758-2199-411b-81e7-d3ff4a80d143",
	macro_action_table_id = 647394,


	/*  Creates stable guid from source string.
	    Same input string always creates same guid.
	*/
	function getStableGuidFromString source_string =
	(
		encoding_class = dotNetClass "System.Text.Encoding"
		md5_class = dotNetClass "System.Security.Cryptography.MD5"
		md5_provider = md5_class.Create()

		source_bytes = encoding_class.UTF8.GetBytes source_string
		hash_bytes = md5_provider.ComputeHash source_bytes
		guid_value = dotNetObject "System.Guid" hash_bytes

		guid_value.ToString() -- return
	),


	/*  Creates CUI menu items from dictionary.
	    Dictionary value creates submenu, array value creates macro action.
	*/
	function createCuiMenuItemsFromDictionary parent_menu dictionary_value id_path:"" =
	(
		dictionary_keys = GetDictKeys dictionary_value

		for key_name in dictionary_keys do
		(
			item_value = dictionary_value[key_name]
			item_path = id_path + "/" + key_name

			if ((classOf item_value) == Dictionary) then
			(
				submenu_id = getStableGuidFromString ("submenu|" + item_path)
				submenu_menu = parent_menu.CreateSubMenu submenu_id key_name

				if (submenu_menu != undefined) then
				(
					createCuiMenuItemsFromDictionary submenu_menu item_value id_path:item_path
				)
			)
			else
			(
				macro_category = item_value[1]
				macro_name = item_value[2]
				action_id = getStableGuidFromString ("action|" + item_path + "|" + macro_category + "|" + macro_name)
				permanent_action_id = macro_name + "`" + macro_category

				parent_menu.CreateAction action_id macro_action_table_id permanent_action_id title:key_name
			)
		)

		ok -- return
	),


	/*  Creates root menu and fills it from dictionary.
	    This function is called by #cuiRegisterMenus callback.
	*/
	function registerMenus =
	(
		menu_manager = callbacks.notificationParam()
		main_menu_bar = menu_manager.mainMenuBar

		root_menu = main_menu_bar.CreateSubMenu root_menu_id menu_title beforeId:help_menu_id

		if (root_menu != undefined) then
		(
			createCuiMenuItemsFromDictionary root_menu menu_items id_path:menu_title
		)

		ok -- return
	),


	/*  Registers 3ds Max 2025+ CUI callback.
	    Callback uses global Menu instance.
	*/
	function registerCallback =
	(
		callbacks.removeScripts id:callback_id
		callbacks.addScript #cuiRegisterMenus "Menu.registerMenus()" id:callback_id

		ok -- return
	),


	/*  Removes registered CUI callback.
	    Does not remove already built menu from current CUI state.
	*/
	function unregisterCallback =
	(
		callbacks.removeScripts id:callback_id

		ok -- return
	),


	on create do
	(
		--ok
	)
)
