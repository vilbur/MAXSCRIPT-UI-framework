filein( getFilenamePath(getSourceFileName()) + "/../ControlTypes/ControlTypes.ms" )


/** Defaults RENAME THIS TO ControlsDefaults_v
  *
  *	Priority of default parameters 
  *
  *		1) User defined for control type
  *		2) Global default per control type
  *		3) Global defaults for all controls
  *
 */
struct ControlDefaults_v
(
	/*
		this.keys   = #( #global,	#button )		
		this.values = #( List,	List )		
	*/
	include "Library/MAXSCRIPT-UI-framework/Lib/List/ListBody.ms"

	
	control_types = (ControlTypes_v()).getAllTypes(),

	/** Set default param
	 */
	function setDefaultParam key val type: =
	(
		--print ("ControlDefaults_v.setDefaultParam("+Key as string +", "+val as string +", type:#"+type as string+")")
		ParamsList = this._getParamsList(type)

		ParamsList.setVal key val
	),

	/** Set this.keys & this.values
	  *
	  * this.keys   = #( #global,	#button )		
	  * this.values = #( #(#width, 96),	#(#across, 4) )
	  *
	 */
	function setDefaultsForAllTypes =
	(
		--print "ControlDefaults_v._setDefaultsForAllTypes()"
		
		append control_types #global
		
		control_types = control_types + this.keys
		
		for default_key in control_types do
			this.setVal (default_key) (this._getDefaultParamsList(default_key))
	),

	
	private
	
	
	/** _get params by control type
	 */
	function _getDefaultParamsList default_key =
	(
		--print "ControlDefaults_v._getDefaultParamsList()"
		ParamsList = this._getParamsList(default_key)
		--format "ParamsList	= % \n" ParamsList
		keys_values = case default_key of
		(
			#button:	#( #across, 4,	#width, 96 )
			#list:	#( #across, 1 )
			#checkbox:	#( #across, 1 )
			#edittext:	#( #across, 1 )
			--#global:	#( #across, 4 )
			--#global:	#( #border, false )
			--default:	#( ) -- #global
		)
		
		if( keys_values != undefined ) then
			for i = 1 to keys_values.count  by 2  do
				ParamsList.setVal keys_values[i] keys_values[i+1] unique:true
		
		--format "default_key	= % \n" default_key 
		--format "keys_values	= % \n" keys_values
		--format "ParamsList	= % \n" ParamsList
		ParamsList --return 
	),

	/** Get control class
	  *
	  * @return	#name|undefined	E.G.: return #button if default_key == #Checkbutton || #list if default_key == #multilistbox
	 */
	function _getControlTypeClass default_key type_classes =
	(
		--print "ControlDefaults_v.getControlClass()"
		--format "default_key	= % \n" default_key
		rx         = dotNetClass "System.Text.RegularExpressions.RegEx"
		rx_options = dotNetClass "System.Text.RegularExpressions.RegexOptions"

		matches = rx.matches default_key type_classes rx_options.IgnoreCase

		match_groups = (for matchIdx = 0 to matches.count-1 collect for groupIdx = 0 to matches.item[matchIdx].groups.count-1 collect ( matches.item[matchIdx].groups.item[groupIdx].value )) --return
		--format "match_groups	= % \n" match_groups
		if( match_groups.count > 0 ) then
			match_groups[1][1] as name --return 
	),

	/** Get params list
	 */
	function _getParamsList default_key =
	(
		--print "ControlDefaults_v._getParamsList()"
		if( (ParamsList = this.getval default_key) == undefined ) then 
			ParamsList = this._setParamsList (default_key)

		ParamsList --return
	),
	
	/** _set params list
	 */
	function _setParamsList default_key =
	(
		--print "ControlDefaults_v._setParamsList()"
		ParamsList = List_v()

		this.setVal default_key (ParamsList)
		
		ParamsList --return	
	),

	/**  
	 */
	on create do
	(
	)

)
