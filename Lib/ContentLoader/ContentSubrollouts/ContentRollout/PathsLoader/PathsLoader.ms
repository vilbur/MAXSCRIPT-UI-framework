/**  
 *	TODO: Rename this to FilesLoader_v
 *	
 */
struct PathsLoader_v
(
	path,
	
	folder_prefix = "rollout*",
		
	dirs	= #(),
	
	rollout_dirs = #(),

	macro_files	= #(),
	
	maxscript_files	= #(),

	ini_files	= #(),
		
	/** Get full paths of directories and files in this.dir
	  *
	  * @return	array of paths	sorted alphabetically
	 */
	function getSubrolloutsAndControlsPaths =
	(
		--format "\n"; print "PathsLoader_v.getSubrolloutsAndControlsPaths()"
		sort ( join rollout_dirs macro_files ) --return
	),
	
	/** File in files
	 */
	function fileInMaxscriptFiles =
	(
		for file in maxscript_files do
			this._fileIn file
	),

	/** File in
	 */
	function _fileIn file =
	(
		--format "PathsLoader_v.fileIn % \n" file
		filein file
	),


	private
	
	/** _get controls and rollouts
	  *
	  * @return	array	
	 */
	function _isSubrolloutsSlot path =
	(
		matchPattern ( filenameFromPath path ) pattern:folder_prefix ignoreCase:true --return
	),
	
	/** 
	 */
	function _getRolloutDirs =
	(
		for dir in (getDirectories (path + "/*")) where ( this._isSubrolloutsSlot dir ) collect dir --return
	),
	
	/** 
	 */
	function _getDirs =
	(
		for dir in (getDirectories (path + "/*")) where not ( this._isSubrolloutsSlot dir ) collect dir --return
	),
	
	/** Get *.mcr files
	 */
	function _getMacroFiles =
	(
		sort ( getFiles (path + "/*.mcr")) --return
	),
	
	/** Get *.ms files
	 */
	function _getMaxscriptFiles =
	(
		sort ( getFiles (path + "/*.ms")) --return
	),
	
	/** Get *.ini files
	 */
	function _getIniFiles =
	(
		sort ( getFiles (path + "/*.ini")) --return
	),
	
	
	on create do
	(
		--format "PathsLoader_v.onCreate	% \n" path
		dirs            = this._getDirs()
		
		rollout_dirs    = this._getRolloutDirs()

		macro_files     = this._getMacroFiles()

		maxscript_files = this._getMaxscriptFiles()

		ini_files       = this._getIniFiles()
		
		--format "ini_files	= % \n" ini_files
	)
)