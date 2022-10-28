clearListener()

filein( "$userscripts\Library\MAXSCRIPT-UI-framework\Lib\Dialog\Dialog.ms" )

/** Add sub rollouts
 */
function addSubRolloutSlots _Rollout level: =
(

	_Rollouts = _Rollout.Rollouts()
	-- _Rollouts = _Rollout.Rollouts height:1024
	
	for i = 1 to 1 do
	(

		title = " Rollout "+ i as string +" Level: " + level as string

		_SubRollout = _Rollouts.Roll title id:( _Rollout.id as string + title ) --height:512
		_Controls = _SubRollout.controls()

		if level < 2 then
			addSubRolloutSlots _SubRollout level:(level + 1)

		for i = 1 to 5 do 
			 _Controls.control #button ("Button " + i as string ) across:1

	)

)

/* DIALOG */



Dialog 	= Dialog_v title:(getFilenameFile(getSourceFileName())) width:512 height:1024 

Subollout_slots	= addSubRolloutSlots Dialog level:1 

/* CREATE DIALOG */ 
Dialog.create()

--execute ( "rolloutsautoheighttest_Rollout_1_Level_1.height = 256" )
