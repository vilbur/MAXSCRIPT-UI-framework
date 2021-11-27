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
	  * @property	string	params	Params for control
	  *
	  * @return Object _Control	"./Control/Control.ms"
	 */
	function Control type caption id:undefined params:undefined locals:#() =
	(
		--if( type == #browsePath ) then 
			--return this.browsePath caption id:id params:params
		
		--print "Controls_v.control()"
		_Control = Control_v type:type caption:caption id:id params:params add_locals:locals
		
		append list _Control
		
		_Control --return 
	),
	
	--/** Browse path
	-- */
	--function browsePath caption id: params: =
	--(
	--	print "Controls_v.browsePath()"
	--	
	--	--this.Control #Button   caption 	 params:#(#across, 2, #align, #left ) --id:id
	--	--this.Control #Edittext "Test "	 params:#(#fieldwidth, 256, #align, #right) --id:id
	--	--this.Control #Edittext "Test "	 params:#(#fieldwidth, 256, #align, #center) --id:id
	--	this.Control #Edittext caption	 params:#( #align, #right) --id:id
	--	--this.Control #Edittext caption	
	--
	--	--this.Control #Button   caption 	 params:#(#across, 2 ) --id:id
	--
	--	--this.Control #Edittext ""	 params:#(#fieldwidth, 256) --id:id
	--),
	
	
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