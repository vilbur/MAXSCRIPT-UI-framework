clearListener()

filein( "$userscripts\Library\MAXSCRIPT-UI-framework\Lib\Dialog\Dialog.ms" )



/** Add rollouts
 */
function addRollouts _Rollouts title count slot:slot =
(
	_Rollout_new = #()

	for i = 1 to count do 
		append _Rollout_new (_Rollouts.new ( title + i as string ))

	_Rollout_new --return
)



/* DIALOG */ 

Dialog 	= Dialog_v title:(getFilenameFile(getSourceFileName()))


/* ROLLOUTS */ 	

_Rollouts_A = addRollouts ( Dialog.Rollouts slot:#rollouts_A height:128 )	("Rollout A")(1)
_Rollouts_B = addRollouts ( Dialog.Rollouts() )	("Rollout B")(2)
_Rollouts_C = addRollouts ( Dialog.Rollouts() )	("Rollout C")(3)


/* SUBROLLOUTS */ 

_SubRollouts	= addRollouts (_Rollouts_A[1].Rollouts())("SubRollout A")(2)


/*  NESTED SUBROLLOUTS */ 

_NestedSubRollouts	= addRollouts (_SubRollouts[1].Rollouts())("Nested SubRollout A")(2)


/*  SUPER NESTED SUBROLLOUTS */ 

_SuperNestedSubRollouts	= addRollouts (_NestedSubRollouts[1].Rollouts())("Super Nested SubRollout A")(2)



/** GET ROLLOUT OR SUBROLLOUT SLOT and chang its properties
  *	
  */
_SubRollouts_A	= Dialog.RolloutMain.get (#rollouts_A)
_SubRollouts_A.height = 512
-- format "_SubRollouts_A	= % \n" _SubRollouts_A


_Rollout_A1	= Dialog.RolloutMain.get (#rollout_a1)
-- format "_Rollout_A1	= % \n" _Rollout_A1
_Rollout_A1.title = "Rollout A1 - Changed title"



/* CREATE DIALOG */ 
 -- Dialog.create()
Dialog.create height:1024