clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../../Lib/RolloutCreator/RolloutCreator.ms" )

/** Create variables:
  *		_RolloutCreator
  *		_Rollout
  *		_Controls
  */
include "MAXSCRIPT-UI-framework/Lib/RolloutCreator/_Test/includes/CreateTestRollout.ms" -- "./../../Lib/RolloutCreator/_Test/includes/CreateTestRollout.ms"
/** Multilistbox
 */
function Cratemultilistbox prefix =
(

	_Controls.Default #height 2 type:#list -- type is mask and must match control type E.G.: match #listbox|#multilistbox|#dropdownlist if type==#list
	_Controls.Default #across 3 type:#list  -- match dropdownlist|listbox|multilistbox
	--_Controls.Default #across 3 type:#dropdownlist
	_Controls.Default #across 2 type:#listbox
	_Controls.Default #across 1 type:#multilistbox


	_Controls.control #dropdownlist ("FULL WIDTH " + prefix as string  ) params:#(#across, 1)

	_Controls.control #listbox ("THIS iS HALF " + prefix as string  )

	_Controls.control #multilistbox ("THIS iS FULL WIDTH " + prefix as string  )

	_Controls.control #dropdownlist ("THIRD " + prefix as string  )
	_Controls.control #listbox ("THIS iS HALF TOO " + prefix as string  )
)


/** Controls without fakes
 *  make upside down pyramid of controls
 */
function eachRowDifferenCountOfControls count prefix:"" =
(
	_Controls.Default #border true

	for i = 1 to count do
	(
		across = case of
		(
			( i > 21 ): 7
			( i > 15 ): 6
			( i > 10 ): 5
			( i > 6 ): 4
			( i > 3 ): 3
			( i > 1 ): 2
			default: 1
		)
		--format "across:	% \n" across
		_Controls.Default #width 96 type:#button
		--_Controls.Default #width 96 type:#label

		title = prefix + i as string +" of "+ count as string

		_Button1    = _Controls.control #button ( title ) params:#(#across, across)
	)
)


/** If group has not full row of control, than add fake controls up to end of group
  *
  * In this way, controls of next group will start in correct next group group
 */
function testFakeControlsOnEndOfGroup _Controls count across =
(
	for i = 1 to count do
		_Control    = _Controls.control #button ( i as string + " of "+ count as string +" across "+ across as string ) params:#(#across, across)
)



/*------------------------------------------------------------------------------
	TESTS DEFINITION
--------------------------------------------------------------------------------*/
/** CreateOnlyButtons
 */
function createOnlyButtons count prefix:"" =
(
	eachRowDifferenCountOfControls count prefix:prefix
)


/** Test break across if next control has different across
  *
  * REASON:	Across parameter ignores new value unless it completes his row
  * WHAT IS DONE:	Fake controls are generated to complete and fill row of previous across
  *
  * BENEFITS: This allows has for example #listbox control width:
 */
function myltipleListboxes count =
(
	for i = 2 to count+1 do
		Cratemultilistbox(i)
)

/** Create controls goups
 */
function createControlsGoups _groups =
(
	for i = 1 to _groups do
		testFakeControlsOnEndOfGroup(_Rollout.Controls group:("Group "+(i) as string +" of "+(_groups) as string )  ) (i+2) (i+1)
)

/** Createsubrollouts
 */
function createsubrolloutsControls =
(
	--format "_Rollout	= % \n" _Rollout
	Subrollouts_1 = _Rollout.Subrollouts()

	Subrollout_1 = Subrollouts_1.new "Subrollout1"

	_Controls = Subrollout_1.controls group:"Subrollouts test"

	for i = 1 to 1 do
		_Button1 = _Controls.control #button ( "Subrollouts "+ i as string) --params:#(#across, across)
)


/*==============================================================================

	RUN TESTS

================================================================================*/

/*------ BUTTONS ------*/
--createOnlyButtons(1) prefix:"x"
--createOnlyButtons(28)


/*------ LSITBOXES ------*/
--myltipleListboxes(1)
--myltipleListboxes(3)

/*------ CONTROL GROUPS ------*/
 createControlsGoups(2)
--createControlsGoups(3)
 --createControlsGoups(4)

/* SUBROLLOUTS */
 createsubrolloutsControls()



/** CREATE DIALOG from _Rollout
  */
dialog_width = 512
dialog_height = 1920
--dialog_height = 1024
include "MAXSCRIPT-UI-framework/Lib/RolloutCreator/_Test/includes/CreateTestDialog.ms" -- "./../../Lib/RolloutCreator/_Test/includes/CreateTestDialog.ms"