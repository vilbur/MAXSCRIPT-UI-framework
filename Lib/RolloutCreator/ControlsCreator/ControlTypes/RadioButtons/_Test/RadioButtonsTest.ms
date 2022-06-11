clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../../../../RolloutCreator.ms" )
filein( getFilenamePath(getSourceFileName()) + "/../../../../../Ini/Ini.ms" )


try( destroyDialog test )catch()


/*------------------------------------------------------------------------------
	TEST SETUP
--------------------------------------------------------------------------------*/
/** DEFINE UI 
 * 
 * [All control types available in maxscript UI ](https://help.autodesk.com/view/MAXDEV/2021/ENU/?guid=GUID-E421933F-958E-42FD-80A1-D66F2A2C0A06)
 */

/** Get items
 */
function getItems count = for i = 1 to count collect ("Button "+ i as string )



_RolloutCreator 	= RolloutCreator_v Ini:(Ini_v())
 -- _RolloutCreator 	= RolloutCreator_v Ini:(Ini_v _path:(getSourceFileName()))

_Rollout = _RolloutCreator.new "Test"

_Controls = _Rollout.Controls group:"Test"



/*------------------------------------------------------------------------------
	TEST RADIOBUTTONS
--------------------------------------------------------------------------------*/

_Controls.control #RadioButtons "Unselectable buttons"	params:#( #unselect,true,	#align,#left )	items:(getItems( 3 )) --value:3 
		
_Controls.control #RadioButtons "Offset defined as single Point2"	params:#( #offsets, [8, 16],	#align,#left ) items:(getItems( 4 ))
		
_Controls.control #RadioButtons "Offset defined for each button"	params:#( #offsets, #([0, 0], [0, 8], [0, 16]),	#align,#left )	items:(getItems( 3 )) 
		
_Controls.control #RadioButtons "Multiple columns with single offset"	params:#( #offsets,[64, 32], #columns,3,	#align,#left)	items:(getItems( 9 )) 



/** CREATE UI 
 *	
 */
_RolloutCreator.createRollout _Rollout width:320

CreateDialog (_RolloutCreator.getDefinition _Rollout) width:320
--CreateDialog (_RolloutCreator.getDefinition _Rollout) 

