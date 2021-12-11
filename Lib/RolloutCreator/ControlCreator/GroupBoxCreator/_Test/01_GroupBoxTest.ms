clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../../../RolloutCreator.ms" )

/** Create variables:
  *		_RolloutCreator
  *		_Rollout
  *		_Controls
  */
include "Library/MAXSCRIPT-UI-framework/Lib/RolloutCreator/_Test/includes/CreateTestRollout.ms" -- "../../../_Test/includes/CreateTestRollout.ms"

/*------------------------------------------------------------------------------
	TESTS DEFINITION
--------------------------------------------------------------------------------*/
function createControls control_type:#button groupbox_name:"" =
(
	for i = 1 to 3 do 
		_Button1    = _Controls.control control_type ( groupbox_name + " "+i as string ) params:#(#groupbox, groupbox_name, #across, 2)
)

/** Create group box
 */
function createGroupBox groupbox_name groupbox:true =
(
	if groupbox then 
		_GroupBox = _Controls.control #GroupBox groupbox_name params:#(#across, 2, #height, 128) 
		--_GroupBox = _Controls.control #GroupBox groupbox_name params:#(#across, 2) 
		--_GroupBox = _Controls.control #GroupBox groupbox_name params:#(#across, 2, #height, 256, #width, 128) 
	
	createControls control_type:#button groupbox_name:groupbox_name	--params:#(#across, 2) 
)

/** Groupboxes with height
 */
function groupboxesWithHeight count:1 =
(
	for i = 1 to count do 
		createGroupBox ("Defined height "+ i as string )
)

/** Groupboxes with height
 */
function selfdefinedGroupboxes count:1 =
(
	for i = 1 to count do 
		createGroupBox ("Self defined groupbox "+ i as string ) groupbox:false
)

/** Heightby next ntrol
 */
function heightbyNextControl =
(
	_Controls.control #GroupBox "Height to next row y position"	params:#(#across, 2) 
	_Controls.control #GroupBox "Height by next groupbox"	params:#(#across, 2) 
	_Controls.control #GroupBox "Height by this last control in row"	params:#(#across, 2, #height, 96)

	_Controls.control #GroupBox	"Height by next control"	params:#(#across, 2) 
	_Controls.control #multilistbox	"Test"	params:#(#height, 3)
)

/** Last groupbox size by rollout
 */
function lastGroupboxSizeByRollout =
(
	_Controls.control #GroupBox "Fill rollout to the border"	params:#(#across, 2) 
)




/*------------------------------------------------------------------------------
	RUN TESTS 
--------------------------------------------------------------------------------*/

groupboxesWithHeight count:3

heightbyNextControl()

selfdefinedGroupboxes count:2

--lastGroupboxSizeByRollout()






/*------------------------------------------------------------------------------
	CREATE ROLLOUT
--------------------------------------------------------------------------------*/

/** Create dialog from _Rollout
  */
dialog_width = 420
--dialog_width = undefined

dialog_height = 256
dialog_height = 720
--dialog_height = undefined
include "Library/MAXSCRIPT-UI-framework/Lib/RolloutCreator/_Test/includes/CreateTestDialog.ms"
