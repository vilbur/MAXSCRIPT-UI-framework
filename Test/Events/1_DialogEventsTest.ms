clearListener()


filein( "$userscripts\Library\MAXSCRIPT-UI-framework\Lib\Dialog\Dialog.ms" )

try( destroyDialog ROLLOUT_test )catch()


Dialog 	= Dialog_v title:"Test"  ini:( getSourceFileName())
-- Dialog.Events.add #open	"print(\"Custom dialog event #open\")"
-- Dialog.Events.add #close	"print(\"Custom dialog event #close\")"
-- Dialog.Events.add #moved	"print(\"#Custom dialog event moved\")"
-- Dialog.Events.add #resized	"print(\"Custom dialog event #resized\")"

-- Dialog.Events.add #okToClose	"print(\"Custom dialog event #okToClose\"); true"



/* ROLLOUT */ 
_Rollouts  = Dialog.Rollouts()
_Rollout = _Rollouts.new "Subrollout 1"
_Rollout_2 = _Rollouts.new "Subrollout 2"

_Rollout.Events.add #rolledUp	"print(\"Custom Rollout event #open \"+val as string )"
_Controls = _Rollout.Controls group:"Subrollout Controls"

_Button_1 = _Controls.control #checkbox "Cbeckbox 1" 


/* SUBROLLOUTS */ 
Subrolllouts = _Rollout.Rollouts()
_Subrolllout = Subrolllouts.new "Nested"
_Subrolllout.Events.add #rolledUp	"print(\"Custom Subrolllout event #open \"+val as string )"




Dialog.create()

Dialog.register()