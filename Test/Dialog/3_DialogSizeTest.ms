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

	CREASTE DIALOG WIDTH VARIOUS PARAMETERS OF SIZE

--------------------------------------------------------------------------------*/
function createTestDialog slots:0 nested:0 rollouts:0 controls:0 controls_dialog:#() subrollouts_height: construct_width:  width: height: min_size:undefined ini: reset_ini:false lockWidth:false lockHeight:false =
(
	if classOf controls_dialog != Array then
		controls_dialog = #(controls_dialog, 0)

	Dialog     = Dialog_v title:"Height Test" ini:(if ini != unsupplied or reset_ini then getSourceFileName() else undefined ) width:construct_width min_size:min_size

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


	Dialog.create width:width height:height lockWidth:lockWidth lockHeight:lockHeight

	Dialog.register()
)




/*==============================================================================

	RUN TESTS

	----- IMPORTANT NOTES -----

	1) Lock width does NOT WORK ON REGISTERED Dialog


================================================================================*/

/*------------------------------------------------------------------------------
	UNDEFINED SIZE
--------------------------------------------------------------------------------*/

/* DEFAULT */
-- createTestDialog()


/* SLOTS AND CONTROLS */
createTestDialog controls_dialog:10

--createTestDialog slots:1 rollouts:1 controls:10
--createTestDialog slots:2 rollouts:2 controls:10
-- createTestDialog slots:2 rollouts:1 controls:20
 --createTestDialog slots:2 rollouts:2 controls:10 controls_dialog:#(1,2)
-- createTestDialog slots:2 rollouts:2 controls:0 controls_dialog:#(1,1)


/*------------------------------------------------------------------------------
	DEFINED CONSTRUCT SIZE
--------------------------------------------------------------------------------*/


/* WIDTH CONSTRUCT - also minimal size  */
--createTestDialog  controls_dialog:5	construct_width:256


/* WIDTH CONSTRUCT & MIN SIZE */
--createTestDialog  controls_dialog:5	construct_width:256	min_size:[128,128]


/* ONLY CONTROLS */
--createTestDialog controls_dialog:#(1,2)


/* ONLY ROLLOUTS */
--createTestDialog slots:1 rollouts:1
--createTestDialog slots:2 rollouts:2


/*------------------------------------------------------------------------------
	INI SAVED SIZE
--------------------------------------------------------------------------------*/

--createTestDialog reset_ini:true -- RESET INI


/* SIZE BY INI */
--createTestDialog  controls_dialog:5 ini:true


/* WIDTH CONSTRUCT, HEIGHT AUTO ON FIRST TIME RUN & INI  */
--createTestDialog  controls_dialog:15	construct_width:256 ini:true


/* WIDTH CONSTRUCT, INI DEFINED, BUT IT IS OVERRIDED BY PARAM */
--createTestDialog  controls_dialog:5	construct_width:256 ini:true width:1024 height:512


/* WIDTH CONSTRUCT, INI DEFINED, BUT HEIGHT IS AUTO */
--createTestDialog  controls_dialog:15	ini:true height:undefined


/*------------------------------------------------------------------------------
	LOCKED SIZE
--------------------------------------------------------------------------------*/


/* LOCKED SIZE */
--createTestDialog  slots:1 rollouts:1 controls:10 ini:true lockWidth:true lockHeight:true
