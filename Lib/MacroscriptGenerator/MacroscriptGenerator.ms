/*
 */
struct MacroscriptGenerator_v
(
	/* construct */
	ini_file,

	/* properties */
	mcr_file,

	macroscripts	= Dictionary(),

	general_params	= Dictionary(),

	/* dependency */
	/* reference */
	/* inhered */

	/** /** Generate macroscript file
	*
	*/
   function generateMacroscriptFile =
   (
	   format "\n"; print "MacroscriptGenerator_v.generateMacroscriptFile()"
		format "ini_file:	% \n" ini_file


		sections = for _section in getINISetting ini_file collect _section as name

		format "sections:	% \n" sections
		--deleteFile	mcr_file

		--mcr_file = openFile	(( trimRight ini_file "ini" ) + "mcr")  mode:"w"
		--mcr_file = createFile	(( trimRight ini_file "ini" ) + "mcr")  mode:"w"

		this.setGeneralValues(sections)

		format "general_params:	% \n" general_params

		for _macroscript in sections do
			this.parseMacroscript (_macroscript as string )


		this.mcr_file = createFile	(( trimRight ini_file "ini" ) + "mcr")

		try(

			for dataPair in macroscripts do
				this.writeToFile (dataPair.key)(dataPair.value)

		)catch(
			format "\n——————————————— ERROR IN FILE ———————————————\n\n%\n" (getSourceFileName())
			format "\n————————————————— EXCEPTION —————————————————\n\n%\n" (getCurrentException())
			format "\n——————————————————— TRACE ———————————————————\n%\n"   (getCurrentExceptionStackTrace())
			format "\n——————————————————— STACK ———————————————————\n%\n"   (getCurrentExceptionCallStack())
			close this.mcr_file
		)

		close this.mcr_file
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

	),

	/** Parse macroscript
	 *
	 */
	function parseMacroscript _macroscript =
	(
		format "\n"; print "MacroscriptGenerator_v.parseMacroscript()"

		if (macro_keys = getINISetting ini_file _macroscript).count == 0 then
			return false

		macro_data = deepCopy this.general_params

		for key in macro_keys where (val = getINISetting ini_file _macroscript key) != "" do
		(
			key = key as name

			if macro_data[key] == undefined then
				macro_data[key] = ""

			macro_data[key] += val

		)

		macroscripts[_macroscript as name ] = macro_data
	),

	/** Write to file
	 *
	 */
	function writeToFile macroscript_name macro_data =
	(
		format "\n"; print "MacroscriptGenerator_v.writeToFile()"


        params = #( #category, #buttontext, #toolTip, #icon )

        params_data = for data_pair in macro_data where findItem params data_pair.key > 0 collect data_pair

        filters_data = for data_pair in macro_data where matchPattern (data_pair.key as string) pattern:"IS*" collect data_pair
        execute_data = for data_pair in macro_data where matchPattern (data_pair.key as string) pattern:"*execute" collect data_pair
        --params_data = for param in params collect macro_data[param]


		this.writeParams ( params_data )
		format "(\n"  to:mcr_file

		this.writeFilters ( filters_data )
		format "\n"  to:mcr_file
		this.writeExecute ( execute_data )

		format ")\n"  to:mcr_file

	),

	/** Write params
	 *
	 */
	function writeParams data_pairs =
	(
		format "\n"; print "MacroscriptGenerator_v.writeParams()"
		format "DATA_PAIRS:	% \n" data_pairs

		for data_pair in data_pairs do
			format "%:	\"%\"\n" (data_pair.key as string ) (data_pair.value as string ) to:mcr_file


	),

	/** Write filters
	 *
	 */
	function writeFilters data_pairs =
	(
		format "\n"; print "MacroscriptGenerator_v.writeFilters()"
		format "DATA_PAIRS:	% \n" data_pairs


		for data_pair in data_pairs do
			format "	%:	%\n" (data_pair.key as string ) (data_pair.value as string ) to:mcr_file

	),

	/** Write execute
	 *
	 */
	function writeExecute data_pairs =
	(
		--format "\n"; print "MacroscriptGenerator_v.writeExecute()"
		for data_pair in data_pairs do
			format "	on % do	(\n		%\n	)\n" (data_pair.key as string ) (data_pair.value as string ) to:mcr_file



	),

	/**
	 */
	on create do
	(
		format "\n"; print "MacroscriptGenerator.onCreate()"
		--for prop in #(  ) where getProperty this prop == undefined do -- CHECK CONSTRUCT PROPERTIES -- Array of this struct properties necessary to run
		--	throw ("\n\n\nUNDEFINED CONSTRUCT PROPERTY\n\n\nSTRUCT:\n\n"+ ((filterString( classof this as string )"(:")[2]) +"\n\n\nPROPERTY:\n\n"+ prop )

		this.generateMacroscriptFile()
	)

)