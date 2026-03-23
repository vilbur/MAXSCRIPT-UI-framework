/*------------------------------------------------------------------------------
	PRESET MENU
	
	Get preset names from ini filenames
	
	Save\Load menus for each preset
	
	
	ROLLOUT MUST HAVE local vaariable ini = "C:\path\to\file.ini"
	
	
--------------------------------------------------------------------------------*/

/** Get preset menu
 */
/** Ui preset menu
 */
struct UiPresetMenu_v
(
	/* on create */
	Dialog, -- Dialog_v --"./../../../Dialog/Dialog.ms"
	
	/* construct */
	/* required */
	/* properties */
	/* private */
	/* dependency */
	/* reference */
	/* inhered */
	
	/** Create
	 */
	function create Submenu:undefined =
	(
		format "\n"; print "UiPresetMenu_v.create()"
		format "EventFired: %\n" EventFired

	ini_file = if Dialog == undefined and EventFired != undefined then
		EventFired.roll.ini
	
	else if Dialog != undefined then
		Dialog.Ini.getPath()
		
	--	execute ( dialog_id as string ) -- access via rollout id E.G.: DIALOG_test.ini
--format "DialogRollout: %\n" DialogRollout
	--Dialog = execute ( Dialog.id as string + ".ini" ) -- access via rollout id E.G.: DIALOG_test.ini
	--format "DialogRollout.ini: %\n" DialogRollout.ini
--	if DialogRollout != undefined then 
		if ini_file != undefined then
		(
			format "ini_file: %\n" ini_file
			--presets_data = getFileNameSuffixes ini_file
			--format "presets_data: %\n" presets_data
		
			/* DEFINE MAIN MENU */
			Menu = if Submenu != undefined then Submenu else RcMenu_v name:"PresetMenu"
			
			menu_1	= Menu.menu "Dialog Menu"
			menu_1.item "Item 1" "messagebox \"Item 1\""

			--Menu.item ( "Presets Maneger" ) ( "(PresetManager_v(@\""+ini_file +"\"))."+method+"( #"+dialog_id as string +") " ) 
			
	--		/* CREATE SUBMENUS */ 
	--		for method in #( "Save", "Load" ) do
	--		(
	--			/* DEFINE MENU */
	--			submenu = Menu.menu (method + " Preset")
	--			
	--			/* DEFAULT PRESETS */
	--			if method == "Load" then
	--				submenu.item ( toUpper(method) + " Default") ""
	--				--submenu.item ( toUpper(method) + " Default") ( getCallback dialog_id ini_file method ) 
	--			
	--			
	--			/* SEPARATOR */ 
	--			--if presets_data.keys.count > 0 then
	--				--submenu.separator()
	----			
	--			/* PRESETS */ 
	--			--for preset_name in presets_data.keys do
	--				--submenu.item ( preset_name ) ( getCallback dialog_id presets_data[preset_name] method ) id:(method + "_"+preset_name)
	--		)
			
			/*------------------------------------------------------------------------------
			CREATE MENU IN DIALOG
			--------------------------------------------------------------------------------*/
            if Dialog != undefined then 
                Menu.create() --return
			
			/*------------------------------------------------------------------------------
			POPUP MENU WHEN MENU IS CREATED BY CALLBACK OF CONTROL 
			--------------------------------------------------------------------------------*/
            else if EventFired != undefined and Submenu == undefined then 
                Menu.popup() --return
			
			else
				Menu --return
	    )
	),
	
	
	function getFileNameSuffixes file_path delimeter:"-" =
	(
		dir = getFilenamePath file_path
		baseName = getFilenameFile file_path
		extension = getFilenameType file_path

		-- 3. Find all files in that directory starting with the base name
		-- We use a wildcard search: baseName + "*" + extension
		searchPattern = dir + baseName + delimeter +"*" + extension
		all_files = getFiles searchPattern
		
		suffixes = #()
		suffixes	= Dictionary #STRING -- KEY:"Preset Name" VALUE:"Preset file path"
	
		-- 4. Loop through files and extract the "difference"
		for f in all_files do
		(
			currentFileName = getFilenameFile f
			
			suffix = substring currentFileName (baseName.count + 1 + delimeter.count ) -1

			suffixes[suffix] = f
		)
		
		return suffixes
	),
	
	/** Get callback
	 */
	function getCallback dialog_id ini_file method =
	(
		"(PresetManager_v(@\""+ini_file +"\"))."+method+"( #"+dialog_id as string +") "
	),
	

	
	private
	

	/**
	 */
	on create do
	(
		--format "\n"; print "UiPresetMenu.onCreate()"
		--for prop in #(  ) where getProperty this prop == undefined do -- CHECK CONSTRUCT PROPERTIES -- Array of this struct properties necessary to run
		--	throw ("\n\n\nUNDEFINED CONSTRUCT PROPERTY\n\n\nSTRUCT:\n\n"+ ((filterString( classof this as string )"(:")[2]) +"\n\n\nPROPERTY:\n\n"+ prop )
	)

)

