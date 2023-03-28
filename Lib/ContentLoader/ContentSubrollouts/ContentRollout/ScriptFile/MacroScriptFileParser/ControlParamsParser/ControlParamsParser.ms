filein( getFilenamePath(getSourceFileName()) + "/ImagesArrayParser/ImagesArrayParser.ms" )

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
	path, -- path to "*.mcr" file

	/* properties */
	params, -- #( #(), #() ) 2D matrix

	/* dependency */
	ImagesArrayParser 	= ImagesArrayParser_v(),

	/** Parse params in "icon" param of macroscript
	  *
	  *
	  * @property	string	params_string	E.G.: "event: #rightclick| width:128 | height : 64|border:true|items: #('item1', 'item2')"
	  *
	  * @return	2D matrix E.G.: #( #( #param1, #param2), #( 'value1', 123 )	 )
	 */
	function parse params_string =
	(
		format "\n"; print "ControlParamsParser_v.parse()"
		--format "params_string	= % \n" params_string
		--format "classOf execute params_string	= % \n" (classOf (execute params_string))
		params = #( #(), #() )

		params_string = this._replaceSingleQuotes(params_string)

		if not this._isIconArray (params_string) then
			for key_value in (filterString params_string "|" splitEmptyTokens:false) do
				this._splitKeyAndValue (key_value)

		else
		(
			params = #( #(#height), #(256) )
		)

		--format "params	= % \n" params
		params --return

		--#( #(), #() )
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

	/** Convert icon:	#("standard", 2) to images:#()
	  *
	  *
	  *
	 */
	function _getPathToIcon =
	(
		--format "\n"; print "ControlParamsParser_v._getPathToIcon()"
		icon_array = execute params_string

		getDir(#ui_ln) + "/IconsDark/" icon_array[1] + ".bmp"
	),

	/** Split key and value
	  *
	 */
	function _splitKeyAndValue key_value_string =
	(
		format "\n"; print "ControlParamsParser_v.splitKeyAndValue()"
		format "key_value_string	= % \n" key_value_string
		colon_index = findString key_value_string ":" -- split string by firt occurencce of ":"

		key	= substring key_value_string 1 (colon_index-1)
		val	= substring key_value_string   (colon_index+1)	-1

		if key as name != #images then
		(
			val = this._convertDatatype( this._trimWhiteSpace(val))

			append params[1] ( this._sanitizeKey(key) as name )
			append params[2] val
		)
		else
			ImagesArrayParser.setImageParameter(params)(execute val)

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
		--_string = substituteString _string "\\" "\\\\"
		rx	= dotNetClass "System.Text.RegularExpressions.RegEx"
		rx_options	= dotNetClass "System.Text.RegularExpressions.RegexOptions"

		is_variable = (rx.match _string "^\s*(\d+|true|false|undefined|unsupplied|\(\s*color\s+\d+\s+\d+\s+\d+\s*\))\s*$" rx_options.IgnoreCase ).success

		if not is_variable and (is_string = ( rx.match _string "(^'*[A-Za-z0-1_\s]+'*$)" rx_options.IgnoreCase ).success ) then
		(
			@"" + _string -- IS STRING
		)
		else
		(
			try((execute(_string)))catch(_string) -- IS VARIABLE
		)
	),

	/**
	 */
	on create do
	(
	)
)