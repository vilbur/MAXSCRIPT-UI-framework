clearListener()

filein( "$userscripts\Library\MAXSCRIPT-UI-framework\Lib\Dialog\Dialog.ms" )




for i = 1 to 12 do 
(
	width = i * 64
	format "width	= % \n" width
	/* DIALOG */ 
	Dialog 	= Dialog_v title:( "Dialog "+i as string ) width:width height:96
	
	_Rollout = Dialog.roll ( "Rollout "+width as string ) 
	
	Subrollouts = _Rollout.Subrollouts height:48
	
	_Rollout = Subrollouts.roll ( "Subrollout "+width as string ) 

	/* CREATE DIALOG */ 
	--Dialog.create()
	Dialog.create pos:[512, i*128]
)