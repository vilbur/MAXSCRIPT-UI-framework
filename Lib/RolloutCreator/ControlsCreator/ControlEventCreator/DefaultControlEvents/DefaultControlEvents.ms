filein( getFilenamePath(getSourceFileName()) + "/BrowsePath/BrowsePath.ms" )	-- "./BrowsePath/BrowsePath.ms"
filein( getFilenamePath(getSourceFileName()) + "/RadioButtons/RadioButtons.ms" )	-- "./RadioButtons/RadioButtons.ms"
filein( getFilenamePath(getSourceFileName()) + "/Slider/Slider.ms" )	-- "./Slider/Slider.ms"

/** Default control events
 */
struct DefaultControlEvents_v
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

		case _Control.type of
		(
			#BROWSEPATH:	(BrowsePath_v()).getEvent(_Control)(event_type)	-- "./BrowsePath/BrowsePath.ms"
			#RADIOBUTTONS:	(RadioButtons_v()).getEvent(_Control)(event_type)	-- "./RadioButtons/RadioButtons.ms"
			#SLIDER:	(Slider_v()).getEvent(_Control)(event_type)	-- "./Slider/Slider.ms"
		)

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
