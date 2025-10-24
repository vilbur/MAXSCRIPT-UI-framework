filein( getFilenamePath(getSourceFileName()) + "/McrFileWriter/McrFileWriter.ms" )	--"./McrFileWriter/McrFileWriter.ms"

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
    ini_file,

    /* properties */
    --mcr_file,
    mcr_file_path,

    macroscripts = #(),

    general_params = Dictionary(),

    keys_params = #( #category, #buttontext, #tooltip, #icon ),
    keys_filter = #( #IsVisible, #IsChecked, #isEnabled, #isIndeterminate ),
    keys_code   = #( #execute, #altExecute ),

	all_keys = keys_params + keys_filter + keys_code + #(#macroscript),


    /* dependency */
	
    /* reference */
    /* inhered */

	
	
    /** Generate .mcr file from .ini file
    *
    * @return path to *.mcr file
    */
    function convertIniToMcr =
    (
        format "\n"; print "MacroscriptGenerator_v.convertIniToMcr()"
		format "ini_file: %\n" ini_file

		if not doesFileExist ini_file then
			format "\n!!! MacroscriptGenerator_v: INI FILE DOES NOT EXISTS:\n%\n\n" ini_file
		
		this._setMcrFilePath()

        sections = for _section in getINISetting ini_file collect _section
		format "sections: %\n" sections

        this.setGeneralValues(sections)

        for macroscript_name in sections do
		(
			--format "\n\n"
			--format "MACROSCRIPT_NAME:	% \n" MACROSCRIPT_NAME
			macro_data = this.parseMacroscript (macroscript_name )

			this._autoFillValuesByScriptName (macroscript_name) (macro_data)

			this._mergeMacroAndGeneralData(macro_data)

			this._replacePlaceholders (macro_data)

			append macroscripts (macro_data)
		)

		format "MACROSCRIPTS: %\n" macroscripts
		
		McrFileWriter_v(this)


		this.mcr_file_path --return
    ),

    private

    /** Set general values
     *
     */
    function setGeneralValues sections =
    (
        --format "\n"; print "MacroscriptGenerator_v.setGeneralValues()"
        general_keys = if findItem sections "general" > 0 then getINISetting ini_file "general" else #()

        if (index = findItem sections "general") > 0 then
			deleteItem sections index

        for key in general_keys where (general_value = getINISetting ini_file "general" key) != "" do
			general_params[key as name ] = general_value

        /* Add macroscript name */
        if general_params[#macroscript] == undefined then
			general_params[#macroscript] = ""
    ),

    /** Parse macroscript
     *
     */
    function parseMacroscript macroscript_name =
    (
        --format "\n"; print "MacroscriptGenerator_v.parseMacroscript()"
		--format "MACROSCRIPT_NAME:	% \n" macroscript_name
        /** Get macroscript data
         *
         */
        function getMacroscriptData macroscript_name macro_keys =
        (
            --format "\n"; print "MacroscriptGenerator_v.getMacroscriptData()"
            macro_data = Dictionary()

            --for key in macro_keys where (val = getINISetting ini_file macroscript_name key) != "" do macro_data[key as name] = val
            for key in macro_keys do macro_data[key as name] = getINISetting ini_file macroscript_name key

            macro_data --return
        )

        macro_keys = getINISetting ini_file macroscript_name

		getMacroscriptData(macroscript_name)( macro_keys )
    ),

	/** Auto fill values
	  * Set ButtonText by script name E.G.: "Script_Name" >>> "Script Name"
	  * Set executed by script name without change
	  *
	  */
	function _autoFillValuesByScriptName macroscript_name &macro_data =
	(
		--format "\n"; print "MacroscriptGenerator_v.autoFillValues()"
		--format "macro_data[#buttontext]: %\n" macro_data[#buttontext]
		--format "MACRO_DATA IN:	% \n" macro_data
		/* ADD MACROSCRIPT NAME */
		if macro_data[#macroscript] == undefined then
			macro_data[#macroscript] = macroscript_name


		/* ADD BUTTONTEXT */
		if macro_data[#buttontext] == undefined then
		 macro_data[#buttontext] = substituteString macroscript_name "_" " " -- use script name as button text

		/* ADD EXECUTED */
		if macro_data[#execute] == undefined then
			macro_data[#execute] =  "\"" +( substituteString macroscript_name " " "")+ "\""

		
		--if ( general_params[#macroscript] ) != undefined then 
		--macroscript_name = substituteString (general_params[#macroscript] + macro_data[#macroscript]) " " "_"
		macroscript_name = substituteString macro_data[#macroscript] " " "_"

			
		--format "MACRO_DATA:	% \n" macro_data
		macro_data --return
	),

	/** Merge macro and general data
	  *
	  */
	function _mergeMacroAndGeneralData &macro_data =
	(
		--format "\n"; print "MacroscriptGenerator_v._mergeMacroAndGeneralData()"

		fn isParameter key = findItem this.keys_params key > 0
		fn isFilter    key = findItem this.keys_filter key > 0
		fn isCode      key = findItem this.keys_code   key > 0


        for key in this.all_keys do
		(
            general_value =  if general_params[key] != undefined then general_params[key] else ""
            macro_value   =  if macro_data[key]    != undefined then macro_data[key] else ""

			if not (general_value == "" and macro_value == "") then
				merged_value = case of
				(
					(isParameter key):	this._mergeParams  (macro_value) (general_value) (key)
					(isFilter key):	this._mergeFilters (macro_value) (general_value) (key)
					(isCode key):	this._mergeCode    (macro_value) (general_value)
				)

			if merged_value != undefined then
				macro_data[key] = merged_value
		)

		macro_data --return
	),



	/** Merge macroscript params
     */
    function _mergeParams macro_value general_value key =
    (
        --format "\n"; print "MacroscriptGenerator_v._mergeParams()"

		divider = case of
		(
			(general_value == "" or macro_value == ""): ""
			   (general_value != "" and key == #icon ): "|"
											  default: " "
		)

		if not (key == #BUTTONTEXT and macro_value == "" ) then
			general_value + divider + macro_value --return
		else
			"" --return empty button text
    ),

    /** Merge macroscript filters
     */
     function _mergeFilters macro_value general_value key =
    (
        --format "\n"; print "MacroscriptGenerator_v._mergeFilters()"
        function ifContains _string pattern = matchPattern _string pattern:pattern

		--format "\ton %\tdo %\n" (key as string ) (condition) to:mcr_file

		case of
		(
			(macro_value == "" or general_value == ""): general_value + macro_value
					(ifContains macro_value   "or *"):	general_value + " " + macro_value
					(ifContains general_value "or *"):	macro_value + " " + general_value
					default:	general_value + "\tand\t" + macro_value
		)
    ),

    /** Merge macroscript code
     */
    function _mergeCode macro_value general_value =
    (
		--/* USE ONLY MACROSCRIPT EXECUTE IF STARTS WITH SAME WORD AS GENERAL EXECUTE */
		first_word_are_same = (filterString macro_value " ")[1] == (filterString general_value " ")[1]

		if macro_value != "" then
			if first_word_are_same then macro_value else general_value + " " +  macro_value
    ),

	/** Replace placeholders
	  *
	  */
	function _replacePlaceholders &macro_data  =
	(
		--format "\n\n"; print "MacroscriptGenerator_v.replacePlaceholders()"
		--format "MACRO_DATA IN:	% \n" macro_data

		pattern = this._getPatternForAllKeys()

        for key in this.all_keys where macro_data[key] != undefined do
		(
			if (match = this.regexGetMatches macro_data[key] pattern).count > 0 then
			(
				replace_with_key = match[1][2] as name

				if macro_data[replace_with_key] != undefined then
					macro_data[key] = substituteString (macro_data[key]) (match[1][1]) (macro_data[replace_with_key])
			)
		)

		macro_data --return
	),

	function regexGetMatches _string pattern ignorecase:true =
	(
		rx         = dotNetClass "System.Text.RegularExpressions.RegEx"
		rx_options	= dotNetClass "System.Text.RegularExpressions.RegexOptions"

		matches = if (ignorecase) then rx.matches _string pattern rx_options.IgnoreCase else rx.matches _string pattern

		(for matchIdx = 0 to matches.count-1 collect for groupIdx = 0 to matches.item[matchIdx].groups.count-1 collect ( matches.item[matchIdx].groups.item[groupIdx].value )) --return
	),

	/** Get pattern for all keys
	  *
	  */
	function _getPatternForAllKeys =
	(
		--format "\n"; print "MacroscriptGenerator_v._getPatternForAllKeys()"
		all_keys_string = ""

		for key in this.all_keys do all_keys_string += key as string + "|"

		 "{(" + ( trimRight all_keys_string "|") + ")}"
	),

	/** Set mcr file
	  *
	  */
	function _setMcrFilePath =
	(
		--format "\n"; print "McrFileWriter_v._setMcrFilePath()"
		this.mcr_file_path = ( trimRight this.ini_file ".ini" )

		if not matchPattern  this.mcr_file_path pattern:"*.mcr" then
			 this.mcr_file_path += ".mcr"
	),

    /**
     */
    on create do
    (
    --format "\n"; print "MacroscriptGenerator.onCreate()"
    --for prop in #() where getProperty this prop == undefined do -- CHECK CONSTRUCT PROPERTIES -- Array of this struct properties necessary to run
    --throw ("\n\n\nUNDEFINED CONSTRUCT PROPERTY\n\n\nSTRUCT:\n\n"+ ((filterString( classof this as string )"(:")[2]) +"\n\n\nPROPERTY:\n\n"+ prop )

    )
)