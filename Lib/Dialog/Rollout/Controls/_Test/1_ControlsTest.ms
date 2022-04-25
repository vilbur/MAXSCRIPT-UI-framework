clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../../Rollout.ms" )


try( destroyDialog ROLLOUT_test )catch()


/** DEFINE UI 
 *	
 */
_Rollout  = Rollout_v title:"Test"

_Controls = _Rollout.Controls()

_Button_1 = _Controls.control #button	"Button 1"
_Checkbox = _Controls.control #checkbox	"Checkbox 2"


format "_Rollout	= % \n" _Rollout
format "_Controls	= % \n" _Controls
format "_Button_1	= % \n" _Button_1



/** CREATE UI 
 *	
 */
_RolloutCreator = rolloutCreator (_Rollout.id) (_Rollout.title)

_RolloutCreator.begin()


for _Controls in _Rollout._Controls do
	for _Control in _Controls.list do
		_RolloutCreator.addControl _Control.type _Control.id _Control.caption


_RolloutCreator.end()

CreateDialog (_RolloutCreator.def)