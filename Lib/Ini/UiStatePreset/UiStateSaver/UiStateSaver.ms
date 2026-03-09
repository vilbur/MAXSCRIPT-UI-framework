/** SAVE STATE OF ROLLOUT AND CONTROLS TO INI FILE
  
	UNSUPPORT SAVE CONTROL VALUES 
	
	--"./../../_Dev/GET_bitmap.filename_PROPERTY_PROBLEM.ms"
	
  
 */
struct UiStateSaver_v
(
	/* construct */
	ini_file,

	/* dependency */
	/* reference */
	/* inhered */
	/* properties */


	/** Save dialog dock state
	 */
	function saveDialogDockState _RolloutClass =
	(
		format "\n"; print "UiStateSaver_v.saveDialogDockState()"
		--format "isRegistered: %\n" ( this.isRegistered _RolloutClass )
		--format "_RolloutClass	= % \n" _RolloutClass
	
		if( dialog_is_not_closed = GetDialogSize _RolloutClass) != [0,0] then -- if dialog is closed by user, exists but it is not displayed , then it`s size is [0,0,]
		(
			dialog_position = GetDialogPos _RolloutClass 
			
			/* AVOID OFFSETING OF REGISTERED DIALOG */ 
			if this.isRegistered _RolloutClass then
			(
				dialog_position.x -= 6
				dialog_position.y -= 29
			)
			
			this._saveToIni _RolloutClass.name "size"	(GetDialogSize _RolloutClass )
	
			this._saveToIni _RolloutClass.name "position"	( dialog_position )
	
			this._saveToIni _RolloutClass.name "dock_state"	(try(cui.getDockState _RolloutClass )catch())
		)
	),

	/** _save controls and subrollouts
	 */
	function saveControlsAndSubrollouts _RolloutClass =
	(
		format "\n"; print "UiStateSaver_v.saveControlsAndSubrollouts()"
		format "ini_file: %\n" ini_file
		
		
		for control in _RolloutClass.controls do
		--(
			if classOf control == SubRollout then
				this._saveSubRollouts(control)(_RolloutClass.name)

			else
				this._saveControl(_RolloutClass)(control)
		--)
	),

	/** _save rollout
	 */
	function saveRollout _RolloutClass =
	(
		--format "\n"; print "UiStateSaver_v.saveRollout()"
		this._saveToIni (_RolloutClass.name) ("rolledUp") ( (_RolloutClass.open == false) as string )

		this.saveControlsAndSubrollouts(_RolloutClass)
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
	function _saveSubRollouts _SubRolloutClass _RolloutClass =
	(
		--format "\n"; print "UiStateSaver_v._saveSubRollouts()"

		this._saveSubrolloutsOrder(_SubRolloutClass) (_RolloutClass)


		for control in _SubRolloutClass.Rollouts do
		(
			--format "control	= % \n" control

			if classOf control == RolloutClass then
				this.saveRollout(control)
		)
	),

	/** _save control
	 */
	function _saveControl _RolloutClass Ctrl =
	(
		format "\n"; print "UiStateSaver_v._saveControl()"
		format "Ctrl: %\n" Ctrl

		/** Get image tag value
		 */
		function getImageTagValueWorkaround Ctrl =
		(
			format "\n"; print "UiStateSaver_v.getImageTagValueWorkaround()"
			
			format "Ctrl: %\n" Ctrl
			format "Ctrl.name: %\n" Ctrl.name
			format "Ctrl.BITMAP: %\n" Ctrl.bitmap
			
		)
		
		class_of_control = classOf Ctrl

		local val = undefined 


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
		
			
		/*------------------------------------------------------------------------------

			UNSUPPORT SAVE CONTROL VALUES 

		--------------------------------------------------------------------------------*/	

			--ProgressBarControl:
			--CurveControl:		-- DOES NOT WORK YET
			--popupMenuControl:		-- DOES NOT WORK YET
			--TimerControl:
			
		/*------------------------------------------------------------------------------

			POROBLEMATIC CONTROL TYPES TO GET THEIR VALUE
			
			--"./../../_Dev/GET_bitmap.filename_PROPERTY_PROBLEM.ms"
			
		--------------------------------------------------------------------------------*/
		
			--ImgTag:	getImageTagValueWorkaround Ctrl
			--BitmapControl:	Ctrl.fileName
			
			HyperLinkControl: Ctrl.address

		)
		format "val	= % \n" val

		/* materialButton and mapButton can save undefined value ( button must save empty state )
		
		*/ 
		
		if( val != undefined or class_of_control == MtlButtonControl or class_of_control == MapButtonControl ) then
			this._saveToIni (_RolloutClass.name) Ctrl.name (val as string )
	),


	/** Save subrollouts order
	 */
	function _saveSubrolloutsOrder _SubRolloutClass _RolloutClass =
	(
		--format "\n"; print "UiStateSaver_v._saveSubrolloutsOrder()"
		/** Get subrollouts by order in UI
		 */
		function _getOrderedRollouts rollouts =
		(
			fn sortByY A B = (windows.getWindowPos A.hWnd).y - (windows.getWindowPos B.hWnd).y
	
			qsort rollouts sortByY --> 'rollouts' will now be sorted based on Y
	
			rollouts --return
		)
		
		
		
		rollout_ids = for _rollout in _getOrderedRollouts(_SubRolloutClass.Rollouts) collect _rollout.name as name

		this._saveToIni (_RolloutClass) (_SubRolloutClass.name) (with printAllElements on (rollout_ids as string )) -- IMPORTANT: without "with printAllElements on" long array formated to ini end with "..." INFO:https://help.autodesk.com/view/MAXDEV/2022/ENU/?guid=GUID-92B98D11-60FF-4742-A1BA-692EE135E085
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
		format "\n"; print "UiStateSaver_v._saveToIni()"
		--format "ini_file	= % \n" ini_file
		format "section	= % \n" section
		format "key	= % \n" key
		format "val	= % \n" val

		if classof val == string then
			val = substituteString val "\\" "\\\\"

		setINISetting ini_file section key ( val as string )
	),

	--/** Remove from ini
	-- */
	--function _delIniSetting section key =
	--(
	--	--format "\n"; print "UiStateSaver_v._delIniSetting ()"
	--	delIniSetting  ini_file section key
	--),



	/**
	 */
	on create do
	(
		--clearListener()
		--format "\n"; print("UiStateSaver_v.onCreate()")
	)
)