/* QuadMenu_v for 3ds Max 2026 CUI quad menu system.
   Uses #cuiRegisterQuadMenus and maxOps.GetICuiQuadMenuMgr().
*/

global QuadMenu_v_registry
if QuadMenu_v_registry == undefined then
(
	QuadMenu_v_registry = #()
)

global QuadMenu_v_callback_id
QuadMenu_v_callback_id = #QuadMenu_v_registerAll

/* Register all QuadMenu_v instances into current CUI quad menu manager.
*/
function QuadMenu_v_registerAll =
(
	quad_menu_mgr = callbacks.notificationParam()

	if QuadMenu_v_registry != undefined then
	(
		for quad_menu_item in QuadMenu_v_registry where quad_menu_item != undefined do
		(
			quad_menu_item.buildFromCallback quad_menu_mgr
		)
	)

	true -- return
)

/* Wrapper for 3ds Max 2026 CUI QuadMenu.
*/
struct QuadMenu_v
(
	menu_name = "UnnamedQuad", 
	prefix = "_",
	right_click = #nonePressed,
	context_guid = "ac7c70f8-3f86-4ff5-a510-e4fd6a9c368e",
	quad_guid = undefined,
	use_existing_right_click = false,
	clear_existing = true,
	auto_reload = true,

	QuadMenu = undefined,
	Quads = #(),

	private

	quad_titles = #(undefined, undefined, undefined, undefined),
	action_items = #(),
	callback_string = "QuadMenu_v_registerAll()",
	hotkeys = #( #nonePressed, #shiftPressed, #altPressed, #controlPressed, #shiftAndAltPressed, #shiftAndControlPressed, #controlAndAltPressed, #shiftAndAltAndControlPressed ),

	public

	/* Add macroScript action item into quad menu.
	   action_name is macroScript name, category is macroScript category.
	*/
	function addAction action_name category quad_index:#TOP_RIGHT title:undefined item_guid:undefined action_table_id:647394 separator_before:false =
	(
		quad_pos = this._getQuadPosition quad_index
		action_string = (action_name as string) + "`" + (category as string)

		if item_guid == undefined then
		(
			item_guid = this._makeStableGuid ((this._getFullName()) + "|" + (quad_pos as string) + "|" + action_string + "|" + (title as string))
		)

		if separator_before == true then
		(
			this.addSeparator quad_index:quad_pos
		)

		append action_items #( #action, quad_pos, item_guid, action_table_id, action_string, title )

		if auto_reload == true then
		(
			this.reloadConfiguration()
		)

		this -- return
	),

	/* Add macroScript action item into quad menu. Alias for addAction. */
	function addItem action_name category quad_index:#TOP_RIGHT title:undefined item_guid:undefined action_table_id:647394 separator_before:false =
	(
		this.addAction action_name category quad_index:quad_index title:title item_guid:item_guid action_table_id:action_table_id separator_before:separator_before -- return
	),

	/* Add separator into quad menu. */
	function addSeparator quad_index:#TOP_RIGHT item_guid:undefined =
	(
		quad_pos = this._getQuadPosition quad_index

		if item_guid == undefined then
		(
			item_guid = this._makeStableGuid ((this._getFullName()) + "|" + (quad_pos as string) + "|separator|" + ((action_items.count + 1) as string))
		)

		append action_items #( #separator, quad_pos, item_guid )

		if auto_reload == true then
		(
			this.reloadConfiguration()
		)

		this -- return
	),

	/* Set title of one quad quadrant. */
	function setQuadTitle title quad_index:#TOP_RIGHT =
	(
		quad_number = this._getQuadNumber quad_index
		quad_titles[quad_number] = title as string

		if auto_reload == true then
		(
			this.reloadConfiguration()
		)

		this -- return
	),

	/* Compatibility method for older wrapper usage. */
	function addMenu menu_or_name quad_index =
	(
		menu_title = menu_or_name as string

		if (superClassOf menu_or_name) == StructDef then
		(
			if isProperty menu_or_name #name then
			(
				menu_title = menu_or_name.name as string
			)
		)

		this.setQuadTitle menu_title quad_index:quad_index -- return
	),

	/* Get CUI menu by quadrant. */
	function getMenu quad_index =
	(
		quad_pos = this._getQuadPosition quad_index

		if QuadMenu == undefined then
		(
			this._setCurrentQuadMenu()
		)

		if QuadMenu != undefined then
		(
			QuadMenu.GetMenuByPos quad_pos -- return
		)
		else
		(
			undefined -- return
		)
	),

	/* No-op compatibility method. */
	function showAllQuads switch:true =
	(
		this -- return
	),

	/* Set viewport right click modifier for this quad menu. */
	function setRightClick which:#nonePressed =
	(
		right_click = which

		if auto_reload == true then
		(
			this.reloadConfiguration()
		)

		format "ASSIGN HOTKEY TO QUADMENU: \"%\" HOTKEY: %\n" (this._getFullName()) right_click

		this -- return
	),

	/* Reset right click to default. */
	function resetRightClick =
	(
		format "WARNING: QuadMenu_v.resetRightClick() is not implemented for 3ds Max 2026 CUI quad menus.\n"
		this -- return
	),

	/* Set hotkey from string or name. */
	function setHotkey hotkey =
	(
		if (hotkey_name = this._getHotkeyFromString hotkey) != undefined then
		(
			this.setRightClick which:hotkey_name
		)
		else
		(
			format "WARNING: invalid quad menu hotkey: %\n" hotkey
		)

		this -- return
	),

	/* Register callback and force CUI quad menu reload. */
	function reloadConfiguration =
	(
		callbacks.removeScripts id:QuadMenu_v_callback_id
		callbacks.addScript #cuiRegisterQuadMenus callback_string id:QuadMenu_v_callback_id

		quad_menu_mgr = maxOps.GetICuiQuadMenuMgr()

		if quad_menu_mgr != undefined then
		(
			quad_menu_mgr.LoadConfiguration (quad_menu_mgr.GetCurrentConfiguration())
		)

		this -- return
	),

	/* Build quad menu from #cuiRegisterQuadMenus callback. */
	function buildFromCallback quad_menu_mgr =
	(
		if quad_guid == undefined then
		(
			quad_guid = this._makeStableGuid ((this._getFullName()) + "|quad")
		)

		viewport_context = quad_menu_mgr.GetContextById context_guid

		if viewport_context != undefined then
		(
			-- Check for an existing menu bound to this hotkey or title
			existing_menu_by_hotkey = viewport_context.GetRightClickMenuByModifiers right_click
			
			if existing_menu_by_hotkey != undefined then
			(
				QuadMenu = existing_menu_by_hotkey
				quad_guid = QuadMenu.Id -- Hijack the GUID of the existing menu to modify it safely
			)
			else if use_existing_right_click == true then
			(
				QuadMenu = viewport_context.GetRightClickMenuByModifiers right_click
			)
			else
			(
				QuadMenu = viewport_context.CreateQuadMenu quad_guid (this._getFullName())
			)

			if QuadMenu != undefined then
			(
				-- Safely attempt to clear out old quadrants if requested
				if clear_existing == true then
				(
					for quad_number = 1 to 4 do
					(
						local q_pos = this._getQuadPosition quad_number
						local existing_quad = QuadMenu.GetMenuByPos q_pos
						if existing_quad != undefined do
						(
							-- Attempt to clear items using available CUI methods, swallow error if unsupported
							--try ( existing_quad.ClearItems() ) catch ()
							--try ( existing_quad.Clear() ) catch ()
							
							existing_quad.ClearItems()
							existing_quad.Clear()
							
						)
					)
				)

				-- Ensure the hotkey modifier is explicitly mapped to this menu
				viewport_context.SetRightClickModifiers QuadMenu right_click
			)

			this._buildQuadrants()
			this._buildActions()
		)

		QuadMenu -- return
	),

	private

	/* Create or fetch all quadrant menus. */
	function _buildQuadrants =
	(
		Quads = #()

		for quad_number = 1 to 4 do
		(
			quad_pos = this._getQuadPosition quad_number
			quad_menu = undefined

			if QuadMenu != undefined then
			(
				quad_menu = QuadMenu.GetMenuByPos quad_pos

				if quad_menu == undefined then
				(
					quad_menu = QuadMenu.CreateMenu (this._getQuadGuid quad_number) (this._getQuadTitle quad_number) quad_pos
				)
			)

			append Quads quad_menu
		)

		Quads -- return
	),

	/* Create all stored actions and separators. */
	function _buildActions =
	(
		for action_item in action_items do
		(
			item_type = action_item[1]
			quad_pos = action_item[2]
			menu = this.getMenu quad_pos

			if menu != undefined then
			(
				case item_type of
				(
					#action:
					(
						item_guid = action_item[3]
						action_table_id = action_item[4]
						action_string = action_item[5]
						title = action_item[6]

						if title == undefined then
						(
							menu.CreateAction item_guid action_table_id action_string
						)
						else
						(
							menu.CreateAction item_guid action_table_id action_string title:(title as string)
						)
					)

					#separator:
					(
						item_guid = action_item[3]
						menu.CreateSeparator item_guid
					)
				)
			)
		)

		true -- return
	),

	/* Get current CUI quad menu from current configuration. */
	function _setCurrentQuadMenu =
	(
		quad_menu_mgr = maxOps.GetICuiQuadMenuMgr()

		if quad_menu_mgr != undefined then
		(
			viewport_context = quad_menu_mgr.GetContextById context_guid

			if viewport_context != undefined then
			(
				QuadMenu = viewport_context.GetRightClickMenuByModifiers right_click
			)
		)

		QuadMenu -- return
	),

	/* Register this struct instance globally. */
	function _registerInstance =
	(
		if QuadMenu_v_registry == undefined then
		(
			QuadMenu_v_registry = #()
		)

		for registry_index = QuadMenu_v_registry.count to 1 by -1 do
		(
			registry_item = QuadMenu_v_registry[registry_index]

			if registry_item == undefined then
			(
				deleteItem QuadMenu_v_registry registry_index
			)
			else
			(
				if registry_item.menu_name == this.menu_name then
				(
					deleteItem QuadMenu_v_registry registry_index
				)
			)
		)

		append QuadMenu_v_registry this

		this -- return
	),

	/* Get stable GUID for menu item from string source. */
	function _makeStableGuid source =
	(
		md5_class = dotNetClass "System.Security.Cryptography.MD5"
		encoding_class = dotNetClass "System.Text.Encoding"
		bit_converter_class = dotNetClass "System.BitConverter"

		md5 = md5_class.Create()
		bytes = encoding_class.UTF8.GetBytes (source as string)
		hash = md5.ComputeHash bytes
		hex_string = bit_converter_class.ToString hash
		hex_string = substituteString hex_string "-" ""
		hex_string = toLower hex_string

		(substring hex_string 1 8) + "-" + \
		(substring hex_string 9 4) + "-" + \
		(substring hex_string 13 4) + "-" + \
		(substring hex_string 17 4) + "-" + \
		(substring hex_string 21 12) -- return
	),

	/* Get full quad menu name. */
	function _getFullName =
	(
		if not matchPattern menu_name pattern:(prefix + "*") ignoreCase:false then
		(
			prefix + menu_name -- return
		)
		else
		(
			menu_name -- return
		)
	),

	/* Get quad title by number. */
	function _getQuadTitle quad_number =
	(
		if quad_titles[quad_number] != undefined then
		(
			quad_titles[quad_number] -- return
		)
		else
		(
			(this._getFullName()) + "-" + (quad_number as string) -- return
		)
	),

	/* Get stable GUID for quadrant. */
	function _getQuadGuid quad_number =
	(
		this._makeStableGuid ((this._getFullName()) + "|quadrant|" + (quad_number as string)) -- return
	),

	/* Get quad number from old or new quadrant value. */
	function _getQuadNumber quad_index =
	(
		case quad_index of
		(
			#BOTTOM_RIGHT: 1
			#BottomRight: 1
			#TOP_RIGHT: 2
			#TopRight: 2
			#TOP_LEFT: 3
			#TopLeft: 3
			#BOTTOM_LEFT: 4
			#BottomLeft: 4
			default: quad_index
		) -- return
	),

	/* Get 3ds Max 2026 CUI quadrant position name. */
	function _getQuadPosition quad_index =
	(
		quad_number = this._getQuadNumber quad_index

		case quad_number of
		(
			1: #BottomRight
			2: #TopRight
			3: #TopLeft
			4: #BottomLeft
			default: quad_index
		) -- return
	),

	/* Get hotkey from name or string prefix. */
	function _getHotkeyFromString hotkey_source =
	(
		if hotkey_source == undefined do return undefined
		
		if (findItem hotkeys (hotkey_source as name)) == 0 then
		(
			hotkey_source = hotkey_source as string
			delimeters = "_- "
			prefix_array = filterString hotkey_source delimeters

			if prefix_array.count > 0 then
			(
				hotkey = trimLeft prefix_array[1] delimeters

				if not matchPattern hotkey pattern:"RightClick" then
				(
					if not matchPattern hotkey pattern:"*Pressed" then
					(
						hotkey = hotkey + "Pressed"
					)

					hotkey = hotkey as name

					if (findItem hotkeys hotkey) > 0 then
					(
						hotkey -- return
					)
				)
				else
				(
					#nonePressed -- return
				)
			)
		)
		else
		(
			hotkey_source as name -- return
		)
	),

	/* Initialize QuadMenu_v instance. */
	on create do
	(
		this._registerInstance()

		if quad_guid == undefined then
		(
			quad_guid = this._makeStableGuid ((this._getFullName()) + "|quad")
		)

		if (hotkey = this._getHotkeyFromString menu_name) != undefined then
		(
			right_click = hotkey
		)

		callbacks.removeScripts id:QuadMenu_v_callback_id
		callbacks.addScript #cuiRegisterQuadMenus callback_string id:QuadMenu_v_callback_id

		if auto_reload == true then
		(
			this.reloadConfiguration()
		)
	)
)
--
--macroScript QuadMenu_v_Test_Action
--category:"QuadMenu_v_Test"
--toolTip:"QuadMenu_v Test Action"
--(
--	messageBox "QuadMenu_v test action executed."
--)
--
--quad_menu_test = QuadMenu_v  right_click:#nonePressed clear_existing:true
--quad_menu_test.setQuadTitle "QuadMenu_v Test" quad_index:#TOP_RIGHT
--quad_menu_test.addItem "QuadMenu_v_Test_Action" "QuadMenu_v_Test" quad_index:#TOP_RIGHT title:"Run QuadMenu_v Test"