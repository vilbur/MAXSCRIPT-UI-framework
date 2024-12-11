/** Rollout resizer
 */
struct RolloutResizer_v
(
	/* construct */

	/* properties */
	padding_bottom = 8,

	offset_position = 0,

	/* developent  */
	DEBUG = false,
	--DEBUG = true,

	/** Resize subrollouts
	 */
	function fitSlotsToDialog _Rollout  =
	(
		format "\n"; print "RolloutResizer_v._resizeSubrollouts()"
		--format "_Rollout:	% \n" _Rollout
		--if ( dialog_height = _Rollout.RCI.height ) == undefined then
		--	dialog_height = execute( _Rollout.id as string + ".height" )

		fit_rollouts_stamp = timestamp()

		/** Remove controls before first slot
		  *
		  */
		function removeControlsBeforeFirstSlot &dialog_controls =
		(
			for i = 1 to dialog_controls.count do
				if classOf dialog_controls[1] != subRollout then
					deleteItem dialog_controls 1
				else exit

			dialog_controls --return
		)

		dialog_height = _Rollout.height

		dialog_controls = _Rollout.controls

		subrollout_slots = for control in dialog_controls where classOf control == subRollout collect control

		format "subrollout_slots.count: %\n" subrollout_slots.count
		if subrollout_slots.count > 0 then
		(
			removeControlsBeforeFirstSlot (dialog_controls)

			last_control = this._getLastControl (dialog_controls)

			last_control_position = last_control.pos.y + last_control.height

			empty_space_bottom = dialog_height - last_control_position - padding_bottom

			size_offset_per_slot = (empty_space_bottom / subrollout_slots.count) as integer
			format "size_offset_per_slot: %\n" size_offset_per_slot
			for control in dialog_controls do
				if classOf control == subRollout then
					this._resizeSubrolloutSlot (control)(size_offset_per_slot)
				else
					this._offsetContrtol (control)
		)

		--if this.DEBUG then format "fitSlotsToDialog % ms\n" ((timestamp()) - fit_rollouts_stamp)

		offset_position = 0
	),

	private

	/** Get last control
	  *
	  */
	function _getLastControl controls =
	(
		--format "\n"; print "RolloutResizer_v._getLastControl()"
		for i = controls.count to 1 by -1 do
		(
			control_class	= classOf controls[i]

			if control_class != GroupStartControl and control_class != GroupEndControl  then
				 return controls[i]
		)
	),

	/** Resize subrollout slot
	 */
	function _resizeSubrolloutSlot subrolloutControl size_offset_per_slot =
	(
		--format "\n"; print "RolloutResizer_v._resizeSubrolloutSlot()"
		subrolloutControl.pos.y	+= offset_position -- Move slot

		subrolloutControl.height	+= size_offset_per_slot -- resize slot

		offset_position	+= size_offset_per_slot -- increment position
	),

	/** Offset contrtol
	 */
	function _offsetContrtol control =
	(
		--format "\n"; print "RolloutResizer_v._offsetContrtol()"
		control.pos.y += offset_position
	),

	/**
	 */
	on create do
	(
		--format "\n"; print "RolloutResizer.onCreate()"
		--for prop in #(  ) where getProperty this prop == undefined do -- CHECK CONSTRUCT PROPERTIES -- Array of this struct properties necessary to run
		--	throw ("\n\n\nUNDEFINED CONSTRUCT PROPERTY\n\n\nSTRUCT:\n\n"+ ((filterString( classof this as string )"(:")[2]) +"\n\n\nPROPERTY:\n\n"+ prop )
	)

)
