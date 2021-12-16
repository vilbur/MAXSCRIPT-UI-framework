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
	/* construct */ 
	ini_path, -- set in RolloutCreator_v._setIniToCreators()
	
	/* properties */
	_Rollout,
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
		format "\n"; print "ControlEventBinder_v.combineEventsAndAddHandlers()"
		format "_Control	= % \n" _Control
		this._Control = _Control
		
		event_types	= EventTypes.getEventTypesOfControl	(_Control.type)
		events_params	= EventTypes.getParamsOfEvents	(_Control.type)
		
		this._setCustomEvents()
		this._setDefaultEvents()
		this._setSaveIniEvents()
		
		this._combineEventTypes()
		
		this._setCallbackParamters()
		
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
		print "ControlEventBinder_v._addHandlers()"
		for Event in _Control.Events.list do 
			this._addHandler(Event)
	),

	/** Bind events
	 */
	function _addHandler Event =
	(
		print "ControlEventBinder_v._addHandler()"
		if( Event.code == "" ) then
			return false
		format "EVENT = % \n" Event
		_Rollout._RolloutCreator.addHandler _Control.id Event.type codeStr:(Event.code) paramStr:Event.params filter:on
	),

	/** _combine events
	 */
	function _setCustomEvents =
	(
		print "ControlEventBinder_v._setCustomEvents()"
		EventsCombiner.setEventsClass #CUSTOM _Control.Events.list
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
		EventsCombiner.setEventsClass #SAVEINI ( SaveIniControlEvents.getEvents(_Control)(event_types) )
	),

	/** Get parameters of callback defined in event_types
	 */
	function _setCallbackParamters =
	(
		--print "ControlEvents._setCallbackParamters()"
		--format "event_types	= % \n" event_types
		for i = 1 to event_types.count where events_params[i] != undefined  do
		(
			Event = this._getEvent(event_types[i])

			Event.params = events_params[i]

			if not( matchPattern Event.code pattern:("* "+Event.params) ) then -- add prameters behind callback E.G.: "callbackFn" >>>  "callbackFn inSpin inCancel"
				Event.code  += " "+ Event.params
		)
	),


	/*------------------------------------------------------------------------------
		******************************** OLD ********************************
	--------------------------------------------------------------------------------*/

	/** Add handlers
	  * http://help.autodesk.com/view/3DSMAX/2015/ENU/?guid=__files_GUID_5FC5036F_E2D7_46C9_9AFA_7B3550B9F254_htm
	 */
	function getEvents _Control rollout_id =
	(
		this._Control	= _Control
		event_types	= EventTypes.getEventTypesOfControl (_Control.type)
		events_params	= this.getParamsOfEvents  (_Control.type)
		format "event_types	= % \n" event_types
		format "events_params	= % \n" events_params

		/* PARAMETER */ 
		this._setCallbackParamters()

		/* EVENT FIRED */ 
		this._addEventFired()


		 _Control.Events.list --return
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


	/**_type _add event fired
	 */
	function _addEventFired =
	(
		--print "ControlEventBinder_v._addEventFired()"
		EventFiredCreator = EventFiredCreator_v control_id:_Control.id

		for i = 1 to event_types.count  do
		(
			Event = this._getEvent(event_types[i])

			_EventFired    = EventFiredCreator.getEventFired(event_types[i])(Event.params)
			--format "_EventFired	= % \n" _EventFired
			Event.code = _EventFired+ ";"+ Event.code
			--Event.code =  Event.code + ";"+ _EventFired
		)

	),

	/** If checkbox has value true, then fire up checkbox`s callback when UI starts
	 */
	function _addToStartupEvents type callback =
	(
		if( Parent_Control._Parameters.getVal #checked == true ) then
		(
			EventFired_true = this.Events.setEventFired type Parent_Control.id.full val:true -- simulate event fired

			appendIfUnique STARTUP_EVENTS (EventFired_true+callback)
		)
	),

	/** Exception
	 */
	function _exception type =
	(
		messageBox ("WARNING\n\nUnknown Event Type: #"+ type + "\n\nControl: "+ (Parent_Control.Id.get() ))
	),

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
		print("ControlEventBinder_v.onCreate()")
		format "_ROLLOUT	= % \n" _Rollout	)
)