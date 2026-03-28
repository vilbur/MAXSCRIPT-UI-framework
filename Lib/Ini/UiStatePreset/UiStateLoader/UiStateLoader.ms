/** Ui state loader
 */
struct UiStateLoader_v
(
	/* construct */
	ini_file,

	/* required */
	
	/* properties */
	Ini,
	
	slots_and_order = #(),
	
	/* private */
	/* dependency */
	/* reference */
	/* inhered */
	
	
	/** Load controls and subrollouts
	 */
	function loadControlsAndSubrollouts _RolloutClass =
	(
		--format "\n"; print "UiStateLoader_v.loadControlsAndSubrollouts()"
		
		this._loadSubrolloutsOrder (_RolloutClass)

		this._reorderAllSubrollouts()
		
		this.loadControls (_RolloutClass)
	),
	
	/** Load controls
	 */
	function loadControls _RolloutClass =
	(
		--format "\n"; print "UiStateLoader_v.loadControls()"
		for control in _RolloutClass.controls do
			if classOf control == SubRollout then
				for _SubRollout in control.rollouts do 
					this.loadControls(_SubRollout)
				
			else
				this._loadControl(_RolloutClass)(control)
	),
	

	private
	
	
	/** Load controls and subrollouts
	 */
	function _loadSubrolloutsOrder _RolloutClass =
	(
		--format "\n"; print "UiStateLoader_v._loadSubrolloutsOrder()"
		
		for control in _RolloutClass.controls do
			if classOf control == SubRollout then
				this._getSubrolloutsOrder(_RolloutClass)(control)
				--this._loadControl(_RolloutClass)(control)
	),
	
	/** _load rollout
	 */
	function _reorderAllSubrollouts =
	(
		--format "\n"; print "UiStateLoader_v._reorderAllSubrollouts()"
		/* REORDER SUBROLLOUTS IN EACH SLOT */
		for slot_data in slots_and_order do 
			this.reorderSubRollouts slot_data[#SLOT] slot_data[#SUBROLLOUTS]

	),
	
	/** Get subrollouts order
	 */
	function _getSubrolloutsOrder _RolloutClass _SubRolloutSlot =
	(
		--format "\n"; print "UiStateLoader_v._getSubrolloutsOrder()"
		reordered_rollouts = #()
		
		loaded_order_ids = Ini.load _RolloutClass.name _SubRolloutSlot.name
		--format "LOADED_ORDER_IDS: %\n" loaded_order_ids
		
		/* GET RIGHT ORDER */ 
		for i = 1 to _SubRolloutSlot.Rollouts.count do
		(
			_SubRollout = _SubRolloutSlot.Rollouts[i]

			--format "rolledUp: %\n" (classOf( Ini.load _SubRollout.name "rolledUp" ))
			
			--_SubRollout.open = Ini.load _SubRollout.name "rolledUp"
			
			index	= findItem loaded_order_ids ( _SubRollout.name as name )
			
			reordered_rollouts[index] = _SubRollout
		)
		
		--format "REORDERED_ROLLOUTS: %\n" reordered_rollouts
		
		slot_data	= Dictionary #( #SLOT, _SubRolloutSlot ) #( #SUBROLLOUTS, reordered_rollouts )
		
		append slots_and_order slot_data

		/* EDIT CONTROL AFTER REORDERING */ 
		for _SubRollout in _SubRolloutSlot.Rollouts do
			this._loadSubrolloutsOrder _SubRollout
	),
	
	
	/*
	  Reorders a subRollout control to match a target array of rollouts.
	  Optimized to prevent removing/adding rollouts that are already in a valid sequence.
			
	   Example Usage
	   ReorderSubRollouts myMainRollout.mySubSlot #(rolloutC, rolloutA, rolloutB)
 
	  Arguments:
	  _SubRolloutSlot          - The subRollout control (e.g., myDialog.mySubSlot)
	  targetRollouts - An array of rollout definitions in the exact order you want them
	*/
	function reorderSubRollouts _SubRolloutSlot targetRollouts =
	(
		--format "\n"; print "UiStateLoader_v.reorderSubRollouts()"
		--format "_SubRolloutSlot: %\n" _SubRolloutSlot
		
		-- 1. CLEANUP: Remove any current rollouts that are NOT in the target array
		--for i = _SubRolloutSlot.rollouts.count to 1 by -1 do
		--(
		--	_rollout = _SubRolloutSlot.rollouts[i]
		--	
		--	if (findItem targetRollouts _rollout) == 0 do
		--		removeSubRollout _SubRolloutSlot _rollout
		--)
	
		-- 2. OPTIMIZE: Find the longest prefix of the target array 
		-- that already exists in the correct relative order inside the sub-rollout.
		current_rollouts = _SubRolloutSlot.rollouts
		prefix_count = 0
		cIndex = 1
		prefix_broken = false
	
		for tRo in targetRollouts while not prefix_broken do
		(
			found = false
			while cIndex <= current_rollouts.count and not found do
			(
				if current_rollouts[cIndex] == tRo then found = true
				
				cIndex += 1
			)
	
			if found then
				prefix_count += 1
			else
				prefix_broken = true
		)
	
		-- 3. REORDER: Move only the out-of-sequence rollouts to the end
		for i = (prefix_count + 1) to targetRollouts.count do
		(
			_rollout = targetRollouts[i]
	
			-- If it's already in the slot (but out of order), remove it so it shifts
			if (findItem _SubRolloutSlot.rollouts _rollout) > 0 do
				RemoveSubRollout _SubRolloutSlot _rollout
	
			-- Append the rollout to its new correct position at the end
			AddSubRollout _SubRolloutSlot _rollout
			
		)
		
		/* OPEN \ CLOSE subrollouts */ 
		for _rollout in targetRollouts do 
			_rollout.open = not (Ini.load _rollout.name "rolledUp")
	),

	/** _load control
	 */
	function _loadControl _RolloutClass Ctrl =
	(
		--format "\n"; print "UiStateLoader_v._loadControl()"
		--format "Ctrl: %\n" Ctrl

		
		--format "val	= % \n" val
		--format "classOf val: %\n" ( classOf val )
		if (val = Ini.load _RolloutClass.name Ctrl.name) != undefined then 
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
