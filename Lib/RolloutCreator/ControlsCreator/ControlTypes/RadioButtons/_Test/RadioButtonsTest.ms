clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../../../../../Dialog/Dialog.ms" )


/*------------------------------------------------------------------------------
	TEST SETUP
--------------------------------------------------------------------------------*/

Dialog 	    = Dialog_v title:"Test" ini:(getSourceFileName())
--Dialog 	    = Dialog_v title:"Test"

--_Controls = Dialog.Controls group:"Test"

_Rollouts	 = Dialog.Rollouts()

_Rollout    = _Rollouts.Roll "Subrollout"

_Controls = _Rollout.Controls group:"Test"


/** Get items
 */
function getItems count = for i = 1 to count collect ("Button "+ i as string )


/*------------------------------------------------------------------------------
	TEST RADIOBUTTONS
--------------------------------------------------------------------------------*/

_Controls.control #RadioButtons "Unselectable buttons"	params:#( #unselect,true,	#align,#left )	items:(getItems( 3 )) value:1
		
_Controls.control #RadioButtons "Offset defined as single Point2"	params:#( #offsets, [8, 16],	#align,#left ) items:(getItems( 4 ))
		
--_Controls.control #RadioButtons "Offset defined for each button"	params:#( #offsets, #([0, 0], [0, 8], [0, 16]),	#align,#left )	items:(getItems( 3 )) 
		
--_Controls.control #RadioButtons "Multiple columns with single offset"	params:#( #offsets,[64, 32], #columns,3,	#align,#left)	items:(getItems( 9 )) 

--_Controls.control #checkbox "checkbox test"

/** CREATE UI 
 *	
 */
Dialog.create()
--Dialog.create height:1024