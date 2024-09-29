filein( getFilenamePath(getSourceFileName()) + "/DefaultControlEvents/DefaultControlEvents.ms" )	-- "./DefaultControlEvents/DefaultControlEvents.ms"


/** Control event creator
 */
struct ControlEventCreator_v
(
	/* construct */
	_Rollout,

	/* dependency */
	DefaultControlEvents	= DefaultControlEvents_v(),
	TooltipCreator	= TooltipCreator_v(),
	EventTypes	= EventTypes_v(),

	/* properties */
	event_types = EventTypes.event_types,

	/* reference */
	/* inhered */

	/** Create events
	  *
	  */
	function createEvents _Control =
	(
		--format "\n================\n"; print "ControlEventCreator_v.createEvents()"
		--format "_Control:	% \n" _Control.caption

		/** Get event params
		 */
		function getParams Event = if Event != undefined then Event.params else ""


		EventFiredCreator = EventFiredCreator_v _RolloutClass:(_Rollout.id as string ) _RolloutControl:( _Rollout.id as string +"."+ _Control.id as string )


		for event_type in this.EventTypes.priority where ( event_params = event_types[_Control.type][event_type]) != undefined do
		(
			if ( Event = _Control.Events[event_type] ) != undefined then
			(
				Event.params = event_params

				this._setArgumentsToCallback(Event)

				this._addToAutoRunEvents(_Control)(Event)

				TooltipCreator.addTooltip(_Control)(event_type)
			)


			Event_default = DefaultControlEvents.getDefaultEvent (_Control) (event_type)


			if  Event != undefined or Event_default != undefined then
			(
				/* GET NEW EVENT IF ONLY DEAFAULT CALLBACK EXIST */
				if  Event == undefined then Event = Event_v type:event_type params:event_params

				/*------ MERGE CALLBACKS CODE ------*/
				callback = this._mergeCodeOfEvents (event_type) (Event) (Event_default)

				/* GET EVENT FIRED */
				event_fired = EventFiredCreator.getEventFired(event_type)( getParams Event + " " + getParams Event_default )

				free_event_fired = "EventFired = undefined"

				/*------ MERGE FINAL CALLABCK ------*/
				Event.callback = "\n" + event_fired + "\n\n" + callback + "\n" + free_event_fired + "\n"


				--format "\n----------------------------------------\n";
				----format "EVENT:         %\n" Event
				--format "EVENT.params:    %\n" Event.params
				--format "EVENT.arguments: %\n" Event.arguments
				--format "EVENT.callback:  %\n" Event.callback


				/* RETURN FINAL EVENT TO CONTROL */
				_Control.Events[event_type] = Event
			)
		)
	),

	private


	/** Add to auto run after dialog is created
	  *
	  * Control MUST has CHECKED parameter and it`s value MUST be TRUE
	  *
	 */
	function _addToAutoRunEvents _Control Event =
	(
		--format "\n"; print "ControlEventCreator_v._addToAutoRunEvents()"
		if Event.autorun then
			if ( control_state = _Control.Params.getVal (#checked) ) != undefined and control_state == true then
				AUTORUN_EVENTS[ ( _Control.id as string + "_" + Event.type as string  )as name ] = Event.callback
	),


	/** Set arguments to events
	  * E.G.:	 on spinner changed val inspisn do fooCallback VAL INSPIN CUSTOM_PARAM -- CAllback parameters are VAL, INSPIN & CUSTOM_PARAM
	  */
	function _setArgumentsToCallback Event =
	(
		--format "\n"; print "ControlEventCreator_v._setArgumentsToCallback()"
		--format "Event: %\n" Event

		/** Convert each argument to string friendly format
		  * @return Array of arguemnts
		  */
		function convertArgumentsToString arguments =
		(
			--format "\n"; print "ControlEventBinder_v.getCallbackParams()"
			--if classOf arguments != Array then
			--	arguments = #(arguments)

			for argument in arguments where argument !="" collect
				case classOf argument of
				(
					string:	"\"" +argument + "\""
					name:	"#" + argument as string
					default: argument as string
				)
		)
		/** Join prameters to string, if not added already
		  *
		  * @return string E.G.: "fooCallback" >>> "fooCallback(val)(inspin)(custom_param)"
		  */
		function joinArgumentsToString arguments =
		(
			--format "\n"; print "ControlEventBinder_v.joinArgumentsToString()"
			arguments_string = ""

			--params_in_callback =	deleteItem (filterString callback " ()") 1 -- get parameters from string E.G.:  "fooCallback val (inSpin)" >>> #( "val", "inspin" )

			/* ADD PRAM IF IS NOT ADDED E.G.: "fooCallback" >>> "fooCallback val (inSpin)" */
			--for argument in arguments where findItem params_in_callback argument == 0 do
			for argument in arguments do
				arguments_string  += " ("+ argument as string + ")" -- add parameters after callback E.G.: "callbackFn" >>>  "callbackFn inSpin inCancel

			arguments_string --return
		)

		/** Callback has arguments
		 */
		function callbackHasArguments callback =
		(
			--format "\n"; print "ControlEventCreator_v.callbackHasArguments()"
			RegEx		 = ( dotNetClass "System.Text.RegularExpressions.RegEx" )
			IgnoreCase = ( dotNetClass "System.Text.RegularExpressions.RegexOptions" ).IgnoreCase

			has_space	= "\s"
			has_name	= "\#"
			has_bracket	= "\("
			has_quote	= "\\\""
			is_macro	= "macros.run"

			pattern = "[" + has_space + has_bracket + has_quote + has_name + "]|" + is_macro

			RegEx.isMatch callback pattern IgnoreCase
		)


		/*------------------------------------------------------------------------------
			SET ARGUMENTS TO CALLBACK
		--------------------------------------------------------------------------------*/
		if Event.callback != "" and not callbackHasArguments (Event.callback) then
		(
			format "classOf Event.arguments: %\n" (classOf Event.arguments)
			/* JOIN ARRAY */
			if classOf Event.arguments == Array then
			(
				arguments = join ( filterString Event.params " ") (convertArgumentsToString(Event.arguments))

				if arguments.count > 0  then
					Event.callback += joinArgumentsToString (arguments)

			)

			/* ADD STRING */
			else if Event.params.count > 0 or Event.arguments.count > 0 then

				Event.callback += " " + Event.params + " " + (Event.arguments as string )

			/* ADD DEFAULT BRACKETS */
			else
				Event.callback += "()"

		)
	),

	/** MERGE CODE OF DEFAULT AND CUSTOM
	  *
	  */
	function _mergeCodeOfEvents event_type Event Event_default =
	(
		--format "\n"; print "ControlEventCreator_v._mergeCodeOfEvents()"
		callback = ""

		if Event_default != undefined and Event_default.callback != "" then
			callback += "\n/* ---- DEFAULT CALLBACK ---- */\n" + Event_default.callback

		if Event.callback != "" then
			callback +=  "\n\n/* ---- CUSTOM CALLBACK ---- */\n" + Event.callback

		callback --return
	),

	/** Validate event
	  *
	  */
	function _validateEvents _Control =
	(
		--format "\n----------------\n"; print "ControlEventCreator_v._getEventPramas()"
		--format "_Control:	% \n" _Control.caption
		--format "_Control.type:	% \n" _Control.type

		for Event_Data in _Control.Events do
			--format "event_types[_Control.type][Event_Data.key]:	% \n" event_types[_Control.type][Event_Data.key]
			if event_types[_Control.type][Event_Data.key] == undefined then
			(
				format  ("\n\n=================== WARNING ======================\n\n")
				print  ("EVENT TYPE #"+ Event_Data.key as string +" DOES NOT EXISTS")
				format "\n"
				format "Control:  #% \n" 	_Control.id
				format "Title:    \"%\" \n"	_Control.caption
				format "Type:     %\n" 	_Control.type
				format "Event:    % \n"	Event_Data.key
				format "\n"
				format "AVAILABLE EVENTS FOR THIS TYPE: % \n" event_types[_Control.type].keys
				format "\n"
				print  ("================================================")
			)
	),


	/**
	 */
	on create do
	(
		--format "\n"; print "ControlEventCreator.onCreate()"
		--for prop in #(  ) where getProperty this prop == undefined do -- CHECK CONSTRUCT PROPERTIES -- Array of this struct properties necessary to run
		--	throw ("\n\n\nUNDEFINED CONSTRUCT PROPERTY\n\n\nSTRUCT:\n\n"+ ((filterString( classof this as string )"(:")[2]) +"\n\n\nPROPERTY:\n\n"+ prop )


	)

)
