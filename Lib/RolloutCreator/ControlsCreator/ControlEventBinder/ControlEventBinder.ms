filein( getFilenamePath(getSourceFileName()) + "/EventFiredCreator/EventFiredCreator.ms" )
filein( getFilenamePath(getSourceFileName()) + "/EventClasses/DefaultControlEvents/DefaultControlEvents.ms" )
filein( getFilenamePath(getSourceFileName()) + "/EventClasses/SaveIniControlEvents/SaveIniControlEvents.ms" )
filein( getFilenamePath(getSourceFileName()) + "/EventTypes/EventTypes.ms" )

global STARTUP_EVENTS = #() -- run callbacks of controls like checkbox, checkbutton on UI start

/** ControlEventBinder_v 
 *
 * DEFAULT CALLBACKS:
 *		1) Fire global variable EventFired = EventFired_v
 * 		2) Save value of control to ini file if is defined
 * 		
 * 		
 * 		
 *							   !!!!!!!!! NOTES FOR ADDING NEW TYPE OF CONTROL !!!!!!!!!
 * 		 
 *								  Edit arrays in this file: control_types, event_types
 * 		
 * 		
 */
struct ControlEventBinder_v 
(

	__construct = #( #_Rollout ),

	/* construct */ 
	_Rollout,

	/* construct option */ 
	ini_path, -- set in RolloutCreator_v._setIniToCreators()

	/* properties */
	_Control,

	/* dependency */
	EventTypes	= EventTypes_v(),
	EventsCombiner	= EventsCombiner_v(),
	DefaultControlEvents	= DefaultControlEvents_v(),
	SaveIniControlEvents	= SaveIniControlEvents_v ini_path:ini_path rollout_id:_Rollout.id,

	control_types	= (ControlTypes_v()).getAllTypes(),

	event_types,	-- get events from event_types array
	events_params,	-- get params from event_types array

	/** Combine events and add handlers
	 */
	function combineEventsAndAddHandlers _Control =
	(
		format "\n"; print ("ControlEventBinder_v.combineEventsAndAddHandlers() "+ _Control.id)

		this._Control = _Control

		event_types	= EventTypes.getEventTypesOfControl	(_Control.type)
		events_params	= EventTypes.getParamsOfEvents	(_Control.type)
		
		
		this._validateEvents()
		
		this._setCallbackParamters()
		
		this._setDefaultEvents()
		this._setSaveIniEvents()
		this._setCustomEvents()

		this._combineEventTypes()


		/* EVENT FIRED */ 
		this._addEventFired()

		/* PARAMETER */ 
		this._addHandlers()
	),

	/** _combine all event types
	 */
	function _combineEventTypes =
	(
		--format "\n"; print "ControlEventBinder_v._combineEventTypes()"
		this._Control.Events.list = for event_type in event_types where (Event = EventsCombiner.combine (event_type)) != undefined collect Event
	),

	/** _bind events
	 */
	function _addHandlers =
	(
		--print "ControlEventBinder_v._addHandlers()"
		for Event in _Control.Events.list do 
			this._addHandler(Event)
	),

	/** Bind events
	 */
	function _addHandler Event =
	(
		--print "ControlEventBinder_v._addHandler()"
		if( Event.code == "" ) then
			return false
		format "EVENT = % \n" Event
		_Rollout._RolloutCreator.addHandler _Control.id Event.type codeStr:(Event.code) paramStr:Event.params filter:on
	),

	/** _combine events
	 */
	function _setDefaultEvents =
	(
		EventsCombiner.setEventsClass #DEFAULTS ( DefaultControlEvents.getEvents(_Control.type) ) 
	),

	/** _combine events
	 */
	function _setSaveIniEvents =
	(
		--format "***** TEST = % \n"( SaveIniControlEvents.getEvents(_Control)(event_types))
		if( ini_path != undefined ) then  
			EventsCombiner.setEventsClass #SAVEINI ( SaveIniControlEvents.getEvents(_Control)(event_types) )
	),

	/** _combine events
	 */
	function _setCustomEvents =
	(
		--print "ControlEventBinder_v._setCustomEvents()"
		EventsCombiner.setEventsClass #CUSTOM _Control.Events.list
	),

	/** Get parameters of callback defined in event_types
	  
	  
		TODO: REFRACT THIS METHOD
	  
	 */
	function _setCallbackParamters =
	(
		--print "ControlEvents._setCallbackParamters()"
		--format "event_types	= % \n" event_types
		--for i = 1 to event_types.count where events_params[i] != undefined  do
		for i = 1 to event_types.count do
		(
			Event = this._getEvent(event_types[i])

			if( events_params[i] == undefined ) then
			(
				
				if not( matchPattern Event.code pattern:("*()") ) then -- add brackets after callback E.G.: "callbackFn" >>>  "callbackFn()"
					Event.code  += "()"
				
			) else if not( matchPattern Event.code pattern:("* "+Event.params) ) then -- add parameters after callback E.G.: "callbackFn" >>>  "callbackFn inSpin inCancel"
			(
				Event.params = events_params[i]
				Event.code  += " "+ Event.params
			)
				
		)
	),

	/**_type _add event fired
	 */
	function _addEventFired =
	(
		--print "ControlEventBinder_v._addEventFired()"
		EventFiredCreator = EventFiredCreator_v control_id:_Control.id

		for i = 1 to event_types.count  do
		(
			--format "event_types[i]	= % \n" event_types[i]
			Event	= this._getEvent(event_types[i])
			_EventFired	= EventFiredCreator.getEventFired(event_types[i])(Event.params)

			Event.code = _EventFired + "\n"+ Event.code
		)

	),

	/** Get event from control, if dos not exists then create new
	 */
	function _getEvent event_type =
	(
		--print "ControlEventBinder_v._getEvent()"
		if( (Event_existing = this._getControlEvent(event_type)) != undefined ) then Event_existing else (Event_v type:event_type)
	),

	/** _get control event
	 */
	function _getControlEvent event_type =
	(
		--print "ControlEventBinder_v._getControlEvent()"
		(for Event in _Control.Events.list where Event.type == event_type collect Event)[1] --return 
	),

	/** _validate events
	 */
	function _validateEvents =
	(
		print "ControlEventBinder_v._validateEvents()"
		for Event in _Control.Events.list where findItem event_types Event.type == 0 do
			throw  ("WARNING\n\nUnknown Event Type: #"+ Event.type + "\n\nControl: "+ (_Control.id))
		
	),
	

	
	/*------------------------------------------------------------------------------
		******************************** OLD ********************************
	--------------------------------------------------------------------------------*/

	--
	--/** If checkbox has value true, then fire up checkbox`s callback when UI starts
	-- */
	--function _addToStartupEvents type callback =
	--(
	--	if( Parent_Control._Parameters.getVal #checked == true ) then
	--	(
	--		EventFired_true = this.Events.setEventFired type Parent_Control.id.full val:true -- simulate event fired
	--
	--		appendIfUnique STARTUP_EVENTS (EventFired_true+callback)
	--	)
	--),
	--


	/*------------------------------------------------------------------------------
		TEST
	--------------------------------------------------------------------------------*/

	public

	/** Alias for private method for testing
	 */
	function getEventTypesOfControlTest control_type =
	(
		EventTypes.getEventTypesOfControl (control_type)
	),

	/*------------------------------------------------------------------------------
		ON CREATE
	--------------------------------------------------------------------------------*/

	on create do
	(
		--print("ControlEventBinder_v.onCreate()")
		--format "_ROLLOUT	= % \n" _Rollout
		ConstructPropeties test:this
	)

)