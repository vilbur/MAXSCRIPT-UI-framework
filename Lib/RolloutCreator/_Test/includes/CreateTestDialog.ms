/** CREATE DIALOG 
 */


if( dialog_width == undefined ) then
	dialog_width  = unsupplied
	
if( dialog_height == undefined ) then
	dialog_height = unsupplied

_RolloutCreator.createRollout _Rollout height:dialog_height

CreateDialog (_RolloutCreator.getDefinition _Rollout) width:dialog_width height:dialog_height autoLayoutOnResize:true

_RolloutCreator.SubolloutsCreator.addSubRollouts _Rollout