clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../../../RolloutCreator.ms" )

/** Create variables:
  *		_RolloutCreator
  *		_Rollout
  *		_Controls
  */
--group_name = "This is group"
--group_name = undefined 
--include "Library/MAXSCRIPT-UI-framework/Lib/RolloutCreator/_Test/includes/CreateTestRollout.ms" -- "../../../_Test/includes/CreateTestRollout.ms"
filein( getFilenamePath(getSourceFileName()) + "/../../../../Dialog/Dialog.ms" )


Dialog 	= Dialog_v title:"Test"

_Controls = Dialog.Controls()

--_Rollouts_1	= Dialog.Rollouts()
--_Rollout	= _Rollouts_1.Roll "Subrollout A"

/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	DEFAULT HEIGHT OF GROUPBOX IS USED

	IF
		GROUPBOX HAS NOT NEXT CONTROL TO FIT SIZE
	AND
		HEIGHT IS NOT DEFINED

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/*
*/ 
function createControls _ControlsTarget control_name control_type:#button =
(
	for i = 1 to 3 do 
		_Button1    = _ControlsTarget.control control_type ( control_name + " "+i as string ) --params:#(#across, 4)
)

/** Create group box
 */
function createGroupBox _Controls groupbox_name =
(
	_GroupBox = _Controls.control #GroupBox groupbox_name params:#( #across, 1, #height, 128)

	createControlsinGroupbox _Controls groupbox_name:groupbox_name
	--createControlsinGroupbox _Controls groupbox_name:"WHERE ARE iM"
	--createControls _Controls	"Groupbox Mising"

)

/*
*/ 
function createControlsinGroupbox _ControlsTarget control_type:#button groupbox_name:"" =
(
	for i = 1 to 3 do 
		_Button1    = _ControlsTarget.control control_type ( groupbox_name + " "+i as string ) params:#(#groupbox, groupbox_name)
)

/** Groupboxes with height	
 */
function groupboxInSubrollout groupbox_count:1 =
(

	Subrollouts_1 = _Rollout.Subrollouts()

	for s = 1 to 2 do
	(
		Subrollout_1 = Subrollouts_1.Roll ("Subrollout1"+s as string )
		
		_Controls_sub = Subrollout_1.controls()
		
		for i = 1 to groupbox_count do
		(
			groupbox_name = "Subrollout groupbox "+s as string+ i as string
		
			_Controls_sub.control #GroupBox (groupbox_name) params:#(#across,2, #height, 128)
		
			createControlsinGroupbox _Controls_sub groupbox_name:groupbox_name
		)

	)

)

/*------------------------------------------------------------------------------
	RUN TESTS 
--------------------------------------------------------------------------------*/


--createControls _Controls	"TestBtn"

createGroupBox _Controls ("TestGroupbox")

--groupboxInSubrollout groupbox_count:1

--_Controls.control #button ("GOOOOOOD") 


/*------------------------------------------------------------------------------
	CREATE ROLLOUT
--------------------------------------------------------------------------------*/



Dialog.create()


--/** Create dialog from _Rollout
--  */
--dialog_width = 420
----dialog_width = undefined
--
--dialog_height = 256
--dialog_height = 1280
----dialog_height = undefined
--include "Library/MAXSCRIPT-UI-framework/Lib/RolloutCreator/_Test/includes/CreateTestDialog.ms"
