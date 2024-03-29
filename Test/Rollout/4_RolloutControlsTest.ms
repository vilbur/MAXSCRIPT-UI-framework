clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../../Lib/Dialog/Dialog.ms" ) -- "./../../Lib/Dialog/Dialog.ms"




/** Add rollouts
 */
function addRollouts _Rollouts title count slot:slot =
(
	_Rollout_new = #()

	for i = 1 to count do 
		append _Rollout_new (_Rollouts.new ( title + i as string ))

	_Rollout_new --return
)

/** Add rollouts
 */
function addControls _Controls title count =
(
	_Controls_new = #()

	for i = 1 to count do 
		append _Controls_new ( _Controls.control #button (title + i as string ) ) --params:#(  #across, 1)

	_Controls_new --return
)

/* DIALOG */ 

Dialog 	= Dialog_v title:(getFilenameFile(getSourceFileName()))


/* ROLLOUTS */ 	

_Rollouts_A = addRollouts ( Dialog.Rollouts height:512 )("Rollout A")(1)

/* SUBROLLOUTS */ 

_SubRollouts	= addRollouts (_Rollouts_A[1].Rollouts())("SubRollouts A")(1)


/*  NESTED SUBROLLOUTS */ 

_NestedSubRollouts	= addRollouts (_SubRollouts[1].Rollouts())("Nested SubRollouts A")(1)


/*  SUPER NESTED SUBROLLOUTS */ 

_SuperNestedSubRollouts	= addRollouts (_NestedSubRollouts[1].Rollouts())("Super Nested SubRollouts A")(1)

_SuperSuperNestedSubRollouts	= addRollouts (_SuperNestedSubRollouts[1].Rollouts())("Super Super Nested A")(1)


/*  SET HEIGHT */

 _Rollouts_A[1].height = 460
_SubRollouts[1].height = 380
_NestedSubRollouts[1].height = 256
_SuperNestedSubRollouts[1].height = 128


/*
   CONTROLS
*/ 
_Controls	= addControls( _Rollouts_A[1].controls() )("Rollout A")(1)
Subrollout_Controls	= addControls( _SubRollouts[1].controls() )("Subrollout A")(2)

Nested_Controls	= addControls( _NestedSubRollouts[1].controls() )("Nested A")(3)

_SuperNestedSub_Controls	= addControls( _SuperNestedSubRollouts[1].controls() )("Super Nested A")(4)


/* CREATE DIALOG */ 
 -- Dialog.create()
Dialog.create height:1024





