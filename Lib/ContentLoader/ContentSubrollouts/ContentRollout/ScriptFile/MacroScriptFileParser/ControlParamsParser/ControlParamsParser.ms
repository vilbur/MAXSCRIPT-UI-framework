filein( getFilenamePath(getSourceFileName()) + "/ImagesArrayParser/ImagesArrayParser.ms" )
filein( getFilenamePath(getSourceFileName()) + "/IconArrayParser/IconArrayParser.ms" )

/** Parse parameters in 'icon' parameter of macroscript DOCUMENTATION:https://help.autodesk.com/view/MAXDEV/2021/ENU/?guid=GUID-6E21C768-7256-4500-AB1F-B144F492F055#icons
  *
  * Parameters of control is string separated with pipe "|"
  *		E.G.:  icon:"width:128|height:64"
  *
  *
  *
 */
struct ControlParamsParser_v
(
	/* required */

	/* properties */
	params,
	--params	= Dictionary #NAME, -- KEY: #PARAM_NAME VALUE:"Param Value"

	/* dependency */
	ImagesArrayParser 	= ImagesArrayParser_v(),
	IconArrayParser 	= IconArrayParser_v(),
	
	/* private properties */
	patterns = #(
		"\d+.*\d*",	-- integer or float
		"true|false",
		"undefined|unsupplied",
		"red|green|blue|white|black|orange|yellow|brown|gray",
		"\[.*\]",	-- point2, point3
		"\(*color\s+\d+\s+\d+\s+\d+\s*\)*",	-- color E.G.: "color 128 128 128" or "(color 128 128 128)"
		"#[^\s\(]+",	-- #name but not array
		"#\(.*\)",	--array
		""
	),

	/** Parse params in "icon" param of macroscript
	  *
	  * @property	string	params_string	E.G.: "event: #rightclick| width:128 | height : 64|border:true|items: #('item1', 'item2')"
	  * @property	string	macro_name	just for easier debug if error occures
	  *
	  * @return	Dictionary 
	 */
	function parse params_string macro_name =
	(
		--format "\n"; print "ControlParamsParser_v.parse()"
		--format "params_string	= % \n" params_string
		--format "classOf execute params_string	= % \n" (classOf (execute params_string))
		--params = #( #(), #() )
		params	= Dictionary #NAME

		params_string = this._replaceSingleQuotes(params_string)

		if not this._isIconArray (params_string) then
			for key_value in (filterString params_string "|" splitEmptyTokens:false) do
				this._splitKeyAndValue (params)(key_value)

		else
			IconArrayParser.setIconParameter (params)(execute params_string)(macro_name)

		--format "PARAMS	= % \n" params
		params --return
	),

	private

	/** Test if icon parameter is default icon array E.G.: #("Cameras",1)
	  *
	  * IMAGE BUTTON PARAMETER:	https://help.autodesk.com/view/3DSMAX/2017/ENU/?guid=__files_GUID_E03EED5F_E21F_4C2F_AFA9_BA16A6602ACA_htm#WS73099CC142F487553098682E12AC2FC2BC7-7435
	 */
	function _isIconArray params_string =
	(
		--format "\n"; print "ControlParamsParser_v.isIconArray()"
		----format "result	= % \n" (matchPattern params_string pattern:@"#(*")
		matchPattern params_string pattern:@"#(*" --return
	),

	/** Split key and value
	  *
	 */
	function _splitKeyAndValue &params key_value_string =
	(
		--format "\n"; print "ControlParamsParser_v.splitKeyAndValue()"
		--format "key_value_string	= % \n" key_value_string
		colon_index = findString key_value_string ":" -- split string by firt occurencce of ":"

		----if colon_index != undefined then
		(
			key	= substring key_value_string 1 (colon_index-1)
			val	= substring key_value_string   (colon_index+1)	-1

			if key as name != #IMAGES then
			(
				param	= this._sanitizeKey(key) as name
				val	= this._convertDatatype( this._trimWhiteSpace(val))

				this.params[param] = val
			)
			else
				ImagesArrayParser.setImageParameter(params)(execute val)
		)
		
		params --return
	),

	/**  Leading "#" is removed, avoid doubled E.G.: "##id"
	 */
	function _sanitizeKey key =
	(
		trimLeft ( trimRight key ) "# " --return
	),

	/** Remove leading and trailing white space
	 */
	function _trimWhiteSpace _string =
	(
		trimLeft ( trimRight _string ) --return
	),

	/** Replace "'" with "\""
	 */
	function _replaceSingleQuotes params_string =
	(
		--format "\n"; print "ControlParamsParser_v.escapeQuotes()"

		if matchPattern params_string pattern:"*'*" then
			params_string = substituteString params_string "'" "\""

		params_string --return
	),

	/** Format string value to valid datatype
	 */
	function _convertDatatype _string =
	(
		--format "\n"; print "ControlParamsParser_v._convertDatatype()"
		--format "_string: %\n" _string

		/** Join array
		 */
		function joinPatterns params_input =
		(
			--format "\n"; print ".joinArray()"
			params_string = ""

			for param in params_input do params_string += param + "|"

			trimRight params_string "|"
		)
		
		RegEx	= dotNetClass "System.Text.RegularExpressions.RegEx"
		RegEx_options	= dotNetClass "System.Text.RegularExpressions.RegexOptions"

	
		is_variable = (RegEx.match _string ("^("+joinPatterns(patterns)+")$") RegEx_options.IgnoreCase ).success
		--format "is_variable: %\n" is_variable

		if not is_variable then
		--if not is_variable and classOf (execute _string) == UndefinedClass then
			@"" + _string -- IS STRING

		else
			execute(_string)
			--try((execute(_string)))catch(_string) -- IF STRING IS VARIABLE E.G.: "#( 1, 2 ,3 )|[1,2]"

	),

	/**
	 */
	on create do
	(
	)
)