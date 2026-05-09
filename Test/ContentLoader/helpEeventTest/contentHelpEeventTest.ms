clearListener(); print("Cleared in: "+getSourceFileName())

/** INCLUDE UI 
 */
filein( getFilenamePath(getSourceFileName()) + "/../../../Lib/ContentLoader/ContentLoader.ms" )


/*
	1) DIALOG HAS LOCAL VARIABLE:
	
		Dialog.help_urls = Dictionary #( #DIALOG, "https://github.com/username" ) #( #ROLLOUT, "" )


	2) SET VARIABLE ON EVENT ROLLOUT ROLLUP OPEN:
		
		Dialog.help_urls[#ROLLOUT] = "/relative/path/to/subrollout/content"

		
	3) OPEN URL ON HELP EVENT:
		
		shellLaunch ( Dialog.help_urls[#ROLLOUT] + Dialog.help_urls[#ROLLOUT] ) ""

*/ 



/* LOAD CONTENT */ 
current_dir	= getFilenamePath(getSourceFileName())

ContentLoader	= ContentLoader_v path:(current_dir+"/Nested-Rollouts" )  DEBUG:true


/* CHANGE DIALOG PROPERTIES */ 
ContentLoader.Dialog.width  = 320
ContentLoader.Dialog.height = 1024


--format "ContentLoader.Dialog: %\n" ContentLoader.Dialog

ContentLoader.Dialog.Event #HELP	"https://github.com/vilbur"

--format "XXXXXXXXXXXXXXXXXXXXXXXX: %\n" (DIALOG_nested_rollouts.ParentsAslot.ROLLOUT_rolla.ROLLOUT_VARIABLE)
--format "XXXXXXXXXXXXXXXXXXXXXXXX: %\n" (DIALOG_nested_rollouts.ROLLOUT_VARIABLE)


/* CREATE DIALOG */ 
ContentLoader.create() --return 
