clearListener()

/** INCLUDE UI 
 */
filein( getFilenamePath(getSourceFileName()) + "/../../../../ContentLoader/ContentLoader.ms" )

/** Load content from file tree
 */
function loadContentTest =
(
	current_dir	= getFilenamePath(getSourceFileName())

	ContentLoader	= ContentLoader_v path:(current_dir+"/content")

	ContentLoader.create  width:512--return 
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
 Dialog = loadContentTest()
-- Dialog = loadContentTest("Nested-Rollouts")


