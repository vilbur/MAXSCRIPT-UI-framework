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
		local Subrollouts = _Rollout.subrollouts slot:slot ini_file:ini_file

		this._setSlotPropertiesFromIniFile(Subrollouts)
		
		for ContentRollout in Rollouts do
			ContentRollout.addToUi Subrollouts
	),

	private
	
	/** Set slot name by name of folder without prefix: "rollouts-"
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
	function _createRollouts paths ini_file =
	(
		format "\n"; print ("ContentSubrollouts_v._createRollouts()")
		format "paths	= % \n" paths
		format "ini_file	= % \n" ini_file
		
		for path in paths do 
			append Rollouts ( RolloutParrent.createNewRollout (path)(ini_file) )
	),
	
	/** Set props for Subrollouts slot from ini file
	 */
	function _setSlotPropertiesFromIniFile &Subrollouts =
	(
		--format "\n"; print "ContentSubrollouts_v._setSlotPropertiesFromIniFile()"
		if ini_file != undefined and (SLOT_PROPS_EXISTS = hasINISetting ini_file ( SECTION = slot as string )) then
		(
			for key in (getINISetting ini_file section) do
			(
				prop_name = key as name
				
				val_ini = getINISetting ini_file section key
				
				val = if val_ini as number != undefined then val_ini as number else val_ini
				
				if hasProperty Subrollouts prop_name  then 
					setProperty Subrollouts prop_name val
				else
					format "-----------------\n\nERROR: Set property with ini file %\n\nSubrollout has not property: %\n\n-----------------" ini_file prop_name
			)
		)
		
		Subrollouts --return
	),
	
	on create do
	(
		--print ("ContentSubrollouts_v.onCreate	" + path )

		PathsLoader = PathsLoader_v path:path

		PathsLoader.fileInMaxscriptFiles()
		
		this._setSlot()

		this._createRollouts( PathsLoader.rollout_dirs ) (PathsLoader.ini_files[1])
	)
)