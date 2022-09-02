clearListener()

filein( "$userscripts\Library\MAXSCRIPT-UI-framework\Lib\Dialog\Dialog.ms" )




/** Dialog default width
 */
function dialogDefaultWidth =
(

	/* DIALOG */ 
	Dialog 	= Dialog_v title:"Dialog default width"
	
	_Rollout = Dialog.roll "Rollout default width"
	
	Subrollouts = _Rollout.Subrollouts height:48
	
	_Rollout = Subrollouts.roll ( "Subrollout default width" ) 

	/* CREATE DIALOG */ 
	Dialog.create height:96 lockWidth:false
	--Dialog.create pos:[512, i*128]
)

dialogDefaultWidth()