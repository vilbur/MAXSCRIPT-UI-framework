
/** Ui state preset menu
 */
struct UiStatePresetManager_v
(
	/* construct */
	ini_file,
	callback	= Dictionary #NAME, -- KEY:#methodName VALUE:"callbackFunction"
	
	/* required */
	
	/* properties */
	preset_dir_name = "INI-Presets",
	ini_filename = "",
	preset_dir = "",
	delimeter = "-", -- delimenter in "{ini filename}delimenter{preset suffix}.ini" E.G.: "foo-file.ini" >>> "foo-file-preset-A.ini"
	
	/* private */
	private
	
	preset_names,
	
	/* dependency */
	/* reference */
	/* inhered */
	
	public
	
	/** PresetDialog create
	 */
	function dialogCreate =
	(
		--format "\n"; print "UiStatePresetManager_v.dialogCreate()"
		
		manage_button = #( "Save", "Load", "Rename", "Delete" )
		
		PresetDialog 	    = Dialog_v title:"Presets Manager" width:232  --ini:ini_file width:128
		
		--PresetDialog.addLocal #UiStatePresetManager this
		
		--_Controls   = PresetDialog.Controls()
		_Controls   = PresetDialog.Controls DEBUG:true
		
		--_Controls.control #CHECKBUTTON "checkbutton" highlightColor:red across:1
		--_Controls.control #CHECKBOX "Checkbox"
		_Controls.control #EDITTEXT "[preset name]" across:1 labelOnTop:true

		preset_names = this.getFileNameSuffixes()
		
		_multilistbox =  _Controls.control #MULTILISTBOX "[preset list]" items:preset_names.keys offset:[0, 0] width:200 across:1
		
		
		_multilistbox.Event #selectionEnd ( "UI_STATE_PRESET_MANAGER.presetSelected()")
		_multilistbox.Event #doubleClicked ( "UI_STATE_PRESET_MANAGER.loadPreset()")
		
		for method in manage_button do
		(
			_Button = _Controls.control #BUTTON method across:((manage_button.count / 2 ) as integer ) width:96 height:32 --width:( PresetDialog.width / manage_button.count )
			--format "_Button: %\n" _Button
			
			_Button.Event #Pressed ( "UI_STATE_PRESET_MANAGER."+method+"Preset()")
			--_Button.Event #PRESSED ("format \""+PresetDialog.id as string +"\n\"")
			--_Button.Event #PRESSED ("print \""+PresetDialog.id as string +"\"\n")
			
		)
		
		PresetDialog.create height:undefined

	),
	
	
	/** Save
	 */
	function savePreset =
	(
		format "\n"; print "UiStatePresetManager_v.SavePreset()"
	),
	
	/** Load
	 */
	function loadPreset =
	(
		format "\n"; print "UiStatePresetManager_v.loadPreset()"
		
		if ( selected_presets = this._getSelectedPresetFromListbox() ) != undefined then
		(
			_get_preset_path = this._getPresetPath selected_presets[selected_presets.count]
			
			
			
				 
		)
			--execute (callback[#loadPreset] + " @\"" + + "\""  )
	),
	
	
	/** Rename preset
	 */
	function renamePreset =
	(
		format "\n"; print "UiStatePresetManager_v.renamePreset()"
	),
	
	/** Delete preset
	 */
	function deletePreset =
	(
		format "\n"; print "UiStatePresetManager_v.deletePreset()"
	),
	
	/** Preset selected
	 */
	function presetSelected =
	(
		format "\n"; print "UiStatePresetManager_v.presetSelected()"
		--format "EventFired: %\n" EventFired
		if ( selected_presets = this._getSelectedPresetFromListbox() ) != undefined then 
			format "SELECTED_PRESETS: %\n" selected_presets
			--DIALOG_presets_manager.ET_preset_name.text = DIALOG_presets_manager.ML_preset_list.items[(selected_presets as Array )[1]]
		
		
	),
	
	private
	
	/** Get preset path
	 */
	function _getPresetPath preset_name =
	(
		--format "\n"; print "UiStatePresetManager_v._getPresetPath()"
		preset_dir + ini_filename + delimeter + preset_name + ".ini"

	),
	/** Get selected preset from listbox
	  
		@return #("name of selected preset")
	 */
	function _getSelectedPresetFromListbox =
	(
		--format "\n"; print "UiStatePresetManager_v._getSelectedPresetFromListbox()"
		--selected_items = #()
		if not (selected_presets = DIALOG_presets_manager.ML_preset_list.selection).isEmpty then
			for index in selected_presets as Array collect DIALOG_presets_manager.ML_preset_list.items[index] --return
	),
	
	
	function getFileNameSuffixes =
	(
		suffixes	= Dictionary #STRING -- KEY:"Preset Name" VALUE:"Preset file path"
		format "ini_file: %\n" ini_file
		ini_dir = getFilenamePath ini_file
		
		preset_dir = ini_dir + "\\"+preset_dir_name+"\\"
		
		ini_filename = getFilenameFile ini_file
		extension = getFilenameType ini_file

		
		search_pattern = preset_dir + ini_filename + delimeter +"*" + extension
		
		all_files = getFiles search_pattern
		
		--suffixes = #()
		
		-- 4. Loop through files and extract the "difference"
		for f in all_files do
		(
			currentFileName = getFilenameFile f
			
			suffix = substring currentFileName (ini_filename.count + 1 + delimeter.count ) -1
		
			suffixes[suffix] = f
		)
		
		suffixes -- return
	),

	/**
	 */
	on create do
	(
		--format "\n"; print "UiStatePresetManager.onCreate()"
		--for prop in #(  ) where getProperty this prop == undefined do -- CHECK CONSTRUCT PROPERTIES -- Array of this struct properties necessary to run
		--	throw ("\n\n\nUNDEFINED CONSTRUCT PROPERTY\n\n\nSTRUCT:\n\n"+ ((filterString( classof this as string )"(:")[2]) +"\n\n\nPROPERTY:\n\n"+ prop )
	
		global UI_STATE_PRESET_MANAGER = this
	)

)
