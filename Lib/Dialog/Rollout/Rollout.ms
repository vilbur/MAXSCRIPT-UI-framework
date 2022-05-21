filein( getFilenamePath(getSourceFileName()) + "/EventsList/EventsList.ms" )
filein( getFilenamePath(getSourceFileName()) + "/Controls/Controls.ms" )
filein( getFilenamePath(getSourceFileName()) + "/Subrollouts/Subrollouts.ms" )

/** Rollout 
 */
struct Rollout_v
(
	__construct = #( #title ),

	/* construct */
	title,
	
	/* properties */
	id,
	height,
	parent_rollout_id,
	
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

	/** Get new slot of subrollouts
	 */
	function Subrollouts slot: height:height =
	(
		local Subrollouts = Subrollouts_v parent_rollout_id:id slot:(this._getSubrolloutsSlot(slot)) height:height 

		append _Controls Subrollouts

		Subrollouts --return
	),

	/** Get new slot of subrollouts
	  *
	  * Front end alias for user this.Subrollouts()
	 */
	function Rollouts slot: height: =
	(
		--print "Rollout_v.Rollouts()"
		this.Subrollouts slot:slot height:height --return
	),
	
	/** Get Subrollouts_v or Rollout_v 
	  * 
	  * 
	  * 
	  * @return	object Subrollouts_v|Rollout_v
	 */
	function get id =
	(
		--format "\n"; print "Rollout_v.get()"
		
		--local found_result
		
		if( ( local found_result = this._getSubrolloutSlot(id) ) == undefined ) then
			found_result = this._getRollout(id)
		
		found_result --return
	),
	

	/*------------------------------------------------------------------------------
		
		TODO:
		
		Move methods of _RolloutCreator to RolloutCreator_v.ms
		
	--------------------------------------------------------------------------------*/
	
	
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
	function addlocal key val =
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
		if ( parent_rollout_id != undefined ) then
			parent_rollout_id +"."+ id as string --return 
		
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
		if slot == undefinedr or slot == unsupplied then
		(
			subrollouts_count = (for _struct in _Controls where matchPattern (classof _struct as string ) pattern:@"*Subrollouts_v*" collect _struct).count + 1 -- Add 1 because of current subrollouts are not added yet
						
			suffix = if (subrollouts_count > 1 ) then ("_"+subrollouts_count as string ) else ""
			
			slot = "subrollouts_"+ subrollouts_count as string
		)

		slot as name --return 
	),

	/** Set id by title if not defined
	 */
	function _setId =
	(
		--print "Rollout_v._setId()"
		if ( id == undefined or id == unsupplied ) then
			id = toLower title
			
			--id = substituteString title "Rollout" "" -- remove "rollout" from title to avoid id like: "ROLLOUT_Rollout_A" if title is "Rollout A'
			--id  = "ROLLOUT_" + id -- add prefix
			
			id = substituteString ( trimRight ( trimLeft id )) " " "_" -- replace whitespace with underscore

			id = this._repleaceCharacters "^(\d+)" "" -- remove number as first letter, global variable MUST NOT starts with number

			id = this._repleaceCharacters "[^A-Za-z0-9_]" "_" -- remove invalid characters E.G.: "Butt@n_&_1" >>> "Button_1"

			id = this._repleaceCharacters "[_]+" "_" -- remove multiple underscores E.G.: "button___1" >>> "button_1"
		
		this.validateid()
		
		id = id as name
	),

	/** Validate title
	 */
	function validateid =
	(
		--format "\n"; print "Subrollouts_v.validateTitle()"
		--format "id	= % \n" id
		variable_test = execute (id)
		--format "variable_test	= % \n" (classof variable_test)
		
		if classof variable_test != UndefinedClass and classof variable_test != RolloutClass then
		(
			id_prefixed = "ROLLOUT_" + id
		
			print ("WARNING: Rollout id \"" + id + "\" is MaxScript variable, Rollout id has been changed to \"" + id_prefixed + "\"")
			
			id  = id_prefixed
		)
		
	),
	
	/** _repleace string
	 */
	function _repleaceCharacters search replace =
	(
		( dotNetObject "System.Text.RegularExpressions.Regex" search ).Replace ( id ) replace  --return 
	),
	
	/** Search for subrollouts slot
	 */
	function _getSubrolloutSlot slot =
	(
		--format "\n"; print "Rollout_v._getSubrollout()"
		(for _Subrollouts in (this._getSubrollouts()) where _Subrollouts.slot == slot as name collect _Subrollouts)[1] --return
	),
	
	/** Search for rollout in subrolluts
	 */
	function _getRollout id =
	(
		--format "\n"; print "Rollout_v.getRollouts()"
		local found_rollout
		
		for _Subrollouts in this._getSubrollouts() do
			if( ( rollout_exists = _Subrollouts.get(id) ) != undefined ) then
				found_rollout = rollout_exists

		found_rollout --return
	),
	
	/** Get subrollouts
	 */
	function _getSubrollouts =
	(
		--format "\n"; print "Rollout_v._getSubrolouts()"
		for _Control in _Controls where hasProperty _Control "slot" collect _Control --return
	),
	
	/**  
	 */
	on create do
	(
		--print "Rollout_v.onOpen()"
		ConstructPropeties test:this

		this._setId()
	)
)