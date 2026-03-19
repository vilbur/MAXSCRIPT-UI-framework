
global DIALOG_presets_manager

/** Ui state preset menu
 */
struct SuffixManagerDialog_v
(
	/* construct */
	ini_file,
	
	callbacks	= Dictionary #NAME, -- KEY:#methodName VALUE:"callbackFunction"
	
	/* required */
	
	/* properties */
	preset_dir_name = "Presets",
	ini_filename = "",
	preset_dir = "",
	delimeter = "-", -- delimenter in "{ini filename}delimenter{preset suffix}.ini" E.G.: "foo-file.ini" >>> "foo-file-preset-A.ini"
	
	private

	/* controls */ 	
	presets_list,
	edit_new_name,

	/* data */ 
	preset_names,

	preset_name_selected = "",
	preset_name_written = "",
	
	
	--result	= Dictionary #NAME -- KEY: #CALLBACK_ACTION DATA:#(string)|string
	
	
	/* dependency */
	/* reference */
	/* inhered */
	
	public
	
	/** PresetDialog create
	 */
	function dialogCreate =
	(
		--format "\n"; print "SuffixManagerDialog_v.dialogCreate()"
		
		/** Get listbox height
		 */
		function getListboxHeight preset_names = if preset_names.keys.count < 3 then 5 else preset_names.keys.count + 3
		
		rows_count = 1
		
		preset_names = this.getFileNameSuffixes()
		
		manage_button = #( "Save", "Load", "Delete" )
		
		
		/* DIALOG */ 
		PresetDialog = Dialog_v title:"Presets Manager" id:#DIALOG_presets_manager width:232  --ini:ini_file width:128
		
		--PresetDialog.addLocal #SuffixManagerDialog this
		
		--_Controls   = PresetDialog.Controls()
		_Controls   = PresetDialog.Controls DEBUG:true
		
		--_Controls.control #CHECKBUTTON "checkbutton" highlightColor:red across:1
		--_Controls.control #CHECKBOX "Checkbox"
		
		/*------------------------------------------------------------------------------
			CONTROLS 
		--------------------------------------------------------------------------------*/
		
		/* EDIT PRESET NAME */ 
		_edit_new_name =  _Controls.control #EDITTEXT "Preset name" across:1 labelOnTop:true ini:false

		_edit_new_name.Event #CHANGED	( "PRESET_MANAGER._setChangedNewPresetName()")
		
		
		/* PRESET LIST */ 
		_multilistbox =  _Controls.control #MULTILISTBOX "[preset list]" items:( sort preset_names.keys ) offset:[0, 0] width:200 height:( getListboxHeight(preset_names) ) across:1 ini:false
		
		_multilistbox.Event #SELECTIONEND	( "PRESET_MANAGER.presetSelectedCallback()")
		_multilistbox.Event #DOUBLECLICKED ( "PRESET_MANAGER.setOrLoadPresetCallback()")
		
		
		/* BUTTONS  */ 
		for method in manage_button do
		(
			_Button = _Controls.control #BUTTON method across:((manage_button.count / rows_count ) as integer ) width:64 height:32 border:false --width:( PresetDialog.width / manage_button.count )
			--format "_Button: %\n" _Button
			
			_Button.Event #Pressed ( "PRESET_MANAGER."+method+"Preset()")
			--_Button.Event #PRESSED ("format \""+PresetDialog.id as string +"\n\"")
			--_Button.Event #PRESSED ("print \""+PresetDialog.id as string +"\"\n")
			
		)
		
		
		/* CREATEDIALOG */ 
		PresetDialog.create height:undefined

		
		/* SHORCUTS TO CONTROLS */ 
		edit_new_name = DIALOG_presets_manager.ET_preset_name
		presets_list = DIALOG_presets_manager.ML_preset_list
		
	),
	
	/*==============================================================================
		CALLBACKS
	================================================================================*/
	
	/** Add Callback executed after action
		
		@param string callback
	  
		@param name type #SAVE | #LOAD | #RENAME | #DELETE | #DEFAUT

	 */
	function callback callback action:#DEFAULT =
	(
		--format "\n"; print "SuffixManagerDialog_v.callback()"
		this.callbacks[action] = callback as string
	),

	/** Set or load preset callback
	 */
	function setOrLoadPresetCallback =
	(
		--format "\n"; print "SuffixManagerDialog_v.setOrLoadPresetCallback()"
		
		this._setWrittenAndSelectedPreset()

		--format "TEST: %\n" (preset_name_selected == preset_name_written)
		if preset_name_selected == preset_name_written then
			this.loadPreset()
		else
			this.presetSelectedCallback forced:true
	),
	
	/** New name changed callback
	 */
	function _setChangedNewPresetName =
	(
		--format "\n"; print "SuffixManagerDialog_v._setChangedNewPresetName()"
		preset_name_written =	edit_new_name.text
	),
	
	/** Fill edit text field with name of last selected preset
	 */
	function presetSelectedCallback forced:false =
	(
		--format "\n"; print "SuffixManagerDialog_v.presetSelectedCallback()"
		--format "forced: %\n" forced

		this._setWrittenAndSelectedPreset()

		--format "EDIT: %\n" (preset_name_selected != "" and preset_name_written == "")
		
		  /* IF SOMETHING IS SELECTED */                                      /* BUT NEW PRESET NAME NOT EXIST */ 
		if forced or ( preset_name_selected != "" and preset_name_written == "" ) then
			edit_new_name.text = preset_name_selected /* FILL EDIT TEXT */
			
			
		/* RESET THIS */ 
		--this._resetNewAndSelectedPresets()
	),
	
	/*==============================================================================
		ACTIONS
	================================================================================*/
	
	/** SAVE new preset file works as RENAME also
	 */
	function savePreset =
	(
		/** Get save method
		 */
		function getSaveMethod all_presets preset_name_selected preset_name_written =
		(
			--format "\n"; print "SuffixManagerDialog_v.getSaveMethod()"
			--format "preset_name_selected: %\n" preset_name_selected
			--format "preset_name_written: %\n" preset_name_written
			
			if preset_name_written != "" or preset_name_selected != "" then
				case of
				(
					( preset_name_written == preset_name_selected ): #SAVE
					
					/* IF NOTHING SELECTED - TEST IF NEW NAME EXISTS */ 
					--( preset_name_selected == "" ): if findItem all_presets preset_name_written > 0 then #SAVE else #CREATE_NEW_PRESET
					( preset_name_selected == "" ): #SAVE 
					
					
					/* IF PRESET IS ONLY SELECTED */ 
					( preset_name_written == "" ): #SAVE
					
					
					( preset_name_written != preset_name_selected ): #RENAME_OR_CREATE_NEW
				)
		)
		--format "\n"; print "SuffixManagerDialog_v.SavePreset()"
		this._setWrittenAndSelectedPreset()

		
		save_method = getSaveMethod (presets_list.items) (preset_name_selected) (preset_name_written)
		
		--format "SAVE METHOD: %\n" save_method
		
		
		if save_method != undefined then
		(
			/* GET FINAL FILENAME - EDIT TEXT HAS PRIORITY */ 
			preset_save_name = if preset_name_written == "" then preset_name_selected else preset_name_written
			
			/* GET FINAL PATH */ 
			preset_save_path = this._getPresetPath preset_save_name
			--format "PRESET_SAVE_PATH: %\n" preset_save_path

			/* ASK USER TO "RENAME" OR "CREATE NEW" PRESET */ 
			if save_method == #RENAME_OR_CREATE_NEW then
				save_method = case queryBox ("RENAME PRESET ?\n\n\"" + preset_name_selected +"\"\n\nTO\n\n\"" + preset_name_written +"\"" ) title:"RENAME PRESET" of
				(
					--true: #RENAME
					true:
					(
						if findItem presets_list.items preset_name_written == 0 or \
							queryBox ("PRESET EXIST ALREADY\n\nOVERWRITE PRESET ?\n\n\"" + preset_name_written +"\"" ) title:"RENAME PRESET" then
								#RENAME
					)

					default: #SAVE
				)
				
			if save_method != undefined then
			(
				
				result = Dictionary #( save_method, preset_save_path )
				
				if save_method == #RENAME then
					--result[#RENAME] = #(  preset_name_selected,  preset_name_written )
					result[#RENAME] =  Dictionary #( #FROM, this._getPresetPath preset_name_selected ) #( #TO, preset_save_path )
	
					----result[#RENAME] = Dictionary #( #FROM, this._getPresetPath preset_name_selected ) #( #TO, this._getPresetPath preset_name_written )
					--result[#RENAME] = Dictionary #( #FROM, "@" + this._getPresetPath preset_name_selected )-- #( #TO, this._getPresetPath preset_name_written )
				/* POST CALLBACK */
			
				this._executeCallback (result)

				/* RENAME FILE */ 
				if save_method == #RENAME then
				(
					deleteFile result[#RENAME][#TO]
					
					renameFile result[#RENAME][#FROM] result[#RENAME][#TO]
				)
				
				
				/* EXECUTE CALLBACK */ 			
				this._updatePresetList selected:preset_name_written
			)
		)
	),

	/** Load
	 */
	function loadPreset =
	(
		--format "\n"; print "SuffixManagerDialog_v.loadPreset()"
		this._setWrittenAndSelectedPreset()

		load_preset_name = if preset_name_selected == "" then preset_name_written else preset_name_selected
		
		if load_preset_name != "" then
		(
			result = Dictionary #( #LOAD, this._getPresetPath load_preset_name )
			
			this._executeCallback (result)
		)
	),
	
	/** Delete preset
	 */
	function deletePreset =
	(
		--format "\n"; print "SuffixManagerDialog_v.deletePreset()"
		/** Join array to string
		 */
		function arrayToString arr delimeter = ( _string = ""; for item in arr do _string += item as string  + delimeter; substring _string 1 (_string.count-delimeter.count))
		
		selected_presets = this._getAllSelectedPresetsFromListbox()
		
		presets_to_delete =  if selected_presets.count == 0 then presets_list.items else selected_presets
		
		query_msg = case selected_presets.count of
		(
			0: "ALL presets"
			1: "preset" 
			default: "presets" 
		)
		
		/* COMFIRM DELETION */ 
		if queryBox ( "Delete "+ query_msg +" ?\n\n" + arrayToString presets_to_delete "\n" ) title:"Delete presets" then
		(
			presets_paths = for preset_to_delete in presets_to_delete collect this._getPresetPath preset_to_delete
			
			result = Dictionary #( #DELETE, presets_paths )
			
			/* EXECUTE CALLBACK */ 			
			this._executeCallback (result)
			
			/* DELETE PRESET FILES */ 
			for presets_path in presets_paths do
				deleteFile presets_path
			

			/* POST CALLBACK */ 			
			this._updatePresetList()
		)

	),
	
	
	private

	/** Execute callback
	 */
	function _executeCallback data =
	(
		--format "\n"; print "SuffixManagerDialog_v._executeCallback()"
		
		callback_key = data.keys[1]
		
		if callbacks[callback_key] == undefined then 
			callback_key = #DEFAULT
		--format "callback_key: %\n" callback_key
		
		if ( callbacks[callback_key] ) != undefined then
		(
			data_str = this._dictionaryToExecString data

			execute ( callbacks[callback_key] + " (" + data_str +")" )
		)
	),
	
	/** Update preset list
	 */
	function _updatePresetList selected:undefined =
	(
		--format "\n"; print "SuffixManagerDialog_v._updatePresetList()"
		preset_names = this.getFileNameSuffixes()
		
		--current_selection = presets_list.selection

		presets_list.items = sort preset_names.keys

		if selected != undefined then 
			presets_list.selection = #{findItem presets_list.items selected}
	),
		
	/** Get written and selected preset
	 */
	function _setWrittenAndSelectedPreset =
	(
		--format "\n"; print "SuffixManagerDialog_v._setWrittenAndSelectedPreset()"
		preset_name_selected = this._getSelectedPresetFromListbox()
		
		preset_name_written = this._getNewNameFromEditText()
		
		--format "preset_name_written: %\n" preset_name_written
		--format "preset_name_selected: %\n" preset_name_selected
	),
	
	/** Get new name from edit text
	 */
	function _getNewNameFromEditText =
	(
		--format "\n"; print "SuffixManagerDialog_v._getNewNameFromEditText()"
		trimLeft edit_new_name.text --return
	),
	
	/** Get preset path
	 */
	function _getPresetPath preset_name =
	(
		--format "\n"; print "SuffixManagerDialog_v._getPresetPath()"
		preset_dir + ini_filename + delimeter + preset_name + ".ini"
	),
	
	/** Get selected preset from listbox
	  
		get last preset if multiple presets are selected
	  
		@return string name of selected preset or empty string
	 */
	function _getSelectedPresetFromListbox =
	(
		--format "\n"; print "SuffixManagerDialog_v._getSelectedPresetFromListbox()"

		if ( selected_presets = this._getAllSelectedPresetsFromListbox() ).count > 0 then
			selected_presets[1] --return
			--selected_presets[selected_presets.count] --return
		else
			"" --return
	),
	
	/** Get selected presets from listbox
	  
		@return #("name of selected preset")
	 */
	function _getAllSelectedPresetsFromListbox =
	(
		--format "\n"; print "SuffixManagerDialog_v._getSelectedPresetFromListbox()"
		--selected_items = #()
		--mlistbox = DIALOG_presets_manager.ML_preset_list
		
		for index in presets_list.selection collect presets_list.items[index] --return
	),
	
	/** Convert nested dictionary to executable string
	  *	
	  */
	function _dictionaryToExecString val =
	(
		if classOf val == Dictionary then
		(
			-- Start the dictionary constructor string
			result = "(Dictionary"
			keysArr = getDictKeys val
			
			-- Loop through all keys and recursively process values
			for k in keysArr do
			(
				v = getDictValue val k
				keyStr = "#" + (k as string)
				valStr = this._dictionaryToExecString v
				
				-- Append as an array pair: #(#key, "value")
				result += " #(" + keyStr + ", " + valStr + ")"
			)
			
			result += ")"
			
			result -- return
		)
		else if classOf val == String then
		(
			-- Escape backslashes for file paths and escape quotes
			escapedStr = substituteString val "\\" "\\\\"
			escapedStr = substituteString escapedStr "\"" "\\\""
			
			-- Wrap the final string in quotes
			("\"" + escapedStr + "\"") -- return
		)
		else if classOf val == name then
		(
			("#" + (val as string )) -- return
		)
		else
		(
			-- Fallback for numbers, booleans, etc.
			(val as string ) -- return
		)
	),


	function getFileNameSuffixes =
	(
		suffixes	= Dictionary #STRING -- KEY:"Preset Name" VALUE:"Preset file path"
		--format "ini_file: %\n" ini_file
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
		--format "\n"; print "SuffixManagerDialog.onCreate()"
		--for prop in #(  ) where getProperty this prop == undefined do -- CHECK CONSTRUCT PROPERTIES -- Array of this struct properties necessary to run
		--	throw ("\n\n\nUNDEFINED CONSTRUCT PROPERTY\n\n\nSTRUCT:\n\n"+ ((filterString( classof this as string )"(:")[2]) +"\n\n\nPROPERTY:\n\n"+ prop )
		/* SET THIS GLOBAL FOR EXECUTION OF CALLBACKS */ 
		global PRESET_MANAGER = this
	)

)
