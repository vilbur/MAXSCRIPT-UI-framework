clearListener(); print("Cleared in: "+getSourceFileName())

/** INCLUDE UI 
 */
filein( getFilenamePath(getSourceFileName()) + "/../../../Lib/ContentLoader/ContentLoader.ms" )




/* LOAD CONTENT */ 
current_dir	= getFilenamePath(getSourceFileName())

ContentLoader	= ContentLoader_v path:(current_dir+"/Nested-Rollouts" )

/* CHANGE DIALOG PROPERTIES */ 
ContentLoader.Dialog.width  = 320
ContentLoader.Dialog.height = 1024


format "ContentLoader.Dialog: %\n" ContentLoader.Dialog

ContentLoader.Dialog.Event #HELP	"https://github.com/vilbur"


/* CREATE DIALOG */ 
ContentLoader.create() --return 

