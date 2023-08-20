/** Default control callbacks
 */
struct DefaultControlCallbacks_v
(
	/* construct */


	/* properties */


	/* dependency */
	/* reference */
	/* inhered */
	/** Get default event
	  *
	  */
	function getDefaultCallback _Control event_type =
	(
		format "\n"; print "DefaultControlCallbacks_v.getDefaultEvent()"

		if event_type == #pressed then
		"print \"DEAFAULT CVALLBACK\";" --return

	),


	private


	/**
	 */
	on create do
	(
		--format "\n"; print "DefaultControlCallbacks.onCreate()"
		--for prop in #(  ) where getProperty this prop == undefined do -- CHECK CONSTRUCT PROPERTIES -- Array of this struct properties necessary to run
		--	throw ("\n\n\nUNDEFINED CONSTRUCT PROPERTY\n\n\nSTRUCT:\n\n"+ ((filterString( classof this as string )"(:")[2]) +"\n\n\nPROPERTY:\n\n"+ prop )

	)

)
