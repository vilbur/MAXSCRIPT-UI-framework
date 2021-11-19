--filein( getFilenamePath(getSourceFileName()) + "/ControlEvent/ControlEvents.ms" )

/** Control
 */
struct Control_v
(
	--__construct = #(  ),
	/* properties */
	type,
	id,
	
	/* required */
	caption,
	params,
	
	/* reference */
	
	/* dependency */
	--Events = ControlEvents_v(),

	private
	
	
	/**  
	 */
	on create do
	(
		
	)
	
)
