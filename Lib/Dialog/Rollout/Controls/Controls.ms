filein( getFilenamePath(getSourceFileName()) + "/Control/Control.ms" )
filein( getFilenamePath(getSourceFileName()) + "/DefaultParameters/DefaultParameters.ms" )	/* DefaultParameters */
filein( getFilenamePath(getSourceFileName()) + "/GroupBoxes/GroupBoxes.ms" )



/** Controls
 */
struct Controls_v
(
	/* properties */
	group,
		
	list = #(),

	/* dependency */
	DefaultParameters = DefaultParameters_v(),
	
	GroupBoxes 	= GroupBoxes_v(),
	
	
	/** Create new control
	  *
	  * @property	#name	type	Type of control
	  * @property	string	caption	Caption of control, caption is hidden if it`s wrapped into brackets "[]" E.G.: "[Browse Path]"
	  * @property	#name	id	Id of control
	  * @property	array	params	Params for control #( #key1, "value1", #key2, "value2" )
	  *
	  * @return Object _Control	"./Control/Control.ms"
	 */
	function Control type caption id:undefined params:#() items: locals:#() add_to_controls:true =
	(
		--format "\n"; print "Controls_v.Control()"
		--format "items	= % \n" items
		--format "params	= % \n" params
		--format "caption	= % \n" caption
		--params = #(#labels, #("item") )
		_Control = Control_v type:type caption:caption id:id add_locals:locals

				
		if( items != unsupplied ) then 
			_Control.Param #items (items)
		
		
		this._setParamsToControl(_Control)(params)

		GroupBoxes.tryAddGroupbox(this)(_Control)
		GroupBoxes.tryAddControl (this)(_Control)
		
		if( add_to_controls ) then 
			this.add _Control
		
		_Control --return 
	),
	
	/** Add
	 */
	function add _Control =
	(
		append list _Control
	),
	
	/** Get
	 */
	function get control_id =
	(
		(for _Control in list where _Control.id == control_id collect _Control)[1]
	),
	
	/** Set controls Default params
	  * 
	  * if type match control type, then be applied as default
	  *  
	  * @param	#name	type is mask and must match control type E.G.: match #listbox|#multilistbox|#dropdownlist if type==#list
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
		--print "Controls_v._setParamsToControl()"
		
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
	function _convertDatatype val =
	(		
		if classOf (val_converted = try((execute(val)))catch()) == UndefinedClass then val_converted = substituteString val "\\" "\\\\"
		
		val_converted --return
	),
	
	/**  
	 */
	on create do
	(
		--print "Controls_v.create()"
	)
)