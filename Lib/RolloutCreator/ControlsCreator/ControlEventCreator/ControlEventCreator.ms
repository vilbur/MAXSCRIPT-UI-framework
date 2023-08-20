/** Control event creator
 */
struct ControlEventCreator_v
(
	/* construct */

	control_events = Dictionary(),
	/* properties */


	/* dependency */
	/* reference */
	/* inhered */

	/** Create events
	  *
	  */
	function createEvents _Control =
	(
		format "\n"; print "ControlEventCreator_v.createEvents()"
		for Event_data in _Control.Events where (event_params = this._getEventParams (_Control) (Event_data.key)) != undefined do
		(
			--format "Event_data:	% \n" Event_data
			Event = Event_data.value

			Event.params = event_params

			this._setArgumentsToCallback( Event )


			--this._addDefaultCallback()

			--this._addEventFired()

			format "Event:	% \n" Event
		)

	),

	private

	/** Set arguments to events
	  * E.G.:	 on spinner changed val inspisn do fooCallback VAL INSPIN CUSTOM_PARAM -- CAllback parameters are VAL, INSPIN & CUSTOM_PARAM
	  */
	function _setArgumentsToCallback Event =
	(
		format "\n"; print "ControlEventCreator_v._setArgumentsToCallback()"
		/** Convert each argument to string friendly format
		  * @return Array of arguemnts
		  */
		function getCallbackArguments arguments =
		(
			--format "\n"; print "ControlEventBinder_v.getCallbackParams()"
			if classOf arguments != Array then
				arguments = #(arguments)

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
		function getArgumentsString callback arguments =
		(
			--format "\n"; print "ControlEventBinder_v.getArgumentsString()"
			arguments_string = ""

			params_in_callback =	deleteItem (filterString callback " ()") 1 -- get parameters from string E.G.:  "fooCallback val (inSpin)" >>> #( "val", "inspin" )

			/* ADD PRAM IF IS NOT ADDED E.G.: "fooCallback" >>> "fooCallback val (inSpin)" */
			for argument in arguments where findItem params_in_callback argument == 0 do
				arguments_string  += " ("+ argument as string + ")" -- add parameters after callback E.G.: "callbackFn" >>>  "callbackFn inSpin inCancel

			arguments_string --return
		)
		/** Add brackets to callback
		  */
		function tryAddBracketsToCallback &callback =
		(
			has_brackets_already	= matchPattern callback pattern:"*(*)"	-- if "callbackHasBarckets()"
			is_not_escaped_string	= matchPattern callback pattern:"*\"*\""	-- if not match E.G.: "print (\"XXX\")" OR "print \"XXX\""

			 if not (has_brackets_already or is_not_escaped_string) then
				callback += "()"
		)


		/*------------------------------------------------------------------------------
			SET ARDUMENTS TO CALLBACK
		--------------------------------------------------------------------------------*/

		callback = trimRight Event.callback[#code] "()"  -- remove curly brackets, fool proof when adding callabck

		is_macro = matchPattern callback pattern:"*macros.run*"

		if not is_macro then
		(
			arguments = join ( filterString Event.params " ") (getCallbackArguments(Event.callback[#arguments]))

			if arguments.count > 0 then
				callback += 	getArgumentsString (callback)(arguments)

			else
				tryAddBracketsToCallback(callback)
		)

		format "EVENT:	% \n" Event
		Event.callback[#code] = callback
	),


	/** Validate event
	  *
	  */
	function _getEventParams _Control event_type =
	(
		--format "\n"; print "ControlEventCreator_v._getEventPramas()"
		if control_events[_Control.type][event_type] == undefined then
		(
			print  ("------------------- WARNING ----------------------")
			print  ("UNKNOWN TYPE OF EVENT FOR CONTROL.")
			format "\n\n"
			--format "_Rollout: % \n" _Rollout.title
			format "Control:  #% \n" 	_Control.id
			format "Title:    \"%\" \n"	_Control.caption
			format "Type:     %\n" 	_Control.type
			format "Event:    % \n"	event_type
			format "\n"
			format "AVAILABLE EVENTS FOR THIS TYPE:    % \n" control_events[_Control.type].keys
			format "\n"
			print  ("------------------------------------------------")
		)

		control_events[_Control.type][event_type] --return
	),

	/** Set events per control type
	  *
	  */
	function _setEventsPerControlType =
	(
		--format "\n"; print "ControlEventCreator_v._setEventsPerControlType()"
		control_events[#Label] 	= #()
		control_events[#Button] 	= Dictionary #( #pressed, "" )	#( #rightclick, "" )
		control_events[#CheckButton]	= Dictionary #( #changed, "val" )	#( #rightclick, "" )
		control_events[#Spinner]	= Dictionary #( #changed, "val inSpin" )	#( #entered, "inSpin inCancel" )	#(#buttonup, "inCancel")	#(#buttondown, "")

	),

	/**
	 */
	on create do
	(
		this._setEventsPerControlType()
		--format "\n"; print "ControlEventCreator.onCreate()"
		--for prop in #(  ) where getProperty this prop == undefined do -- CHECK CONSTRUCT PROPERTIES -- Array of this struct properties necessary to run
		--	throw ("\n\n\nUNDEFINED CONSTRUCT PROPERTY\n\n\nSTRUCT:\n\n"+ ((filterString( classof this as string )"(:")[2]) +"\n\n\nPROPERTY:\n\n"+ prop )

	)

)
