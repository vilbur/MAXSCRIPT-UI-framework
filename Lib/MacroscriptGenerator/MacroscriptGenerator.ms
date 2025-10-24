filein( getFilenamePath(getSourceFileName()) + "/McrFileWriter/McrFileWriter.ms" )	--"./McrFileWriter/McrFileWriter.ms"
filein( getFilenamePath(getSourceFileName()) + "/MacroData/MacroData_v.ms" )	        --"./MacroData/MacroData_v.ms"

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

    MacroDataGeneral = MacroData_v(),

    keys_params = #( #category, #buttontext, #tooltip, #icon ),
    keys_filter = #( #IsVisible, #IsChecked, #isEnabled, #isIndeterminate ),
    keys_code   = #( #execute, #altExecute ),

	all_keys = keys_params + keys_filter + keys_code + #(#macroscript),

    /** Generate .mcr file from .ini file
    *
    * @return path to *.mcr file
    */
    function convertIniToMcr =
    (
        --format "\n"; print "MacroscriptGenerator_v.convertIniToMcr()"
		--format "ini_file: %\n" ini_file

		if not doesFileExist ini_file then
			FORMAT "\n!!! MacroscriptGenerator_v: INI FILE DOES NOT EXISTS:\n%\n\n" ini_file
		
		this._setMcrFilePath()

        sections = for _section in getINISetting ini_file collect _section
		--format "sections: %\n" sections

        this.setGeneralValues(sections)

        for macroscript_name in sections do
		(
			MacroData = this.parseMacroscript (macroscript_name)

			this._autoFillValuesByScriptName (macroscript_name) (MacroData)
			this._mergeMacroAndGeneralData(MacroData)
			this._replacePlaceholders (MacroData)

			append macroscripts (MacroData)
		)

		--format "MACROSCRIPTS: %\n" macroscripts
		
		McrFileWriter_v(this)
		
		this.mcr_file_path --return
    ),

    private

    /** Set general values
     *
     */
    function setGeneralValues sections =
    (
        general_keys = if findItem sections "general" > 0 then getINISetting ini_file "general" else #()

        if (index = findItem sections "general") > 0 then
			deleteItem sections index

        for key in general_keys where (general_value = getINISetting ini_file "general" key) != "" do
			MacroDataGeneral.setProp key general_value

		if MacroDataGeneral.name == undefined then
			MacroDataGeneral.name = ""
    ),

    /** Parse macroscript
     *
     */
    function parseMacroscript macroscript_name =
    (
        --format "\n"; print "MacroscriptGenerator_v.parseMacroscript()"

        function getMacroscriptData macroscript_name macro_keys =
        (
			--format "\n"; print "MacroscriptGenerator_v.getMacroscriptData()"
			--format "macro_keys: %\n" macro_keys
            MacroData = MacroData_v()
			
            for key in macro_keys do
				MacroData.setProp key (getINISetting ini_file macroscript_name key)
			
			MacroData --return
        )

        macro_keys = getINISetting ini_file macroscript_name
		
		getMacroscriptData(macroscript_name)(macro_keys)
    ),

	/** Auto fill values by script name */
	function _autoFillValuesByScriptName macroscript_name &MacroData =
	(
        --format "\n"; print "MacroscriptGenerator_v._autoFillValuesByScriptName()"
		if MacroData.name == undefined then
			MacroData.name = macroscript_name

		if MacroData.buttontext == undefined then
			MacroData.buttontext = substituteString macroscript_name "_" " "

		if MacroData.exe == undefined then
			MacroData.exe = "\"" + (substituteString macroscript_name " " "") + "\""

		/* CAMEL CASE macroscript name */ 
		MacroData.name = substituteString MacroData.name " " "_"
		
		MacroData --return
	),

	/** Merge macro and general data */
	function _mergeMacroAndGeneralData &MacroData =
	(
        --format "\n"; print "MacroscriptGenerator_v._mergeMacroAndGeneralData()"
		fn isParameter key = findItem this.keys_params key > 0
		fn isFilter    key = findItem this.keys_filter key > 0
		fn isCode      key = findItem this.keys_code   key > 0

        for key in this.all_keys do
		(
            general_value =  if (val = MacroDataGeneral.getProp key) != undefined then val else ""
--format "\n"
--format "general_value: %\n" general_value
            macro_value =  if (val = MacroData.getProp key) != undefined then val else ""
--format "macro_value: %\n" macro_value
			if not (general_value == "" and macro_value == "") then
				merged_value = case of
				(
					(isParameter key):	this._mergeParams  (macro_value) (general_value) (key)
					(isFilter key):	this._mergeFilters (macro_value) (general_value) (key)
					(isCode key):	this._mergeCode    (macro_value) (general_value)
					
						default: general_value + macro_value
				)
--format "merged_value: %\n" merged_value
			if merged_value != undefined then
				MacroData.setProp key merged_value
		)

		MacroData --return
	),

    /** Merge macroscript params */
    function _mergeParams macro_value general_value key =
    (
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

    /** Merge macroscript filters */
    function _mergeFilters macro_value general_value key =
    (
        function ifContains _string pattern = matchPattern _string pattern:pattern

		case of
		(
			(macro_value == "" or general_value == ""): general_value + macro_value
			(ifContains macro_value   "or *"):	general_value + " " + macro_value
			(ifContains general_value "or *"):	macro_value + " " + general_value
			default:	general_value + "\tand\t" + macro_value
		)
    ),

    /** Merge macroscript code */
    function _mergeCode macro_value general_value =
    (
		first_word_are_same = (filterString macro_value " ")[1] == (filterString general_value " ")[1]

		if macro_value != "" then
			if first_word_are_same then macro_value else general_value + " " +  macro_value
    ),

	/**
		Replace placeholders
	*/
	function _replacePlaceholders &MacroData =
	(
        format "\n"; print "MacroscriptGenerator_v._replacePlaceholders()"
		pattern = this._getPatternForAllKeys()

        for key in this.all_keys where (val = MacroData.getProp key) != undefined do
			if (match = this.regexGetMatches val pattern).count > 0 then
			(
				replace_with_key = match[1][2] as name

				if(val_replace = MacroData.getProp replace_with_key) != undefined then
				(
					val_new = substituteString val (match[1][1]) val_replace
					
					MacroData.setProp key val_new
				)
			)

		MacroData --return
	),

	function regexGetMatches _string pattern ignorecase:true =
	(
		rx         = dotNetClass "System.Text.RegularExpressions.RegEx"
		rx_options	= dotNetClass "System.Text.RegularExpressions.RegexOptions"

		matches = if (ignorecase) then rx.matches _string pattern rx_options.IgnoreCase else rx.matches _string pattern
		
		(for matchIdx = 0 to matches.count-1 collect for groupIdx = 0 to matches.item[matchIdx].groups.count-1 collect ( matches.item[matchIdx].groups.item[groupIdx].value )) --return
	),

	function _getPatternForAllKeys =
	(
		all_keys_string = ""
		
		for key in this.all_keys do all_keys_string += key as string + "|"
		 "{(" + (trimRight all_keys_string "|") + ")}"
	),

	function _setMcrFilePath =
	(
		this.mcr_file_path = (trimRight this.ini_file ".ini")

		if not matchPattern this.mcr_file_path pattern:"*.mcr" then
			 this.mcr_file_path += ".mcr"
	),

    on create do
    (
    )
)
