clearListener()


--filein( getFilenamePath(getSourceFileName()) + "/../../Lib/Ini/Ini.ms" )
--filein( getFilenamePath(getSourceFileName()) + "/../../Lib/RolloutCreator/RolloutCreator.ms" )
filein( "$userscripts\Library\MAXSCRIPT-UI-framework\Lib\Dialog\Dialog.ms" )



--try( destroyDialog ROLLOUT_test )catch()


/** Button test
 */
function CallbackNoParam =
(
	print "CallbackNoParam"

	if( EventFired != undefined ) then 
		(format "EventFired.control 	= % \nEventFired.type 	= % \n\n" EventFired.control EventFired.type)
)

/** on value changed
 */
function CallbackWithValue val =
(
	--print "CallbackWithValue"
	
	if( EventFired != undefined ) then 
		format "EventFired.control 	= % \nEventFired.type 	= % \n" EventFired.control EventFired.type
	
	format "val 	= % \n" val
	
	format "EventFired 	= % \n\n" EventFired
)


/** on value changed
 */
function CallbackWith2Params arg_1 arg_2 =
(
	--print "CallbackWith2Params"
	if( EventFired != undefined ) then 
		format "EventFired.control 	= % \nEventFired.type 	= % \n" EventFired.control EventFired.type

	format "arg_1 	= % \narg_2  	= % \n" arg_1 arg_2

	format "EventFired 	= % \n\n" EventFired
)





/** DEFINE UI 
 *	
 */
Dialog 	= Dialog_v title:(getFilenameFile(getSourceFileName()))  ini:( getSourceFileName())

--_RolloutCreator 	= RolloutCreator_v Ini:(Ini_v( getSourceFileName()))

_Rollouts  = Dialog.Rollouts height:512
_Rollout = _Rollouts.Roll "Rollout 1"

_Controls = _Rollout.Controls group:"Test"

--_Button_1 = _Controls.control #button "Button 1"
--_Button_1.Event #pressed	"print \"Button Pressed\""
--_Button_1.Event #rightclick	"print \"Button Rightclick\""


 --_EditText = _Controls.control #EditText "EditText 1"
-- _EditText.Event #entered  "CallbackWithValue(val)"
-- _EditText.Event #changed "CallbackWithValue(val)"

--_BrowsePath = _Controls.control #browsePath "EditText 1"
--_BrowsePath.Event #entered  "CallbackWithValue(val)"
--_BrowsePath.Event #changed "CallbackWithValue(val)"


-- _EditText.Event #changed	"print val"

--_BrowsePath = _Controls.control #BrowsePath "BrowsePath 1"

_Multilistbox = _Controls.control #Multilistbox "Multilistbox 1" across:1 items:#("A", "B" )

/** CREATE UI 
 *	
 */
--_RolloutCreator.createRollout _Rollout

--CreateDialog (_RolloutCreator.getDefinition _Rollout)
Dialog.create width:256 

--Dialog.register()