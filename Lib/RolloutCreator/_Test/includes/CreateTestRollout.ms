filein( getFilenamePath(getSourceFileName()) + "/../../../Ini/Ini.ms" )

try(cui.UnRegisterDialogBar Test)catch() 
try( destroyDialog          Test)catch()


if( RolloutCreator_v == undefined ) then 
	throw "RolloutCreator_v struct is MISSING in test file.\n\nPlease import it BEFORE include of CreateTestRollout.ms"

	
	
if( width == undefined ) then
	width  = 512
	
if( height == undefined ) then
	height = 512

if( group_name == undefined ) then
	group_name = ""
	
	

/** DEFINE ROLLOUT 
 *	
 */
_RolloutCreator 	= RolloutCreator_v Ini:(Ini_v())

_Rollout = Rollout_v title:"Test" width:width

_Controls = _Rollout.Controls group:group_name 