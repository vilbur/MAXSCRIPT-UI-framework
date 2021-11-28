/**  
 *	
 *	
 */
struct FileInImporter_v
(
	dirs,
	
	
	/** Loop dirs and file in *.ms files
	  *
	  *
	  */
	function fileInSubdirs dirs =
	(
		--format "FileI/*n*/Importer_v.fileInSubdirs() % \n" dirs
		for dir in dirs do
		(
			--format "@@@ dir = % \n" dir
			(FileInImporter_v()).fileInSubdirs (getDirectories (dir + "/*"))
			
			this.fileInFiles (getFiles (dir + "/*.ms"))
		)
	),
	
	/** File in files
	 */
	function fileInFiles maxscript_files =
	(
		--format "maxscript_files = % \n" maxscript_files
		for file in maxscript_files do
			this.fileIn file

	),
	
	/** File in
	 */
	function fileIn file =
	(
		--format "	FileInImporter_v.fileIn qs% \n" file
		filein file
	),
	
	
	on create do
	(

	)
)