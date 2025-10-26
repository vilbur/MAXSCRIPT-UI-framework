

filein( getFilenamePath(getSourceFileName()) + "/McrFileWriter/McrFileWriter.ms" )	--"./McrFileWriter/McrFileWriter.ms"
filein( getFilenamePath(getSourceFileName()) + "/MacroData/MacroData.ms" )	--"./MacroData/MacroData.ms"
filein( getFilenamePath(getSourceFileName()) + "/IniToMacroParser/IniToMacroParser.ms" )	--"./IniToMacroParser/IniToMacroParser.ms"

/* Compile  *.ini files to  *.mcr files
   MacroscriptGenerator()
		→ convertIniToMcr()
		→ generateMcrFile()
		--→ generateIniFile()
			→ McrFileWriter()
*/
struct MacroscriptGenerator_v
(
    /* construct */

    /* properties */
	--mcr_file_path,
    --MacroDataArray = #(),

	
	/* dependency */
	IniToMacroParser,
	--McrFileWriter = McrFileWriter_v(),
	
    /** Generate .mcr file from .ini file
    *
    * @return path to *.mcr file
    */
    function convertIniToMcr ini_file =
    (
        --format "\n"; print "MacroscriptGenerator_v.convertIniToMcr()"
		--format "ini_file: %\n" ini_file
		MacroDataArray = #()

		if not doesFileExist ini_file then
			FORMAT "\n!!! MacroscriptGenerator_v: INI FILE DOES NOT EXISTS:\n%\n\n" ini_file
		
		mcr_file_path = ( trimRight ini_file ".ini")
        
		if not matchPattern mcr_file_path pattern:"*.mcr" then
			 mcr_file_path += ".mcr"
		
		sections = for _section in getINISetting ini_file collect _section
		--format "sections: %\n" sections

		IniToMacroParser = IniToMacroParser_v(ini_file)
		
        IniToMacroParser.setGeneralValues(sections)

        for macroscript_name in sections do
		(
			MacroData = IniToMacroParser.getMacroData (macroscript_name)

			append MacroDataArray (MacroData)
		)

		--format "MACROSCRIPTS: %\n" MacroDataArray
		
		McrFileWriter_v MacroDataArray mcr_file_path
		
		mcr_file_path --return
    ),
	
	/** Generate mcr file
	 */
	function generateMcrFile MacroDataArray mcr_file_path file_in:undefined =
	(
		--format "\n"; print "MacroscriptGenerator_v.generateMcrFile()"
		--this.mcr_file_path = mcr_file_path
		
		MacroDataArray = if classOf MacroDataArray != Array then #(MacroDataArray) else MacroDataArray

		McrFileWriter_v MacroDataArray mcr_file_path file_in:file_in
		
		mcr_file_path --return
	),

    private

    on create do
    (
    )
)
