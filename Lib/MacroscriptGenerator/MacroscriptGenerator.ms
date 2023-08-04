/*
 */
struct MacroscriptGenerator_v
(
	/* construct */
	ini_file,

	/* properties */
	mcr_file,

	--macroscripts	= Dictionary(),
	macroscripts	= #(),

	general_params	= Dictionary(),

	/* dependency */
	/* reference */
	/* inhered */

	/** /** Generate macroscript file
	*
	*/
   function generateMacroscriptFile =
   (
	   --format "\n"; print "MacroscriptGenerator_v.generateMacroscriptFile()"
		sections = for _section in getINISetting ini_file collect _section as name

		this.setGeneralValues(sections)

		for macroscript_name in sections do
			this.parseMacroscript (macroscript_name as string )

		this.writeToFile()
   ),

	private

	/** Set general values
	 *
	 */
	function setGeneralValues sections =
	(
		--format "\n"; print "MacroscriptGenerator_v.setGeneralValues()"
		general_keys = if findItem sections #general > 0 then getINISetting ini_file "general" else #()

		if (index = findItem sections #general) > 0 then
			deleteItem sections index

		for key in general_keys where (general_value = getINISetting ini_file #general key) != "" do
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

		macro_data = this.getMacroscriptData(macroscript_name)( getINISetting ini_file macroscript_name )

		if macro_data == undefined then
			return false

		macro_data = this.mergeData(macro_data)

		append macroscripts macro_data
	),

	/** Get macroscript data
	 *
	 */
	function getMacroscriptData macroscript_name macro_keys =
	(
		--format "\n"; print "MacroscriptGenerator_v.getMacroscriptData()"
		if macro_keys.count == 0 then
			return undefined

		macro_data = Dictionary()

		for key in macro_keys where (val = getINISetting ini_file macroscript_name key) != "" do
		(
			format "val:	% \n" val
			macro_data[key as name] = val
		)


		macro_data[#macroscript] = macroscript_name

		/* ADD BUTTONTEXT */
        if macro_data[#buttontext] == undefined then
	      macro_data[#buttontext] = substituteString macroscript_name "_" " "

		macro_data --return
	),

	/** Merge data
	 *
	 */
	function mergeData macro_data =
	(
		--format "\n"; print "MacroscriptGenerator_v.mergeData()"

		for key in general_params.keys do
		(
			macro_value = if macro_data[key] != undefined then macro_data[key] else ""

			space = if key == #macroscript or macro_value == "" then "" else " "

			macro_data[key] = general_params[key] + space + macro_value
		)

		macro_data --return
	),

	/** Write to file
	*
	*/
	function writeToFile =
	(
		--format "\n"; print "MacroscriptGenerator_v.writeToFile()"

		/* CREATE FILE */
		this.mcr_file = createFile	(( trimRight ini_file "ini" ) + "mcr")

		/* WRITE FILE START */
		if general_params[#filein] != undefined then
			format "filein %\n\n" general_params[#filein] to:mcr_file

		/* WRITE EACH MACROSCRIPT */
		try(
			for macro_data in macroscripts do
				this.writeSectionsToFile(macro_data)
		)catch(
			format "\n——————————————— ERROR IN FILE ———————————————\n\n%\n" (getSourceFileName())
			format "\n————————————————— EXCEPTION —————————————————\n\n%\n" (getCurrentException())
			format "\n——————————————————— TRACE ———————————————————\n%\n"   (getCurrentExceptionStackTrace())
			format "\n——————————————————— STACK ———————————————————\n%\n"   (getCurrentExceptionCallStack())

			close this.mcr_file
		)

		/* CLOSE FILE */
		close this.mcr_file
	),


	/** Write to file
	*
	*/
	function writeSectionsToFile macro_data =
	(
		--format "\n"; print "MacroscriptGenerator_v.writeToFile()"
		params = #( #category, #buttontext, #toolTip, #icon )

		params_data  = for data_pair in macro_data where findItem params data_pair.key > 0                        collect data_pair
		filters_data = for data_pair in macro_data where matchPattern (data_pair.key as string) pattern:"IS*"      collect data_pair
		execute_data = for data_pair in macro_data where matchPattern (data_pair.key as string) pattern:"*execute" collect data_pair

		/* WRITE COMMENT */
		format "/** %\n */\n"	macro_data[#buttonText] to:mcr_file

		/* WRITE MACROSCRIPT NAME */
		format "macroscript		%\n"	macro_data[#macroscript] to:mcr_file

		/* WRITE PARAMS */
		this.writeParams ( params_data )

		/* OPEN MACROSCRIPT BRACKET */
		this.writeOpenBracket()

		/* WRITE FILTERS */
		this.writeFilters ( filters_data )

		/* WRITE COMMANDS */
		this.writeExecute ( execute_data )

		/* CLOSE MACROSCRIPT BRACKET */
		this.writeCloseBracket()
	),

	/** Write params
	 *
	 */
	function writeParams data_pairs =
	(
		--format "\n"; print "MacroscriptGenerator_v.writeParams()"
		for data_pair in data_pairs do
			format "%:	\"%\"\n" (data_pair.key as string ) (data_pair.value as string ) to:mcr_file
	),

	/** Write filters
	 *
	 */
	function writeFilters data_pairs =
	(
		--format "\n"; print "MacroscriptGenerator_v.writeFilters()"
		for data_pair in data_pairs do
			format "	on % do	%\n" (data_pair.key as string ) (data_pair.value as string ) to:mcr_file
	),

	/** Write execute
	 *
	 */
	function writeExecute data_pairs =
	(
		data_pairs = for i = data_pairs.count to 1 by -1 collect data_pairs[i] -- reverse array, execute will be first

		for data_pair in data_pairs do
		(
			onCommand = data_pair.key as string

			if data_pair.key == #altExecute then -- add "type" to "on AltExecute type do"
				onCommand += " type"

			format "\n	on % do (\n		%\n	)\n" onCommand (data_pair.value as string ) to:mcr_file
		)
	),

	/** Write open bracket
	 *
	 */
	function writeOpenBracket =
	(
		--format "\n"; print "MacroscriptGenerator_v.writeOpenBracket()"
		format "(\n"  to:mcr_file
	),

	/** Write close bracket
	 *
	 */
	function writeCloseBracket =
	(
		--format "\n"; print "MacroscriptGenerator_v.writeCloseBracket()"
		format ")\n\n"  to:mcr_file
	),

	/**
	 */
	on create do
	(
		--format "\n"; print "MacroscriptGenerator.onCreate()"
		--for prop in #(  ) where getProperty this prop == undefined do -- CHECK CONSTRUCT PROPERTIES -- Array of this struct properties necessary to run
		--	throw ("\n\n\nUNDEFINED CONSTRUCT PROPERTY\n\n\nSTRUCT:\n\n"+ ((filterString( classof this as string )"(:")[2]) +"\n\n\nPROPERTY:\n\n"+ prop )

		this.generateMacroscriptFile()
	)
)