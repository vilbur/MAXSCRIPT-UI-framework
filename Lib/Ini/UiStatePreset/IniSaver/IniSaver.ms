/** SAVE STATE OF ROLLOUT AND CONTROLS TO INI FILE
 */
struct IniSaver_v
(
	/* construct */
	ini_file,

	/* dependency */
	/* reference */
	/* inhered */
	/* properties */


	/** Save dialog dock state
	 */
	function saveDialogDockState _Rollout =
	(
		format "\n"; print "IniSaver_v.saveDialogDockState()"
		--format "isRegistered: %\n" ( this.isRegistered _Rollout )
		--format "_Rollout	= % \n" _Rollout
	
		if( dialog_is_not_closed = GetDialogSize _Rollout) != [0,0] then -- if dialog is closed by user, exists but it is not displayed , then it`s size is [0,0,]
		(
			dialog_position = GetDialogPos _Rollout 
			
			/* AVOID OFFSETING OF REGISTERED DIALOG */ 
			if this.isRegistered _Rollout then
			(
				dialog_position.x -= 6
				dialog_position.y -= 29
			)
			
			this._saveToIni _Rollout.name "size"	(GetDialogSize _Rollout )
	
			this._saveToIni _Rollout.name "position"	( dialog_position )
	
			this._saveToIni _Rollout.name "dock_state"	(try(cui.getDockState _Rollout )catch())
		)
	),

	/** _save controls and subrollouts
	 */
	function saveControlsAndSubrollouts _RolloutClass =
	(
		format "\n"; print "IniSaver_v.saveControlsAndSubrollouts()"
		format "ini_file: %\n" ini_file
		
		
		for control in _RolloutClass.controls do
		--(
			if classOf control == SubRollout then
				this._saveSubRollouts(control)(_RolloutClass.name)

			else
				this._saveControl(_RolloutClass)(control)
		--)
	),
	
	private
	
	/** Is registered
	 */
	function isRegistered dialog_id =
	(
		--format "\n"; print "if.isRegistered()"
		try(
			execute ("cui.getDockState "+ dialog_id )
			
			true --return
		)
		catch
		(
			false --return
		)
	),

	/** _save rollout
	 */
	function _saveSubRollouts _SubRolloutClass _Rollout =
	(
		--format "\n"; print "IniSaver_v._saveSubRollouts()"

		this._saveSubrolloutsOrder(_SubRolloutClass) (_Rollout)


		for control in _SubRolloutClass.Rollouts do
		(
			--format "control	= % \n" control

			if classOf control == RolloutClass then
				this._saveRollout(control)
		)
	),

	/** _save rollout
	 */
	function _saveRollout _RolloutClass =
	(
		--format "\n"; print "IniSaver_v._saveRollout()"
		this._saveToIni (_RolloutClass.name) ("rolledUp") ( (_RolloutClass.open == false) as string )

		this.saveControlsAndSubrollouts(_RolloutClass)
	),

	/** _save control
	 */
	function _saveControl _RolloutClass Ctrl =
	(
		format "\n"; print "IniSaver_v._saveControl()"
		format "Ctrl: %\n" Ctrl

		local val

		val = case classOf Ctrl of
		(
			CheckBoxControl:	Ctrl.checked
			CheckButtonControl:	Ctrl.checked

			SpinnerControl:	Ctrl.value
			SliderControl:	Ctrl.value
			AngleControl:	Ctrl.degrees

			ListboxControl:	Ctrl.selection
			ComboboxControl:	Ctrl.selection -- ComboBox and DropdownList ALSO !!!
			MultiListBoxControl:	Ctrl.selection

			EdittextControl:	Ctrl.text
			PickbuttonControl:	Ctrl.object
			ColorPickerControl:	Ctrl.color
			RadioControl:	Ctrl.state

			MtlButtonControl: Ctrl.material
			MapButtonControl: Ctrl.map
			
			ImgTag:	Ctrl.bitmap
			BitmapControl:	Ctrl.fileName

			--hyperlinkControl:
			--ProgressBarControl:
			--CurveControl:		-- DOES NOT WORK YET
			--popupMenuControl:		-- DOES NOT WORK YET
			--TimerControl:

		)
		format "val	= % \n" val
		
		if( val != undefined ) then
			this._saveToIni (_RolloutClass.name) Ctrl.name (val as string )
	),


	/** Save subrollouts order
	 */
	function _saveSubrolloutsOrder _SubRolloutClass _Rollout =
	(
		--format "\n"; print "IniSaver_v._saveSubrolloutsOrder()"
		/** Get subrollouts by order in UI
		 */
		function _getOrderedRollouts rollouts =
		(
			fn sortByY A B = (windows.getWindowPos A.hWnd).y - (windows.getWindowPos B.hWnd).y
	
			qsort rollouts sortByY --> 'rollouts' will now be sorted based on Y
	
			rollouts --return
		)
		
		
		
		rollout_ids = for _rollout in _getOrderedRollouts(_SubRolloutClass.Rollouts) collect _rollout.name as name

		this._saveToIni (_Rollout) (_SubRolloutClass.name) (with printAllElements on (rollout_ids as string )) -- IMPORTANT: without "with printAllElements on" long array formated to ini end with "..." INFO:https://help.autodesk.com/view/MAXDEV/2022/ENU/?guid=GUID-92B98D11-60FF-4742-A1BA-692EE135E085
	),

	--/**
	--  *
	--  */
	--function regexGetMatches string pattern ignorecase:true =
	--(
	--	rx         = dotNetClass "System.Text.RegularExpressions.RegEx"
	--	rx_options	= dotNetClass "System.Text.RegularExpressions.RegexOptions"
	--
	--	matches = if (ignorecase) then rx.matches string pattern rx_options.IgnoreCase else rx.matches string pattern
	--
	--	(for matchIdx = 0 to matches.count-1 collect for groupIdx = 0 to matches.item[matchIdx].groups.count-1 collect ( matches.item[matchIdx].groups.item[groupIdx].value )) --return
	--),

	/** Save value to ini file
	 */
	function _saveToIni section key val =
	(
		format "\n"; print "IniSaver_v._saveToIni()"
		--format "ini_file	= % \n" ini_file
		format "section	= % \n" section
		format "key	= % \n" key
		format "val	= % \n" val

		if( ini_file != undefined  and val != undefined ) then
		(
			if classof val == string then
				val = substituteString val "\\" "\\\\"

			setINISetting ini_file section key ( val as string )
		)
	),

	--/** Remove from ini
	-- */
	--function _delIniSetting section key =
	--(
	--	--format "\n"; print "IniSaver_v._delIniSetting ()"
	--	delIniSetting  ini_file section key
	--),



	/**
	 */
	on create do
	(
		--clearListener()
		--format "\n"; print("IniSaver_v.onCreate()")
	)
)