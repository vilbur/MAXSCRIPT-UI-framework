/** ImagesArrayParser
 */
struct ImagesArrayParser_v
(
	/* properties */
	path, -- path to "*.mcr" file
	

	/** Get icon path
	  * 
	  * 1) Relative path to "*.mcr" file
	  * 2) $userScripts
	  * 3) Absolute path
	  * 
	  * 
	 */
	function getIconPath images =
	(
		format "\n"; print "ControlParamsParser_v._getIconPath()"
		format "path	= % \n" path
		
		images[1] = this.replaceSystemDir(images[1])

		--format "icon_path	= % \n" images[1]
		
		--GetDir 
		
		--images[1] = "C:/GoogleDrive/Programs/CG/3DsMax/scripts/Library/MAXSCRIPT-UI-framework/Lib/ContentLoader/ContentSubrollouts/ContentRollout/ScriptFile/_Test/Test-files/icons_sprite.bmp"
		--images[1] = "$userScripts/Library/MAXSCRIPT-UI-framework/Lib/icons_sprite.bmp"
		
		images --return
	),
	
	/** Replace system dir
	 */
	function replaceSystemDir icon_path =
	(
		format "\n"; print "ImagesArrayParser_v.replaceSystemDir()"
		format "icon_path	= % \n" icon_path
		
		
		if matchPattern icon_path pattern:"$*" then 
		(
			string_split	= filterString icon_path "/"
			
			system_dir = string_split[1]
			 			
			system_dir_pah = getDir (( substring string_split[1] 2 -1 ) as name ) + "/"
			
			format "system_dir	= % \n" system_dir
			format "system_dir_pah	= % \n" system_dir_pah
			
			icon_path = substituteString icon_path system_dir system_dir_pah
			--icon_path = substituteString icon_path "$userScripts" "sHIT"
			
			--format "icon_path	= % \n" icon_path
			
			icon_path --return
		)
		else
		(
			
			result = getFilenamePath(path) +"/"+ icon_path --return
			format "result	= % \n" result
			result --return
		)
		
	),
	
	
	/**  
	 */
	on create do
	(
	)
	
)
