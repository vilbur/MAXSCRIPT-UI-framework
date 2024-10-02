filein( getFilenamePath(getSourceFileName()) + "/Event/Event.ms" ) -- "./Event/Event.ms"


/*------------------------------------------------------------------------------

	DEPRECATED

--------------------------------------------------------------------------------*/


/** Event
 */
struct EventsList_v
(
	list	= #(),

	/** Set
	 */
	function add type callback params:"" tooltip:"" =
	(
		--print "EventsList_v.add()"
		--format "type: %\n" type
		--format "callback	= % \n" callback
		append list (Event_v type:type callback:callback tooltip:tooltip arguments:params)
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
		--print("EventsList_v.onCreate()")
	)
)