clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../ConstructPropeties.ms" )

/** 
 */
struct ChildStruct_v
(
	__construct = #( #this_is_set, #this_is_not_set ),
	
	/* properties */
	this_is_set,
	this_is_not_set,
	
	/**  
	 */
	on create do
	(
		ConstructPropeties test:this
	)
)


/** Struct construct test
 */
struct ConstructPropetiesTest_v
(
	__construct = #( #this_is_set, #this_is_not_set ),
	
	/* properties */
	this_is_set,
	this_is_not_set,
	
	ChildStruct = ChildStruct_v this_is_set:"fooBar",
	
	/**  
	 */
	on create do
	(
		ConstructPropeties test:this
	)
)

ConstructPropetiesTest_v this_is_set:"fooBar"