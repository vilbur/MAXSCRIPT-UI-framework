/** Event types
 */
struct EventTypes_v
(
	
	control_types	= (ControlTypes_v()).getAllTypes(),
	--event_types,
	
	List 	= List_v(),

	
	
	/**  get events for control type from event_types array
	  *
	  * @return	array of event types for control E.G.: return #( #pressed,	#rightclick) if control_type == #button 
	 */
	function getEventTypesOfControl control_type =
	(
		--print "ControlEventBinder_v._getEventTypesOfControl()"
		for event_type in this._eventTypesOfControlType(control_type) where event_type != undefined collect
			if( classOf event_type == Array ) then event_type[1] else event_type

	),
	
	/** get params for control type from event_types array
	 */
	function getParamsOfEvents control_type =
	(
		--format "\n"; print "ControlEventBinder_v._getParamsOfEvents()"
		for event_type in this._eventTypesOfControlType(control_type) where event_type != undefined collect
			if( classOf event_type == Array ) then event_type[2] else undefined
	),

	
	private
	
	
	/** _set event types
	 */
	function _setEventTypes =
	(
		--print("EventTypes_v._setEventTypes()")
		for control_type in control_types do
		(
			control_events = case control_type of (
								#label:	#( )
								#groupbox:	#( )
								#button:	#( #pressed,	#rightclick )
								#checkbox:	#( #(#changed,  "val"),	#rightclick )
								#checkbutton:	#( #(#changed,  "val"),	#rightclick )
								#spinner:	#( #(#changed,  "val inSpin"),	#(#entered, "inSpin inCancel"),	#(#buttonup, "inCancel"),	#buttondown )
								#edittext:	#( #(#changed,  "val"),	#(#entered, "val") )
								#listbox:	#( #(#selected, "val"),	#(#doubleClicked, "val"),	#(#rightClick, "val"))
								#multilistbox:	#( #(#selected, "val"),	#(#doubleClicked, "val"),	#rightClick,	#selectionEnd )
								#dropdownlist:	#( #(#selected, "val"),	#rightClick )
								default:	undefined
							)
			
			List.setVal (control_type) (control_events)
		)
	),
	
	/** _event types of control type
	 */
	function _eventTypesOfControlType control_type =
	(
		List.getVal (control_type) --return
	),
	
	/**  
	 */
	on create do
	(
		--print("EventTypes_v.onCreate()")
		this._setEventTypes()
	)
)