filein( getFilenamePath(getSourceFileName()) + "/ControlEvent/ControlEvent.ms" )

/** Control
 */
struct Control_v
(
	--__construct = #(  ),
	/* properties */
	type = #button,
	id,
	
	/* required */
	caption,
	params,
	
	/* reference */
	
	/* dependency */
	Events = ControlEvent_v(),

	private
	
	
	/**  
	 */
	on create do
	(
		
	)
	
)
