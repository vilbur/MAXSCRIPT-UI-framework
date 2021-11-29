/** CREATE DIALOG 
 */


if( dialog_width == undefined ) then
	dialog_width  = unsupplied
	
if( dialog_height == undefined ) then
	dialog_height = unsupplied

_RolloutCreator.createRollout _Rollout

CreateDialog (_RolloutCreator.getDefinition _Rollout) width:dialog_width height:dialog_height

_RolloutCreator.addSubRollouts _Rollout