filein( getFilenamePath(getSourceFileName()) + "/BrowsePath/BrowsePath.ms" )	-- "./BrowsePath/BrowsePath.ms"
filein( getFilenamePath(getSourceFileName()) + "/RadioButtons/RadioButtons.ms" )	-- "./RadioButtons/RadioButtons.ms"

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
	function getDefaultEvent _Control event_type =
	(
		--format "\n"; print "DefaultControlCallbacks_v.getDefaultEvent()"
		--format " _Control.type:	% \n" _Control.type

		if( _Control.type == #browsePath ) then
			(BrowsePath_v()).getEvent(_Control)(event_type)-- "./../../ControlTypes/BrowsePath/BrowsePath.ms"

		else if( _Control.type == #RadioButtons ) then
			(RadioButtons_v()).getEvent(_Control)(event_type)-- "./../../ControlTypes/BrowsePath/BrowsePath.ms"
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
