filein( getFilenamePath(getSourceFileName()) + "/EventsList/EventsList.ms" )
filein( getFilenamePath(getSourceFileName()) + "/Controls/Controls.ms" )
filein( getFilenamePath(getSourceFileName()) + "/Subrollouts/Subrollouts.ms" )

/** Rollout 
 */
struct Rollout_v
(
	/* required */
	title,
	id,
	
	/* properties */
	parent_rollout,
	
	/* dependency */
	_Controls = #(),
	Events    = EventsList_v(),
	
	/* extended control params */ 
	add_locals	= #(),	-- #(#variable_name1, init_value1, #variable_name2, init_value2)	// used in ControlCreator_v._addLocalVariablesToRollout 	"../../../RolloutCreator/ControlCreator/ControlCreator.ms"
	add_text,		-- string added to rollout	// used in ControlCreator_v._addFunctionsVariablesToRollout	"../../../RolloutCreator/ControlCreator/ControlCreator.ms"

	_RolloutCreator, -- Maxscript native RolloutCreator  https://help.autodesk.com/view/3DSMAX/2016/ENU/?guid=__files_GUID_5FC5036F_E2D7_46C9_9AFA_7B3550B9F254_htm

	/* inhered */ 
	Layout,

	/** Controls
	 */
	function Controls group:undefined =
	(
		--print "Rollout_v.controls()"
		local Controls = Controls_v group:group

		append _Controls Controls

		Controls --return
	),

	/** Get Subrollouts for rollout
	 */
	function Subrollouts slot: =
	(
		--print "Rollout_v.subrollouts()"
		local Subrollouts = Subrollouts_v parent_rollout:id slot:(this._getSubrolloutsSlot(slot)) 

		append _Controls Subrollouts

		Subrollouts --return
	),

	/** Subrollouts
	  *
	  * Alias for user friedly coding
	 */
	function Rollouts =
	(
		this.Subrollouts() --return
	),
	
	/** Rolloutcreator begin
	  *
	  * @param	integer	width of rollout, needed to center rollout title
	  *
	 */
	function rolloutCreatorBegin width =
	(
		--print "Rollout_v.rolloutcreatorBegin()"
		_RolloutCreator = rolloutCreator id (this._setTitleCenter(width))

		_RolloutCreator.begin()
	),

	/** Addlocal
	 */
	function addlocal ke val =
	(
		--print "Rollout_v.addlocal()"
		append add_locals key
		append add_locals val
	),

	/** Add text
	 */
	function addText text =
	(
		--print "Rollout_v.addText()"
		add_text += text
	),

	/** Get full id to roll 
	 */
	function getFullId =
	(
		if ( parent_rollout != undefined ) then
			parent_rollout +"."+ id as string --return 
		
		else
			id as string --return
	),
	
	private

	/** Center rollout title with empty space prefix
	 */
	function _setTitleCenter width =
	(
		--print "Rollout_v._setTitleCenter()"
		--format "width	= % \n" width
		prefix = ""
		dashes = ""

	if( width != undefined  and (max_version = (maxVersion())[8] )!= undefined and max_version > 2020  ) then
	(
		prefix = ""

		total_length = 20

		/**
				KEEP TITTLE IN THE MIDDLE IS MAGIC ROCKET SCIENCE

				VALUEs aRE lonG TIME TUNED ;)
		  */
		difference = ceil((total_length - title.count)/2) -- get difference in length of characters, longer title has shorter prefix and vice versa

		width_divider = if( width >= 600  ) then 9  -- divide rollout of each length by different divider
					else if( width >= 400  ) then 12
					else if( width <= 250  ) then 40
					else 20

		for i = 1 to floor (width/width_divider) + difference * 2.5 do -- too width 200px
			prefix +=" "

		prefix + dashes +""+ title +"" +dashes--return
	)
	else		
		title
	),

	/** _get slot
	 */
	function _getSubrolloutsSlot slot =
	(
		if slot == unsupplied then 
			slot = "subrollouts_"+( subrollouts_count = (for _struct in _Controls where matchPattern (classof _struct as string ) pattern:@"*Subrollouts_v*" collect _struct).count + 1) as string

		slot as name --return 
	),

	/** Set id by title if not defined
	 */
	function _setId =
	(
		if ( id == undefined or id == unsupplied ) then
		(
			id  = "ROLLOUT_" + title

			id = substituteString ( trimRight ( trimLeft id )) " " "_" -- replace whitespace with underscore

			id = this._repleaceCharacters "[^A-Za-z0-9_]+" "" -- remove invalid characters E.G.: "Butt@n_&_1" >>> "Button_1"

			id = this._repleaceCharacters "[_]+" "_" -- remove multiple underscores E.G.: "button___1" >>> "button_1"
		)
		
		id = id as name
	),

	/** _repleace string
	 */
	function _repleaceCharacters search replace =
	(
		( dotNetObject "System.Text.RegularExpressions.Regex" search ).Replace ( id ) replace  --return 
	),
	/**  
	 */
	on create do
	(
		--print "Rollout_v.onOpen()"
		this._setId()
	)
)