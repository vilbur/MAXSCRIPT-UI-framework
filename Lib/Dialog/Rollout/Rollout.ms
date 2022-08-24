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
	width	= 512,
	height	= 512,
	
	/* properties */
	id,
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

	/** Create new rollout in first slot
	 */
	function Roll title id: =
	(
		--format "\n"; print "Rollout_v.Roll()"
		Subrollouts = if (Subrollout_slots = this.getSubrollouts()).count > 0 then Subrollout_slots[1] else this.Rollouts()
		
		Subrollouts.Roll title id:id --return
	),
	
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
		--format "\n"; print "Rollout_v.Subrollouts()"
		local Subrollouts = Subrollouts_v parent_rollout_id:id slot:(this._getSubrolloutsSlotName(slot)) height:height 

		append _Controls Subrollouts

		Subrollouts --return
	),

	/** Get new slot of subrollouts
	  *
	  * Front end alias for user this.Subrollouts()
	 */
	function Rollouts slot: height: =
	(
		print "Rollout_v.Rollouts()"
		
		this.Subrollouts slot:slot height:height --return
	),
	
	/** Get Subrollouts_v or Rollout_v
	  * works for nested subrollouts as well
	  * 
	  * @param	name	id	id of rollout or subrollout slot
	  * 
	  * @return	object Subrollouts_v|Rollout_v
	 */
	function get id =
	(
		--format "\n"; print "Rollout_v.get()"
		--format "this.id	= % \n" this.id

		if id == this.id then
			return this --return
		else
			for _Subrollouts in this.getSubrollouts() where (found_rollout = _Subrollouts.get (id)) != undefined do
				return found_rollout
		
		undefined --return
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
	function rolloutCreatorBegin rollout_width =
	(
		--print "Rollout_v.rolloutcreatorBegin()"
		_RolloutCreator = rolloutCreator id (this._setTitleCenter(rollout_width))

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
	
	/** Get subrollouts
	 */
	function getSubrollouts =
	(
		--format "\n"; print "Rollout_v._getSubrolouts()"
		for _Control in _Controls where hasProperty _Control "slot" collect _Control --return
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

	/** Generate slot id if not defined
	  * 
	  * 1st slot id "subrollouts"
	  * 2nd and others has numbered suffix E.G.: "subrollouts_2"
	  *
	  * @return	string	
	 */
	function _getSubrolloutsSlotName slot_id =
	(
		--print "Rollout_v._getSubrolloutsSlotName()"
		if slot_id == undefined or slot_id == unsupplied then
			slot_id = if ((subrollouts_count = this._getSubrolloutsCount()) > 1 ) then "subrollouts_" +subrollouts_count as string else "subrollouts"

		slot_id as name --return 
	),
	
	/** Get subrollouts count
	 */
	function _getSubrolloutsCount =
	(
		--format "\n"; print "Rollout_v._getSubrolloutsCount()"
		(for _struct in _Controls where matchPattern (classof _struct as string ) pattern:@"*Subrollouts_v*" collect _struct).count + 1 -- Add 1 because of current subrollouts are not added yet
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

			id = this._repleaceCharacters "^(\d*[_-]*)" "" -- remove number as first letter, global variable MUST NOT starts with number E.G.: "1_FooDialog|_FooDialog" >>> "FooDialog"

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
		if matchPattern id pattern:@"rollout" or classof ( executed_id = execute (id) ) != UndefinedClass and classof ( executed_id ) != RolloutClass then
		(
			id_prefixed = "ROLLOUT_" + id
			
			--format "classof executed_id	= % \n" (classof executed_id)
			--print ("WARNING: Rollout id \"" + id + "\" is MaxScript variable, Rollout id has been changed to \"" + id_prefixed + "\"\n\n\n")
			format "\n"
			print ("WARNING: Rollout id \"" + id + "\" is classof "+(classof executed_id) as string+", Rollout id has been changed to \"" + id_prefixed + "\"")
			format "\n"
			id  = id_prefixed
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
		--print "Rollout_v.onOpen()"
		ConstructPropeties test:this

		this._setId()
	)
)