/** Layout
 */
struct Layout_v
(
	__construct = #(  ),
	
	/* required */
	/* dependency */
	/* reference */
	/* properties */
	width,

	private
	
	/**  
	 */
	on create do
	(
		--print("Layout_v.onCreate()")
		--this._checkConstctructProperties()
	)
	
)
