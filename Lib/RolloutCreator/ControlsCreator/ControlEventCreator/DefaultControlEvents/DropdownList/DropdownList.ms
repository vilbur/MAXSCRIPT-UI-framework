/** Dropdown list
 */
struct DropdownList_v
(
	/* construct */
	
	/* required */
	
	/* properties */
	
	
	/* private */
	/* dependency */
	/* reference */
	/* inhered */
	
	/** Set height by items count
	 */
	function setHeightByItemsCount _Control =
	(
		--format "\n"; print "DropdownList_v.setHeightByItemsCount()"
		--format "_Control.Params[#ITEMS]: %\n" _Control.Params[#ITEMS]
		--format "_Control.Params[#HEIGHT]: %\n" _Control.Params[#HEIGHT]
		
		/* IF ITEMS EXISTS BUT HEIGHT PARAM NOT */ 
		if _Control.Params[#ITEMS] != undefined and _Control.Params[#HEIGHT] == undefined then
			_Control.Params[#HEIGHT] = _Control.Params[#ITEMS].count + 1
	),
	
	private
	

	/**
	 */
	on create do
	(
		--format "\n"; print "DropdownList.onCreate()"
		--for prop in #(  ) where getProperty this prop == undefined do -- CHECK CONSTRUCT PROPERTIES -- Array of this struct properties necessary to run
		--	throw ("\n\n\nUNDEFINED CONSTRUCT PROPERTY\n\n\nSTRUCT:\n\n"+ ((filterString( classof this as string )"(:")[2]) +"\n\n\nPROPERTY:\n\n"+ prop )
	)

)
