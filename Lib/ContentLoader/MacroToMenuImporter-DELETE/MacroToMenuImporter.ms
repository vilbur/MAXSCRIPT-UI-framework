/** Macro to menu importer
  * 
  * 1) Parse *.mcr files in dir and subdirectories
  * 2) Create menus
  * 3) Add macros as items to menus
  * 
  * 
  * 		IMPORTANT: Macroscipt ust has parameter icon:"menu:true"
  * 
  * 
  * NOTES:
  * 	Same process as ContentLoader_v does, but without creating ui
  * 
 */
struct MacroToMenuImporter_v
(
	/* construct */
	dir,

	/* required */
	

	/* properties */
	blacklist = #(), 

	/* private */
	/* dependency */
	/* reference */
	/* inhered */

	debug = true,
	--debug = false,

	private
	
	
	--global debug = true
	--global debug = false
	
	/** Import
	 */
	function _import =
	(
		all_macro_files = getFiles ( dir + "/*.mcr" ) recurse:true  -- "./../../slot_properties.ini"

		--format "\n"; print "MacroToMenuImporter_v._import()"
		for macro_path in all_macro_files where this._isNotOnBlacklist macro_path do
		(
			if debug then
				format "filein: % \n" macro_path
		
			try(
				
				(ScriptFile_Content_v(macro_path)).importMacroscriptsToMenus()
				
			)catch(
		
				format "!!!!! FILEIN *.mcr file ERROR\n\n%\n\n" (getCurrentException())
			)
		)
	),

	/** Is not on blacklist
	 */
	function _isNotOnBlacklist macro_path =
	(
		--format "\n"; print ".isNotOnBlacklist()"
		--format "macro_path = % \n" macro_path
	

	
		allow_inport = true
	
		for pattern in blacklist where matchPattern macro_path pattern:pattern do
		(
			if debug then
				format "\nBLACKLISTED: %\n\n" macro_path
	
			allow_inport = false
	
			return false
		 )
	
		allow_inport --return
	),

	/**
	 */
	on create do
	(
		--format "\n"; print "MacroToMenuImporter.onCreate()"
		this._import()
		--for prop in #(  ) where getProperty this prop == undefined do -- CHECK CONSTRUCT PROPERTIES -- Array of this struct properties necessary to run
		--	throw ("\n\n\nUNDEFINED CONSTRUCT PROPERTY\n\n\nSTRUCT:\n\n"+ ((filterString( classof this as string )"(:")[2]) +"\n\n\nPROPERTY:\n\n"+ prop )
	)

)
