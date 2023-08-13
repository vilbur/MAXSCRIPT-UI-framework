clearListener(); print("Cleared in:"+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../../Lib/Dialog/Dialog.ms" ) -- "./../../Lib/Dialog/Dialog.ms"

/*------------------------------------------------------------------------------
	HELP METHODS
--------------------------------------------------------------------------------*/
/** Create controls
 *
 */
function addControls _Rollout count prefix:"Button" =
(
	_Controls	= _Rollout.Controls()

	for i = 1 to count do
		_Controls.control #Button ( prefix + " Control:"+ i as string ) across:1
)
/** Add rollouts
 */
function addRollouts SubRollouts title count slot:slot =
(
	--print "addRollouts()"
	--format "SubRollouts:	% \n" SubRollouts
	_Rollout_new = #()

	for i = 1 to count do
		append _Rollout_new ( SubRollouts.Roll ( title + " Roll:"+ i as string ))
		--format "TITLE:	% \n"  ( title + " Rollout:"+ i as string )

	--format "SubRollouts:	% \n" SubRollouts
	_Rollout_new --return
)



/*------------------------------------------------------------------------------

	CREASTE DIALOG WITH VARIOUS PARAMETERS OF SIZE

--------------------------------------------------------------------------------*/
function createTestDialog slots:0 nested:0 rollouts:0 controls:0 controls_dialog:#() subrollouts_height: dialog_width:256 dialog_height: min_size:undefined ini: reset_ini:false lockWidth:true lockHeight:false =
(

	Dialog     = Dialog_v title:"Height Test" ini:(if ini != unsupplied or reset_ini then getSourceFileName() else undefined )

	if reset_ini then
		Dialog.Ini.deleteIni()

	/* DIALOG TOP CONTROLS */
	if controls_dialog.count > 0 then
		addControls(Dialog) (controls_dialog[1]) prefix:"Top"

	for s = 1 to slots do
	(
		--Rollouts_New = addRollouts ( Dialog.Rollouts height:subrollouts_height )("Slot:"+ s as string )(rollouts)
		if rollouts > 0 then
		(
			Rollouts_New = addRollouts ( Dialog.Rollouts() )("Slot:"+ s as string )(rollouts)

			if controls > 0 then
				for r = 1 to Rollouts_New.count do
					addControls(Rollouts_New[r]) (controls) prefix:("Slot:"+ s as string +" Roll:"+ r as string )
		)
	)

	/* DIALOG DOWN CONTROLS */
	if controls_dialog.count > 0 then
		addControls(Dialog) (controls_dialog[2]) prefix:"Down"


	Dialog.create width:dialog_width height:dialog_height min_size:min_size lockWidth:lockWidth lockHeight:lockHeight

	Dialog.register()
)




/*==============================================================================

	RUN TESTS

	IMPORTANT NOTES:
		Lock width does NOT WORK ON REGISTERED Dialog


================================================================================*/


/* CLEAN */
--createTestDialog()


/* ONLY CONTROLS */
--createTestDialog controls_dialog:#(1,2)

/* ONLY ROLLOUTS */
--createTestDialog slots:1 rollouts:1
--createTestDialog slots:2 rollouts:2

/* SLOTS AND CONTROLS */
--createTestDialog slots:1 rollouts:1 controls:10
--createTestDialog slots:2 rollouts:2 controls:10
--createTestDialog slots:1 rollouts:2 controls:5 controls_dialog:#(1,2)



/* DEFINED HEIGHT */
--createTestDialog slots: 2 rollouts:2 controls:5 controls_dialog:#(1,2) dialog_height:1024


/* HEIGHT SAVED IN INI */
--createTestDialog slots: 2 rollouts:2 controls:5 controls_dialog:#(1,2) ini:true

/* HEIGHT SAVED IN INI BUT INIT HEIGHT SET */
--createTestDialog reset_ini:true -- reset ini
--createTestDialog slots: 2 rollouts:2 controls:5 controls_dialog:#(1,2) ini:true dialog_height:512 -- height of dialog for first run


/* INI IS USED BUT SIZE IS NOT SAVED */
--createTestDialog reset_ini:true -- reset ini
createTestDialog slots: 2 rollouts:2 controls:5 controls_dialog:#(1,2) ini:true dialog_height:#auto


/* MINIMAL SIZE OF DIALOG */
--createTestDialog  slots:1 rollouts:1 controls:10 ini:true min_size:[256,256]


/* UNLOCK WIDTH, LOCK HEIGHT */
--createTestDialog  slots:1 rollouts:1 controls:10 ini:true lockWidth:false lockHeight:true