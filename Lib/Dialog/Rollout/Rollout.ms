filein( getFilenamePath(getSourceFileName()) + "/Controls/Controls.ms" )	-- "./Controls/Controls.ms"
filein( getFilenamePath(getSourceFileName()) + "/Subrollouts/Subrollouts.ms" )	-- "./Subrollouts/Subrollouts.ms"
filein( getFilenamePath(getSourceFileName()) + "/RolloutResizer/RolloutResizer.ms" )	-- "./RolloutResizer/RolloutResizer.ms"

/** Rollout
 */
struct Rollout_v
(
	rolledup, -- if undefined then ini is used, if ini undefined then subbrollout is open on init

	include "MAXSCRIPT-UI-framework/Lib/Dialog/Rollout/RolloutBody.ms" --"./RolloutBody.ms"

	/**
	 */
	on create do
	(
		--format "\n"; print "Rollout_v.onCreate()"
		for prop in #( #title ) where getProperty this prop == undefined do -- CHECK CONSTRUCT PROPERTIES -- Array of this struct properties necessary to run
			throw ("\n\n\nUNDEFINED CONSTRUCT PROPERTY\n\n\nSTRUCT:\n\n"+ ((filterString( classof this as string )"(:")[2]) +"\n\n\nPROPERTY:\n\n"+ prop )

		this._setId()

		--title = (title + " nested: " + (this.getNestedLevel()) as string )
	)
)