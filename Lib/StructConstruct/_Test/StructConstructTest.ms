clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../StructConstruct.ms" )


/** Struct construct test
 */
struct ConstructPropetiesTest_v
(
	
	/* properties */
	this_is_set,
	this_is_not_set,

	private
	
	/**  
	 */
	on create do
	(
		ConstructPropeties test:this properties:#( #this_is_set, #this_is_not_set )
	)
	
)

ConstructPropetiesTest_v this_is_set:"fooBar"