/** Control params
  
  
  REMOVE THIS AND USE ONLY List_v
  
  
  
 */
struct ParamsList_v
(
	--__construct = #(  ),
	
	/* required */
	/* dependency */
	/* reference */
	/* properties */
	
	include "Library/MAXSCRIPT-UI-framework/Lib/List/ListBody.ms"

	--private
	

	/**  
	 */
	on create do
	(
		--print("ControlParams_v.onCreate()")
		--this._checkConstctructProperties()
	)
	
)
