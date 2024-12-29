
filein( getFilenamePath(getSourceFileName()) + "/Callback/Callback.ms" )	--"./Callback/Callback.ms"


/* CALLBACKMANAGER is global singleton instance

	It can be used by mutliple scripts at once

*/ 
if CALLBACKMANAGER == undefined then 
	global CALLBACKMANAGER

/*
  	[callback types]https://help.autodesk.com/view/3DSMAX/2015/ENU/?guid=__files_GUID_C1F6495F_5831_4FC8_A00C_667C5F2EAE36_htm
 */
struct CallbackManager_v
(
	/* construct */

	/* properties */
	List = Dictionary(), -- KEY: callback_fn_callback_type VALUE:Callback_v

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
		format "\n"; print "Callback_v.import()"
		for callback_subdir in  getDirectories (dir + "/*") recurse:true do
			for callback_file in getFiles (callback_subdir + "/*.ms") do
			(
				--format "callback_subdir: %\n" callback_subdir
				type = getFilenameFile( trimRight callback_subdir "\\" )
				--format "type: %\n" type
				callback = getFilenameFile( callback_file )
				--format "callback: %\n" callback
				filein callback_file
				
				this.add callback type
			)
	),
	
	/** Add Callback
	  *
	  */
	function add callback_fn type id: =
	(
		format "\n"; print "CallbackManager_v.add()"
		format "callback_fn:	% \n" callback_fn
		format "type:	% \n" type

		callback_key = this._getCallbackKey (callback_fn)(type)(id)

		this.List[callback_key] = Callback_v callback:(this._getCallbackFn (callback_fn)) type:type id:( if id == unsupplied then callback_key else id )

		--this.startCallback (this.List[callback_key])
	),

	/** Add Callback
	  *
	  * @retrun #(Callback_v) removed callbacks
	  */
	function remove callback: type: id: =
	(
		--format "\n"; print "CallbackManager_v.remove()"
		_Callbacks = this.getCallbacks callback:callback type:type id:id

		--format "_Callbacks	= % \n" _Callbacks
		--format "\n\n------------------------------------\n\n"

		if _Callbacks != undefined then
			for _Callback in _Callbacks do
				this.kill (_Callback)

		_Callbacks --return
	),

	/** Get callbacks
	 *
	 * @return #(Callback_v)
	 */
	function getCallbacks callback: type: id: =
	(
		--format "\n"; print "Callback_v.getCallback()"
		--format "\n\n------------------------------------\n\n"

		/** Get callback by type
		 */
		function getCallbackByProperty key val option_key:undefined option_val:undefined =
		(
			for dataPair in this.List
				where getProperty dataPair.value key == val and ( if option_val != undefined then getProperty dataPair.value option_key == option_val else true )
					collect dataPair.value
		)


		callback_exist	= callback	!= unsupplied
		type_exist	= type	!= unsupplied
		id_exist	= id	!= unsupplied

		callback = (this._getCallbackFn(callback))

		if not ( callback_exist and type_exist and id_exist ) then
			case of
			(
				/*------ GET BY MULTIPLE PARAMS ------*/
				(callback_exist and type_exist ):	getCallbackByProperty(#type)	(type)	option_key:#type	option_val:type
				(callback_exist and id_exist ):	getCallbackByProperty(#callback)	(callback)	option_key:#id	option_val:id
				(type_exist     and id_exist ):	getCallbackByProperty(#type)	(type)	option_key:#id	option_val:id

				--/*------ GET BY SINGLE PARAM ------*/
				(callback_exist ):	getCallbackByProperty(#callback)	(callback)
				(type_exist ):	getCallbackByProperty(#type)	(type)
				(id_exist ):	getCallbackByProperty(#id)	(id)
				
				default: for key in this.List.keys collect this.List[key]
			)
		else
			/*------ GET BY ALL PARAMS ------*/
			#( this.List[this._getCallbackKey (callback)(type)(id)] )
	),
	
	/** Start
	 */
	function start callback: type: id: =
	(
		--format "\n"; print "Callback_v.start()"
		_Callbacks = this.getCallbacks callback:callback type:type id:id

		for Callback in _Callbacks do 
			this.startCallback (Callback)
	),
	
	/** Kill
	 */
	function kill callback: type: id: =
	(
		--format "\n"; print "Callback_v.start()"
		_Callbacks = this.getCallbacks callback:callback type:type id:id

		for Callback in _Callbacks do 
			this.killCallback (Callback)
	),
	
	/** Start
	 */
	function startCallback Callback =
	(
		format "\n"; print ("CallbackManager_v.startCallback( "+Callback.id+" )")
		--format "CallbackManager_v.START TYPE:% CALLBACK:% ID:% \n\n" Callback.type Callback.callback Callback.id
		callbacks.addScript Callback.type Callback.callback id:Callback.id
	),
	
	/** Kill
	 *
	 */
	function killCallback Callback =
	(
		format "\n"; print ("CallbackManager_v.killCallback( "+Callback.id+" )")
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
		--format "\n"; print "Callback._getCallbackName()"
		--if not matchPattern (callback) pattern:@"pattern"ignoreCase:false then

		( trimRight ( callback as string ) "()" ) + "()" --return
	),

	/** Get callback key for this.List
	 *
	 * @return #name E.G.: #callbackFn_nodeCreated
	 */
	function _getCallbackKey callback type id =
	(
		--format "\n"; print "Callback._getCallbackName()"

		id_string = if id != unsupplied then "_" + id as string else ""

		(( trimRight (callback as string ) "()" ) +"_"+ (type as string ) + id_string ) as name --return
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
