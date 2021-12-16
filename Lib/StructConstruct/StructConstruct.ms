/** Tet if properties of given class are not undefined
 */
struct ConstructPropeties
(
	/* properties */
	test,
	properties,

	private
	
	/** _get struct name
	 */
	function _getStructName =
	(
		(filterString( classof test as string )"(:")[2] --return
	),
	
	/**  
	 */
	on create do
	(
		for prop in properties where getProperty test prop == undefined do
			messageBox ("STRUCT:\n\n"+ (this._getStructName()) +"\n\n\nPROPERTY:\n\n"+ prop ) title:"UNDEFINED CONSTRUCT PROPERTY"
		
	)
	
)