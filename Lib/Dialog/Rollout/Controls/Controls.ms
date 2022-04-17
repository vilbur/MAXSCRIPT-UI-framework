filein( getFilenamePath(getSourceFileName()) + "/Control/Control.ms" )
filein( getFilenamePath(getSourceFileName()) + "/ControlDefaults/ControlDefaults.ms" )
filein( getFilenamePath(getSourceFileName()) + "/GroupBoxes/GroupBoxes.ms" )



/** Controls
 */
struct Controls_v
(
	/* properties */
	group,
		
	list = #(),

	/* dependency */
	Defaults = ControlDefaults_v(),
	
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
	function Control type caption id:undefined params:#() locals:#() add_to_controls:true =
	(
		--print ("Controls_v.Control() " + caption)
		_Control = Control_v type:type caption:caption id:id add_locals:locals
		
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
		Defaults.setDefaultParam key val type:type
	),

	
	private
	
	
	/** Set params to control
	 * @property	Array	keys_values	#( #key1, "value1", #key2, "value2" )
	 *  
	 * 
	 */
	function _setParamsToControl &_Control keys_values =
	(
		--print "Controls_v._setParamsToControl()"
		--format "keys_values	= % \n" keys_values
		for i = 1 to keys_values.count  by 2  do
			_Control.Param keys_values[i] keys_values[i+1]

		_Control --return
	),
	
	/**  
	 */
	on create do
	(
		--print "Controls_v.create()"
	)
)