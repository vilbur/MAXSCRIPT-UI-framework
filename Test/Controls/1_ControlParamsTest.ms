clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../../../../../RolloutCreator/RolloutCreator.ms" )

try( destroyDialog ROLLOUT_test )catch()



/** DEFINE UI 
 *	
 */
_RolloutCreator 	= RolloutCreator_v()

_Rollout = _RolloutCreator.new "Test"

_Controls_1 = _Rollout.Controls()
_Controls_2 = _Rollout.Controls()



/** SET GLOBAL PARAMETERS FOR ALL TYPES
 */
-- _Controls_1.Default #across 1
_Controls_1.Default #width 32
_Controls_1.Default #height 32

/** SET PARAMETERS PER CONTROL, test of override of global params
 *
 * 
 *
 */
Button_1 = _Controls_1.control #Button "Default width"
Button_2 = _Controls_1.control #Button "Params string"	params:"width:256|height:64, border:false"
Button_4 = _Controls_1.control #Button "Params array"	params:#( #width,96, #height,64, "border",false )
Button_5 = _Controls_1.control #Button "Invalid param" 	params:"foobar:256"


/** MASS SET OF GLOBAL PARAMETERS
 */
--_Controls_2.Defaults #( #width,128, #height,5, #across,2 )

--listbox_1 = _Controls_2.control #listbox  "Items array string"	params:"Items: #(\"String Item 1\", \"String Item 2\" )"
--listbox_2 = _Controls_2.control #listbox  "Items array"	params:#( #Items, #("Array item 1", "Array Item 2" ))







/** CREATE UI 
 *	
 */
_RolloutCreator.createRollout _Rollout

CreateDialog (_RolloutCreator.getDefinition _Rollout) width:512