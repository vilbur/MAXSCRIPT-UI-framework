clearListener()

filein( "$userscripts\Library\MAXSCRIPT-UI-framework\Lib\Dialog\Dialog.ms" )




/** Dialog default width
 */
function dialogDefaultWidth title ini:undefined width: height: pos: =
(

	/* DIALOG */ 
	Dialog 	= Dialog_v title:title ini:ini
	--Dialog 	= Dialog_v title:"Dialog default width"
	
	_Rollout = Dialog.roll "Rollout"
	
	Subrollouts = _Rollout.Subrollouts height:48
	
	_Rollout = Subrollouts.roll ( "Subrollout" ) 

	SubrolloutsNested = _Rollout.Subrollouts height:48
	
	_Rollout_nested = SubrolloutsNested.roll ( "Subrollout nested" ) 

	/* CREATE DIALOG */ 
	Dialog.create width:width height:height lockWidth:false pos:pos
	--Dialog.create pos:pos
)


dialogDefaultWidth("Dialog default width" ) pos:[0,0]

-- dialogDefaultWidth("Dialog ini file width" )ini:( getSourceFileName()) pos:[0,256]

-- dialogDefaultWidth("Dialog defined dimensions" ) width:512 height:96 pos:[0,512]


