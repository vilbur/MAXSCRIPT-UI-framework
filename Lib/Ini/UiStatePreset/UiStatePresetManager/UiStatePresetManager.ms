
/** Ui state preset menu
 */
struct UiStatePresetManager_v
(
	/* construct */
	ini_file,
	callbacks	= Dictionary #NAME, -- KEY:#methodName VALUE:"callbackFunction"
	
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
		
		/** Get listbox height
		 */
		function getListboxHeight preset_names = if preset_names.keys.count < 5 then 5 else preset_names.keys.count
		
		rows_count = 1
		
		preset_names = this.getFileNameSuffixes()
		
		manage_button = #( "Save", "Load", "Delete" )
		
		PresetDialog 	    = Dialog_v title:"Presets Manager" width:232  --ini:ini_file width:128
		
		--PresetDialog.addLocal #UiStatePresetManager this
		
		--_Controls   = PresetDialog.Controls()
		_Controls   = PresetDialog.Controls DEBUG:true
		
		--_Controls.control #CHECKBUTTON "checkbutton" highlightColor:red across:1
		--_Controls.control #CHECKBOX "Checkbox"
		_Controls.control #EDITTEXT "Preset name" across:1 labelOnTop:true ini:false

		
		_multilistbox =  _Controls.control #MULTILISTBOX "[preset list]" items:preset_names.keys offset:[0, 0] width:200 height:( getListboxHeight(preset_names) ) across:1 ini:false
		
		
		_multilistbox.Event #selectionEnd  ( "UI_STATE_PRESET_MANAGER.presetSelectedCallback()")
		_multilistbox.Event #doubleClicked ( "UI_STATE_PRESET_MANAGER.loadPreset()")
		
		for method in manage_button do
		(
			_Button = _Controls.control #BUTTON method across:((manage_button.count / rows_count ) as integer ) width:64 height:32 border:false --width:( PresetDialog.width / manage_button.count )
			--format "_Button: %\n" _Button
			
			_Button.Event #Pressed ( "UI_STATE_PRESET_MANAGER."+method+"Preset()")
			--_Button.Event #PRESSED ("format \""+PresetDialog.id as string +"\n\"")
			--_Button.Event #PRESSED ("print \""+PresetDialog.id as string +"\"\n")
			
		)
		
		PresetDialog.create height:undefined

	),
	
	/** Callback
	 */
	function callback type callback =
	(
		--format "\n"; print "UiStatePresetManager_v.callback()"
		this.callbacks[type] = callback
	),
	
	/** Save
	 */
	function savePreset =
	(
		format "\n"; print "UiStatePresetManager_v.SavePreset()"
			
		selected_preset = this._getSelectedPresetFromListbox()
		
		preset_new_name = this._getNewNameFromEditText()

		--preset_path_selected = this._getPresetPath selected_preset
		format "preset_new_name == selected_preset: %\n" (preset_new_name == selected_preset)
		format "preset_new_name == '': %\n" (preset_new_name == "")
		--format "preset_new_name: %\n" preset_new_name
		--preset_path_selected = preset_dir + ini_filename + delimeter + selected_preset[1] + ".ini"
		--format "preset_path_selected: %\n" preset_path_selected
		
		/** Get save method
		 */
		function getSaveMethod selected_preset preset_new_name =
		(
			--format "\n"; print "UiStatePresetManager_v.getSaveMethod()"
			if preset_new_name != "" or selected_preset != undefined then
			(
				if preset_new_name == "" then
				(
					
					
				)
				else if selected_preset == undefined then
				(
					
					
				)
				
			)
		)
		
		save_method = getSaveMethod selected_preset preset_new_name
		format "save_method: %\n" save_method
		
		--/* NEW OR RENAME PRESET */ 
		--if preset_new_name != "" and preset_new_name != selected_preset then
		--(
		--	preset_path_new = this._getPresetPath preset_new_name
		--
		--	/* RENAME */ 
		--	if queryBox ("RENAME PRESET ?\n\n" + selected_preset +"\n\nTO\n\n"+ preset_new_name ) title:"RENAME PRESET"  then
		--		format "RENAME: %\n" preset_path_new
		--	
		--	
		--	/* CREATE NEW PRESET */ 
		--	else
		--		format "NEW PRESET: %\n" preset_path_new
		--	
		--)
		----/* RESAVE PRESET IF EDIT TEXT IS EMPTY OR TEXT IS SAME AS SELCTED PRESET */ 
		--else if preset_new_name == selected_preset then
		--	format "SAVE: %\n" (this._getPresetPath selected_preset)
		--
		--else
		--	messageBox "NOTHING SELECTED \n\n    AND\n\n PRESET NAME IS MEPTY" beep:false
			
	),
	
	/** Load
	 */
	function loadPreset =
	(
		format "\n"; print "UiStatePresetManager_v.loadPreset()"
		format "EventFired: %\n" EventFired
		if ( selected_preset = this._getSelectedPresetFromListbox() ) != "" then
		(
			format "SELECTED_PRESETS: %\n" selected_preset
			
			DIALOG_presets_manager.ET_preset_name.text
			
			preset_path_selected = this._getPresetPath selected_preset[1]
			preset_path_selected = preset_dir + ini_filename + delimeter + selected_preset[1] + ".ini"
			format "preset_path_selected: %\n" preset_path_selected
			format "callbacks: %\n" callbacks
			format "CALLBACK: %\n" callbacks[#loadPreset]
			execute ( callbacks[#loadPreset] + " @\"" + preset_path_selected + "\""  )
		)
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
		if ( selected_preset = this._getSelectedPresetFromListbox() ) != "" then
		(
			for selected_preset in selected_preset do
			(
				
				preset_path_selected = this._getPresetPath selected_preset
				format "preset_path_selected: %\n" preset_path_selected
				
				
			)
			
			
		)
	),
	
	/** Fill edit text field with name of last selected preset
	 */
	function presetSelectedCallback =
	(
		format "\n"; print "UiStatePresetManager_v.presetSelectedCallback()"
		
		/* IF NOTHING IS SELECTED */ 
		if  ( selected_preset = this._getSelectedPresetFromListbox() ) != "" and  \
		/* BUT NEW PRESET NAME EXIST */ 
		this._getNewNameFromEditText() == "" then
			/* FILL EDIT TEXT */ 
			DIALOG_presets_manager.ET_preset_name.text = selected_preset
	),
	
	private
	
	/** Get new name from edit text
	 */
	function _getNewNameFromEditText =
	(
		--format "\n"; print "UiStatePresetManager_v._getNewNameFromEditText()"
		trimLeft DIALOG_presets_manager.ET_preset_name.text --return
	),
	
	/** Get preset path
	 */
	function _getPresetPath preset_name =
	(
		--format "\n"; print "UiStatePresetManager_v._getPresetPath()"
		preset_dir + ini_filename + delimeter + preset_name + ".ini"
	),
	
	/** Get selected preset from listbox
	  
		get last preset if multiple presets are selected
	  
		@return string name of selected preset or empty string
	 */
	function _getSelectedPresetFromListbox =
	(
		format "\n"; print "UiStatePresetManager_v._getSelectedPresetFromListbox()"

		if ( selected_presets = this._getAllSelectedPresetsFromListbox() ).count > 0 then
			selected_presets[selected_presets.count] --return
		else
			"" --return
	),
	
	/** Get selected presets from listbox
	  
		@return #("name of selected preset")
	 */
	function _getAllSelectedPresetsFromListbox =
	(
		format "\n"; print "UiStatePresetManager_v._getSelectedPresetFromListbox()"
		--selected_items = #()
		mlistbox = DIALOG_presets_manager.ML_preset_list
		
		for index in mlistbox.selection collect mlistbox.items[index] --return
	),
	
	function getFileNameSuffixes =
	(
		suffixes	= Dictionary #STRING -- KEY:"Preset Name" VALUE:"Preset file path"
		format "ini_file: %\n" ini_file
		ini_dir = getFilenamePath ini_file
		
		preset_dir = ini_dir + preset_dir_name + "\\"
		
		ini_filename = getFilenameFile ini_file
		extension = getFilenameType ini_file

		
		search_pattern = preset_dir + ini_filename + delimeter + "*" + extension
		
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
