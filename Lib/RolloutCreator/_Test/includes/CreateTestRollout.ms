filein( getFilenamePath(getSourceFileName()) + "/../../../Ini/Ini.ms" )

try(cui.UnRegisterDialogBar Test)catch() 
try( destroyDialog          Test)catch()


if( RolloutCreator_v == undefined ) then 
	throw "RolloutCreator_v struct is MISSING in test file.\n\nPlease import it BEFORE include of CreateTestRollout.ms"

if( group_name == undefined ) then
	group_name = ""
/** DEFINE ROLLOUT 
 *	
 */
_RolloutCreator 	= RolloutCreator_v Ini:(Ini_v())

_Rollout = _RolloutCreator.new "Test"

_Controls = _Rollout.Controls group:group_name 