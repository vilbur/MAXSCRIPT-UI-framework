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

_Rollouts_A = addRollouts ( Dialog.Rollouts height:512 )("Rollout A")(2)
_Rollouts_B = addRollouts ( Dialog.Rollouts() )("Rollout B")(2)
_Rollouts_C = addRollouts ( Dialog.Rollouts())("Rollout C" )(3)


/* SUBROLLOUTS */ 

_SubRollouts	= addRollouts (_Rollouts_A[1].Rollouts())("SubRollouts A")(2)


/*  NESTED SUBROLLOUTS */ 

_NestedSubRollouts	= addRollouts (_SubRollouts[1].Rollouts())("Nested SubRollouts A")(2)


/*  SUPER NESTED SUBROLLOUTS */ 

_SuperNestedSubRollouts	= addRollouts (_NestedSubRollouts[1].Rollouts())("Super Nested SubRollouts A")(2)


/*  SET HEIGHT */ 
-- _Rollouts_A[1].height = 512
_SubRollouts[1].height = 320
_NestedSubRollouts[1].height = 320


/*
   CONTROLS
*/ 
 _Controls	= addControls( _SuperNestedSubRollouts[1].controls() )("Button Rollout A1")(6)
 _Controls	= addControls( _SuperNestedSubRollouts[2].controls() )("Button Rollout A2")(6)

Nested_Controls	= addControls( _NestedSubRollouts[1].controls() )("Button Rollout A")(2)



/* CREATE DIALOG */ 
 -- Dialog.create()
Dialog.create height:1024





