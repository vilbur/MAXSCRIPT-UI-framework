
/** Defaults RENAME THIS TO ControlDefaultsList_v
 */
struct ControlDefaults_v
(
	--__construct = #(  ),
	
	/* required */
	/* dependency */
	/* reference */
	/* properties */
	
	/*
	
	
	keys   = #( #global,	#button )		
	values = #( List,	List )		
	
	
	*/ 
	
	include "Library/MAXSCRIPT-UI-framework/Lib/List/ListBody.ms"
	
	public
	
	/** Set default param
	 */
	function setDefaultParam key val type: =
	(
		print "ControlDefaults_v.setDefaultParam()"
		
		ParamsList = this._getParamsList(type)
		
		ParamsList.setVal key val
		--format "ParamsList	= % \n" (ParamsList)
		--format "this	= % \n" this
	),
	
	/** Get params list
	 */
	function _getParamsList type =
	(
		--print "ControlDefaults_v._getParamsList()"
		if( (ParamsList = this.getval type) == undefined ) then 
			ParamsList = List_v()
		
		--format "ParamsList	= % \n" ParamsList
		
		this.setVal type ParamsList
		
		ParamsList --return
	),
	
	
	
	/**  
	 */
	on create do
	(
		--print("Defaults_v.onCreate()")
	)
	
)
