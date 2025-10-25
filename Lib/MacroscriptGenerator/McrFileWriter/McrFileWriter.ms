
/* write *.mcr file
   
 */
struct McrFileWriter_v
(
    /* construct */
    MacroDataArray,
    mcr_file_path,

    /* properties */
	mcr_file,

    /* dependency */
    /* reference */
    /* inhered */


    /** Write to file
    *
    */
    function writeToFile =
    (
        format "\n"; print "McrFileWriter_v.writeToFile()"
        /* CREATE FILE */

        /* WRITE FILE START */
        --if general_params[#filein] != undefined then
			--format "filein %\n\n" general_params[#filein] to:mcr_file

        try(
			this.mcr_file = createFile mcr_file_path

            /* WRITE EACH MACROSCRIPT */
            for MacroData in MacroDataArray do
				this.writeSectionsToFile(MacroData)

        )catch(

            format "\n——————————————— ERROR IN FILE ———————————————\n\n%\n" (getSourceFileName())
            format "\n————————————————— EXCEPTION —————————————————\n\n%\n" (getCurrentException())
            format "\n——————————————————— TRACE ———————————————————\n%\n"(getCurrentExceptionStackTrace())
            format "\n——————————————————— STACK ———————————————————\n%\n"(getCurrentExceptionCallStack())

            close this.mcr_file
        )

        /* CLOSE FILE */
		if mcr_file != undefined then
		(
			close this.mcr_file
	
			free this.mcr_file
		)
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
		/* CAMEL CASE macroscript name */ 
		macroscript_name = substituteString MacroData.name " " "_"
		
        format "macroscript %\n" macroscript_name to:mcr_file
	),

    /** Merge macroscript code
     */
    function _writeParams MacroData =
    (
        for param_data in MacroData.getParams #PARAMETERS do
			format "%:\t\"%\"\n" ( param_data.key as string ) param_data.value to:mcr_file
    ),

    /** Merge macroscript filters
     */
     function _writeFilters MacroData =
    (
        for param_data in MacroData.getParams #FILTERS do
			format "\ton %\tdo %\n" ( param_data.key as string ) param_data.value to:mcr_file
    ),

    /** Merge macroscript code
     */
    function _writeCode MacroData =
    (
		--format "\n"; print "McrFileWriter_v._writeCode()"

		params = MacroData.getParams #CODE 
		
        for key in #( #exe, #altExecute ) where params[key] != undefined do
		(
			--cmd = param_data.key as string
			cmd = if key == #altExecute then "altExecute type" else "execute"
			
			format "\n\ton % do\n\t(\n\t\t%\n\t)\n" cmd params[key]  to:mcr_file
		)
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