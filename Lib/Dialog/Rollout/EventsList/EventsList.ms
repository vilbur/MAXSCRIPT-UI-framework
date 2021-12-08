/** Event
 */
struct EventsList_v
(
	list	= #(),
	
	/** Set
	 */
	function add type callback params:"" tooltip:"" =
	(
		--print "ControlEvent_v.add()"
		--format "callback	= % \n" callback
		append list (Event_v type:type code:callback tooltip:tooltip params:params)
	),
	
	/** Get
	 */
	function get type =
	(
		(for Event in List where Event.type == type collect Event)[1]
	),
	
	/** replace event by type or add new if does not exist
	 */
	function replace Event =
	(
		for i = 1 to list.count where list[i].type == Event.type do index =  i
		--format "index	= % \n" index
		if( index != undefined ) then
			list[i] = Event
		else
			append list Event
	),
	
	
	private
	

	/**  
	 */
	on create do
	(
		--print("ControlEvent_v.onCreate()")
	)
)