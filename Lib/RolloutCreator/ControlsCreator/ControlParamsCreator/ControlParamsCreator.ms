
global CONTROL_BITMAPS_STORE = #() -- buffer for bitmaps of controls, because of bitmap cannot be converted to string passed to RolloutCreator

/** Control Params http://help.autodesk.com/view/3DSMAX/2016/ENU/?guid=__files_GUID_EA37E7DB_1E74_4377_B3D8_EDAE19CE27E7_htm
  * 
  * ControlParams_v set parameters of control
  * 
 */
struct ControlParamsCreator_v
(
	/* inherit */
	Defaults, -- defaults parameters for controls
	
	/* dependency */
	--ParamsListMerged,

	/* properties */ 
	
	/** Get params for control
	  * 
	  * Priority of params
	  * 	1) User Defined parameters
	  * 	2) By type of control E.g.:  #(#multiListBox, #listbox, #list) // DEFINED IN DefaultParameters_v._getDefaultParamsList() in FILE:  "./../../../Dialog/Rollout/Controls/Defaults/Defaults.ms" 
	  * 	3) Global for all controls
	  * 
	 */
	function mergeDefaultParams &_Control =
	(
		--format "\n----------------------------------------------\n"
		--format "\n"; print "ContolParamsCreator_v.mergeDefaultParams()"
		--format "% PARAMS: %\n" _Control.id _Control.Params
		
		/* DEFAULTS PARAMS FOR CONTROL TYPE */ 
		this._mergeDictionaries (_Control)(Defaults.Params[_Control.type])
		
		/* GLOBAL PARAMS */
		this._mergeDictionaries (_Control)(Defaults.Params[#GLOBAL])
		
		_Control --return
	),
	
	/** Set DefaultParameters_v from Controls_v
	 */
	function setDefaultParameters Defaults =
	(
		--print "ControlParamsCreator_v.setDefaultParameters()"
		this.Defaults = Defaults
		
		--this.Defaults.setDefaultsForEachControlType()
	),
	
	/** Join array
	 */
	function join List =
	(
		params_string = ""
		
		if List != undefined then
			for key in List.keys do
				params_string += key as string +":"+ ( this._formatToString key List[key] ) + " "
			
		trimRight params_string  --return
	),

	
	private

	/** Merge params
	  * 
	  * Old values are not overwritten
	 */
	function _mergeDictionaries &_Control params_to_merge =
	(
		--format "\n"; print "ControlParamsCreator_v._mergeDictionaries()"
		for key in params_to_merge.keys do
		(
			--format "\n\n_Control: %\n" _Control.id
			--format "% : %\n" key (not(_Control.hasParam(key)))
			
			--format "WIDTH: %\n" (_Control.Params[#WIDTH])
			
			if not _Control.hasParam(key) then
				_Control.Params[key] = params_to_merge[key]
			
			--format "WIDTH: %\n" (_Control.Params[#WIDTH])
		)

		_Control --return
	),

	/** Format value to string
	  *
	  * @return	string	
	 */
	function _formatToString key val =
	(
		--print ("Params_v._formatToString() " + val as string )
		
		/** Stringify array
		  *
		  * Workoraund for "as string"
		  * "as string" works only for array with max 20 items
		  * https://help.autodesk.com/view/3DSMAX/2015/ENU/?guid=__files_GUID_92B98D11_60FF_4742_A1BA_692EE135E085_htm
		  *
		  * @return	string	
		  */
		function _stringifyArray arr =
		(
			if( arr.count > 20 ) then
			(
				items_string = ""
				
				for item in arr do items_string += "\"" + item + "\","
				
				"#("+( trimRight items_string ",")+")" --return
			)
			else
				arr as string --return
		)
		
		classof_val = classOf val
		
		/* CONVERT EACH DATATYPE TO STRING */ 
		if( classof_val == name ) then
			val = "#" + val as string -- Add "#" prefix to name
		
		else if( classof_val == string  and key != #BITMAP  ) then
			val = "\"" + val +"\"" -- Wrap string to escaped qoutes \"\"
			
		else if( classof_val == Array ) then
			val = _stringifyArray val -- Wrap string to escaped qoutes \"\"
			
		else if key == #BITMAP then 
		(
			append CONTROL_BITMAPS_STORE val
			
			val = "CONTROL_BITMAPS_STORE["+CONTROL_BITMAPS_STORE.count as string +"]"
		)
		
		val as string --return
	),


	on create do
	(
		--print "ControlParamsCreator_v.onCreate()"
		--CONTROL_BITMAPS_STORE = #() -- reset buffer array
	)
)