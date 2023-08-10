/** Rollout resizer
 */
struct RolloutResizer_v
(
	/* construct */

	/* properties */
	padding_bottom = 8,

	offset_position = 0,


	/** Resize subrollouts
	 */
	function resizeSubrollouts _Rollout  =
	(
		--format "\n"; print "RolloutResizer_v._resizeSubrollouts()"
		--print "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
		--format "_Rollout.id	= % \n" _Rollout.id
		--format "_Rollout.height:	% \n" _Rollout.height
		--format "_Rollout.RCI:	% \n" _Rollout.RCI
		--format "_Rollout.RCI.height:	% \n" _Rollout.RCI.height

		if ( dialog_height = _Rollout.RCI.height ) == undefined then
			dialog_height = execute( _Rollout.id as string + ".height" )

		dialog_controls = execute( _Rollout.id as string + ".controls" )

		subrollout_slots = for control in dialog_controls where classOf control == subRollout collect control

		if subrollout_slots.count > 0 then
		(
			last_control_position = dialog_controls[dialog_controls.count].pos.y + dialog_controls[dialog_controls.count].height

			empty_space_bottom = dialog_height - last_control_position - padding_bottom

			size_offset_per_slot = (empty_space_bottom / subrollout_slots.count) as integer

			if  size_offset_per_slot > 0  then
			(
				for control in dialog_controls do

					if classOf control == subRollout then
						this._resizeSubrolloutSlot (control)(size_offset_per_slot)
					else
						this._offsetContrtol (control)
			)
		)
	),

	private

	/** Resize subrollout slot
	 */
	function _resizeSubrolloutSlot subrolloutControl size_offset_per_slot=
	(
		--format "\n"; print "RolloutResizer_v._resizeSubrolloutSlot()"
		subrolloutControl.pos.y	+= offset_position

		subrolloutControl.height	+= size_offset_per_slot

		offset_position	+= size_offset_per_slot
	),

	/** Offset contrtol
	 */
	function _offsetContrtol control =
	(
		--format "\n"; print "RolloutResizer_v._offsetContrtol()"

		if offset_position > 0 then
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
