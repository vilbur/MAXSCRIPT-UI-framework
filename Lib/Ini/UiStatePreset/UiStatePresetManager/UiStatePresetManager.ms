
/** Ui state preset menu
 */
struct UiStatePresetManager_v
(
	/* construct */
	ini_file,
	
	/* required */
	
	/* properties */
	preset_names,
	
	/* private */
	/* dependency */
	/* reference */
	/* inhered */
	
	/** Dialog create
	 */
	function dialogCreate =
	(
		--format "\n"; print "UiStatePresetManager_v.dialogCreate()"
		
		manage_button = #( "Save", "Load", "Rename", "Delete" )
		
		Dialog 	    = Dialog_v title:"Presets Manager" ini:ini_file width:128
		
		
		_Controls   = Dialog.Controls()
		
		_Controls.control #CHECKBUTTON "checkbutton" highlightColor:red across:1
		_Controls.control #CHECKBOX "Checkbox"
		
		preset_names = this.getFileNameSuffixes()
		
		_multilistbox =  _Controls.control #MULTILISTBOX "Multilistbox" items:preset_names.keys offset:[0, 32] width:200 across:1
		
		
		for method in manage_button do
			_Controls.control #BUTTON method across:((manage_button.count / 2 ) as integer ) width:96 height:32 --width:( Dialog.width / manage_button.count )
	),

	private
	
	function getFileNameSuffixes delimeter:"-" =
	(
		dir = getFilenamePath ini_file
		baseName = getFilenameFile ini_file
		extension = getFilenameType ini_file

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

	/**
	 */
	on create do
	(
		--format "\n"; print "UiStatePresetManager.onCreate()"
		--for prop in #(  ) where getProperty this prop == undefined do -- CHECK CONSTRUCT PROPERTIES -- Array of this struct properties necessary to run
		--	throw ("\n\n\nUNDEFINED CONSTRUCT PROPERTY\n\n\nSTRUCT:\n\n"+ ((filterString( classof this as string )"(:")[2]) +"\n\n\nPROPERTY:\n\n"+ prop )
	)

)
