clearListener(); print("Cleared in:\n"+getSourceFileName())

/* CONTENT LOADER */
filein( getFilenamePath(getSourceFileName()) + "/../../../Lib/ContentLoader/ContentLoader.ms" ) -- "./../../../Lib/ContentLoader/ContentLoader.ms"


/*==============================================================================

	TEST LOAD CONTENT & MODIFY DIALOG CODE

================================================================================*/



/** Load content and create dialog
  
  
   @return Dialog_v
 */
function loadContentAndCreateDialog =
(
	--format "\n"; print ".loadContentAndCreateDialog()"
	current_dir	= getFilenamePath(getSourceFileName())
	
	
	/* LOAD CONTENT FROM FOLDERS */
	ContentLoader	= ContentLoader_v path:(current_dir+"/content") ini:undefined --ini:( getSourceFileName()) --DEBUG:DEBUG
	--ContentLoader	= ContentLoader_v path:(current_dir+"/Groupbox-Test")
	
	ContentLoader.Dialog.title = "ContentLoadAndModify"

	/* CREATE UI */
	--ContentLoader.create() --width:512
	
	ContentLoader.Dialog --return
)

/** Createcontent load and modify dialog
 */
function createContentLoadAndModifyDialog Dialog: =
(
	format "\n"; print ".createContentLoadAndModifyDialog()"
	
	/* DIALOG */
	if Dialog == undefined then 
		Dialog 	    = Dialog_v ("ContentLoadAndModify") ini:(getSourceFileName())
	
	
	/* ROLLOUTS */
	_Rollouts	 = Dialog.Rollouts()
	_Rollout    = _Rollouts.Roll "Subrollout"
	_Controls   = _Rollout.Controls() -- group:"Rollout Controls"
	_Button     = _Controls.control #button "Button defined in code" id:#button_2
	
	

	
)


/*==============================================================================

	RUN TEST

================================================================================*/

/* LAOD CONTENT & CREATE DILAOG */ 
Dialog = loadContentAndCreateDialog()

/* MODIFY DILAOG */ 
createContentLoadAndModifyDialog Dialog:Dialog

/* DIALOG CREATE */
Dialog.create()