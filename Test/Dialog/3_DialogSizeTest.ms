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

	INI SAVED SIZE

--------------------------------------------------------------------------------*/

function iniSavedSizeUnlockedWidth init_height: reset_ini:false =
(
	Dialog = Dialog_v title:"Ini saved size"  ini:(getSourceFileName())

	if reset_ini then
		Dialog.Ini.deleteIni()

	Dialog.create

	addControls(Dialog) 10

	Dialog.create width:512 height:init_height lockWidth:false

	--Dialog.register()
)



function createTestDialog slots:0 nested:0 rollouts:0 controls:0 controls_dialog:#() subrollouts_height: dialog_width:256 dialog_height: init_height: reset_ini:false =
(

	Dialog     = Dialog_v title:"Height Test"

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


	Dialog.create width:dialog_width

	--Dialog.register()
)




/*==============================================================================

	RUN TESTS

	IMPORTANT NOTES:
		Lock width does NOT WORK ON REGISTERED Dialog


================================================================================*/


/* DIALOG CLEAN */
--createTestDialog()


/* DIALOG ONLY CONTROLS */
createTestDialog controls_dialog:#(1,2)

/* DIALOG ONLY ROLLOUTS */
--createTestDialog slots:1 rollouts:1
--createTestDialog slots:2 rollouts:2

/* DIALOG ONLY ROLLOUTS */
--createTestDialog slots:1 rollouts:1 controls:10
--createTestDialog slots:2 rollouts:2 controls:10
createTestDialog slots:1 rollouts:1 controls:5 controls_dialog:#(1,2)


--defaultSizeNoRollouts controls_count:10

--dialogWithRollouts slots_count:3 controls_count:5
--dialogWithRollouts subrollouts_height:256

--definedSizesDialog controls_count:10 width:256 height:1024


--iniSavedSizeUnlockedWidth init_height:256 reset_ini:true
--iniSavedSizeUnlockedWidth init_height:#auto
