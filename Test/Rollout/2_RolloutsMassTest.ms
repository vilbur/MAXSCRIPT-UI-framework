clearListener()

filein( "$userscripts\Library\MAXSCRIPT-UI-framework\Lib\Dialog\Dialog.ms" )



/** Add sub rollouts
 */
function addRollouts _Rollouts title count slot:slot =
(
	_Rollout_new = #()

	for i = 1 to count do 
		append _Rollout_new (_Rollouts.new title )

	_Rollout_new --return
)


/* DIALOG */ 

Dialog 	= Dialog_v title:(getFilenameFile(getSourceFileName())) 

/* ROLLOUTS */ 	

_Rollouts = addRollouts ( Dialog.Rollouts slot:#rollouts_A height:1024 )	("Rollout A")(1)

height = 512

/* SUB ROLLOUTS */ 	

for i = 1 to 6 do
(
	title = ("subrollout_"+ i as string )

	_Rollouts = addRollouts (_Rollouts[1].Rollouts height:(height -= 48 ) ) title 1 slot:( title as name)
)


/* CREATE DIALOG */ 
 -- Dialog.create()
Dialog.create width:720 height:640 