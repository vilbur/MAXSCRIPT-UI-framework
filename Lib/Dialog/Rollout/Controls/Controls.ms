filein( getFilenamePath(getSourceFileName()) + "/Control/Control.ms" )	-- "./Control/Control.ms"
filein( getFilenamePath(getSourceFileName()) + "/DefaultParameters/DefaultParameters.ms" )	-- "./DefaultParameters/DefaultParameters.ms"
filein( getFilenamePath(getSourceFileName()) + "/GroupBoxes/GroupBoxes.ms" )	-- "./GroupBoxes/GroupBoxes.ms"


/** Controls
 */
struct Controls_v
(
	/* properties */
	group,

	List = #(),

	/* dependency */
	DefaultParameters = DefaultParameters_v(),

	GroupBoxes 	= GroupBoxes_v(),

	rollout_id,

	/** Create new control
	  *
	  * @property	#name	type	Type of control
	  * @property	string	caption	Caption of control, caption is hidden if it`s wrapped into brackets "[]" E.G.: "[Browse Path]"
	  * @property	#name	id	Id of control
	  * @property	#boolean	ini	Enable Disable save control value to ini
	  * @property	array	params	Params for control #( #key1, "value1", #key2, "value2" )
	  *
	  * @return Object _Control	"./Control/Control.ms"
	 */
	function Control type caption id:undefined params:#() width: height: offset: align: items: range: value: tooltip: across: locals:#() ini:true add_to_controls:true =
	(
		--format "\n"; print "Controls_v.Control()"
		--format "caption	= % \n" caption
		--format "id	= % \n" id
		--format "params	= % \n" params
		if ( key_index = findItem params #id ) > 0 then
			id = params[key_index +1]


		_Control = Control_v type:type caption:caption id:id add_locals:locals rollout_id:rollout_id

		--
		--format "_Control.id = % \n" _Control.id
		--format "_Control	= % \n" _Control
		_param_names  = #( #width, #height, #offset, #align, #items, #range, #value, #ini, #tooltip, #across)
		_param_values = #(  width,  height,  offset,  align, items,  range,   value,  ini,  tooltip,  across)


		for i = 1 to _param_values.count where _param_values[i]!= unsupplied do
			_Control.Param (_param_names[i]) (_param_values[i])


		this._setParamsToControl(_Control)(params)


		if _Control.type == #Groupbox  then
			GroupBoxes.addGroupbox(this)(_Control)
		else
			GroupBoxes.addControlToGroupbox (this)(_Control)


		if( add_to_controls ) then
			this.add _Control

		_Control --return
	),

	/** Add
	 */
	function add _Control =
	(
		append List _Control
	),

	/** Get
	 */
	function get control_id =
	(
		(for _Control in List where _Control.id == control_id collect _Control)[1]
	),

	/** Set controls Default params
	  *
	  * if type match control type, then be applied as default
	  *
	  * @param	#name	type is mask and must match control type E.G.: match #listbox|#multilistbox|#dropdownlist if type==#List
	  *
	 */
	function Default key val type:#global =
	(
		--print ("Controls_v.Default("+Key as string +", "+val as string +", type:#"+type as string+")")
		 DefaultParameters.setDefaultParam key val type:type
	),

	/** Wrapper of method this.Default() for mass assignment params in array
	  *
	  * @param	#array keys_values	#( #key1,"value1", #key2,"value2" )
	  *
	 */
	function Defaults keys_values type:#global =
	(
		for i = 1 to keys_values.count  by 2  do
			this.Default keys_values[i] keys_values[i+1] type:type
	),

	private


	/** Set params to control
	 * @property	array|string	params	E.G.: #( #key1, "value1", #key2, "value2" ) | "#key1:value1, #key2:value2"
	 *
	 *
	 */
	function _setParamsToControl &_Control params =
	(
		--format "\n"; print "Controls_v._setParamsToControl()"
		--format "params	= % \n" params
		if classOf params == string then
			params = this._splitParamsString (params)

		for i = 1 to params.count  by 2  do
			_Control.Param params[i] params[i+1]

		_Control --return
	),


	/** _split params string
	  *
	  * @param	string	params_string E.G.: "width:256|height:64, border:false"
	  *
	  * @return	array E.G.: #("width", 256, "height", 64, "border", false)
	 */
	function _splitParamsString params_string =
	(
		--format "\n"; print "Controls_v._splitParamsString()"
		params = #()

		for key_value_pair in filterString params_string "|," splitEmptyTokens:false do
			for key_value in filterString key_value_pair ":"  do
				append params (this._convertDatatype( trimRight ( trimLeft key_value )))

		params --return
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
		--print "Controls_v.create()"
		if this.group != undefined then
			this.group = this.group as name
	)
)