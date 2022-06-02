filein( getFilenamePath(getSourceFileName()) + "/../ControlTypes/ControlTypes.ms" )


/** Default parameters for control types
  *
  *
  *	Parameters are used by this priority:
  *
  *		1) User defined for control type
  *		2) Global default for control type
  *		3) Global defaults for all controls
  *
 */
struct DefaultParameters_v
(
	/*
	  
		this.keys   = #( #global,	#button,	#checkbox,	... ) -- control types
		this.values = #( List,	List,	List,	... ) -- list of parameters and values for each control type
		
	*/
	include "Library/MAXSCRIPT-UI-framework/Lib/List/ListBody.ms"

	
	control_types = (ControlTypes_v()).getAllTypes(),

	/** Set default param
	 */
	function setDefaultParam key val type: =
	(
		--print ("DefaultParameters_v.setDefaultParam("+Key as string +", "+val as string +", type:#"+type as string+")")
		ParamsList = this._getParamsList(type)

		ParamsList.setVal key val
	),

	/** Set this.keys & this.values
	  *
	  * this.keys   = #( #global,	#button )		
	  * this.values = #( #(#width, 96),	#(#across, 4) )
	  *
	 */
	function setDefaultsForEachControlType =
	(
		--print "DefaultParameters_v._setDefaultsForAllTypes()"
		this._setControlTypes()
		
		this._setValuesForEachControlType()
	),

	/** Get keys for control type
	  * 
	  * @property	name	control_type	type of control for search
	  * 
	  * @return	array of matching DefaultParameters.keysto control_type E.G.:  #(#multiListBox, #listbox, #list) if control_type == #multiListBox
	 */
	function getKeysForControlType control_type =
	(
		--format "\n"; print "DefaultParameters_v._getKeysForControlType()"
		
		for control_type_key in this._keysSorted() where  matchPattern (control_type as string ) pattern:( "*" + (control_type_key as string ) + "*") collect control_type_key --return
	),
	
	/** Get parameters for control type
	 */
	function getParametersForControlType control_type =
	(
		--format "\n"; print "DefaultParameters_v.getParametersForControlType()"		
		this.getVal(control_type as name )
	),
	
	private
	

	/** Merge control types defined by user with all control types
	  * 
	  * Add #global type if not defined by user
	  */
	function _setControlTypes =
	(
		--format "\n"; print "DefaultParameters_v.setControlTypes()"
		
		control_types = control_types + this.keys
		
		appendIfUnique control_types #global
	),
	
	/** Set values of parameters for each control type
	 */
	function _setValuesForEachControlType =
	(
		--format "\n"; print "DefaultParameters_v._setValuesForEachControlType()"
		for control_type in control_types do
			this.setVal (control_type) (this._getDefaultParamsList(control_type))
	),

	/**  Sort array items from longest to shortest one
	  *	@return	array	 
	  */
	function _keysSorted =
	(
		--format "\n"; print "ControlParamsCreator_v._getControlTypesKeys()"'
		arr = sort (deepCopy keys)
		
		for i=arr.count to 1 by -1 collect arr[i]
	),
	
	/** _get params by control type
	 */
	function _getDefaultParamsList control_type =
	(
		--print "DefaultParameters_v._getDefaultParamsList()"
		--format "control_type	= % \n" control_type
		ParamsList = this._getParamsList(control_type)
		--format "ParamsList	= % \n" ParamsList
		keys_values = case control_type of
		(
			#Button:	#( #across, 4,	#width, 96 )
			#List:	#( #across, 1 )
			#Checkbox:	#( #across, 1 )
			#Edittext:	#( #across, 1 )
			--#Radiobuttons:	#( #offset, [128,0] )
			#Radiobuttons:	#( #across, 1)
			#Angle:	#( #dir, #cw)
			--#Radiobuttons:	#( #offsets, #([0,0], [0,0])  )
			#Global:	#( #across, 4 )
			--default:	#( ) -- #global
		)
		
		if( keys_values != undefined ) then
			for i = 1 to keys_values.count  by 2  do
				ParamsList.setVal keys_values[i] keys_values[i+1] unique:true
		
		--format "control_type	= % \n" control_type 
		--format "keys_values	= % \n" keys_values
		--format "ParamsList	= % \n" ParamsList
		ParamsList --return 
	),

	/** Get control class
	  *
	  * @return	#name|undefined	E.G.: return #button if control_type == #Checkbutton || #list if control_type == #multilistbox
	 */
	function _getControlTypeClass control_type type_classes =
	(
		--print "DefaultParameters_v.getControlClass()"
		rx         = dotNetClass "System.Text.RegularExpressions.RegEx"
		rx_options = dotNetClass "System.Text.RegularExpressions.RegexOptions"

		matches = rx.matches control_type type_classes rx_options.IgnoreCase

		match_groups = (for matchIdx = 0 to matches.count-1 collect for groupIdx = 0 to matches.item[matchIdx].groups.count-1 collect ( matches.item[matchIdx].groups.item[groupIdx].value )) --return
		--format "match_groups	= % \n" match_groups
		if( match_groups.count > 0 ) then
			match_groups[1][1] as name --return 
	),

	/** Get params list
	 */
	function _getParamsList control_type =
	(
		--print "DefaultParameters_v._getParamsList()"
		if( (ParamsList = this.getval control_type) == undefined ) then 
			ParamsList = this._setParamsList (control_type)

		ParamsList --return
	),
	
	/** _set params list
	 */
	function _setParamsList control_type =
	(
		--print "DefaultParameters_v._setParamsList()"
		ParamsList = List_v()

		this.setVal control_type (ParamsList)
		
		ParamsList --return	
	),

	/**  
	 */
	on create do
	(
	)

)
