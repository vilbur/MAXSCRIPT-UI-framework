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
			if classOf control != SubRollout then
				this._loadControl(_RolloutClass)(control)
			
			else
				this._loadSubRollouts(_RolloutClass)(control)
	),
	
	private
	
	/** _load rollout
	 */
	function _loadSubRollouts _RolloutClass _SubRolloutSlot =
	(
		format "\n"; print "UiStateLoader_v._loadSubRollouts()"

		reordered_rollouts = #()
		
		loaded_order_ids = Ini.load _RolloutClass.name _SubRolloutSlot.name
		
		for i = 1 to _SubRolloutSlot.Rollouts.count do
		(
			_SubRollout = _SubRolloutSlot.Rollouts[i]

			index	= findItem loaded_order_ids ( _SubRollout.name as name )

			reordered_rollouts[index] = _SubRollout
		)
		
		format "reordered_rollouts: %\n" reordered_rollouts
		
		this.reorderSubRollouts _SubRolloutSlot reordered_rollouts
	),
	
	/*
	  Reorders a subRollout control to match a target array of rollouts.
	  Optimized to prevent removing/adding rollouts that are already in a valid sequence.
			
	   Example Usage
	   ReorderSubRollouts myMainRollout.mySubSlot #(rolloutC, rolloutA, rolloutB)
 
	  Arguments:
	  subUI          - The subRollout control (e.g., myDialog.mySubSlot)
	  targetRollouts - An array of rollout definitions in the exact order you want them
	*/
	function reorderSubRollouts subUI targetRollouts =
	(
		format "\n"; print "UiStateLoader_v.reorderSubRollouts()"
		-- 1. CLEANUP: Remove any current rollouts that are NOT in the target array
		for i = subUI.rollouts.count to 1 by -1 do
		(
			ro = subUI.rollouts[i]
			if (findItem targetRollouts ro) == 0 do
			(
				removeSubRollout subUI ro
			)
		)
	
		-- 2. OPTIMIZE: Find the longest prefix of the target array 
		-- that already exists in the correct relative order inside the sub-rollout.
		currentRollouts = subUI.rollouts
		prefixCount = 0
		cIndex = 1
		prefixBroken = false
	
		for tRo in targetRollouts while not prefixBroken do
		(
			found = false
			while cIndex <= currentRollouts.count and not found do
			(
				if currentRollouts[cIndex] == tRo then found = true
				cIndex += 1
			)
	
			if found then prefixCount += 1
			else prefixBroken = true
		)
	
		-- 3. REORDER: Move only the out-of-sequence rollouts to the end
		for i = (prefixCount + 1) to targetRollouts.count do
		(
			ro = targetRollouts[i]
	
			-- If it's already in the slot (but out of order), remove it so it shifts
			if (findItem subUI.rollouts ro) > 0 do
			(
				removeSubRollout subUI ro
			)
	
			-- Append the rollout to its new correct position at the end
			addSubRollout subUI ro
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
		--format "\n"; print "UiStateLoader_v._loadControl()"
		--format "Ctrl: %\n" Ctrl

		val = Ini.load _RolloutClass.name Ctrl.name
		--format "val	= % \n" val
		--format "classOf val: %\n" ( classOf val )
		
		case classOf Ctrl of
		(
			CheckBoxControl:	Ctrl.checked = val
			CheckButtonControl:	Ctrl.checked = val

			SpinnerControl:	Ctrl.value = val
			SliderControl:	Ctrl.value = val
			AngleControl:	Ctrl.degrees = val

			ListboxControl:	Ctrl.selection = val
			ComboboxControl:	Ctrl.selection = val
			MultiListBoxControl:	Ctrl.selection = val

			EdittextControl:	Ctrl.text = val
			PickbuttonControl:	Ctrl.object = val
			ColorPickerControl:	Ctrl.color = val
			RadioControl:	Ctrl.state = val

			
			--MtlButtonControl: Ctrl.material = val
			--MapButtonControl: Ctrl.map
		
			
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
			
			--HyperLinkControl: Ctrl.address
		)
	),


	/** Save subrollouts order
	 */
	function _loadSubrolloutsOrder _SubRolloutSlot _RolloutClass =
	(
		format "\n"; print "UiStateLoader_v._loadSubrolloutsOrder()"
		/** Get subrollouts by order in UI
		 */
		function _getOrderedRollouts rollouts =
		(
			fn sortByY A B = (windows.getWindowPos A.hWnd).y - (windows.getWindowPos B.hWnd).y
	
			qsort rollouts sortByY --> 'rollouts' will now be sorted based on Y
	
			rollouts --return
		)
		
		rollout_ids = for _rollout in _getOrderedRollouts(_SubRolloutSlot.Rollouts) collect _rollout.name as name

		format "rollout_ids: %\n" rollout_ids
		
		loaded_order = this._loadIni (_RolloutClass.name) (_SubRolloutSlot.name)
		
		format "loaded_order: %\n" loaded_order
	),

	--/** Load ini value 
	-- */
	--function _loadIni section key =
	--(
	--	format "\n"; print "UiStateSaver_v._loadIni()"
	--	----format "ini_file	= % \n" ini_file
	--	format "section	= % \n" section
	--	format "key	= % \n" key
	--	--format "val	= % \n" val
	--
	--	getINISetting ini_file section key --return
	--),

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
