/** CREATE DIALOG 
 */




--_RolloutCreator.createRollout _Rollout height:dialog_height
_RolloutCreator.createRollout _Rollout

--CreateDialog (_RolloutCreator.getDefinition _Rollout) width:1024 height:1024 autoLayoutOnResize:true
CreateDialog (_RolloutCreator.getDefinition _Rollout) autoLayoutOnResize:true

--_RolloutCreator.SubolloutsCreator.addSubRollouts _Rollout