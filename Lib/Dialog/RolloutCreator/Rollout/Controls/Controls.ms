filein( getFilenamePath(getSourceFileName()) + "/Control/Control.ms" )

/** Controls
 */
struct Controls_v
(
	--__construct = #(  ),
	--
	--/* required */
	--/* dependency */
	--/* reference */
	--/* properties */
	group,
	--list	= #(),
		
	list = #(),
	
	--ControlsBox,
	--_Subrollouts,
	--
	/** Controls
	 */
	function Control type caption id: params: =
	(
		--print "Controls_v.control()"
		
		_Control = Control_v type:type caption:caption id:id params:params
		
		append list _Control
		
		_Control --return 
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
