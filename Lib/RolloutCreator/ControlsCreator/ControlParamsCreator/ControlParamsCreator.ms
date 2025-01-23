
global CONTROL_BITMAPS_STORE = #() -- buffer for bitmaps of controls, because of bitmap cannot be converted to string passed to RolloutCreator

/** Control Params http://help.autodesk.com/view/3DSMAX/2016/ENU/?guid=__files_GUID_EA37E7DB_1E74_4377_B3D8_EDAE19CE27E7_htm
  * 
  * ControlParams_v set parameters of control
  * 
 */
struct ControlParamsCreator_v
(
	/* inherit */
	DefaultParameters, -- defaults parameters for controls
	
	/* dependency */
	ParamsListMerged,

	/* properties */ 
	
	/** Get params for control
	  * 
	  * Priority of params
	  * 	1) User Defined parameters
	  * 	2) Global per control type E.g.:  #(#multiListBox, #listbox, #list) // DEFINED IN DefaultParameters_v._getDefaultParamsList() in FILE:  "./../../../Dialog/Rollout/Controls/DefaultParameters/DefaultParameters.ms" 
	  * 	3) Global for all controls
	  * 
	 */
	function mergeParams &_Control =
	(
		--format "\n"; print "ContolParamsCreator_v.mergeParams()"
		/* DEFAULTS PARMAS */ 
		for control_type_key in DefaultParameters.getKeysForControlType(_Control.type) do
			_Control.Params.merge ( DefaultParameters.getParametersForControlType(control_type_key) )
		
		/* MERGE Defaults.keys.#global */
		if _Control.type != #Groupbox then -- DO NOT USE GLOBAL PARAMETERS ON #groupbox control
			_Control.Params.merge ( DefaultParameters.getVal(#global) )
		
		_Control --return
	),
	
	/** Set DefaultParameters_v from Controls_v
	 */
	function setDefaultParameters DefaultParameters =
	(
		--print "ControlParamsCreator_v.setDefaultParameters()"
		this.DefaultParameters = DefaultParameters
		
		this.DefaultParameters.setDefaultsForEachControlType()
	),
	
	/** Join array
	 */
	function join List =
	(
		if( List == undefined ) then
			return ""
		
		--print "\nHOTFIX Params_v.join()"
		_params = ""
		
		for k=1 to List.keys.count do
			_params += List.keys[k] as string +":"+ ( this._formatToString List.keys[k] List.values[k] ) + " "
			
		trimRight _params  --return
	),

	
	private


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
		CONTROL_BITMAPS_STORE = #() -- reset buffer array
	)
)