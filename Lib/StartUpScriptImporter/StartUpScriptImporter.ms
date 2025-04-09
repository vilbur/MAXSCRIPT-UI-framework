 /** Import structures used in macroscripts on 3Ds Max startup.
  * 
  * USECASE: If script is used in quad menu, then imported scripts are independent on UI
  * 
  * Create .ms file in "#maxroot+ "/stdplugs/stdscripts/"
  * 
  * STD scripts are evaluated first, before 3Ds Max macrosctips
  *		 3Ds Max is importing files in order
  *		 	1) Std scripts
  *		 	2) Macroscripts
  *		 	3) Startup scripts
  *
 */
struct StartUpScriptImporter_v
(
	/* construct */
	root, -- absolute path for filein_files E.G.: root_path + filein_files[i] == "C:\Foo\Bar\" + "some_file.ms"
	
	/* required */
	files = #(), -- ABSOLUTE OR RELATIVE paths to imported files
	
	/* properties */
	filename, -- filename of std script in "#maxroot/stdplugs/stdscripts/viltools-startup.ms"
	
	/* private */
	/* dependency */
	/* reference */
	/* inhered */

	/** Create Start Up File and import this file
	 */
	function createStartUpFile files std:false =
	(
		--format "\n"; print "StartUpScriptImporter_v.createStartUpFile()"
		this.files = files

		this._setFileName()
		this._setRootPath()

		std_file_path = this._getStdFilePath(std)
		
		
		this._removeLeadingSlashFromPaths()
		this._convertRelativeToAbsolutePaths()
		this._normalizePaths()
		
		this._writeToFile(std_file_path)
		
		filein (std_file_path)
	),
	
	/** Delete file
	 */
	function delete std:false =
	(
		--format "\n"; print "StartUpScriptImporter_v.deleteFile()"
		deleteFile (this._getStdFilePath(std))
	),

	private
	
	/** Write to file
	 */
	function _writeToFile std_file_path =
	(
		--format "\n"; print "StartUpScriptImporter_v._writeToFile()"
		std_file = createFile std_file_path
		
		content      = ""
		files_string = ""
		
		for file_path in files do
			files_string += "\n\t@\"" + file_path + "\","
		
		files_string	= trimRight files_string  ","
		
		--content += "format \"\\n\"; print \"FileInImporter_v._fileInFil	es()\""
		--content += "format \"\\nFiles imported from file: %\\n\\n\" \""+std_file_path+"\""

		content += "file_in_files = #("+files_string+"\n)\n\n"
		
		content += "for file_path in file_in_files do\n"
		content += "if doesFileExist file_path then\n("
		content += "		filein file_path\n"
		content += "		format \"FILE IN: %\\n\" file_path"
		content += ")\nelse\n"
		content += "		format \"\\n\\n----- WARNING: Missing file in: %\\n\\nERROR OF IMPORT FILE: %\\n\" (getSourceFileName()) file_path"
		
		try(
			format "%" content to:std_file
			
			close std_file
		)
		catch
			close std_file
		
	),
	
	/** Get file path to startup file
	  * 
	  * SUBDIRS:
	  * 	std == true  >>> "C:\Program Files\Autodesk\3ds Max 2023\stdplugs\stdscripts\"
	  * 	std == false >>> "C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\startup"
	  *
	 */
	function _getStdFilePath std =
	(
		subdir = if std then getDir #MAXROOT + "/stdplugs/stdscripts/" else getDir #userStartupScripts + "/"

		pathConfig.normalizePath ( subdir + filename + ".ms" ) --return
	),
	
	/** Remove leading slash
	 */
	function _removeLeadingSlashFromPaths =
	(
		--format "\n"; print "StartUpScriptImporter_v._removeLeadingSlashFromPaths()"
		for i = 1 to files.count where matchPattern files[i] pattern:("\\*") or matchPattern files[i] pattern:("/*") do
			files[i]	= substring files[i] 2 -1
	),
	
	/** Convert relative to absolute paths
	 */
	function _convertRelativeToAbsolutePaths =
	(
		--format "\n"; print "StartUpScriptImporter_v._convertRelativeToAbsolutePaths()"
		for i = 1 to files.count where not pathConfig.isAbsolutePath files[i] do
			files[i] = root + "/" + files[i]
	),
	
	/** Set file name
	 */
	function _setFileName =
	(
		--format "\n"; print "StartUpScriptImporter_v._setFileName()"
		--if root != undefined and filename == undefined and this._isPathToFile(root) then
		if root != undefined and filename == undefined then
			filename = getFilenameFile(root)
	),

	/** Set root path
	  * 
	  * Get path to directory if root is path to file
	 */
	function _setRootPath =
	(
		--format "\n"; print "StartUpScriptImporter_v._setRootPath()"
		
		if root != undefined and this._isPathToFile(root) then
			root	= getFilenamePath(root)
	),
	
	/** Is path to file
	 */
	function _isPathToFile _path =
	(
		not doesDirectoryExist _path
	),
	
	/** Normalize paths
	 */
	function _normalizePaths =
	(
		--format "\n"; print "StartUpScriptImporter_v._normalizePaths()"
		files = makeUniqueArray (for file in files collect pathConfig.convertPathToLowerCase ( pathConfig.normalizePath file ))
	),

	/**
	 */
	on create do
	(
		--format "\n"; print "StartUpScriptImporter.onCreate()"
		--for prop in #(  ) where getProperty this prop == undefined do -- CHECK CONSTRUCT PROPERTIES -- Array of this struct properties necessary to run
		--	throw ("\n\n\nUNDEFINED CONSTRUCT PROPERTY\n\n\nSTRUCT:\n\n"+ ((filterString( classof this as string )"(:")[2]) +"\n\n\nPROPERTY:\n\n"+ prop )
	
		--format "pathConfig.removePathLeaf (getSourceFileName()): %\n" (pathConfig.removePathLeaf (getSourceFileName()))
		--format "getThisScriptFilename(): %\n" (getThisScriptFilename())
		--format "getSourceFileName():     %\n" (getSourceFileName())
		--format "root: %\n" root
		
	)

)
