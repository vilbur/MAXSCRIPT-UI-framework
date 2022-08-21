filein( getFilenamePath(getSourceFileName()) + "/../ConstructPropeties/ConstructPropeties.ms" )

filein( getFilenamePath(getSourceFileName()) + "/../List/List.ms" )

--filein( getFilenamePath(getSourceFileName()) + "/../Ini/Ini.ms" )

filein( getFilenamePath(getSourceFileName()) + "/Event/Event.ms" )

filein( getFilenamePath(getSourceFileName()) + "/../Dialog/Rollout/Rollout.ms" )
filein( getFilenamePath(getSourceFileName()) + "/../Dialog/Rollout/Subrollouts/Subrollouts.ms" )

filein( getFilenamePath(getSourceFileName()) + "/RolloutEventBinder/RolloutEventBinder.ms" )

filein( getFilenamePath(getSourceFileName()) + "/ControlsCreator/ControlsCreator.ms" )

filein( getFilenamePath(getSourceFileName()) + "/SubolloutsCreator/SubolloutsCreator.ms" )

/** RolloutCreator_v
 */
struct RolloutCreator_v
(
	__construct = #( ),

	/* construct option */ 
	Ini,
	
	/* dependency */ 
	EventBinder	= RolloutEventBinder_v ini_path:(Ini.getPath()),

	ControlsCreator,
	SubolloutsCreator = SubolloutsCreator_v ini_path:(Ini.getPath()),

	
	/* properties */

	/* store */
	width,

	/** Create dialog
	 */
	function createRollout _Rollout width: height: =
	(
		--format "\n\n-------------------------------------	RolloutCreator_v.createRollout() %	-------------------------------------\n"  ( _Rollout.id as string );
		--format "classOf _Rollout.id	= % \n" (classOf _Rollout.id)
		
		ControlsCreator   = ControlCreator_v _Rollout:_Rollout Ini:Ini
		
		SubolloutsCreator._Rollout = _Rollout

		this._setWidth(width)

		/* EDIT start */ 
		_Rollout.rolloutCreatorBegin(this.width)

		ControlsCreator.crateControslInGroupboxAsLast(_Rollout)

		/* add LOCAL VARIABLES */ 
		this._addLocalVariablesToRollout (_Rollout)

		/* add TEXT */ 
		this._addTextToRollout (_Rollout)
		
		
		
		if _Rollout.height != undefined and _Rollout.height != unsupplied then
			height =  _Rollout.height
			
		if _Rollout.width == undefined or _Rollout.width == unsupplied then
			_Rollout.width = width 
		
		
				
		/* set height of SUBROLLOUTS slot */ 
		if( height != unsupplied ) then
			SubolloutsCreator.setSubrolloutsSlotHeight(height)

		/* add CONTROLS and SUBROLLOUTS SLOTS */ 
		this._addControlsAndSubrolloutesSlots (_Rollout)

		/* create SUBROLLOUTS */ 
		this._createSubrollouts (_Rollout)
		
		/* add EVENTS */
		if( ini != undefined ) then 
			EventBinder.combineEventsAndAddHandlers(_Rollout)

		/* EDIT end */ 
		_Rollout._RolloutCreator.end()
		
		--format "%\n\n" "------------------------------------------------------------"
		--
		--format "%\n" _Rollout._RolloutCreator.def
		--format "%\n" _Rollout
		--
		--format "%\n\n" "------------------------------------------------------------"
	),

	/** New
	 */
	function Roll title id: =
	(
		Rollout_v title:title id:id --return
	),
	
	/** Get new Rollout
	 */
	function new title id: =
	(
		format "\n"; print "!!!!!!!! DEPRECATED METHOD Subrollouts_v.Roll() please use Subrollouts_v.roll() "

		this.Roll title id:id --return
	),
	
	/** Get definition
	 */
	function getDefinition _Rollout =
	(
		_Rollout._RolloutCreator.def
	),
	
	
	private

	
	/** _setup creation
	 */
	function _setWidth width =
	(
		if( width != unsupplied ) then
			this.width = width
	),

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
				--ControlsCreator.AcrossModifier.fakeControlsOnEndofGroup(_Rollout._RolloutCreator) --fake_control_caption:"SUBROLLOUTS"

				SubolloutsCreator.addSubrolloutSlots(ControlsBox_or_Subrollouts)
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
				_Rollout._RolloutCreator.addLocal ( _Rollout.add_locals[i] as string )  init:_Rollout.add_locals[i+1]
	),

	/** Add functions variables to rollout
	 */
	function _addTextToRollout _Rollout =
	(
		--print "ControlCreator_v._addTextToRollout()"
		--format "_Rollout.add_text	= % \n" _Rollout.add_text
		if( _Rollout.add_text != undefined ) then
			_Rollout._RolloutCreator.addText  _Rollout.add_text filter:true
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
		--format "Ini	= % \n" Ini
		ConstructPropeties test:this
	)	
)