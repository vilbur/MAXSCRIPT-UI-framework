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
--_Rollouts_B = addRollouts ( Dialog.Rollouts() )	("Rollout B")(2)
--_Rollouts_C = addRollouts ( Dialog.Rollouts() )	("Rollout C")(3)


/* SUBROLLOUTS */ 

_SubRollouts	= addRollouts (_Rollouts_A[1].Rollouts())("SubRollout A")(1)
--_SubRollouts	= addRollouts (_Rollouts_A[1].Rollouts slot:#SubRollouts_A1)("SubRollout A")(1)


/*  NESTED SUBROLLOUTS */ 

_NestedSubRollouts	= addRollouts (_SubRollouts[1].Rollouts())("Nested SubRollout A")(4)
--_NestedSubRollouts	= addRollouts (_SubRollouts[1].Rollouts slot:#nested_subRollouts_A1)("Nested SubRollout A")(4)


/*  SUPER NESTED SUBROLLOUTS */ 

_SuperNestedSubRollouts	= addRollouts (_NestedSubRollouts[1].Rollouts())("Super Nested SubRollout A")(1)
--_SuperNestedSubRollouts	= addRollouts (_NestedSubRollouts[1].Rollouts slot:#super_nested_subRollouts_A1)("Super Nested SubRollout A")(1)



/** GET ROLLOUT OR SUBROLLOUT SLOT and chang its properties
  *	
  */
--_SubRollouts_A	= Dialog.RolloutMain.get (#rollouts_A)
----_SubRollouts_A.height = 512



--_Rollout_A1	= _SubRollouts_A.get (#rollout_a1)
--_Rollout_A1	= Dialog.RolloutMain.get (#rollout_a1)
 --format "_Rollout_A1	= % \n" _Rollout_A1
--_Rollout_A1.height = 512
----
--Subrollout_a1	= _Rollout_A1.get (#Subrollout_a1)
--Subrollout_a1	= Dialog.RolloutMain.get (#Subrollout_a1)
--format "Subrollout_a1	= % \n" Subrollout_a1
--Subrollout_a1.height = 512
----
--Nested_subrollout_a1	= Subrollout_a1.get (#Nested_subrollout_a1)
--Nested_subrollout_a1	= Dialog.RolloutMain.get (#Nested_subrollout_a1)
--format "Nested_subrollout_a1	= % \n" Nested_subrollout_a1
----Nested_subrollout_a1.height = 512
--
--
--super_nested_subrollout_a1	= Nested_subrollout_a1.get (#super_nested_subrollout_a1)
Super_nested_subrollout_a1	= Dialog.RolloutMain.get (#Super_nested_subrollout_a1)
format "Super_nested_subrollout_a1	= % \n" Super_nested_subrollout_a1
--Nested_subrollout_a1.height = 512


















/* CREATE DIALOG */ 
 -- Dialog.create()
Dialog.create height:1024