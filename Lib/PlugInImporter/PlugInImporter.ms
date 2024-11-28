/** Copy source file to  (getDir #maxroot) + "\\stdplugs\\stdscripts"
  
  
  HWO TO USE:
  
	(PlugInImporter_v "C:\Foo\BarPlugin.ms").install()
  
  
 */
struct PlugInImporter_v
(
	/* construct */
	source,	

	/* required */
	

	/* properties */
	max_plugins_dir = (getDir #maxroot) + "\\stdplugs\\stdscripts",

	/* private */
	/* dependency */
	/* reference */
	/* inhered */

	/** Install
	 */
	function install =
	(
		--format "\n"; print "PlugInImpoerter_v.install()"
		filename = filenameFromPath( source )
		
		max_plugins_path = max_plugins_dir + "\\" + filename
		
		if doesFileExist source then
		(
			deleteFile max_plugins_path
		
			copyFile (source) (max_plugins_path)
		
			filein source
		)
		else
			format "\n\n----- WARNING PlugInImporter_v -----\n\n: Missing plugin file: %\n" source

	),

	private


	/**
	 */
	on create do
	(
		--format "\n"; print "PlugInImpoerter.onCreate()"
		--for prop in #(  ) where getProperty this prop == undefined do -- CHECK CONSTRUCT PROPERTIES -- Array of this struct properties necessary to run
		--	throw ("\n\n\nUNDEFINED CONSTRUCT PROPERTY\n\n\nSTRUCT:\n\n"+ ((filterString( classof this as string )"(:")[2]) +"\n\n\nPROPERTY:\n\n"+ prop )
	)

)
