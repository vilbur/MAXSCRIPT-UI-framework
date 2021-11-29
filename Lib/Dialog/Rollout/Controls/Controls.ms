filein( getFilenamePath(getSourceFileName()) + "/Control/Control.ms" )
filein( getFilenamePath(getSourceFileName()) + "/ControlDefaults/ControlDefaults.ms" )
/** Controls
 */
struct Controls_v
(
	/* properties */
	group,
		
	list = #(),

	/* dependency */
	Defaults = ControlDefaults_v(),

	/** Create new control
	  *
	  * @property	#name	type	Type of control
	  * @property	string	caption	Caption of control
	  * @property	#name	id	Id of control
	  * @property	array	params	Params for control
	  *
	  * @return Object _Control	"./Control/Control.ms"
	 */
	function Control type caption id:undefined params:#() locals:#() add_to_controls:true =
	(
		_Control = Control_v type:type caption:caption id:id add_locals:locals
		
		this._setParamsToControl(_Control)(params)

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
	
	
	private
	
	
	/** Set params to control
	 * @property	Array	keys_values	#( #key1, "value1", #key2, "value2" )
	 *  
	 * 
	 */
	function _setParamsToControl &_Control keys_values =
	(
		for i = 1 to keys_values.count  by 2  do
			_Control.Param keys_values[i] keys_values[i+1]

		_Control --return
	),
	
	/** Default
	  
	   TODO: ADD OTHER PARAMETERS
	   
	 */
	function Default width: height: across: =
	(
		Defaults.setValues #( #width, #height, #across ) #( width, height, across ) filter:true
	),

	/**  
	 */
	on create do
	(
		--print "Controls_v.create()"
	)
)