/** Event
 */
struct Events_v
(
	list	= #(),
	
	/** Set
	 */
	function add type callback params:"" tooltip:"" =
	(
		--print "ControlEvent_v.add()"
		append list (Event_v type:type code:callback tooltip:tooltip params:params)
	),
	
	
	private
	

	/**  
	 */
	on create do
	(
		--print("ControlEvent_v.onCreate()")
	)
)