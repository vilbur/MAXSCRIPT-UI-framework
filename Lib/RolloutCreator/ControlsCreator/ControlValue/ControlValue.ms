/** Control value
 */
struct ControlValue_v
(
	/* properties */
	_Control,

	/** Each control has different property where value is stored
	  *
	  * E.G.: EditText.text|Checkbox.checked|Spinner.range
	  *
	  * Used for pass value: parameter on Control creation as well
	  */
	names_of_value_param = #(
		#( #SELECTION,	#Listbox,	#Multilistbox,	#Dropdownlist, #Combobox	),
		#( #CHECKED,	#Checkbox,	#Checkbutton		),
		#( #RANGE,  	#Spinner,	#Slider,	#Angle	),
		#( #TEXT,  	#Edittext,	#BrowsePath		),
		#( #DEFAULT,  	#RadioButtons			),
		#( #MATERIAL,  	#Materialbutton			),
		#( #COLOR,  	#ColorPicker			),
		#( #FILENAME,  	#Bitmap  			),
		#( #ICONNAME,  	#imgTag			),
		#( #ADDRESS,  	#hyperlink			)
	),

	/** Add value parameter
	  *
	  * Priority of value definition
	  * 	1) value from ini file - if control`s parameter ini: is not false
	  * 	2) user defined value
	 */
	function setControlValue _Control ini_value =
	(
		--format "\n"; print "ControlValue_v._setControlValue()"
		--format "_Control.type: %\n" _Control.type
		--format "ini_value: %\n" ini_value
		
		this._Control = _Control

		/* EXIT IF CONTROL HAS NOT VALUE E.G.: #label or #groupbox HAS NOT VALUE */
		if (value_param_name = this._getNameOfValueParameter() ) == undefined  then
			return false

		/* GET INI VALUE */ 
		val = if ini_value != undefined then
				ini_value
				
		/* GET BITMAP VALUE */ 
		else if _Control.type == #BITMAP or _Control.type == #IMGTAG then
		(
			value_param_name = #BITMAP
		   
			this._getBitmapValue()
		)
		else /* GET DEFINED VALUE */ 
		   this._getValueParameter (value_param_name)
		   
		--format "VALUE_PARAM_NAME: %\n" value_param_name
		--format "val: %\n" val
		if val != undefined then 
			this._setValue(value_param_name)(val)
		
		------this._removeReduntantParams()
	),
	
	/** Each control type has different name of parameter for default value
	  *
	  * E.G.:
	  * 	#checkbox	checked:true
	  * 	#listbox	selection:3
	  * 	#radiobuttons	default:3
	  *
	  *  @return	name of parameter
	 */
	function _getNameOfValueParameter =
	(
		--print "ControlValue_v._getNameOfValueParameter()"
		name_of_param = for param_name_array in names_of_value_param where findItem param_name_array _Control.type > 0 collect param_name_array[1]

		if( name_of_param.count > 0 ) then
			name_of_param[1] --return
	),

	/** Get value parameter
	 */
	function _getValueParameter value_param_name =
	(
		--format "\n"; print "ControlValue_v.getValueParameter()"
		val = _Control.Params[#VALUE]
		
		if val == undefined then --try get parameter #value  e.g.: params:#(#value, true)
			val = _Control.Params[value_param_name]	            --try get parameter by name e.g.: params:#(#checked, true)

		val --return
	),

	/** Set parameter of value with correct name for control type
	  * 	then remove #value paramater
	  *
 	  * E.G.: set #checked parameter and delete #value
	  *
	 */
	function _setValue value_param_name val =
	(
		val = this._setValueToDatatype(value_param_name)(val)

		_Control.Params[value_param_name] = val
	),

	/** Set value correct to datatype
	  *
	  * Cover special cases as Range datatype, or number in text field, which is treaded as number, but IT MUST be string for edit text control
	  *
	  * Ini_v is converting string to datatype, but in some caseses error can occured, E.G.: 0 >>> "0"
	  *
	  */
	function _setValueToDatatype value_param_name val  =
	(
		--format "\n"; print "ControlValue_v._setValueToDatatype()"

		/** Set value into range
		  *
		  * @return	point3
		 */
		function setValueIntoRange val =
		(
			--format "\n"; print "ControlValue_v._setValueIntoRange()"

			if classOf val != point3  then
			(
				_range = _Control.Params[#RANGE]
		
				_range.z = val
		
				_range --return
			)
			else
				val --return
		)

		case value_param_name of
		(
			#RANGE:	setValueIntoRange (val)
			#TEXT:	val as string
			#COLOR:	val as point3
			default:	val

			/* BELOW ANOTHER CONTROLS DATATYPES */
			--#SELECTION:
			--#DEFAULT:
			--#MATERIAL:
			--#BITMAP:
			--#ADDRESS:
		)
	),
	

	/** Get bitmap value
	 */
	function _getBitmapValue =
	(
		--format "\n"; print "ControlValue_v._getBitmapValue()"
		local _bitmap
		
		alias_params = #( #COLOR, #VALUE )
		
		for param in alias_params while _bitmap == undefined do
			if ( value_param = _Control.Params[param] ) != undefined then 
				_bitmap = case classOf value_param of
				(
					color: bitmap 256 256 color:value_param
					bitmap: value_param
				)

		_bitmap --return
	),

	--/** Remove reduntant params
	-- */
	--function _removeReduntantParams  =
	--(
	--	--format "\n"; print "ControlValue_v.removeReduntantParams()"
	--	--for key in #( #VALUE, #INI, #VALUE, #COLOR ) do
	--	for key in #( #VALUE, #INI, #VALUE, #COLOR ) do
	--		RemoveDictValue _Control.Params key
	--),

	/**
	 */
	on create do
	(
		--print("CotrolValue_v.onCreate()")
	)
)