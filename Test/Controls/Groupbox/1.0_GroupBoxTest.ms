clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../../../Lib/RolloutCreator/RolloutCreator.ms" )

/** Create variables:
  *		_RolloutCreator
  *		_Rollout
  *		_Controls
  */
include "Library/MAXSCRIPT-UI-framework/Lib/RolloutCreator/_Test/includes/CreateTestRollout.ms" -- "../../../_Test/includes/CreateTestRollout.ms"


/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	
	DEFAULT HEIGHT OF GROUPBOX IS USED
	
	IF
		GROUPBOX HAS NOT NEXT CONTROL TO FIT SIZE
	AND
		HEIGHT IS NOT DEFINED
	
	
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/


/*
	TESTS DEFINITION
*/ 
function createControls control_type:#button groupbox_name:"" =
(
	for i = 1 to 3 do 
		_Button1    = _Controls.control control_type ( groupbox_name + " "+i as string ) params:#(#groupbox, groupbox_name, #across, 2)
)





/*------------------------------------------------------------------------------
	RUN TESTS 
--------------------------------------------------------------------------------*/



--_GroupBox = _Controls.control #GroupBox "Groupbox A" params:#(#across, 2, #height, 128)
--groupbox_name = "Groupbox default params"

_GroupBox = _Controls.control #GroupBox "Groupbox default params"

--_Controls.control #button "Button A1" across:1 --params:#(#groupbox, "Groupbox default params" )
_Controls.control #button "Button A1" across:2	params:#(#groupbox, "Groupbox default params" )
_Controls.control #button "Button A2"	params:#(#groupbox, "Groupbox default params" )
_Controls.control #button "Button A3"	params:#(#groupbox, "Groupbox default params" )
--_Controls.control #button "Button A2" params:#(#groupbox, "Groupbox default params" )
--_Controls.control #button "Button A2" params:#(#groupbox, "Groupbox default params" )

--groupboxesWithHeight count:1

--heightbyNextControl()

--selfdefinedGroupboxes count:2

--lastGroupboxSizeByRollout()






/*------------------------------------------------------------------------------
	CREATE ROLLOUT
--------------------------------------------------------------------------------*/

/** Create dialog from _Rollout
  */
--dialog_width = 420
--dialog_width = undefined

--dialog_height = 256
--dialog_height = 720
--dialog_height = undefined
include "Library/MAXSCRIPT-UI-framework/Lib/RolloutCreator/_Test/includes/CreateTestDialog.ms"
