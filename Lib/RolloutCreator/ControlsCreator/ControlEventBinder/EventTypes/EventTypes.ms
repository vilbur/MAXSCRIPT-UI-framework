/** Event types https://help.autodesk.com/view/MAXDEV/2021/ENU/?guid=GUID-E421933F-958E-42FD-80A1-D66F2A2C0A06
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

	/** Get parameters of event defined in this._setEventTypes()
	  * 
	  * E.G.: For control type #Spinner return
	  * 			1) return 'val inSpin' if event type #changed
	  * 			2) return undefined    if event type #buttondown
	  * 
	  * @return	string|undefined	
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
	function _setEventTypesforAllControlTypes =
	(
		--print("EventTypes_v._setEventTypesforAllControlTypes()")
		for control_type in control_types do
			this._setEventTypes (control_type)

	),

	/** _set event types
	 */
	function _setEventTypes control_type =
	(
		--format "\n"; print "EventTypes_v._setEventTypes()"
		--format "control_type	= % \n" control_type
		control_events = case control_type of (
			#Label:	#( )
			#Groupbox:	#( )
			#Timer:	#( #tick )
			#hyperlink:	#( #rightclick )
			#ColorPicker:	#( #(#changed,  "val") )
			#Button:	#( #pressed,	#rightclick )
			#Checkbox:	#( #(#changed,  "val"),	#rightclick )
			#Radiobuttons:	#( #(#changed,  "val"),	#rightclick )
			#PickButton:	#( #(#picked,   "val"),	#rightclick )
			#Materialbutton:	#( #(#picked,   "val"),	#rightclick )
			#CheckButton:	#( #(#changed,  "val"),	#rightclick )
			#Angle:	#( #(#changed,  "val"),	#rightclick )
			#Edittext:	#( #(#changed,  "val"),	#(#entered,	     "val") )
			#BrowsePath:	#( #(#changed,  "val"),	#(#entered,       "val") )
			#Listbox:	#( #(#selected, "val"),	#(#doubleClicked, "val"),	#(#rightClick, "val"))
			#Slider:	#( #(#changed,  "val"),	#rightclick,	#buttondown,	#buttonup  )
			#Spinner:	#( #(#changed,  "val inSpin"),	#(#entered, "inSpin inCancel"),	#(#buttonup, "inCancel"),	#buttondown )
			#MultiListBox:	#( #(#selected, "val"),	#(#doubleClicked, "val"),	#(#rightClick, "val"),	#selectionEnd )
			#Combobox:	#( #(#selected, "val"),	#(#doubleClicked, "val"),	#(#entered , "val"),	#(#changed , "val"),	#rightClick)
			#Dropdownlist:	#( #(#selected, "val"),	#rightClick )
			--default:	undefined
			default:	#()
		)
		--format "control_events	= % \n" control_events
		if( control_events != undefined ) then 
			List.setVal (control_type) (control_events)
		else
			throw ("\n\nYou are trying create control which has not set event types\n\nAdd event types for #"+control_type as string +" to method\n\nEventTypes_v._setEventTypes()")

	),

	/** _event types of control type
	 */
	function _eventTypesOfControlType control_type =
	(
		--print("EventTypes_v._eventTypesOfControlType() " + control_type as string )

		List.getVal (control_type) --return
	),

	/**  
	 */
	on create do
	(
		--print("EventTypes_v.onCreate()")
		this._setEventTypesforAllControlTypes()
	)
)