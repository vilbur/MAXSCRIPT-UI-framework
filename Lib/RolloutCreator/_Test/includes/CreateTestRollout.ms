try(cui.UnRegisterDialogBar ROLLOUT_test)catch() 
try( destroyDialog          ROLLOUT_test )catch()



if( group_name == undefined ) then
	group_name = ""
/** DEFINE ROLLOUT 
 *	
 */
_RolloutCreator 	= RolloutCreator_v()

_Rollout = _RolloutCreator.new "Test"

_Controls = _Rollout.Controls group:group_name