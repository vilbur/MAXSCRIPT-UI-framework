clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../../Lib/Dialog/Dialog.ms" ) -- "./../../Lib/Dialog/Dialog.ms"




/** Add rollouts
 */
function addRollouts _Rollouts title rollouts_in_slot: slot:slot =
(
	_Rollout_new = #()

	for i = 1 to rollouts_in_slot do
		append _Rollout_new (_Rollouts.Roll ( title + i as string ))

	_Rollout_new --return
)



/* DIALOG */

Dialog 	= Dialog_v title:(getFilenameFile(getSourceFileName()))


/* ROLLOUTS */

_Rollouts_A = addRollouts ( Dialog.Rollouts slot:#rollouts_A height:256 )	("Rollout A") rollouts_in_slot: 1
-- _Rollouts_B = addRollouts ( Dialog.Rollouts  height:128 )	("Rollout B") rollouts_in_slot: 2
--_Rollouts_C = addRollouts ( Dialog.Rollouts() )	("Rollout C") rollouts_in_slot: 3
--

/* SUBROLLOUTS */

 _SubRollouts	= addRollouts (_Rollouts_A[1].Rollouts())("SubRollout A") rollouts_in_slot: 5


/*  NESTED SUBROLLOUTS */
 _NestedSubRollouts	= addRollouts (_SubRollouts[1].Rollouts())("Nested SubRollout A") rollouts_in_slot: 3


/*  SUPER NESTED SUBROLLOUTS */

 -- _SuperNestedSubRollouts	= addRollouts (_NestedSubRollouts[1].Rollouts())("Super Nested SubRollout A") rollouts_in_slot: 4



/* GET ROLLOUT OR SUBROLLOUT SLOT and change its properties */
-- Rollouts_A	= Dialog.get (#rollouts_A) -- get slot of subrolouts
-- Rollouts_A.height = 512


--/* get rollout and change properties  */
--_Rollout_A1	= Rollouts_A.get (#rollout_a1)
--_Rollout_A1.height = 512
--_Rollout_A1.title = _Rollout_A1.title + " modified title"

--/* Get via Dialog, Rollout and Subrollouts */
--(Rollouts_A.get (#Subrollout_a1)).height = 320
--(Dialog.get (#Nested_subrollout_a1)).height = 128
--(Dialog.get (#Super_nested_subrollout_a1)).height = 128




/* CREATE DIALOG */
--Dialog.create()
Dialog.create width:512
