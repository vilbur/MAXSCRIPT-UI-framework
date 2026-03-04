
/** String to datatype parser
 */
function parseStringToDatatype input_string =
(
	--format "parseStringToDatatype\n"
	
	/** Join array
	 */
	function joinPatterns params_input =
	(
		--format "\n"; print ".joinArray()"
		params_string = ""

		--for param in params_input do params_string += param + "|"
		for param in params_input where param != "" do params_string += param + "|"

		trimRight params_string "|"
	)
	
	patterns = #(
		"-*\d+.*\d*",	-- integer or float
		"true|false",
		"undefined|unsupplied",
		"red|green|blue|white|black|orange|yellow|brown|gray",
		"\[.*\]",	-- point2, point3
		"\(*color\s+\d+\s+\d+\s+\d+\s*\)*",	-- color E.G.: "color 128 128 128" or "(color 128 128 128)"
		"#[^\s\(\{].*",	-- #name but not array or bitarray
		"#[\(\{].*[\)\}]",	--array or bitarray
		"\(*\s*bitmap\s+\d+\s+\d+\s*.*",
		""
	)
	
	RegEx	= dotNetClass "System.Text.RegularExpressions.RegEx"
	RegEx_options	= dotNetClass "System.Text.RegularExpressions.RegexOptions"
	
	is_variable = (RegEx.match input_string ( "^("+joinPatterns(patterns)+")$") RegEx_options.IgnoreCase ).success

		--if is_variable and not (is_string = ( RegEx.match input_string "(^'*[A-Za-z0-1_\s]+'*$)" RegEx_options.IgnoreCase ).success ) then
	if is_variable then
	(
		try((execute(input_string)))catch(input_string) -- IS VARIABLE
	)
	else
	(
		@"" + input_string -- IS STRING
	)

)
