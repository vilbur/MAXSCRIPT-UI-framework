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
	ini_file, -- path to ini file in Subrollouts folder
	
	/* dependency */
	RolloutParrent,

	/** Add to ui
	 */
	function addToUi _Rollout =
	(
		--print ("ContentSubrollouts_v.addToUi() " + (filenameFromPath path) )
		--format "ini_file	= % \n" ini_file
		local Subrollouts = _Rollout.subrollouts slot:slot

		--this._setPropsFromIniFile(Subrollouts)
		
		for ContentRollout in Rollouts do
			ContentRollout.addToUi Subrollouts
	),

	private
	
	/** Set slot name
	 */
	function _setSlot =
	(
		--format "\n"; print ("ContentSubrollouts_v._setSlot()")
		slot = filenameFromPath path

		slot = trimLeft slot  "rollouts-"

		slot = ( dotNetObject "System.Text.RegularExpressions.Regex" @"[^A-Za-z0-9_]" ).Replace slot ""
	),

	/** _set rollouts
	 */
	function _setRollouts paths =
	(
		for path in paths do 
			append Rollouts ( RolloutParrent.new path )
			
	),
	
	/** Get props from ini file
	 */
	function _setPropsFromIniFile &Subrollouts =
	(
		--format "\n"; print "ContentSubrollouts_v._getPropsFromIniFile()"
		if ini_file != undefined then
		(
			section = (getINISetting ini_file)[1]
			
			for key in (getINISetting ini_file section) do
			(
				val_ini = getINISetting ini_file section key
				
				val = if val_ini as number != undefined then val_ini as number else val_ini
				
				setProperty Subrollouts ( key as name ) val 
			)
		)
		
		Subrollouts --return
	),
	
	on create do
	(
		--print ("ContentSubrollouts_v.onCreate	" + path )
		this._setSlot()

		PathsLoader = PathsLoader_v path:path

		PathsLoader.fileInMaxscriptFiles()

		ini_file = PathsLoader.ini_files[1]
		
		this._setRollouts( PathsLoader.rollout_dirs )
	)
)