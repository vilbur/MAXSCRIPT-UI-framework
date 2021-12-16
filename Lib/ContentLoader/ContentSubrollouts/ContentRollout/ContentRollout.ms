filein( getFilenamePath(getSourceFileName()) + "/PathsLoader/PathsLoader.ms" )
filein( getFilenamePath(getSourceFileName()) + "/ScriptFile/ScriptFile.ms" )
filein( getFilenamePath(getSourceFileName()) + "/../ContentSubrollouts.ms" )

/** Create rollout from dir containing ".ms" & ".mcr" files
 * 
 * @property	string	dir	Path to dir
 * @property	string	title	Name of rollout
 *
 */
struct ContentRollout_v
(
	__construct = #( #path ),

	/* construct */
	path,
	
	/*  properties */
	title,
	
	Subrollouts_and_Controls = #(), -- store groupboxes and rollouts

	PathsLoader,
	
	/** Create and add Rollouts and Controls to UI
	 */
	function addToUi Subrollouts =
	(
		--print ( "ContentRollout_v.addToUi Subrollouts:" + Subrollouts.slot as string  )
		--format "Subrollouts	= % \n" Subrollouts
		Rollout_new	= Subrollouts.new title -- get new rollout
		
		for Subrollouts_or_Controls in Subrollouts_and_Controls do
		--format "Subrollouts_or_Controls = % \n" Subrollouts_or_Controls
			Subrollouts_or_Controls.addToUi Rollout_new
	),
	
	/** Get new instance of This
	 */
	function new path =
	(
		ContentRollout_v path:path --return
	),
	
	private

		/** _get controls and rollouts
	 */
	function _initLoadContentFromDir =
	(
		--print ("ContentRollout_v._initLoadContentFromDir() " + title)
		
		for path in (PathsLoader.getSubrolloutsAndControlsPaths()) do
			append Subrollouts_and_Controls	(this._addSubrolloutOrControlBox path)
	),
	
	/** _add subrollout or control box
	 */
	function _addSubrolloutOrControlBox path =
	(
		if (this._isDir path) then
			this._createSubrollouts path
		else
			this._getFileContent path
	),
	
	/** _is dir
	 */
	function _isDir path =
	(
		getFilenameType path == "" --return
	),
	
	/** _if path is dir
	 */
	function _createSubrollouts path =
	(
		--if( this._isSubrolloutsSlot path == true  ) then
			ContentSubrollouts_v path:path RolloutParrent:this     -- return
	),
	
	/** If path is file
	 */
	function _getFileContent path =
	(
		filein path
		
		ScriptFile_Content_v path:path	-- return
	),
	
	/** Set rollout title by folder title E.g.: "Rollout-1" >> "Rollout 1"
	 */
	function _setName =
	(
		title = filenameFromPath path
	),

	/** 1) Remove invalid characters, valid characters: "A-Za-z0-9-_"
	  * 2) Replace underscore "_" with whitespace " " E.G.: This_is_test" >>> "This is test"
	 */
	function _sanitizeName =
	(
		title = ( dotNetObject "System.Text.RegularExpressions.Regex" "^rollout-"    ).Replace title ""
		title = ( dotNetObject "System.Text.RegularExpressions.Regex" "[^A-Za-z0-9]" ).Replace title ""
	),
	
	on create do
	(
		ConstructPropeties test:this

		this._setName()
		this._sanitizeName()
		
		PathsLoader = PathsLoader_v path:path
		
		PathsLoader.fileInMaxscriptFiles()
		
		this._initLoadContentFromDir()
	)
)