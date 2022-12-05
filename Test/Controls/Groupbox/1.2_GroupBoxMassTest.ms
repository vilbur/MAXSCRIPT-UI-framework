clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../../../Lib/RolloutCreator/RolloutCreator.ms" )

/** Create variables:
  *		_RolloutCreator
  *		_Rollout
  *		_Controls
  */
include "MAXSCRIPT-UI-framework/Lib/RolloutCreator/_Test/includes/CreateTestRollout.ms" -- "../../../_Test/includes/CreateTestRollout.ms"


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
function createControls control_type:#button groupbox_name:"" count:3 =
(
	for i = 1 to count do 
		_Button1    = _Controls.control control_type ( groupbox_name + " "+i as string ) params:#(#groupbox, groupbox_name, #across, 2)
)

/** Create group box
 */
function createGroupBoxWithHight groupbox_name groupbox:true =
(
	if groupbox then 
		--_GroupBox = _Controls.control #GroupBox groupbox_name params:#(#across, 2, #height, 128 ) 
		_GroupBox = _Controls.control #GroupBox groupbox_name params:#(#across, 2, #height, 256 ) 
		--_GroupBox = _Controls.control #GroupBox groupbox_name params:#(#across, 2) 
		--_GroupBox = _Controls.control #GroupBox groupbox_name params:#(#across, 2, #height, 256, #width, 128) 
	
	createControls control_type:#button groupbox_name:groupbox_name	--params:#(#across, 2) 
)

/** Groupboxes with height
 */
function groupboxesWithHeight count:1 =
(
	for i = 1 to count do 
		createGroupBoxWithHight ("Defined height "+ i as string )
)

/** Crete Groupbox defined as parameter in control
  *
  * Usefull when ui is generated from ".mcr" file
  *
 */
function selfdefinedGroupboxes count:1 =
(
	for i = 1 to count do
	(
		groupbox_name = "Self defined groupbox " + i as string
		
		for b = 1 to 3 do
			_Controls.control #button ( groupbox_name + " "+ b as string ) params:#(#groupbox, groupbox_name, #across, 2)
	)
)

/*------------------------------------------------------------------------------
	AUTO HEIGHT OF GROUPBOX
--------------------------------------------------------------------------------*/

/** Height of groupbox is up to control in next row
 */
function heightToNextRow =
(
	_Controls.control #GroupBox "Height to y position of next row"	params:#(#across, 1 )
	--_Controls.control #GroupBox "Groupbox offset"	params:#(#across, 1, #offset, [0, 128], #height, 128) 
	_Controls.control #GroupBox "Groupbox offset"	params:#(#across, 1, #offset, [0, 128] ) 
)

/** Height of groupbox is defined by next groupbox in row
 */
function heightbyNextGroupBox =
(
	_Controls.control #GroupBox "Height by next groupbox"	params:#(#across, 2 )
	_Controls.control #GroupBox "This Groupbox defines height of previous"	params:#(#across, 2, #height, 256)
)

/** Height of groupbox is defined by next control in row
 */
function heightbyNextControl =
(
	_Controls.control #GroupBox	"Height by next control"	params:#(#across, 2) 
	_Controls.control #multilistbox	"Test"	params:#(#across, 2, #height, 5)
)

/*------------------------------------------------------------------------------
	AUTO HEIGHT OF GROUPBOX
--------------------------------------------------------------------------------*/


/** When groupbox is last control in rollout, then its height is up to row ends
 */
function lastGroupboxSizeByRollout =
(	
	--_Controls.control #GroupBox "Fill rollout to the border"	params:#(#across, 1) 
	_Controls.control #GroupBox "Fill rollout to the border"	params:#(#across, 2) -- FIXED bug when next control was fake control
)




/*------------------------------------------------------------------------------
	RUN TESTS 
--------------------------------------------------------------------------------*/

selfdefinedGroupboxes count:1 

--heightbyNextGroupBox()
--heightbyNextControl()
--heightToNextRow()


group_box_count = 1
group_box_count = 2
group_box_count = 3
--groupboxesWithHeight count:group_box_count


--lastGroupboxSizeByRollout()




/*------------------------------------------------------------------------------
	CREATE ROLLOUT
--------------------------------------------------------------------------------*/

/** Create dialog from _Rollout
  */
dialog_width = 420
--dialog_width = undefined

--dialog_height = 256
--dialog_height = 720
dialog_height = 1200
--dialog_height = undefined
include "MAXSCRIPT-UI-framework/Lib/RolloutCreator/_Test/includes/CreateTestDialog.ms"
