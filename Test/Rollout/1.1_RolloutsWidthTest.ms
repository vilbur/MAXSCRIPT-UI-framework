clearListener()

filein( "$userscripts\Library\MAXSCRIPT-UI-framework\Lib\Dialog\Dialog.ms" )




/** Dialog default width
 */
function dialogDefaultWidth title ini:undefined pos: =
(

	/* DIALOG */ 
	Dialog 	= Dialog_v title:title ini:ini
	--Dialog 	= Dialog_v title:"Dialog default width"
	
	_Rollout = Dialog.roll "Rollout"
	
	Subrollouts = _Rollout.Subrollouts height:48
	
	_Rollout = Subrollouts.roll ( "Subrollout" ) 

	/* CREATE DIALOG */ 
	Dialog.create height:96 lockWidth:false pos:pos
	--Dialog.create pos:pos
)


dialogDefaultWidth("Dialog default width" ) pos:[0,0]

dialogDefaultWidth("Dialog ini file width" )ini:( getSourceFileName()) pos:[0,256]

