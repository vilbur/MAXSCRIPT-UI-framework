/** File in importer
 */
struct FileInImporter_v
(
	/* construct */
	root, -- absolute path for filein_files E.G.: root_path + filein_files[i] == "C:\Foo\Bar\" + "some_file.ms"
	
	/* required */
	files = #(), -- ABSOLUTE OR RELATIVE paths to imported files
	

	/* properties */
	blacklist = "",

	/* private */
	/* dependency */
	/* reference */
	/* inhered */

	/** Import
	 */
	function import =
	(
		--format "\n"; print "FileInImporter_v.import()"
		
		this._removeLeadingSlashFromPaths()
		this._convertRelativeToAbsolutePaths()
		this._normalizePaths()
		
		this._fileInFiles()
		
	),

	private

	/** File in files
	 */
	function _fileInFiles =
	(
		format "\n"; print "FileInImporter_v._fileInFiles()"
		for file_path in files where not matchPattern file_path pattern:blacklist do
		(
			format "FILE IN: % \n" (file_path)

			if doesFileExist file_path then
				try(
					filein( file_path)
				)catch
				(
					format "\n——————————————— ERROR IN FILE ———————————————\n\n%\n" (getSourceFileName())
					format "\n————————————————— EXCEPTION —————————————————\n\n%\n" (getCurrentException())
					format "\n——————————————————— TRACE ———————————————————\n%\n"   (getCurrentExceptionStackTrace())
					format "\n——————————————————— STACK ———————————————————\n%\n" 	(getCurrentExceptionCallStack())
				)
		)
	),
	
	/** Remove leading slash
	 */
	function _removeLeadingSlashFromPaths =
	(
		--format "\n"; print "StdScriptImporter_v._removeLeadingSlashFromPaths()"
		for i = 1 to files.count where matchPattern files[i] pattern:("\\*") or matchPattern files[i] pattern:("/*") do
			files[i]	= substring files[i] 2 -1
	),
	
	/** Convert relative to absolute paths
	 */
	function _convertRelativeToAbsolutePaths =
	(
		--format "\n"; print "StdScriptImporter_v._convertRelativeToAbsolutePaths()"
		for i = 1 to files.count where not pathConfig.isAbsolutePath files[i] do
			files[i] = root + "/" + files[i]
	),
	
	/** Normalize paths
	 */
	function _normalizePaths =
	(
		--format "\n"; print "StdScriptImporter_v._normalizePaths()"
		files = makeUniqueArray (for file in files collect pathConfig.convertPathToLowerCase ( pathConfig.normalizePath file ))
	),
	
	/**
	 */
	on create do
	(
		--format "\n"; print "FileInImporter.onCreate()"
		--for prop in #(  ) where getProperty this prop == undefined do -- CHECK CONSTRUCT PROPERTIES -- Array of this struct properties necessary to run
		--	throw ("\n\n\nUNDEFINED CONSTRUCT PROPERTY\n\n\nSTRUCT:\n\n"+ ((filterString( classof this as string )"(:")[2]) +"\n\n\nPROPERTY:\n\n"+ prop )
	)

)
