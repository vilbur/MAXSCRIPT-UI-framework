/** Control params parser
 */
struct ControlParamsParser_v
(
	/* properties */
	params = #( #(), #() ),
	
	/** Parse params in "icon" param of macroscript
	  * 
	  * Each param is separated with pipe "|"
	  * 
	  * 
	  * @property	string	params_string	E.G.: "event: #rightclick| width:128 | height : 64|border:true|items: #('item1', 'item2')"
	  * 
	  * @return	2D matrix E.G.: #( #(param1,param2), #(value1,value2)	 )	
	 */
	function parse params_string =
	(
		format "\n"; print "ControlParamsParser_v.parse()"
		key_value_pairs = filterString params_string "|" splitEmptyTokens:false
		
		for key_value in key_value_pairs do
			this._splitKeyAndValue (key_value)
		
		params --return
	),
	
	private
	
	/** Split key and value
	 */
	function _splitKeyAndValue key_value =
	(
		--format "\n"; print "ControlParamsParser_v.splitKeyAndValue()"
		
		key_value_split = filterString key_value ":" splitEmptyTokens:false
	
		append params[1] ( this._trimWhiteSpace(key_value_split[1]) )
		
		append params[2] ( this._convertDatatype( this._trimWhiteSpace(key_value_split[2])) )
	),
	
	/** Remove leading and trailing white space
	 */
	function _trimWhiteSpace _string =
	(
		trimLeft ( trimRight _string ) --return
	),
	
	/** Format string value to valid datatype
	 */
	function _convertDatatype val =
	(		
		--print "MacroScript_Content_v._convertDatatype()"
		--format "val	= % \n" val
		if( (for pattern in #( "true", "false", "(color*", "[*,*]" ) where matchPattern val pattern:pattern collect pattern).count > 0 ) then 
			execute val
			
		else if( val as number != undefined ) then 
			val as number --return
			
		else if( matchPattern val pattern:"#(*" ) then
		(
			_array = substituteString val "'" "\"" -- replace macroscript define array paramter E.G.: items:#( 'item 1', '2' ) >>> items:#( "item 1", "2" )
		
			execute _array --return
		)
		
		else
			execute val --return
	),
	
	/**  
	 */
	on create do
	(
	)
	
)
