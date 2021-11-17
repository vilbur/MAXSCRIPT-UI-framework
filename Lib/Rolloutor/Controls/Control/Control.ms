filein( getFilenamePath(getSourceFileName()) + "/../ControlEvent/ControlEvent.ms" )

/** Control
 */
struct Control_v
(
	__construct = #(  ),
	
	/* required */
	caption,
	params,
	
	/* dependency */
	Events = ControlEvent_v(),

	
	/* reference */
	/* properties */
	type = #button,
	id,
	
	private
	
	
	/**  
	 */
	on create do
	(
		
	)
	
)
