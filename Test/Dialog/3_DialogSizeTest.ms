clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../../Lib/Dialog/Dialog.ms" ) -- "./../../Lib/Dialog/Dialog.ms"

/*------------------------------------------------------------------------------
	HELP METHODS
--------------------------------------------------------------------------------*/
/** Create controls
 *
 */
function addControls Dialog count =
(
	_Controls	= Dialog.Controls()

	for i = 1 to count do
		_Controls.control #Button ( "Button_"+ i as string ) across:1
)
/** Add rollouts
 */
function addRollouts _Rollouts title count slot:slot =
(
	_Rollout_new = #()

	for i = 1 to count do
		append _Rollout_new (_Rollouts.new ( title + i as string ))

	_Rollout_new --return
)


/*------------------------------------------------------------------------------

	DEFAULT SIZE - SET BY CONTROLS AND ROLLOUTS IN DIALOG

--------------------------------------------------------------------------------*/
function defaultSizeDialog =
(
	Dialog     = Dialog_v title:"Test default"

	addControls(Dialog) 5

	addRollouts ( Dialog.Rollouts height:256 )("Rollout A")(1)

	Dialog.create()

	--Dialog.register()
)





/*------------------------------------------------------------------------------
	DEFINED SIZE
--------------------------------------------------------------------------------*/
function definedSizesDialog =
(
	Dialog_size     = Dialog_v title:"Defined size"

	Dialog_size.create width:256 height:256 -- given size is minimal size of dialog also

	--Dialog_size.register()
)


/*------------------------------------------------------------------------------

	INI SAVED SIZE

--------------------------------------------------------------------------------*/

function iniSavedSizeUnlockedWidth height: =
(
	Dialog = Dialog_v title:"Ini saved size"  ini:(getSourceFileName())

	Dialog.create

	addControls(Dialog) 5

	Dialog.create width:512 height:height lockWidth:false

	--Dialog.register()
)


/*==============================================================================

	RUN TESTS

	IMPORTANT NOTES:
		Lock width does NOT WORK ON REGISTERED Dialog


================================================================================*/
--defaultSizeDialog()
--definedSizesDialog()

--iniSavedSizeUnlockedWidth height:256
iniSavedSizeUnlockedWidth height:#auto
