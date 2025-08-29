filein( getFilenamePath(getSourceFileName()) + "/../ControlTypes/ControlTypes.ms" )	-- "./../ControlTypes/ControlTypes.ms"

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
	--include "MAXSCRIPT-UI-framework/Lib/List/ListBody.ms"

	--ParamsByControlType = Dictionary(),
	Params	=  Dictionary(), -- 2D Dictionary: #( #GLOBAL, #( #PARAM, VALUE ) )

	/** Set default param
	 */
	function setParam key val type:undefined  =
	(
		--print ("DefaultParameters_v.setParam("+Key as string +", "+val as string +", type:#"+type as string+")")
		if type == undefined then
			type = #GLOBAL
		
		Params[type][key] = val
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
		Params[control_type].keys --return
		--for control_type_key in sort this._keysSorted() where  matchPattern (control_type as string ) pattern:( "*" + (control_type_key as string ) + "*") collect control_type_key --return
	),

	/** Get parameters for control type
	 */
	function getParametersForControlType control_type =
	(
		--format "\n"; print "DefaultParameters_v.getParametersForControlType()"
		Params[control_type]
	),

	private

	--/** Get control class
	--  *
	--  * @return	#name|undefined	E.G.: return #button if control_type == #Checkbutton || #list if control_type == #multilistbox
	-- */
	--function _getControlTypeClass control_type type_classes =
	--(
	--	--print "DefaultParameters_v.getControlClass()"
	--	rx         = dotNetClass "System.Text.RegularExpressions.RegEx"
	--	rx_options = dotNetClass "System.Text.RegularExpressions.RegexOptions"
	--
	--	matches = rx.matches control_type type_classes rx_options.IgnoreCase
	--
	--	match_groups = (for matchIdx = 0 to matches.count-1 collect for groupIdx = 0 to matches.item[matchIdx].groups.count-1 collect ( matches.item[matchIdx].groups.item[groupIdx].value )) --return
	--	--format "match_groups	= % \n" match_groups
	--	if( match_groups.count > 0 ) then
	--		match_groups[1][1] as name --return
	--),

	/** _get params by control type
	 */
	function _setDefaultParams =
	(
		--print "DefaultParameters_v._setDefaultParams()"
		--format "control_type	= % \n" control_type
		--format "Params: %\n" Params
		--format "this.Params: %\n" this.Params
		--ParamsList = this._getParamsList(control_type)
		--ParamsList = Dictionary()

		/* GET ALL CONTROL TYPES */ 
		all_control_types = (ControlTypes_v()).list + #(#GLOBAL)
		
		
		/* INIT DICTIONARIES OF PARAMS FOR EACH CONTROL TYPE*/ 
		for control_type in all_control_types do
			Params[control_type] = Dictionary()
		
		/* GLOBAL ACROSS PARAMETER  */ 
		Params[#Global][#ACROSS] = 4
		

		/* ACROSS PARAMS FOR CONTROL TYPE */
		for control_type in #( #Listbox, #Edittext, #BrowsePath, #Radiobuttons ) do
			Params[control_type][#ACROSS] = 1
		
		
		/* PARAMS BY TYPE */ 
		for type in Params.keys do
			case type of
			(
				#BUTTON:	Params[type][#WIDTH] = 96
	
				#SLIDER:	Params[type][#RANGE] = [0,100,0]
				
				#EDITTEXT:	Params[type][#FIELDWIDTH] = 96

				#SPINNER:
				(
					Params[type][#FIELDWIDTH] = 48
					
					Params[type][#DIR] = #CW
					
					Params[type][#RANGE] = [0,100,0]
					
					Params[type][#STARTDEGREES] = [0,100,0]
				)
		)
	),

	/**
	 */
	on create do
	(
		this._setDefaultParams()
	)
)
