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
function getItems count prefix =
(
	for i = 1 to count collect (prefix+" "+ i as string )
)


_RolloutCreator 	= RolloutCreator_v Ini:(Ini_v())
 -- _RolloutCreator 	= RolloutCreator_v Ini:(Ini_v _path:(getSourceFileName()))

_Rollout = _RolloutCreator.new "Test"

_Controls = _Rollout.Controls group:"Test"



/*------------------------------------------------------------------------------
	TEST RADIOBUTTONS
--------------------------------------------------------------------------------*/

_Controls.control #RadioButtons "Row default in params" items:(getItems( 3 )("Column")) params:#(#align, #left )

_Controls.control #RadioButtons "Offset defined as single Point2" items:(getItems( 4 )("Column"))  params:#(#offsets, [8, 16] ) value:3

_Controls.control #RadioButtons "Offset defined for each button" items:(getItems( 3 )("Column"))  params:#( #offsets, #([0, 0], [0, 8], [0, 16]) )

_Controls.control #RadioButtons "Multiple columns and single offset" items:(getItems( 9 )("Column"))  params:#( #offsets,[64, 32], #columns,3, #align,#left )



/** CREATE UI 
 *	
 */
_RolloutCreator.createRollout _Rollout width:320

CreateDialog (_RolloutCreator.getDefinition _Rollout) width:320
--CreateDialog (_RolloutCreator.getDefinition _Rollout) 

