/** Event types
 */
struct EventTypes_v
(
	
	control_types	= (ControlTypes_v()).control_types,

	/* If event is array then it has "val" param
	*
	* Other items in array defines additional params for event.
	*/ 
	event_types = #(
		#( ),				-- #label	
		#( #pressed,	#rightclick ),			-- #button	
		#( #(#changed,  "val"),	#rightclick ),			-- #checkbox	https://help.autodesk.com/view/3DSMAX/2017/ENU/?guid=__files_GUID_D23A42EA_7B69_4DEF_9D6E_C6C85F884268_htm
		#( #(#changed,  "val"),	#rightclick ),			-- #checkbutton	
		#( #(#changed,  "val inSpin"),	#(#entered, "inSpin inCancel"),	#(#buttonup, "inCancel"),	#buttondown ),	-- #spinner	
		#( #(#changed,  "val"),	#(#entered, "val") ),			-- #edittext	https://help.autodesk.com/view/3DSMAX/2017/ENU/?guid=__files_GUID_FC73C160_735C_4F65_A71D_722D63BBB591_htm
		#( #(#selected, "val"),	#(#doubleClicked, "val"),	#(#rightClick, "val")),		-- #listbox	https://help.autodesk.com/view/3DSMAX/2017/ENU/?guid=__files_GUID_7C37748B_C682_4834_B5A6_74185C8C661A_htm
		#( #(#selected, "val"),	#(#doubleClicked, "val"),	#rightClick,	#selectionEnd ),	-- #multilistbox	
		#( #(#selected, "val"),	#rightClick ),			-- #dropdownlist	
		#( ),				-- #GroupBox

		/* Custom compounded controls */
		#( #tick )
		--#( #(#changed,  "val"),	#(#entered, "val") )	-- #browsePath
	),
	
	
	/**  get events for control type from event_types array
	  *
	  * @return	array of event types for control E.G.: return #( #pressed,	#rightclick) if control_type == #button 
	 */
	function getEventTypesOfControl control_type =
	(
		--print "ControlEventBinder_v._getEventTypesOfControl()"
		for event_type in this._eventTypesOfControlType(control_type) collect
			if( classOf event_type == Array ) then event_type[1] else event_type

	),
	
	/** get params for control type from event_types array
	 */
	function getParamsOfEvents control_type =
	(
		--format "\n"; print "ControlEventBinder_v._getParamsOfEvents()"
		for event_type in this._eventTypesOfControlType(control_type) collect
			if( classOf event_type == Array ) then event_type[2] else undefined
	),

	
	private
	
	
	/** _event types of control type
	 */
	function _eventTypesOfControlType control_type =
	(
		event_types[findItem control_types control_type] --return
	),
	
	/**  
	 */
	on create do
	(
		--print("EventTypes_v.onCreate()")
	)
)