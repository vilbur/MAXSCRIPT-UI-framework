
/* write *.mcr file
   
 */
struct McrFileWriter_v
(
    /* construct */
	parent,

    /* properties */
    mcr_file,

--    keys_params = #( #category, #buttontext, #tooltip, #icon ),
--    keys_filter = #( #IsVisible, #IsChecked, #isEnabled, #isIndeterminate ),
--    keys_code   = #( #execute, #altExecute ),
--
--	all_keys = keys_params + keys_filter + keys_code + #(#macroscript),


    /* dependency */
    /* reference */
    /* inhered */


    /** Write to file
    *
    */
    function writeToFile =
    (
        format "\n"; print "McrFileWriter_v.writeToFile()"
		format "parent.macroscripts: %\n" parent.macroscripts
        /* CREATE FILE */
        this.mcr_file = createFile parent.mcr_file_path

        /* WRITE FILE START */
        --if general_params[#filein] != undefined then
			--format "filein %\n\n" general_params[#filein] to:mcr_file

        try(

            /* WRITE EACH MACROSCRIPT */
            for MacroData in parent.macroscripts do
				this.writeSectionsToFile(MacroData)

        )catch(

            format "\n——————————————— ERROR IN FILE ———————————————\n\n%\n" (getSourceFileName())
            format "\n————————————————— EXCEPTION —————————————————\n\n%\n" (getCurrentException())
            format "\n——————————————————— TRACE ———————————————————\n%\n"(getCurrentExceptionStackTrace())
            format "\n——————————————————— STACK ———————————————————\n%\n"(getCurrentExceptionCallStack())

            close this.mcr_file
        )

        /* CLOSE FILE */
        close this.mcr_file

		free this.mcr_file
    ),


    /** Write to file
    *
    */
    function writeSectionsToFile MacroData =
    (
		format "\n------------------------------------------------------------------------------------\n"
        format "\n"; print "McrFileWriter_v.writeSectionsToFile()"
		format "MACRO_DATA: %\n" MacroData
		--format "mcr_file: %\n" mcr_file

        /* WRITE COMMENT */
        format "/** %\n */\n" MacroData.buttonText to:mcr_file
        
        /* WRITE MACROSCRIPT NAME */
        this.writeMacroscriptName( MacroData )
        
        /* WRITE PARAMS */
        this._writeParams( MacroData )
        
        /* OPEN MACROSCRIPT BRACKET */
        this.writeOpenBracket()
        
        /* WRITE FILTERS */
        this._writeFilters( MacroData )
        
        /* WRITE COMMANDS */
        this._writeCode( MacroData )
        
        /* CLOSE MACROSCRIPT BRACKET */
        this.writeCloseBracket()
    ),

	/** Write macroscript name
	 *
	 */
	function writeMacroscriptName MacroData =
	(
		--format "\n"; print "McrFileWriter_v.writeMacroscriptName()"
		--macroscript_name = substituteString (general_params[#macroscript] + MacroData[#macroscript]) " " "_"

        format "macroscript %\n" MacroData.name to:mcr_file
	),

    /** Merge macroscript code
     */
    function _writeParams MacroData =
    (
        for key in parent.keys_params where (val = MacroData.getProp key) != undefined do
			format "%:\t\"%\"\n" ( key as string ) val to:mcr_file
    ),

    /** Merge macroscript filters
     */
     function _writeFilters MacroData =
    (
        for key in parent.keys_filter where (val = MacroData.getProp key) != undefined do
			format "\ton %\tdo %\n" (key as string ) val to:mcr_file
    ),

    /** Merge macroscript code
     */
    function _writeCode MacroData =
    (
		--format "\n"; print "McrFileWriter_v._writeCode()"

        for key in parent.keys_code where (val = MacroData.getProp key) != undefined do
			format "\n\ton % do (\n\t\t%\n\t)\n" ( key as string + (if key == #altExecute then " type" else "")) val to:mcr_file
    ),

    /** Write open bracket
     *
     */
    function writeOpenBracket =
    (
        --format "\n"; print "McrFileWriter_v.writeOpenBracket()"
        format "(\n"to:mcr_file
    ),

    /** Write close bracket
     *
     */
    function writeCloseBracket =
    (
        --format "\n"; print "McrFileWriter_v.writeCloseBracket()"
        format ")\n\n"to:mcr_file
    ),

    /**
     */
    on create do
    (
		--format "\n"; print "McrFileWriter.onCreate()"
		this.writeToFile()
    )
)