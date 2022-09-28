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

		_Rollout.RCI	= rolloutCreator (_Rollout.id) ( _Rollout.title )
		
		/* EDIT start */
		_Rollout.RCI.begin()
		
		ControlsCreator.createControslInGroupboxAsLast(_Rollout)
		
		
		/* add LOCAL VARIABLES */ 
		this._addLocalVariablesToRollout (_Rollout)

		/* add TEXT */ 
		this._addTextToRollout (_Rollout)
		
		
		
		/* add CONTROLS and SUBROLLOUTS SLOTS */ 
		--this._addControlsAndSubrolloutesSlots (_Rollout)
		for _Controls in _Rollout._Controls do
			if( this._isControls(_Controls) )
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
		
		--format "%\n\n" "------------------------------------------------------------"
		--
		--format "%\n" _Rollout.RCI.def
		--format "%\n" _Rollout
		--
		--format "%\n\n" "------------------------------------------------------------"
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
	
	/** Get definition
	 */
	function getDefinition _Rollout =
	(
		_Rollout.RCI.def
	),
	
	
	private


	/** Add controls or subrolloutes
	 */
	function _addControlsAndSubrolloutesSlots _Rollout =
	(
		--print "RolloutCreator_v._addControlsAndSubrolloutesSlots()"
		
		for ControlsBox_or_Subrollouts in _Rollout._Controls do
		(
			--format "CONTROLSBOX_OR_SUBROLLOUTS	= % \n" ControlsBox_or_Subrollouts
			if( this._isControls(ControlsBox_or_Subrollouts) ) then
				ControlsCreator.addControls(ControlsBox_or_Subrollouts)
			
			else
			(
				/**  DISABLE ADDING SUBROLLOUTS SLOT INTO ACROSS LAYOUT
				  */
				--ControlsCreator.AcrossModifier.fakeControlsOnEndofGroup(_Rollout.RCI) --fake_control_caption:"SUBROLLOUTS"

				SubolloutsCreator.addSubrolloutSlot(_Rollout)(ControlsBox_or_Subrollouts)
			)
		)
	),

	 /** _create subrollouts
	  */
	 function _createSubrollouts _Rollout =
	 (
		for Subrollouts in _Rollout._Controls where this._isSubrollouts(Subrollouts) do
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

	/** _is control box
	 */
	function _isControls _Struct =
	(
		--this._getType _Struct == "controls"
		matchPattern (classOf _Struct  as string ) pattern:@"*controls_v*" 
	),

	/** _is subrollouts
	 */
	function _isSubrollouts _Struct =
	(
		--print "RolloutCreator_v._getSubrolloutsCount()"
		matchPattern (classOf _Struct  as string ) pattern:@"*subrollouts_v*" 
	),

	/**  
	 */
	on create do
	(
		--format "\n"; print("RolloutCreator_v.onCreate()")
	)	
)