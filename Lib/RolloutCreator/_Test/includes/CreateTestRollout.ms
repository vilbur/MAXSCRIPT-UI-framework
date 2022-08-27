filein( getFilenamePath(getSourceFileName()) + "/../../../Ini/Ini.ms" )

try(cui.UnRegisterDialogBar Test)catch() 
try( destroyDialog          Test)catch()


if( RolloutCreator_v == undefined ) then 
	throw "RolloutCreator_v struct is MISSING in test file.\n\nPlease import it BEFORE include of CreateTestRollout.ms"


if( group_name == undefined ) then
	group_name = ""
	
if( width == undefined ) then
	width  = unsupplied
	
if( height == undefined ) then
	height = unsupplied

/** DEFINE ROLLOUT 
 *	
 */
_RolloutCreator 	= RolloutCreator_v Ini:(Ini_v()) width:width

_Rollout = _RolloutCreator.Roll "Test"

--_Controls = _Rollout.Controls group:group_name 