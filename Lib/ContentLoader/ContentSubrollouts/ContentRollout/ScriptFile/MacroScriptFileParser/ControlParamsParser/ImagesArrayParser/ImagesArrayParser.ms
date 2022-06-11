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
	 */
	function getIconPath images =
	(
		--format "\n"; print "ControlParamsParser_v._getIconPath()"
		--format "path	= % \n" path
		
		icon_path = images[1]
		
		if matchPattern icon_path pattern:"$*" then 
			images[1] = this.replaceSystemDir(icon_path)
			
		else if matchPattern icon_path pattern:"/*" then 
			images[1] = getFilenamePath(path) +"/"+ icon_path --return
		
		images --return
	),
	
	/** Replace system dir
	 */
	function replaceSystemDir icon_path =
	(
		--format "\n"; print "ImagesArrayParser_v.replaceSystemDir()"
		--format "icon_path	= % \n" icon_path
		
		string_split	= filterString icon_path "/"
		
		system_dir = string_split[1]
					
		system_dir_pah = getDir (( substring string_split[1] 2 -1 ) as name ) + "/"
		
		icon_path = substituteString icon_path system_dir system_dir_pah
		
		icon_path --return
	),
	
	/**  
	 */
	on create do
	(
	)
)
