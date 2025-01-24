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
		--print "ControlValue_v._setControlValue()"
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
		   
		
		
		if val != undefined then 
			this._setValue(value_param_name)(val)
		
		this._removeReduntantParams()
	),
	
	/** Set common control
	 */
	function setCommonControl =
	(
		--format "\n"; print "ControlValue_v.setCommonControl()"
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

		if( ( val = _Control.Params.getVal (#value) ) == undefined ) then --try get parameter #value  e.g.: params:#(#value, true)
			val = _Control.Params.getVal (value_param_name)	            --try get parameter by name e.g.: params:#(#checked, true)

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

		_Control.Params.setVal (value_param_name) (val)
	),

	/** Set value correct to datatype
	  *
	  * Cover special cases as Range datatype, or number in text field, which is treaded as number, but IT MSUT be string for edit text for example
	  *
	  * Ini_v is converting string to datatype, but in some caseses error can occured, E.G.: 0 >>> "0"
	  *
	  */
	function _setValueToDatatype value_param_name val  =
	(
		--format "\n"; print "ControlValue_v._setValueToDatatype()"
		--format "value_param_name: %\n" value_param_name
		--format "val: %\n" val
		
		/** Format string value to valid datatype
		  *
		  * @return	point3
		 */
		function setValueIntoRange val =
		(
			--format "\n"; print "ControlValue_v._setValueIntoRange()"

			if classOf val != point3  then
			(
				_range = _Control.Params.getval #range

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
		
		alias_params = #( #COLOR, #VALUE )
		
		for param in alias_params do
		(
			val = _Control.Params.getVal (#COLOR)
			--format "VAL: % %\n" val (classOf val)
		)
		
		--_bitmap = case of
		--(
		--	(( color_param  = _Control.Params.getVal (#COLOR) ) != undefined): (bitmap 256 32 color:(color_param as color ) )
		--	(( value_param  = _Control.Params.getVal (#VALUE) ) != undefined): if classOf value_param == bitmap then value_param else if classOf value_param == color then (bitmap 256 32 color:value_param )
		--)
		--
		--if _bitmap != undefined then 
		--	this._setValue(#BITMAP)( _bitmap )
			
		bitmap 256 32 color:orange
	),

	/** Remove reduntant params
	 */
	function _removeReduntantParams  =
	(
		--format "\n"; print "ControlValue_v.removeReduntantParams()"
		for key in #( #VALUE, #INI, #VALUE, #COLOR ) do 
			_Control.Params.delete (key)
	),

	/**
	 */
	on create do
	(
		--print("CotrolValue_v.onCreate()")
	)
)