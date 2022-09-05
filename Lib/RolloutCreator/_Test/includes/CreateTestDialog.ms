/** CREATE ROLLOUT & DIALOG 
 */
_RolloutCreator.createRollout (_Rollout)

CreateDialog (_RolloutCreator.getDefinition _Rollout) width:width height:height

_RolloutCreator.SubolloutsCreator.addSubRollouts _Rollout