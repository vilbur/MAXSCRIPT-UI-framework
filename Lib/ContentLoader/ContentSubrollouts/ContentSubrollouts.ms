/** 
 *
 */
struct ContentSubrollouts_v
(
	/* required properties */
	path,

	/*  properties */
	slot,
	Rollouts	= #(),

	/* dependency */
	RolloutParrent,

	/** Add to ui
	 */
	function addToUi _Rollout =
	(
		--print ("ContentSubrollouts_v.addToUi() " + (filenameFromPath path) )
		local Subrollouts = _Rollout.subrollouts slot:slot

		for ContentRollout in Rollouts do
			ContentRollout.addToUi Subrollouts
	),

	/** Set slot name
	 */
	function _setSlot =
	(
		--format "\n"; print ("ContentSubrollouts_v._setSlot()")
		slot = filenameFromPath path

		slot = trimLeft slot  "rollouts-"

		slot = ( dotNetObject "System.Text.RegularExpressions.Regex" @"[^A-Za-z0-9_]" ).Replace slot ""
	),

	/** _set rollouts
	 */
	function _setRollouts paths =
	(
		for path in paths do 
			append Rollouts ( RolloutParrent.new path )
	),

	on create do
	(
		--print ("ContentSubrollouts_v.onCreate	" + path )
		this._setSlot()

		PathsLoader = PathsLoader_v path:path

		PathsLoader.fileInMaxscriptFiles()

		this._setRollouts( PathsLoader.rollout_dirs )
	)
)