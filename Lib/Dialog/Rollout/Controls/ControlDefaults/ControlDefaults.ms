
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
		control_types = include "Library/MAXSCRIPT-UI-framework/Lib/Dialog/Rollout/Controls/control_types.ms"

		--for control_type in #(#global, #button, #list  ) do
		for control_type in control_types do
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
		--format "control_type	= % \n" control_type
		ParamsList = List_v()
		
		keys_values = case this._getControlTypeClass(control_type)("button|list") of
		(
			#button:	#( #across, 4,	#width, 96 )
			#list:	#( #across, 1 )
			default:	#( #across, 2) -- #global
		)
		
		for i = 1 to keys_values.count  by 2  do
			ParamsList.setVal keys_values[i] keys_values[i+1]
		
		ParamsList --return 
	),
	
	/** Get control class
	  *
	  * @return	#name|undefined	E.G.: return #button if control_type == #Checkbutton || #list if control_type == #multilistbox
	 */
	function _getControlTypeClass control_type type_classes =
	(
		--print "ControlDefaults_v.getControlClass()"
		rx         = dotNetClass "System.Text.RegularExpressions.RegEx"
		rx_options = dotNetClass "System.Text.RegularExpressions.RegexOptions"
	
		matches = rx.matches control_type type_classes rx_options.IgnoreCase
		
		match_groups = (for matchIdx = 0 to matches.count-1 collect for groupIdx = 0 to matches.item[matchIdx].groups.count-1 collect ( matches.item[matchIdx].groups.item[groupIdx].value )) --return
		
		if( match_groups.count > 0 ) then
			match_groups[1][1] as name --return 
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
