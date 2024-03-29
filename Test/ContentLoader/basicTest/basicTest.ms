clearListener()

/** INCLUDE UI
 */
filein( getFilenamePath(getSourceFileName()) + "/../../../Lib/ContentLoader/ContentLoader.ms" )

/** Load content from file tree
 */
function loadContentTest dir_name =
(
	current_dir	= getFilenamePath(getSourceFileName())

	ContentLoader	= ContentLoader_v path:(current_dir+"/"+dir_name)

	ContentLoader.Dialog.width  = 256
	ContentLoader.Dialog.height = 1024

	(ContentLoader.Dialog.get (#ROLLOUT_test)).title = "Title changed" -- change property of rollout

	ContentLoader.create() --return
)

--/** Add extra rollout
-- */
--function addRolloutByCodeTest name =
--(
--	_rollout = DialogsGlobal.get(name)
--
--	_controls_A = _rollout.controls groupbox:"Groupbox A" -- get new container for controls
--	_controls_B = _rollout.controls groupbox:"Groupbox B" -- get new container for controls
--	_controls_A.button ("button by code")
--	_controls_B.button ("button by code B")
--)


/*---------------------------------------
	RUN TESTR
-----------------------------------------*/

Dialog = loadContentTest("Test-Content")
