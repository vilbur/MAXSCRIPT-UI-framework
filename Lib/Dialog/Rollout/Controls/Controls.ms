filein( getFilenamePath(getSourceFileName()) + "/Control/Control.ms" )
filein( getFilenamePath(getSourceFileName()) + "/ControlDefaults/ControlDefaults.ms" )
/** Controls
 */
struct Controls_v
(
	--__construct = #(  ),
	--
	--/* required */
	
	--/* reference */
	--/* properties */
	group,
	--list	= #(),
		
	list = #(),

	/* dependency */
	Defaults = ControlDefaults_v(),

	
	--
	/** Controls
	 */
	function Control type caption id:undefined params:undefined =
	(
		--print "Controls_v.control()"
		--format "type	= % \ncaption	= % \nid	= % \nparams	= % \n\n" type caption id params
		
		_Control = Control_v type:type caption:caption id:id params:params
		
		append list _Control
		
		_Control --return 
	),
	
	/** Default
	 */
	function Default width: height: across: =
	(
		Defaults.setValues #( #width, #height, #across ) #( width, height, across ) filter:true
		
		format "Defaults.keys	= % \n" Defaults.keys
		format "Defaults.values	= % \n" Defaults.values		
		--print "Controls_v.default()"
		--if( appendIfUnique Defaults.params param ) then 
			--append Defaults.params val
		
		--format "Defaults.params= % \n" (Defaults.params)
	),
	--
	--/** Subrollouts
	-- */
	--function subrollouts slot: =
	--(
	--	print "Controls_v.subrollouts()"
	--	
	--	
	--	_Subrollouts = Subrollouts_v slot:1
	--	
	--	append _Controls _Subrollouts
	--	
	--	--this --return
	--	_Subrollouts --return
	--),
	--
	--
	--/** Button
	-- */
	--function button caption id: params:"" =
	--(
	--	print "ControlsBox_v.button()"
	--	_Control 	= Control_v caption:caption id:id params:params
	--	format "_Control	= % \n" _Control
	--	append ControlsBox.Controls _Control
	--	
	--	_Control --return
	--),
	
	--
	--
	--
	--private
	--
	--
	/**  
	 */
	on create do
	(
		print "Controls_v.create()"
		format "group	= % \n" group
		
	)
	
)
