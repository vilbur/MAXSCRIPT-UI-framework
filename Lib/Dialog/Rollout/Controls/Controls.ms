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

	/** Controls
	 */
	function Control type caption id:undefined params:undefined =
	(
		--print "Controls_v.control()"
		_Control = Control_v type:type caption:caption id:id params:params
		
		append list _Control
		
		_Control --return 
	),
	
	/** Default
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