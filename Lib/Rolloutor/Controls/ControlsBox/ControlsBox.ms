filein( getFilenamePath(getSourceFileName()) + "/Control/Control.ms" )

/** Controls box
 */
struct ControlsBox_v
(
	__construct = #(  ),
	
	/* required */
	/* dependency */
	/* reference */
	/* properties */
	caption,
	
	Controls	= #(),
	
	/** Button
	 */
	function button caption id: params:"" =
	(
		print "ControlsBox_v.button()"
		_Control 	= Control_v caption:caption id:id params:params
		format "_Control	= % \n" _Control
		append Controls _Control
		
		_Control --return
	), 
	
	
	
	private
	
	
	/**  
	 */
	on create do
	(
		
		
	)
	
	
)
