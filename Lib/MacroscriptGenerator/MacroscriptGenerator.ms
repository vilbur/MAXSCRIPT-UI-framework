filein( getFilenamePath(getSourceFileName()) + "/McrFileWriter/McrFileWriter.ms" )	--"./McrFileWriter/McrFileWriter.ms"
filein( getFilenamePath(getSourceFileName()) + "/MacroData/MacroData_v.ms" )	--"./MacroData/MacroData_v.ms"
filein( getFilenamePath(getSourceFileName()) + "/IniToMacroParser/IniToMacroParser.ms" )	--"./IniToMacroParser/IniToMacroParser.ms"

/* Compile  *.ini files to  *.mcr files
   MacroscriptGenerator()
		→ generateIniFile()
		→ generateMcrFile()
		→ convertIniToMcr()
			→ McrFileWriter()
*/
struct MacroscriptGenerator_v
(
    /* construct */

    /* properties */

    macroscripts = #(),

	
	/* dependency */
	IniToMacroParser,
	
    /** Generate .mcr file from .ini file
    *
    * @return path to *.mcr file
    */
    function convertIniToMcr ini_file =
    (
        --format "\n"; print "MacroscriptGenerator_v.convertIniToMcr()"
		--format "ini_file: %\n" ini_file

		if not doesFileExist ini_file then
			FORMAT "\n!!! MacroscriptGenerator_v: INI FILE DOES NOT EXISTS:\n%\n\n" ini_file
		
        sections = for _section in getINISetting ini_file collect _section
		--format "sections: %\n" sections

		IniToMacroParser = IniToMacroParser_v(ini_file)
		
        IniToMacroParser.setGeneralValues(sections)

        for macroscript_name in sections do
		(
			MacroData = IniToMacroParser.getMacroData (macroscript_name)

			append macroscripts (MacroData)
		)

		--format "MACROSCRIPTS: %\n" macroscripts
		
		McrFileWriter_v(this)
		
		this.IniToMacroParser.mcr_file_path --return
    ),

    private

    on create do
    (
    )
)
