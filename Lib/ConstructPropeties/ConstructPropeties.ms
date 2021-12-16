/** Test if properties of given class are not undefined
 */
struct ConstructPropeties
(
	/* properties */
	Test, -- struct for test

	private
	
	/** _check construct properties
	 */
	function _checkConstructProperties =
	(
		for prop in Test.__construct where getProperty Test prop == undefined do
			this._throwException(prop)
	),
	
	
	/** _throw exception
	 */
	function _throwException prop =
	(
		throw ("\n\n\nUNDEFINED CONSTRUCT PROPERTY\n\n\nSTRUCT:\n\n"+ (this._getStructName()) +"\n\n\nPROPERTY:\n\n"+ prop ) 
	),
	
	/** _get struct name
	 */
	function _getStructName =
	(
		(filterString( classof Test as string )"(:")[2] --return
	),
	
	/**  
	 */
	on create do
	(
		this._checkConstructProperties()
	)
)