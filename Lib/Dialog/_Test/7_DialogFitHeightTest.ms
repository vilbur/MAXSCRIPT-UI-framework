clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../Dialog.ms" )


Dialog 	= Dialog_v title:"Test"


/** Crate dialogcontrols
 */
function crateDialogcontrols =
(
	_Controls_1 = Dialog.Controls()
	
	_Button_1 = _Controls_1.control #button "Button Dialog"
)


/** Sub rollouts1
 */
function addSubRollouts_1 =
(
	_Rollouts_1 = Dialog.Rollouts()
	
	global _Subrolllout_1 = _Rollouts_1.Roll "Subrollout A"
	
	_Controls_1 = _Subrolllout_1.Controls()

	addControls (_Controls_1) "Subrollout"
	
)


/** Sub rollouts2
 */
function addSubRollouts_2 =
(
	_Rollouts_2	  = Dialog.Rollouts()
	
	_Subrolllout_2 = _Rollouts_2.Roll "Subrollout B"
)

/** Add controls
 */
function addControls _Controls prefix =
(
	for i = 1 to 50 do
		_Control = _Controls.control #button ( prefix + " " + i as string ) params:#(#across, 2)
)

/** Add nested subrollouts
 */
function addNestedSubrollouts_1 =
(
	NesteRollouts = _Subrolllout_1.Rollouts()
	NesteRollout  = NesteRollouts.Roll "Nested"
	
	_Controls_1 = NesteRollout.Controls()

	addControls (_Controls_1) "Nested"
)



--crateDialogcontrols()
addSubRollouts_1()
addNestedSubrollouts_1()

addSubRollouts_2()


--Dialog.create pos:[300, 256] height:512
Dialog.create pos:[300, 0]