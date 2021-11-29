
/** Defaults RENAME THIS TO ControlDefaultsList_v
 */
struct ControlDefaults_v
(
	/*
		this.keys   = #( #global,	#button )		
		this.values = #( List,	List )		
	*/ 
	
	include "Library/MAXSCRIPT-UI-framework/Lib/List/ListBody.ms"
	
	public
	
	/** Set default param
	 */
	function setDefaultParam key val type: =
	(
		print "ControlDefaults_v.setDefaultParam()"
		if( type == undefined ) then
			type = #global
		
		ParamsList = this._getParamsList(type)
		
		ParamsList.setVal key val
		--format "ParamsList	= % \n" (ParamsList)
		--format "this	= % \n" this
	),

	/** _set default params per control type
	 */
	function _setDefaultsForAllTypes =
	(
		for control_type in #(#global, #button, #checkbox  ) do
			this._setDefaultsForType(control_type)
	),
	
	/** _set defaults for type
	 */
	function _setDefaultsForType control_type =
	(
		--print "ControlDefaults_v._setDefaultsForType()"
		ParamsList = this._getDefaultParams(control_type)
		
		this.setVal control_type (ParamsList)
	),
	
	/** _get params by control type
	 */
	function _getDefaultParams control_type =
	(
		--print "ControlDefaults_v._getDefaultParams()"
		ParamsList = List_v()

		keys_values = case control_type of
		(
			#global:	#( #across, 4)
			#button:	#( #across, 4)
			#checkbox:	#( #across, 2)
		)
		
		for i = 1 to keys_values.count  by 2  do
			ParamsList.setVal keys_values[i] keys_values[i+1]
		
		ParamsList --return 
	),
	
	
	/** Get params list
	 */
	function _getParamsList control_type =
	(
		--print "ControlDefaults_v._getParamsList()"
		if( (ParamsList = this.getval control_type) == undefined ) then 
			ParamsList = List_v()
		
		--format "ParamsList	= % \n" ParamsList
		
		this.setVal control_type ParamsList
		
		ParamsList --return
	),
	
	
	
	/**  
	 */
	on create do
	(
		this._setDefaultsForAllTypes()
	)
	
)
