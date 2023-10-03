clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../../../Lib/Dialog/Dialog.ms" ) -- "./../../../Lib/Dialog/Dialog.ms"

/*------------------------------------------------------------------------------

	HELPER METHODS

--------------------------------------------------------------------------------*/

/** Add sub rollouts
 */
function addSubRolloutSlots _Rollout prefix:"" rollouts_count:1 nested_levels: controls_count: current_level:0 =
(
	--format "\n"; print ".addSubRolloutSlots()"
	--format "nested_levels	= % \n" nested_levels
	--format "current_level	= % \n" current_level

	if current_level < nested_levels then
	(

		-- _Rollouts = _Rollout.Rollouts height:256
		--_Rollouts = _Rollout.Rollouts height:128
		_Rollouts = _Rollout.Rollouts()

		for r = 1 to rollouts_count do
		(
			rollout_title = prefix + " Rollout: "+ r as string + " "+" Level: " + (current_level + 1) as string


		   _SubRollout = _Rollouts.Roll rollout_title --height:512

		   /* ADD NESTED SUBROLLOUTS */
			   addSubRolloutSlots _SubRollout prefix:prefix nested_levels:nested_levels current_level:(current_level+1) rollouts_count:rollouts_count controls_count:controls_count

		)


	)

	/* ADD CONTROLS */
	if current_level > 0 then
		if controls_count > 0 then
			addSControls _Rollout prefix:(prefix + " "+" Level: " + current_level as string) controls_count:controls_count

)

/** Add sub rollouts
 */
function addSControls _Rollout prefix:"Button" controls_count: =
(
	_Controls = _Rollout.controls()

	for i = 1 to controls_count do
		 _Controls.control #button ( prefix + "." + i as string ) across:1
)




/*------------------------------------------------------------------------------

	TESTS DEFINITION

--------------------------------------------------------------------------------*/


/** Default rollout
 */
function onlyControls controls_count: =
(
	Dialog 	= Dialog_v title:"Case 1: Only controls"

	addSControls (Dialog) controls_count:controls_count

	Dialog.create()
)



/** Default rollout
 */
function controlsRolloutControls nested_levels:0 controls_count:0 rollouts_count:1 =
(
	-- title = "Case 2: Controls Rollout Controls"
	title = "Test"

	Dialog 	= Dialog_v title:title
	-- Dialog 	= Dialog_v title:title ini:(getFilenamePath(getSourceFileName()) + "/Subrollouts Test.ini")


	-- addSControls (Dialog) prefix:"Controls A" controls_count:controls_count

	addSubRolloutSlots (Dialog) prefix:("Slot A") nested_levels:nested_levels rollouts_count:rollouts_count controls_count:controls_count
	-- addSubRolloutSlots (Dialog) prefix:("Slot B") nested_levels:nested_levels controls_count:controls_count

	-- addSControls (Dialog) prefix:"Controls B" controls_count:controls_count

	--Dialog.create()
	-- Dialog.create width:512
	Dialog.create width:512 height:512
	--Dialog.dock(#right)
)



/** Default rollout
 */
function DialogWithSubtollouts title slots_count:0 nested_levels:0 controls_count:0 dialog_height: =
(
	--format "\n"; print ".onlyControls()"
	-- Dialog 	= Dialog_v title:title
	 Dialog 	= Dialog_v title:title ini:(getFilenamePath(getSourceFileName()) + "/Subrollouts Test.ini")

	for i = 1 to slots_count do
		addSubRolloutSlots Dialog prefix:("Slot "+ i as string ) nested_levels:nested_levels controls_count:controls_count

	/* CREATE DIALOG */
	-- Dialog.create width:512 height:1024
	Dialog.create width:512 height:dialog_height
)







/*------------------------------------------------------------------------------

	RUN TESTS

--------------------------------------------------------------------------------*/

clearListener()

/** DILOG WITHOUT SUBROLLOUTS HAS AUTOMATIC HEIGHT
  */
--onlyControls controls_count:3


/** DILOG WITH SUBROLLOUTS WITHOUT CONTROLS
  */
--DialogWithSubtollouts "Subrollouts without controls" slots_count:1  nested_levels:1
--DialogWithSubtollouts "Subrollouts without controls" slots_count:2 nested_levels:1


/** DILOG WITH SUBROLLOUTS WITH CONTROLS
  */
 --controlsRolloutControls nested_levels:1	controls_count:0	rollouts_count:3
 controlsRolloutControls nested_levels:2	controls_count:5	rollouts_count:2
--controlsRolloutControls nested_levels:3	controls_count:1	rollouts_count:3


/** DILOG WITH SUBROLLOUTS WITHOUT CONTROLS
  */
--DialogWithSubtollouts "Subrollouts with controls"  slots_count:1 nested_levels:1 controls_count:3
-- DialogWithSubtollouts "Subrollouts with controls"  slots_count:1 nested_levels:1 controls_count:3 dialog_height:512




--DialogWithSubtollouts slots_count:1 nested_levels:2 controls_count:3 dialog_height:512

--DialogWithSubtollouts slots_count:3 nested_levels:2 controls_count:3




--execute ( "ROLLOUT_subrollouts_with_controls.height = 256" )
