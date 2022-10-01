/** Key press
 */
struct KeyPress_v
(
	/* construct */
	
	
	/* properties */
	mod_keys = #(),
	
	/* dependency */
	/* reference */
	/* inhered */
	
	/** Test
	 */
	function add ctrl: =
	(
		--format "\n"; print "KeyPress_v.test()"
		format "\n"; print ("KEYPRESS_V.TEST ")
	),
	
	private
	
	
	/**  
	 */
	on create do
	(
		format "\n"; print "KeyPress.onCreate()"
		--for prop in #(  ) where getProperty this prop == undefined do -- CHECK CONSTRUCT PROPERTIES -- Array of this struct properties necessary to run
		--	throw ("\n\n\nUNDEFINED CONSTRUCT PROPERTY\n\n\nSTRUCT:\n\n"+ ((filterString( classof this as string )"(:")[2]) +"\n\n\nPROPERTY:\n\n"+ prop ) 
	)
	
)
