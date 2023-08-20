filein( getFilenamePath(getSourceFileName()) + "/EventFiredCreator/EventFiredCreator.ms" )	-- "./EventFiredCreator/EventFiredCreator.ms"
filein( getFilenamePath(getSourceFileName()) + "/DefaultControlEvents/DefaultControlEvents.ms" )	-- "./DefaultControlEvents/DefaultControlEvents.ms"
filein( getFilenamePath(getSourceFileName()) + "/EventTypes/EventTypes.ms" )	-- "./EventTypes/EventTypes.ms"


global STARTUP_EVENTS = #() -- run callbacks of controls like checkbox, checkbutton on UI start

/** ControlEventBinder_v
 *
 * FUNCTIONS OF DEFAULT CALLBACKS:
 *		1) Each event fires global variable EventFired
 * 		2) Save value of control to ini file if is defined
 *
 *
 *							   !!!!!!!!! NOTES FOR ADDING NEW TYPE OF CONTROL !!!!!!!!!
 *
 *								  Edit arrays in this file: control_types, event_types
 */
struct ControlEventBinder_v
(
	__construct = #( #_Rollout ),

	/* construct */
	_Rollout,

	/* construct option */
	--ini_path, -- set in RolloutCreator_v._setIniToCreators()
	--
	--/* properties */
	--_Control,
	--
	--/* dependency */
	--EventTypes	= EventTypes_v(),
	--EventsCombiner	= EventsCombiner_v(),	-- "./../../RolloutEventBinder/EventsCombiner/EventsCombiner.ms"
	--DefaultControlEvents	= DefaultControlEvents_v(),
	--
	--control_types	= (ControlTypes_v()).getAllTypes(),
	--
	--event_types,	-- E.G.: #(#changed, 	#rightClick)	keys
	--events_params,	-- E.G.: #("val",	undefined)	values -- default params for defauls events E.G.: on checkbox changed val do ...

	/** Combine events and add handlers
	 */
	function addHandlers &_Control =
	(
		--format "\n"; print ("ControlEventBinder_v.addHandlers() "+ _Control.id)

		for Event_Data in _Control.Events do
			this._addHandler(_Control)(Event_Data.value)

		_Control --return
	),

	--private

	/** Bind events
	 */
	function _addHandler _Control Event =
	(
		--print "ControlEventBinder_v._addHandler()"
		--format "classOf _Control.id:	% \n" (classOf _Control.id)

		--if _Control.id as name == #CBXBTN_layer_manager then
		--(
		--	format "\n"; print "ControlEventBinder_v._addHandler()"
		--
		--	format "EVENT: % \n"	Event
		--	format "EVENT.type: % \n"	Event.type
		--	format "EVENT.params: % \n"	Event.params
		--	format "EVENT.code: % \n"	Event.code
		--
		--)
		this._addEventFired(_Control)(Event)

		--format "Event.callback[#code]:	% \n" Event.callback[#code]
		if( Event.callback[#code] != "" ) then
			_Rollout.RCI.addHandler _Control.id Event.type codeStr:( "("+Event.callback[#code]+")" ) paramStr:(Event.params) filter:on
	),

	/**_type _add event fired
	 */
	function _addEventFired _Control Event =
	(
		--print "ControlEventBinder_v._addEventFired()"
		EventFiredCreator = EventFiredCreator_v _RolloutClass:(_Rollout.getFullId()) _RolloutControl:( (_Rollout.getFullId()) +"."+ _Control.id as string )

		for Event_Data in _Control.Events do
			Event.callback[#code]  = (EventFiredCreator.getEventFired(Event)) + "\n"+ Event.callback[#code]
			--(EventFiredCreator.getEventFired(Event)) --DEVELOP
	),






















	/** Combine events and add handlers
	 */
	function combineEvents &_Control =
	(
		--format "\n"; print ("ControlEventBinder_v.combineEvents() "+ _Control.id)
		this._Control = _Control

		event_types	= EventTypes.getEventTypesOfControl	(this._Control.type)
		events_params	= EventTypes.getParamsOfEvents	(this._Control.type)

		this._normalizeNamesOfEventTypes()

		this._validateEvents()

		this._setParametersToCallback()
		this._setParametersToEvents()

		this._setDefaultEvents()
		this._setCustomEvents()
		this._combineEvents()


		this._addEventFired()

		this._Control --return
	),


	/** _combine events
	 */
	function _setDefaultEvents =
	(
		EventsCombiner.events_classes[#DEFAULTS] = ( DefaultControlEvents.getEvents(this._Control) )
	),

	/** _combine events
	 */
	function _setCustomEvents =
	(
		--print "ControlEventBinder_v._setCustomEvents()"
		EventsCombiner.events_classes[#CUSTOM] = this._Control.Events.list
	),

	/** Combine all event types default and custom events code
	 */
	function _combineEvents =
	(
		--format "\n"; print "ControlEventBinder_v._combineEvents()"
		this._Control.Events.list = for event_type in event_types where ( Event = EventsCombiner.combine (event_type)) != undefined collect Event
	),

	/** Add prarameters to callback
	  *
	  * E.G.:	 on spinner changed val inspisn do fooCallback VAL INSPIN CUSTOM_PARAM -- CAllback parameters are VAL, INSPIN & CUSTOM_PARAM
	 */
	function _setParametersToCallback =
	(
		--format "\n"; print "ControlEvents._setParametersToCallback()"

		function isMacro _callback = (matchPattern _callback pattern:"*macros.run*")

		/** Get event params
		  */
		function getCallbackParams params_event =
		(
			--format "\n"; print "ControlEventBinder_v.getCallbackParams()"
			if classOf params_event != Array then
				params_event = #(params_event)

			for param in params_event where param !="" collect
				case classOf param of
				(
					string:	"\"" +param + "\""
					name:	"#" + param as string
					default: param as string
				)
		)

		/** Join prameters to string
		  *
		  * @return string E.G.: "(val)(inspin)(custom_param)"
		  */
		function getParamsString Event params =
		(
			--format "\n"; print "ControlEventBinder_v.getParamsString()"
			prams_string = ""

			params_in_callback =	deleteItem (filterString Event.code " ()") 1 -- get parameters from string E.G.:  "fooCallback val (inSpin)" >>> #( "val", "inspin" )

			/* ADD PRAM IF IS NOT ADDED E.G.: "fooCallback" >>> "fooCallback val (inSpin)" */
			for param in params where findItem params_in_callback param == 0 do
				prams_string  += " ("+ param as string + ")" -- add parameters after callback E.G.: "callbackFn" >>>  "callbackFn inSpin inCancel

			prams_string --return
		)

		--format "isMacro(Event.code):	% \n" (isMacro(Event.code))
		--for Event in this._Control.Events.list where not matchPattern Event.code pattern:"* *" do
		for Event in this._Control.Events.list where Event.code.count > 0 and not isMacro(Event.code)  do
		(
			event_params = this._getEventDefaultParams(Event.type)

			params = join ( filterString event_params " ") (getCallbackParams(Event.params))
			--format "PARAMS:	% \n" params
			if params.count > 0 then
				Event.code += getParamsString (Event)(params)

			else if not( matchPattern Event.code pattern:"*(*)" ) and not (  matchPattern Event.code pattern:"*\"*\"" ) then -- if not match E.G.: "print (\"XXX\")" OR "print \"XXX\""
				Event.code += "()" -- add brackets after callback E.G.: "callbackFn" >>>  "callbackFn()"
		)
	),
	/** Set parameters of events
	  *
	  * E.G.:	 on spinner changed VAL INSPISN do ... -- set VAL INSPIN
	 */
	function _setParametersToEvents =
	(
		--print "ControlEvents._setEventsParamters()"
		for Event in this._Control.Events.list where (params = this._getEventDefaultParams(Event.type) ) != undefined do
		--if this._Control.id as name == #CBXBTN_layer_manager then
		--(
		--	format "\n"; print "ControlEventBinder_v._setEventsParamters()"
		--	Event.params = params
		--
		--	format "params:	% \n" params
		--	format "EVENT: % \n"	Event
		--	format "EVENT.type: % \n"	Event.type
		--	format "EVENT.params: % \n"	Event.params
		--	format "EVENT.code: % \n"	Event.code
		--
		--)else
			Event.params = params
	),

	/** Get params for given event type
	  *
	  * @return	string E.G.: "val inSPin"
	 */
	function _getEventDefaultParams event_type =
	(
		--format "\n"; print "ControlEventBinder_v.getParamsForEventType()"
		if ( index = findItem event_types event_type ) > 0 then
			events = events_params[index]

		if events != undefined then events else ""
	),


	/** Get event from control, if dos not exists then create new
	 */
	function _getEvent event_type =
	(
		--print ("ControlEventBinder_v._getEvent() " +event_type)
		if( (Event_existing = this._getControlEvent(event_type)) != undefined ) then Event_existing else (Event_v type:event_type)
	),

	/** _get control event
	 */
	function _getControlEvent event_type =
	(
		--print "ControlEventBinder_v._getControlEvent()"
		(for Event in this._Control.Events.list where Event.type == event_type collect Event)[1] --return
	),


	/** _normalize names of event types
	 */
	function _normalizeNamesOfEventTypes =
	(
		--format "\n"; print "ControlEventBinder_v._normalizeNamesOfEventTypes()"
		for Event in this._Control.Events.list where classOf Event.type == String do
			Event.type = Event.type as name
	),

	/** _validate events
	 */
	function _validateEvents =
	(
		--print "ControlEventBinder_v._validateEvents()"
		for Event in this._Control.Events.list where findItem event_types Event.type == 0 do
		(
			print  ("------------------- WARNING ----------------------")
			print  ("UNKNOWN TYPE OF EVENT FOR CONTROL.")
			format "\n\n"
			format "_Rollout: % \n" _Rollout.title
			format "Control:  #% \n" 	this._Control.id
			format "Title:    \"%\" \n"	this._Control.caption
			format "Type:     %\n" 	this._Control.type
			format "Event:    % \n"	Event.type
			format "\n"
			format "AVAILABLE EVENTS FOR THIS TYPE:    % \n" this.event_types
			format "\n"
			print  ("------------------------------------------------")

		)
			--print  ("\n\n-----------------------------------------\n\n\nERROR - You try add unknown type of event for control (vilbur) \n\n\nControl.id: #"+ (this._Control.id) + "\nEvent.type: #"+ Event.type as string + "\n\n\n-----------------------------------------\n\n\n")
	),

	/*------------------------------------------------------------------------------
		ON CREATE
	--------------------------------------------------------------------------------*/

	on create do
	(
		print("ControlEventBinder_v.onCreate()")
		format "_ROLLOUT	= % \n" _Rollout.title
		--ConstructPropeties test:this
	)

)