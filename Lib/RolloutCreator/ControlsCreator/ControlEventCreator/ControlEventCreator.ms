filein( getFilenamePath(getSourceFileName()) + "/DefaultControlCallbacks/DefaultControlCallbacks.ms" )	-- "./DefaultControlCallbacks/DefaultControlCallbacks.ms"


/** Control event creator
 */
struct ControlEventCreator_v
(
	/* construct */

	/* properties */
	event_types,

	DefaultControlCallbacks = DefaultControlCallbacks_v(),

	/* dependency */
	/* reference */
	/* inhered */

	/** Create events
	  *
	  */
	function createEvents _Control =
	(
		--format "\n================\n"; print "ControlEventCreator_v.createEvents()"
		--format "_Control:	% \n" _Control.caption

		this._validateEvents(_Control)

		for event_type in (event_types[_Control.type].keys) do
		(

			if ( Event = _Control.Events[event_type] ) != undefined then
			(
				this._setEventParams (_Control) (event_type) (Event)

				this._addToAutoRunEvents(_Control)(Event)
			)


			default_callback = DefaultControlCallbacks.getDefaultCallback (_Control) (event_type)

			/* IF DEFAULT OR CUSTOM EVENT EXISTS */
			if  Event != undefined or default_callback != undefined  then
				this._mergeEvents (_Control) (event_type) (Event) (default_callback)
		)
	),

	private

	/** Add to auto run after dialog is created
	  *
	 */
	function _addToAutoRunEvents _Control Event =
	(
		--format "\n"; print "ControlEventCreator_v._addToAutoRunEvents()"
		if Event.autorun then
			AUTORUN_EVENTS[ ( _Control.id as string + "_" + Event.type as string  )as name ] = Event.callback[#code]
	),

	/** Combine events
	  *
	  */
	function _setEventParams _Control event_type Event =
	(
		--format "\n"; print "ControlEventCreator_v.combineEvents()"
		/* GET NEW EVENT IF ONLY DEAFAULT CALLBACK EXIST */
		--if  Event == undefined then Event = Event_v type:event_type

		/* SET EVENT PARAMS */
		Event.params = event_types[_Control.type][event_type]

		/* ADD ARGUMENTS TO CUSTOM CALLBACK */
		if Event.callback[#code] != "" then
			this._setArgumentsToCallback( Event )


		--/* MERGE CODE OF DEFAULT AND CUSTOM CALLBACK */
		--if default_callback != undefined then
		--	Event.callback[#code] = "\n/* ---- DEFAULT CALLBACK ---- */\n" +default_callback +";\n\n/* ---- CUSTOM CALLBACK ---- */\n" + Event.callback[#code]

		--format "-----------------------\n\nEVENT:	% \n" Event
	),


	/** Combine events
	  *
	  */
	function _mergeEvents _Control event_type Event default_callback =
	(
		--format "\n"; print "ControlEventCreator_v.combineEvents()"
		/* GET NEW EVENT IF ONLY DEAFAULT CALLBACK EXIST */
		if  Event == undefined then Event = Event_v type:event_type

		--/* SET EVENT PARAMS */
		--Event.params = event_types[_Control.type][event_type]
		--
		--/* ADD ARGUMENTS TO CUSTOM CALLBACK */
		--if Event.callback[#code] != "" then
		--	this._setArgumentsToCallback( Event )


		/* MERGE CODE OF DEFAULT AND CUSTOM CALLBACK */
		if default_callback != undefined then
			Event.callback[#code] = "\n/* ---- DEFAULT CALLBACK ---- */\n" +default_callback +";\n\n/* ---- CUSTOM CALLBACK ---- */\n" + Event.callback[#code]

		--format "-----------------------\n\nEVENT:	% \n" Event
	),


	/** Set arguments to events
	  * E.G.:	 on spinner changed val inspisn do fooCallback VAL INSPIN CUSTOM_PARAM -- CAllback parameters are VAL, INSPIN & CUSTOM_PARAM
	  */
	function _setArgumentsToCallback Event =
	(
		--format "\n"; print "ControlEventCreator_v._setArgumentsToCallback()"
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
			--format "\n"; print "ControlEventCreator_v.tryAddBracketsToCallback()"
			--format "callback:	% \n" callback
			has_brackets_already	= matchPattern callback pattern:"*(*)"	-- if "callbackHasBarckets()"
			is_not_escaped_string	= matchPattern callback pattern:"*\"*\""	-- if not match E.G.: "print (\"XXX\")" OR "print \"XXX\""

			 if not (has_brackets_already or is_not_escaped_string) then
				callback += "()"

			callback --return
		)

		/*------------------------------------------------------------------------------
			SET ARDUMENTS TO CALLBACK
		--------------------------------------------------------------------------------*/

		callback = Event.callback[#code]

		if matchPattern callback pattern:"*()" then
			callback = trimRight callback "()"  -- remove curly brackets, fool proof when adding callabck

		is_macro = matchPattern callback pattern:"*macros.run*"

		if not is_macro then
		(
			arguments = join ( filterString Event.params " ") (getCallbackArguments(Event.callback[#arguments]))

			if arguments.count > 0 then
				callback += 	getArgumentsString (callback)(arguments)

			else
				tryAddBracketsToCallback(&callback)
		)

		Event.callback[#code] = callback
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

		event_types = (EventTypes_v()).event_types

	)

)
