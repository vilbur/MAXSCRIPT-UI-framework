clearListener()
filein( getFilenamePath(getSourceFileName()) + "/../Rollout.ms" )


try( destroyDialog ROLLOUT_test )catch()

/** DEFINE UI 
 *	
 */
_Rollout = Rollout_v title:"Test"

format "_Rollout	= % \n" _Rollout


/** CREATE UI 
 *	
 */

_Rollout.rolloutCreatorBegin 256

_Rollout._RolloutCreator.end()

CreateDialog (_Rollout._RolloutCreator.def)