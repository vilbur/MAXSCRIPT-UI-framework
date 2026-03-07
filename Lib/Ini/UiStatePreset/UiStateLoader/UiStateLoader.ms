/** Ui state loader
 */
struct UiStateLoader_v
(
	/* construct */
	ini_file,

	/* required */
	
	/* properties */
	Ini,
	
	/* private */
	/* dependency */
	/* reference */
	/* inhered */
	
	/** Load controls and subrollouts
	 */
	function loadControlsAndSubrollouts _RolloutClass =
	(
		format "\n"; print "UiStateLoader_v.loadControlsAndSubrollouts()"
		format "ini_file: %\n" ini_file
		
		
		for control in _RolloutClass.controls do
			if classOf control == SubRollout then
				this._loadSubRollouts(control)(_RolloutClass.name)
			
			else
				this._loadControl(_RolloutClass)(control)
	),
	
	private
	
	/** _load rollout
	 */
	function _loadSubRollouts _SubRolloutClass _Rollout =
	(
		format "\n"; print "UiStateLoader_v._loadSubRollouts()"

		--this._loadSubrolloutsOrder(_SubRolloutClass) (_Rollout)


		for control in _SubRolloutClass.Rollouts do
		(
			--format "control	= % \n" control

			--if classOf control == RolloutClass then
				--this._loadRollout(control)
		)
	),

	/** _load rollout
	 */
	function _loadRollout _RolloutClass =
	(
		format "\n"; print "UiStateLoader_v._loadRollout()"
		--this._loadToIni (_RolloutClass.name) ("rolledUp") ( (_RolloutClass.open == false) as string )

		--this.loadControlsAndSubrollouts(_RolloutClass)
	),

	/** _load control
	 */
	function _loadControl _RolloutClass Ctrl =
	(
		format "\n"; print "UiStateLoader_v._loadControl()"
		format "Ctrl: %\n" Ctrl

		local val

		val = Ini.load _RolloutClass.name Ctrl.name
		
		--val = case classOf Ctrl of
		--(
		--	CheckBoxControl:	Ctrl.checked
		--	CheckButtonControl:	Ctrl.checked
		--
		--	SpinnerControl:	Ctrl.value
		--	SliderControl:	Ctrl.value
		--	AngleControl:	Ctrl.degrees
		--
		--	ListboxControl:	Ctrl.selection
		--	ComboboxControl:	Ctrl.selection -- ComboBox and DropdownList ALSO !!!
		--	MultiListBoxControl:	Ctrl.selection
		--
		--	EdittextControl:	Ctrl.text
		--	PickbuttonControl:	Ctrl.object
		--	ColorPickerControl:	Ctrl.color
		--	RadioControl:	Ctrl.state
		--
		--	MtlButtonControl: Ctrl.material
		--	MapButtonControl: Ctrl.map
		--	
		--	ImgTag:	Ctrl.bitmap
		--	BitmapControl:	Ctrl.fileName
		--
		--	--hyperlinkControl:
		--	--ProgressBarControl:
		--	--CurveControl:		-- DOES NOT WORK YET
		--	--popupMenuControl:		-- DOES NOT WORK YET
		--	--TimerControl:
		--
		--)
		
		format "val	= % \n" val
		
		--if( val != undefined ) then
			--this._loadToIni (_RolloutClass.name) Ctrl.name (val as string )
	),


	/** Save subrollouts order
	 */
	function _loadSubrolloutsOrder _SubRolloutClass _Rollout =
	(
		--format "\n"; print "UiStateLoader_v._loadSubrolloutsOrder()"
		/** Get subrollouts by order in UI
		 */
		function _getOrderedRollouts rollouts =
		(
			fn sortByY A B = (windows.getWindowPos A.hWnd).y - (windows.getWindowPos B.hWnd).y
	
			qsort rollouts sortByY --> 'rollouts' will now be sorted based on Y
	
			rollouts --return
		)
		
		
		
		rollout_ids = for _rollout in _getOrderedRollouts(_SubRolloutClass.Rollouts) collect _rollout.name as name

		this._loadToIni (_Rollout) (_SubRolloutClass.name) (with printAllElements on (rollout_ids as string )) -- IMPORTANT: without "with printAllElements on" long array formated to ini end with "..." INFO:https://help.autodesk.com/view/MAXDEV/2022/ENU/?guid=GUID-92B98D11-60FF-4742-A1BA-692EE135E085
	),

	/** Load ini value 
	 */
	function _loadIni section key val =
	(
		--format "\n"; print "UiStateSaver_v._loadIni()"
		----format "ini_file	= % \n" ini_file
		--format "section	= % \n" section
		--format "key	= % \n" key
		--format "val	= % \n" val

		if( ini_file != undefined  and val != undefined ) then
		(
			if classof val == string then
				val = substituteString val "\\" "\\\\"

			ltINISetting ini_file section key ( val as string )
		)
	),

	/**
	 */
	on create do
	(
		--format "\n"; print "UiStateLoader.onCreate()"
		--for prop in #(  ) where getProperty this prop == undefined do -- CHECK CONSTRUCT PROPERTIES -- Array of this struct properties necessary to run
		--	throw ("\n\n\nUNDEFINED CONSTRUCT PROPERTY\n\n\nSTRUCT:\n\n"+ ((filterString( classof this as string )"(:")[2]) +"\n\n\nPROPERTY:\n\n"+ prop )
	
		Ini = Ini_v	ini_file
	)

)
