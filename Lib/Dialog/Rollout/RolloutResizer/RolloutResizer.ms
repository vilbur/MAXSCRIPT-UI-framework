/** Rollout resizer
 */
struct RolloutResizer_v
(
	/* construct */


	/* properties */
	padding_bottom = 20,

	offset_position = 0,
	--offset_position = 64,


	/* dependency */
	/* reference */
	/* inhered */
	/** Resize subrollouts
	 */
	function XresizeSubrollouts _Rollout  =
	(
		format "\n"; print "RolloutResizer_v._resizeSubrollouts()"
		print "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"

		local subrollout_height

		if _Rollout.hasSubrollouts() then
		(

			for Subrollouts in _Rollout.getSubrollouts() do
			(
				--format "Subrollouts	= % \n" ( (Subrollouts.getSlotId()) as string +".height = 256" )

				--execute( (Subrollouts.getSlotId()) as string +".height = 512" )


				for _RolloutNested in Subrollouts.Rollouts do
				(

					if _RolloutNested.hasSubrollouts() then
					(

						subrollout_height = _RolloutNested.RolloutResizer.resizeSubrollouts(_RolloutNested)

						format "subrollout_height	= % \n" subrollout_height
						--execute( (_RolloutNested.getFullId()) as string +".height = 256" )


						rollout_controls = execute( (_RolloutNested.getFullId()) as string + ".controls" )

						format "\n"
						format "rollout_controls	= % \n" rollout_controls.count

						for control in rollout_controls do
							this._offsetContrtol (control)
					)



				)

			)




			--format "_RolloutNested.getFullId()	= % \n" (_RolloutNested.getFullId())
			--format "_RolloutNested.id	= % \n" (_RolloutNested.id)
			--format "subrollout_height	= % \n" subrollout_height
			--undefined --return
		)


		execute( (_Rollout.getFullId()) as string +".height" ) --return

	),

	/** Resize subrollouts
	 */
	function resizeSubrollouts _Rollout parent_rollout_height =
	(
		format "\n"; print "RolloutResizer_v._resizeSubrollouts()"
		print "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
		format "_Rollout.id	= % \n" _Rollout.id

		_DIALOG_CONTROLS = execute( _Rollout.id as string + ".controls" )

		subrollout_slots = for control in _DIALOG_CONTROLS where classOf control == subRollout collect control

		--parent_rollout_height = execute( _Rollout.id as string + ".height" )
		format "parent_rollout_height	= % \n" parent_rollout_height

		if subrollout_slots.count > 0 then
		(

			controls_end = _DIALOG_CONTROLS[_DIALOG_CONTROLS.count].pos.y + _DIALOG_CONTROLS[_DIALOG_CONTROLS.count].height

			empty_space_bottom = parent_rollout_height - controls_end - padding_bottom

			size_offset_per_slot = (empty_space_bottom / subrollout_slots.count) as integer

			if  size_offset_per_slot > 0  then
			(

				for control in _DIALOG_CONTROLS do

					if classOf control == subRollout then
						this._resizeSubrolloutSlot (control)(size_offset_per_slot)
					else
						this._offsetContrtol (control)

			)


		--	--start_pos	= 0
		--	--controls_height	= 0
		--	--
		--	--
		--	--for control in _DIALOG_CONTROLS where classOf control != subRollout do
		--	--(
		--	--	format "classOf control	= % \n" (classOf control)
		--	--	format "control	= % \n" control.pos
		--	--
		--	--	if control.pos.y > start_pos then
		--	--	(
		--	--
		--	--		controls_height += control.pos.y
		--	--
		--	--	)
		--	--
		--	--)
		--	--
		--	--format "controls_height	= % \n" controls_height
		----	--for Subrollouts in this.getSubrollouts() do
		----	--(
		----	--
		----	--
		----	--	--slot_height = Subrollouts.getHeight()
		----	--	--format "slot_height	= % \n" slot_height
		----	--	--format "Subrollouts.height	= % \n" Subrollouts.height
		----	--	--Subrollouts.setHeight (256)
		----	--
		----	--	--for Subrollout in Subrollouts.Rollouts do
		----	--		--this.createRollout (Subrollout) width:_Rollout.width
		----	--
		----	--)
		----
		--
		)



		for slot in subrollout_slots do
		(
			format "SLOT	= % \n" slot.rollouts

			--slot_height = Subrollouts.getHeight()
			--format "slot_height	= % \n" slot_height
			--format "Subrollouts.height	= % \n" Subrollouts.height
			--Subrollouts.setHeight (256)

			--for Subrollout in Subrollouts.Rollouts do
				--this.createRollout (Subrollout) width:_Rollout.width

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
