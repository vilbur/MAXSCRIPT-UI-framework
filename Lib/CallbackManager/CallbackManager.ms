
filein( getFilenamePath(getSourceFileName()) + "/Callback/Callback.ms" )	--"./Callback/Callback.ms"

filein( getFilenamePath(getSourceFileName()) + "/Callbacks-Special/postNodesClonedEnd/postNodesClonedEnd.ms" )	--"./Callbacks-Default/postNodesClonedEnd/postNodesClonedEnd.ms"

/*------------------------------------------------------------------------------
	
	
    CALLBACKMANAGER is global singleton instance

	It can be used by mutliple scripts at once
	
--------------------------------------------------------------------------------*/
--if CALLBACKMANAGER == undefined then -- IMPORTANT: ENABLE THIS LINE IN PRODUCTION
	global CALLBACKMANAGER

/*
  	[callback types]https://help.autodesk.com/view/3DSMAX/2015/ENU/?guid=__files_GUID_C1F6495F_5831_4FC8_A00C_667C5F2EAE36_htm
 */
struct CallbackManager_v
(
	/* construct */

	/* properties */
	List = Dictionary(), -- KEY: callback_fn_callback_type VALUE:Callback_v

	
	special_events = #(
					  #postNodesClonedEnd,
					  #onSelectionChangedModPanelReady
					  ),
	
	/* dependency */
	/* reference */
	/* inhered */

	/** Import callback files from directories
	  *
	  * callback function and type are get from path:  "DIR_IS_TYPE/FILENAME_IS_CALLBACK.ms"
	  *
	 */
	function import dir =
	(
		--format "\n"; print "Callback_v.import()"
		for callback_subdir in  getDirectories (dir + "/*") recurse:true do
			for callback_file in getFiles (callback_subdir + "/*.ms") do
			(
				--format "callback_subdir: %\n" callback_subdir
				type = getFilenameFile( trimRight callback_subdir "\\" ) as name
				--format "type: %\n" type
				callback = getFilenameFile( callback_file )
				--format "callback: %\n" callback
				--format "callback_file: %\n" callback_file
				
				filein callback_file
				
				--format "classOf callback: %\n" (classOf (execute callback))
				
				/* IF FILE CONTAINS FUNCTION WITH SAME NAME AS FILE */ 
				if classOf (execute callback) != MAXScriptFunction then
				(
					print ("------------------- CallbackManager_v.import() -------------------")
					format "CALLBACK FUNCTION MISSING IN FILE: %\n" (callback_file)
					format "MAKE SURE THAT FILE %.ms CONTAINS FUNCTION: %()\n" callback callback
				)
				else
					this.add callback type
				
				
			)
	),
	
	/** Add Callback
	  *
	  */
	function add callback_fn type id: =
	(
		--format "\n"; print "CallbackManager_v.add()"
		--format "callback_fn:	% \n" callback_fn
		--format "type:	% \n" type

		callback_key = if id == unsupplied then this._getCallbackKey (callback_fn)(type) else id

		this.List[callback_key] = Callback_v callback:(this._getCallbackFn (callback_fn)) type:type id:callback_key
		--format "list:	% \n" list

		--this.startCallback (this.List[callback_key])
	),

	/** Add Callback
	  *
	  * @retrun #(Callback_v) removed callbacks
	  */
	function remove callback_type_id =
	(
		--format "\n"; print "CallbackManager_v.remove()"
		_Callbacks = this.getCallbacks (callback_type_id)

		for i = _Callbacks.count to 1 by -1 do 
			(
				_Callback = _Callbacks[i]
				
				this.killCallback (_Callback)
				
				removeDictValue this.List _Callback.id
			)
	),

	/** Get callbacks
	 *
	 * @return #(Callback_v)
	 */
	function getCallbacks param =
	(
		--format "\n"; print "Callback_v.getCallbacks()"
		--format "param: %\n" param
		--format "list: %\n" list
		--format "\n\n------------------------------------\n\n"

		/** Get callback by type
		 */
		function getCallbackByProperty key val option_key:undefined option_val:undefined =
		(
			--format "\n"; print "Callback_v.getCallbackByProperty()"

			_callbacks = #()
			
			for dataPair in this.List do
			(
				prop_val = getProperty dataPair.value key
				
				if (key == #CALLBACK and matchPattern prop_val pattern:(val+"*")) or prop_val == val then
					append _callbacks dataPair.value
			)
			
			--_callbacks = for dataPair in this.List
			--	where getProperty dataPair.value key == val and ( if option_val != undefined then getProperty dataPair.value option_key == option_val else true )
			--			collect dataPair.value
			--format "_callbacks: %\n" _callbacks
			_callbacks --return
		)
		
		--/** Is id
		-- */
		--function isId val = classOf val == name and this.list[val] != undefined
		--
		
		callback	= if classOf param == string then param
		type	= if classOf param == name and this.list[param] == undefined then param
		id	= if classOf param == name and this.list[param] != undefined then param
		
		--format "callback: %\n" callback
		--format "type: %\n" type
		--format "id: %\n" id

		callback_exist	= callback	!= undefined
		type_exist	= type	!= undefined
		id_exist	= id	!= undefined

		--format "callback_exist: %\n" callback_exist
		--format "type_exist: %\n" type_exist
		--format "id_exist: %\n" id_exist
		--
		callback = (this._getCallbackFn(callback))

		_callbacks = if not ( callback_exist and type_exist and id_exist ) then
			case of
			(
				/*------ GET BY MULTIPLE PARAMS ------*/
				(callback_exist and type_exist ):	getCallbackByProperty(#type)	(type)	option_key:#type	option_val:type
				(callback_exist and id_exist ):	getCallbackByProperty(#callback)	(callback)	option_key:#id	option_val:id
				--(type_exist     and id_exist ):	getCallbackByProperty(#type)	(type)	option_key:#id	option_val:id

				--/*------ GET BY SINGLE PARAM ------*/
				(callback_exist ):	getCallbackByProperty(#callback)	(callback)
				(type_exist ):	getCallbackByProperty(#type)	(type)
				(id_exist ):	getCallbackByProperty(#id)	(id)
				
				default: for key in this.List.keys collect this.List[key]
			)
		else
			/*------ GET BY ALL PARAMS ------*/
			#( this.List[this._getCallbackKey (callback)(type)] )
			
		--format "_CALLBACKS: %\n" _callbacks
		
		_callbacks --return
	),
	
	/** Exe
	 */
	function exe callback_type_id =
	(
		--format "\n"; print "CallbackManager_v.exe()"
		--format "callback_type_id: %\n" callback_type_id
		--format "list: %\n" list
		--format "callbacks: %\n" (this.getCallbacks (callback_type_id))
		--
		
		for Callback in (this.getCallbacks (callback_type_id)) do
			--format "Callback.callback: %\n" Callback.callback
			execute Callback.callback
	),
	
	/** Start
	 */
	function start callback_type_id =
	(
		--format "\n"; print "Callback_v.start()"
		--format "callback_type_id: %\n" callback_type_id
		
		for Callback in (this.getCallbacks (callback_type_id)) do 
			this.startCallback (Callback)
	),
	
	/** Kill
	 */
	function kill callback_type_id =
	(
		--format "\n"; print "Callback_v.start()"
		for Callback in (this.getCallbacks (callback_type_id)) do 
			this.killCallback (Callback)
	),
	
	/** Start
	 */
	function startCallback Callback =
	(
		--format "\n"; print "Callback_v.startCallback()"
		--format "Callback: %\n" Callback

		--format "\n"; print ("CallbackManager_v.startCallback( "+ Callback as string +" )")
		--format "classof Callback.type: %\n" (classof Callback.type)
		--format "CallbackManager_v.START TYPE:% CALLBACK:% ID:% \n\n" Callback.type Callback.callback Callback.id
		
		Callback = deepCopy Callback
		
		if findItem special_events Callback.type > 0 then
		(
			Callback.callback = Callback.type as string + "()"
			
			Callback.type = case Callback.type of
			(
				#postNodesClonedEnd: #postNodesCloned
			)
		)
		--format "Callback: %\n" Callback
		
		callbacks.addScript Callback.type Callback.callback id:Callback.id
	),
	
	/** Kill
	 *
	 */
	function killCallback Callback =
	(
		--format "\n"; print ("CallbackManager_v.killCallback( "+Callback.callback+" )")
		--format "\n"; print "Callback_v.killCallback()"
		--format "Callback.callback = % \n" Callback.callback
		--format "Callback.type = % \n" Callback.type
		--format "Callback.id   = % \n" Callback.id
		try( callbacks.removeScripts Callback.type id:Callback.id )catch()
	),

	private

	/** Turn #name to string and add suffix "()"
	 *
	 *
	 * @return #name E.G.: "fooFn()"
	 */
	function _getCallbackFn callback =
	(
		--format "\n"; print "Callback._getCallbackFn()"
		--format "callback: %\n" callback
		--if not matchPattern (callback) pattern:@"pattern"ignoreCase:false then
		/** Callback has arguments
		 */
		function callbackHasArguments callback =
		(
			--format "\n"; print "ControlEventCreator_v.callbackHasArguments()"
			RegEx		 = ( dotNetClass "System.Text.RegularExpressions.RegEx" )
			IgnoreCase = ( dotNetClass "System.Text.RegularExpressions.RegexOptions" ).IgnoreCase

			/* DO NOT ADD ARGUMENTS IF THESE PATTERNS ARE FOUND IN CALLBACK */
			has_space	= "\s"	-- "Foo Bar"
			has_name	= "\#"	-- "#FooBar"
			has_quote	= "\\\""	-- \"Foo\"
			is_wrrapped	= "^\(.*\)$"	-- ( print @foo@ )
			has_brackets	= ".*\(.*\)$"	-- fooFn(bar)
			is_macro	= "macros.run"	-- macros.run "foo" "bar"

			pattern = "[" + has_space + has_quote + has_name + "]|"+is_wrrapped+"|"+has_brackets+"|" + is_macro

			RegEx.isMatch callback pattern IgnoreCase
		)
		
		callback = callback as string
		
		if not callbackHasArguments callback then
			callback += "()"
		
			
		callback --return
	),

	/** Get callback key for this.List
	 *
	 * @return #name E.G.: #callbackFn_nodeCreated
	 */
	function _getCallbackKey callback type =
	(
		--format "\n"; print "Callback._getCallbackName()"

		--id_string = if id != unsupplied then "_" + id as string else ""

		--( +"_"+ (type as string ) + id_string ) as name --return
		
		callback_fn = trimRight (callback as string ) "()" 
		
		(type as string +"_"+ callback_fn ) as name -- return
	),

	/**
	 */
	on create do
	(
		--format "\n"; print "CallbackManager.onCreate()"
		--for prop in #(  ) where getProperty this prop == undefined do -- CHECK CONSTRUCT PROPERTIES -- Array of this struct properties necessary to run
		--	throw ("\n\n\nUNDEFINED CONSTRUCT PROPERTY\n\n\nSTRUCT:\n\n"+ ((filterString( classof this as string )"(:")[2]) +"\n\n\nPROPERTY:\n\n"+ prop )
	)

)

/*------------------------------------------------------------------------------
  
	SET GLOBAL INSTANCE OF CallbackManager_v
	
--------------------------------------------------------------------------------*/

--if CALLBACKMANAGER == undefined then -- IMPORTANT: ENABLE THIS LINE IN PRODUCTION
	CALLBACKMANAGER = CallbackManager_v()
