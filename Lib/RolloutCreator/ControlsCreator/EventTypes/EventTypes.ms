/** Event types
 */
struct EventTypes_v
(
	/* construct */


	/* properties */
	event_types = Dictionary(),

	priority = #( -- in this order are added auto event of macros in ContentLoader

		/* Custom */
		#leftclick,

		/* Primary */
		#click,
		#pressed,
		#changed,
		#picked,
		#selected,
		#selectionEnd,

		/* Secondary */
		#entered,
		#rightclick,
		#doubleClicked,
		#dblclick,

		/* Others */
		#buttondown,
		#buttonup,
		#tick
	),

	/* dependency */
	/* reference */
	/* inhered */
	/** Set events per control type
	  *
	  */
	function _setEventsPerControlType =
	(
		--format "\n"; print "ControlEventCreator_v._setEventsPerControlType()"
		event_types[#Bitmap] 	= Dictionary()
		event_types[#Label] 	= Dictionary()
		event_types[#Groupbox] 	= Dictionary()
		event_types[#Timer] 	= Dictionary #( #tick,	     "" )
		event_types[#hyperlink] 	= Dictionary #( #rightclick, "" )
		event_types[#ColorPicker] 	= Dictionary #( #changed,  "val")
		event_types[#Button] 	= Dictionary #( #pressed,   "" )	#( #rightclick, "" )
		event_types[#Checkbox] 	= Dictionary #( #changed,  "val")	#( #rightclick, "" )
		event_types[#Radiobuttons] 	= Dictionary #( #changed,  "val")	#( #rightclick, "" )
		event_types[#PickButton] 	= Dictionary #( #picked,   "val")	#( #rightclick, "" )
		event_types[#Materialbutton] 	= Dictionary #( #picked,   "val")	#( #rightclick, "" )
		event_types[#Dropdownlist] 	= Dictionary #( #selected, "val")	#( #rightclick, "" )
		event_types[#CheckButton]	= Dictionary #( #changed,  "val" )	#( #rightclick, "" )
		event_types[#Angle] 	= Dictionary #( #changed,  "val")	#( #rightclick, "" )
		event_types[#Edittext] 	= Dictionary #( #changed,  "val")	#( #entered,       "val")
		event_types[#BrowsePath] 	= Dictionary #( #changed,  "val")	#( #entered,       "val")
		
		event_types[#Listbox] 	= Dictionary #( #selected, "val")	#( #doubleClicked, "val")	#( #rightClick, "val")
		event_types[#Slider] 	= Dictionary #( #changed,  "val")	#( #rightclick, "" )	#( #buttondown, "" )	#( #buttonup, "" )
		event_types[#Spinner]	= Dictionary #( #changed, "val inSpin" )	#( #entered, "inSpin inCancel" )	#( #buttonup, "inCancel")	#( #buttondown, "")
		event_types[#MultiListBox] 	= Dictionary #( #selectionEnd, "")	#( #doubleClicked, "val")	#( #rightClick, "val")	#( #selected, "val")
		event_types[#Combobox] 	= Dictionary #( #selected, "val")	#( #doubleClicked, "val")	#( #entered , "val")	#( #changed , "val")	#( #rightclick, "" )
		event_types[#imgTag]	= Dictionary #( #click ,  "" )	#( #rightclick, "" )	#( #dblclick , "" )	#( #lbuttondown, "Point2 Flags" )	#( #mousedown, "" )	#( #mouseup, "" )	#( #mouseover, "" )	#( #mouseout, "" )
	),

	/** Get next event
	  *
	  */
	function getNextEvent control_type event_priority =
	(

		control_event_types = event_types[control_type].keys

		event_types_by_priority = for event_type in priority where findItem control_event_types event_type > 0 collect event_type

		event_types_by_priority[event_priority]--return
	),
	
	/** Get event types by priority
	 */
	function getEventTypesByPriority control_type =
	(
		--format "\n"; print "EventTypes_v.getEventTypesByPriority()"
		events_by_control = event_types[control_type].keys
		
		for i = priority.count to 1 by -1 do
		(
			--format "priority[i]: %\n" priority[i]
			if findItem events_by_control priority[i] > 0 then
				insertItem priority[i] events_by_control 1
			
		)
		--format "priority_by_type: %\n" (makeUniqueArray events_by_control)
		makeUniqueArray events_by_control
	),


	private


	/**
	 */
	on create do
	(
		this._setEventsPerControlType()

		--format "\n"; print "EventTypes.onCreate()"
		--for prop in #(  ) where getProperty this prop == undefined do -- CHECK CONSTRUCT PROPERTIES -- Array of this struct properties necessary to run
		--	throw ("\n\n\nUNDEFINED CONSTRUCT PROPERTY\n\n\nSTRUCT:\n\n"+ ((filterString( classof this as string )"(:")[2]) +"\n\n\nPROPERTY:\n\n"+ prop )

	)

)
