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
	/* extended control params */ 
	add_locals	= #(),	-- #(#variable_name1, init_value1, #variable_name2, init_value2)	// used in ControlCreator_v._addLocalVariablesToRollout 	"../../../RolloutCreator/ControlCreator/ControlCreator.ms"
	add_text,		-- string added to rollout	// used in ControlCreator_v._addFunctionsVariablesToRollout	"../../../RolloutCreator/ControlCreator/ControlCreator.ms"

	is_subrollout = false,
	
	/* dependency */
	_Controls = #(),
	Events    = EventsList_v(),
	
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
	function Subrollouts =
	(
		--print "Rollout_v.subrollouts()"
		local Subrollouts = Subrollouts_v slot:(this._getSlot())
		
		append _Controls Subrollouts
		
		Subrollouts --return
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
	
	/** Subrollouts
	  *
	  * wrapper for user friedly coding
	 */
	function Rollouts =
	(
		this.Subrollouts() --return
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
		
	if( (max_version = (maxVersion())[8] )!= undefined and max_version > 2020  ) then
	(
		prefix = ""

		total_length = 20
		
		difference = ceil((total_length - title.count)/2) -- center
	
			
		for i = 1 to floor (width/12) + difference do
			prefix +=" "


		for i = 1 to  (difference* 0.5 ) do
			dashes +="—"
	
		prefix + dashes +""+ title +"" +dashes--return
	)
	else		
		title
	),
	
	/** _get slot
	 */
	function _getSlot =
	(
		--print "Rollout_v._getSlot()"
		local subrollouts = for _struct in _Controls where matchPattern (classof _struct as string ) pattern:@"*Subrollouts_v*" collect _struct 

		("slot_"+id+"_"+(subrollouts.count+1) as string ) --return
	),
	
	/** Set id by title if not defined
	 */
	function _setId =
	(
		if ( id == undefined or id == unsupplied ) then
		(
			id  = title
			
			id	= trimRight ( trimLeft id )
			
			id = substituteString id " " "_" -- replace whitespace with underscore
			
			id = this._repleaceCharacters "[^A-Za-z0-9_]+" "" -- remove characters E.G.: "Butt@n_&_1" >>> "Button_1"
			
			id = toUpper ( type as string ) + "_" + id -- add prefix by control type E.G.: "test" >>> "BUTTON_test"
		
			id = this._repleaceCharacters "[_]+" "_" -- remove underscores E.G.: "button___1" >>> "button_1"

			--print "RolloutCreator_v._setId()"
			id = "ROLLOUT_" + (( dotNetObject "System.Text.RegularExpressions.Regex" @"[^A-Za-z0-9_]+" ).Replace ( (substituteString id " " "_") ) "")
			format "@!!!!!!!!!!!! id	= % \n" id
			id --return
		)
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
		--prnt "RolloutCreator_v._setId()"
		this._setId()
		
		--this._setTitleCenter()
		
		--_RolloutCreator = rolloutCreator id ((this._getPrefix())+title)
		--_RolloutCreator = rolloutCreator id title
		--_RolloutCreator = rolloutCreator id ("   "+title)
		
	)
	
)
