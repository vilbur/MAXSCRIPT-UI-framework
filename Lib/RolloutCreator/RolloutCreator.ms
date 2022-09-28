filein( getFilenamePath(getSourceFileName()) + "/../List/List.ms" )

filein( getFilenamePath(getSourceFileName()) + "/../Dialog/Rollout/Rollout.ms" )
filein( getFilenamePath(getSourceFileName()) + "/../Dialog/Rollout/Subrollouts/Subrollouts.ms" )

filein( getFilenamePath(getSourceFileName()) + "/RolloutEventBinder/RolloutEventBinder.ms" )

filein( getFilenamePath(getSourceFileName()) + "/ControlsCreator/ControlsCreator.ms" )

filein( getFilenamePath(getSourceFileName()) + "/SubolloutsCreator/SubolloutsCreator.ms" )

/** RolloutCreator_v
 */
struct RolloutCreator_v
(
	/* construct option */ 
	Ini,
	
	/* properties */
	
	/* dependency */ 
	EventBinder	= RolloutEventBinder_v ini_path:(Ini.getPath()),

	ControlsCreator,
	SubolloutsCreator = SubolloutsCreator_v ini_path:(Ini.getPath()),

	/* store */

	/** Create dialog
	 */
	function createRollout _Rollout =
	(
		format "\n\n-------------------------------------	RolloutCreator_v.createRollout() id:#%	-------------------------------------\n"  ( _Rollout.id as string );
		--format "classOf _Rollout.id	= % \n" (classOf _Rollout.id)
		--format "_Rollout.getFullId()	= % \n" (_Rollout.getFullId())
		--format "_Rollout.getNestedLevel()	= % \n" (_Rollout.getNestedLevel())
		--format "_Rollout.title	= % \n" _Rollout.title
		
		ControlsCreator	= ControlCreator_v _Rollout:_Rollout Ini:Ini
		
		ControlsCreator.moveGrouboxControlsToEnd(_Rollout)
		
		
		_Rollout.RCI	= rolloutCreator (_Rollout.id) ( this._getTitleCentered(_Rollout ) )
		
		/* EDIT start */
		_Rollout.RCI.begin()
		
		
		
		/* add LOCAL VARIABLES */ 
		this._addLocalVariablesToRollout (_Rollout)

		/* add TEXT */ 
		this._addTextToRollout (_Rollout)
		
		
		
		/* add CONTROLS and SUBROLLOUTS SLOTS */ 
		--this._addControlsAndSubrolloutesSlots (_Rollout)
		for _Controls in _Rollout._Controls do
			if( this._is(_Controls)("Controls") )
			then
				ControlsCreator.addControls(_Controls)
			
			else
				SubolloutsCreator.addSubrolloutSlot(_Rollout)(_Controls)
				
				
				
		/* create SUBROLLOUTS */ 
		this._createSubrollouts (_Rollout)
		
		/* add EVENTS */
		if( ini != undefined ) then 
			EventBinder.combineEventsAndAddHandlers(_Rollout)

		/* EDIT end */ 
		_Rollout.RCI.end()
		
		--format "%\n\n%\n%\n%\n\n" "------------------------------------------------------------" _Rollout.RCI.def _Rollout  "------------------------------------------------------------"
	),

	/** New
	 */
	function Roll title id: =
	(
		--format "\n"; print "RolloutCreator_v.Roll()"
		Rollout_v title:title id:id --return
	),
	
	/** Get new Rollout
	 */
	function new title id: =
	(
		format "\n"; print "!!!!!!!! DEPRECATED METHOD RolloutCreator_v.new() DO NOT USE THIS !!! "

		this.Roll title id:id --return
	),
	
	
	private


	 /** _create subrollouts
	  */
	 function _createSubrollouts _Rollout =
	 (
		for Subrollouts in _Rollout._Controls where this._is(Subrollouts)("Subrollouts") do
			for _Subrollout in Subrollouts.Rollouts do
				this.createRollout (_Subrollout)
	 ),
	
	/** Add local variables from Control_v to rollout
	  *
	  * 	Control_v.rollout_locals =  #(#variable_name1, init_value1, #variable_name2, init_value2)
	 */
	function _addLocalVariablesToRollout _Rollout =
	(
		--print "ControlCreator_v._addLocalVariablesToRollout()"
		--format "_Rollout.add_locals	= % \n" _Rollout.add_locals
		if( _Rollout.add_locals != unsupplied ) then
			for i = 1 to _Rollout.add_locals.count by 2 do
				_Rollout.RCI.addLocal ( _Rollout.add_locals[i] as string )  init:_Rollout.add_locals[i+1]
	),

	/** Add functions variables to rollout
	 */
	function _addTextToRollout _Rollout =
	(
		--print "ControlCreator_v._addTextToRollout()"
		--format "_Rollout.add_text	= % \n" _Rollout.add_text
		if( _Rollout.add_text != undefined ) then
			_Rollout.RCI.addText  _Rollout.add_text filter:true
	),
	
	/** get name of strct
	 */
	function _is _Struct pattern =
	(
		--print "RolloutCreator_v._getSubrolloutsCount()"
		matchPattern (classOf _Struct  as string ) pattern:(@"*"+pattern+"_v*" )
	),
	
	/** Center rollout title with empty space prefix
	  * 
	  * TODO: move this method to RolloutCreator_v
	  * 
	  * if rollout is wider then 320
	 */
	function _getTitleCentered _Rollout  =
	(
		--print "Rollout_v._setTitleCenter()"
		prefix	= ""
		
		rollout_padding	= 164 -- with of dialog border or subrallout arrow for open rollout -- HIGHER VALUE MOVES WHOLE TITLE TO LEFT, LOWER TO RIGHT
		px_per_character	= 5 -- width in pixels of character in title
		px_per_space	= 3 -- width in pixels of empty character: " "
		slot_padding	= 24 -- each subrollout is narrower then parent rollout
		
		if( _Rollout.width > 320 and ( IS_NOT_MAIN_ROLLOUT = _Rollout.parent_rollout_id) != undefined and (_Rollout.width != undefined and _Rollout.width != unsupplied ) and (max_version = (maxVersion())[8] )!= undefined and max_version > 2020  ) then
		(
			title_width	= _Rollout.title.count * px_per_character -- get difference in length of characters, longer title has shorter prefix and vice versa
			rollout_width	= _Rollout.width - rollout_padding - ( _Rollout.getNestedLevel() * slot_padding )
			prefix_lenght	= ((rollout_width - title_width) / 2) / px_per_space
			
			for i = 1 to prefix_lenght do -- too width 200px
				prefix += " "
				
			prefix + _Rollout.title --return
		)
		else		
			_Rollout.title
	),
	
	/**  
	 */
	on create do
	(
		--format "\n"; print("RolloutCreator_v.onCreate()")
	)	
)