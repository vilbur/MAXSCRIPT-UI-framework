/** 
 *
 */
struct ContentSubrollouts_v
(
	/* required properties */
	path,
	
	/*  properties */
	slot,
	Rollouts	= #(),
	
	/* dependency */
	RolloutParrent,
	
	/** Add to ui
	 */
	function addToUi _Rollout =
	(
		--format "\n"
		--print ("ContentSubrollouts_v.addToUi() " + (filenameFromPath path) )
		--print ("ContentSubrollouts_v.addToUi " + _Rollout.title )
		local Subrollouts = _Rollout.subrollouts()
		
		for ContentRollout in Rollouts do
			ContentRollout.addToUi Subrollouts
	),
	
	--/** Insert to ui
	-- */
	--function addToUi _Rollout =
	--(
	--	print ( "ContentSubrollouts_v.addToUi()" )
	--
	--	----name	= if( name==undefined )then "" else "";
	--	--
	--	--if( this.isMacrosriptFile() ) then
	--	--(
	--	--	--format " _Rollout	= % \n" _Rollout
	--	--	--format "this._getGroupboxName() = % \n" (this._getGroupboxName())
	--	--	_controls	= _Rollout.Controls.new groupbox:(this._getGroupboxName())
	--	--	--format " _controls = % \n" _controls
	--	--
	--	--	for m = 1 to MacroScripts.count do
	--	--		MacroScripts[m]._addControls _controls
	--	--)
	--	--else
	--	--	this._fileIn()
	--),
		
	
	/** Set slot name
	 */
	function _setSlot =
	(
		slot = filenameFromPath path
		slot = ( dotNetObject "System.Text.RegularExpressions.Regex" @"[^A-Za-z0-9-]" ).Replace slot ""
	),
	
	/** _set rollouts
	 */
	function _setRollouts paths =
	(
		--format "\n"
		--print ("ContentSubrollouts_v._setRollouts()")
		--for path in paths do 
			--format "rollout = % \n" (filenameFromPath path)
			
		for path in paths do 
			append Rollouts ( RolloutParrent.new path )
	),
	
	
	--/** _get sub directories
	-- */
	--function _getSubDirs =
	--(
	--	getDirectories (path + "/*") --return
	--),
	--
	
	on create do
	(
		this._setSlot()
		--format "\n---------------\n"
		--print ("ContentSubrollouts_v.onCreate	" + path )
		
		PathsLoader = PathsLoader_v path:path
		
		PathsLoader.fileInMaxscriptFiles()
		
		
		this._setRollouts( PathsLoader.rollout_dirs )
	)
)