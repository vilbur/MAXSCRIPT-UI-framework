clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../../../../RolloutCreator.ms" )
filein( getFilenamePath(getSourceFileName()) + "/../../../../../Ini/Ini.ms" )


try( destroyDialog test )catch()

/** DEFINE UI 
 * 
 * [All control types available in maxscript UI ](https://help.autodesk.com/view/MAXDEV/2021/ENU/?guid=GUID-E421933F-958E-42FD-80A1-D66F2A2C0A06)
 */

--items_of_controls = for i = 1 to 2 collect (""+ i as string )

/** Get items
 */
function getItems count prefix =
(
	for i = 1 to count collect (prefix+" "+ i as string )
)


-- _RolloutCreator 	= RolloutCreator_v Ini:(Ini_v())
 _RolloutCreator 	= RolloutCreator_v Ini:(Ini_v _path:(getSourceFileName()))

_Rollout = _RolloutCreator.new "Test"

_Controls = _Rollout.Controls group:"Test"


/** CREATE RADIOBUTTONS
  *	
  */
--_Controls.control #RadioButtons "Row Column 1" items:(getItems( 3 )("Column"))
--_Controls.control #RadioButtons "Row Column 1" items:(getItems( 3 )("Column") params:#(#selection, 2 ) )

--_Controls.control #RadioButtons "Offset in Row 1" items:(getItems( 4 )("Column"))  params:#(#offset, [-96, 0] )
--
--_Controls.control #RadioButtons "Offset in Row 1.1" items:(getItems( 4 )("Column"))  params:#(#offset, [-96, 0], #offsets, [8, 0] )
--
--_Controls.control #RadioButtons "Offset in Row 3" items:(getItems( 2 )("Column"))  params:#(#offset, [-96, 0], #offsets, [48, 0])
--
--_Controls.control #RadioButtons "Offset in Row 4" items:(getItems( 6 )("Column"))  params:#(#offset, [-96, 0], #offsets, [24, 0], #columns, 3)
--




/** CREATE UI 
 *	
 */
_RolloutCreator.createRollout _Rollout width:320

CreateDialog (_RolloutCreator.getDefinition _Rollout) width:320
--CreateDialog (_RolloutCreator.getDefinition _Rollout) 

