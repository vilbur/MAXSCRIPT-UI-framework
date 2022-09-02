clearListener()

filein( "$userscripts\Library\MAXSCRIPT-UI-framework\Lib\Dialog\Dialog.ms" )


y_position = -128

for i = 6 to 12 do 
(
	width = i * 64
	format "width	= % \n" width
	/* DIALOG */ 
	Dialog 	= Dialog_v title:( "Dialog "+width as string ) width:width height:128 
	
	_Rollout = Dialog.roll ( "Rollout" ) 
	
	Subrollouts = _Rollout.Subrollouts height:96
	
	_Rollout = Subrollouts.roll ( "Subrollout" ) 
	
	SubrolloutsNested = _Rollout.Subrollouts height:64
	
	_Rollout_nested = SubrolloutsNested.roll ( "Subrollout nested" ) 

	SubrolloutsNestedSub = _Rollout_nested.Subrollouts height:48
	
	_Rollout_nested_seb = SubrolloutsNestedSub.roll ( "Subrollout nested sub" ) 

	/* CREATE DIALOG */ 
	--Dialog.create()
	Dialog.create pos:[512, y_position += 164 ] lockWidth:false 
)