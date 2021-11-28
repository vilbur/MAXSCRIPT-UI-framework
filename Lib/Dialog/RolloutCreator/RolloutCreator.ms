filein( getFilenamePath(getSourceFileName()) + "/../../Ini/Ini.ms" )
filein( getFilenamePath(getSourceFileName()) + "/../Rollout/EventsList/EventsList.ms" )
filein( getFilenamePath(getSourceFileName()) + "/../EventsCombiner/EventsCombiner.ms" )

filein( getFilenamePath(getSourceFileName()) + "/../Rollout/Rollout.ms" )
filein( getFilenamePath(getSourceFileName()) + "/../Rollout/Subrollouts/Subrollouts.ms" )


filein( getFilenamePath(getSourceFileName()) + "/RolloutEvent/RolloutEvent.ms" )
filein( getFilenamePath(getSourceFileName()) + "/ControlCreator/ControlCreator.ms" )

/** RolloutCreator_v
 */
struct RolloutCreator_v
(
	Ini	= Ini_v(),
	ControlCreator	= ControlCreator_v(),
	RolloutEvents	= RolloutEvents_v(),

	/* optionable */
	
	/** New
	 */
	function new title id: =
	(
		Rollout_v title:title id:id --return
	),
	
	/** Get definition
	 */
	function getDefinition _Rollout =
	(
		_Rollout._RolloutCreator.def
	),

	/** Create dialog
	 */
	function createRollout _Rollout =
	(
		format "\n"
		print ("RolloutCreator_v.createRollout() " + _Rollout.id as string )
		--format "_Rollout	= % \n" _Rollout
		
		this._setIniToEventCreators()
		
		/* EDIT start */ 
		_Rollout._RolloutCreator.begin()
		

		
		/* add LOCAL VARIABLES */ 
		this._addLocalVariablesToRollout (_Rollout)

		/* add TEXT */ 
		this._addTextToRollout (_Rollout)
		
		
		/* add CONTROLS */ 
		this.addControlsAndSubrolloutes (_Rollout)
		
		/* add EVENTS */ 
		RolloutEvents.bindEvents (_Rollout)
		
		
		
		/* EDIT end */ 
		_Rollout._RolloutCreator.end()
	),

	/** Add controls or subrolloutes
	 */
	function addControlsAndSubrolloutes _Rollout =
	(
		--print "RolloutCreator_v.addControlsAndSubrolloutes()"
		for ControlsBox_or_Subrollouts in _Rollout._Controls do
			if( this._isControls(ControlsBox_or_Subrollouts) ) then
			
				ControlCreator.addControls (_Rollout)(ControlsBox_or_Subrollouts)
			
			else
			
				this._createSubrollouts (_Rollout)(ControlsBox_or_Subrollouts)
	),
	
	/** Add sub rollouts
	 */
	function addSubRollouts _Rollout =
	(
		--print "RolloutCreator_v._addSubRollouts()"
		for _Subrollouts in _Rollout._Controls where this._isSubrollouts(_Subrollouts) do
			for _Subrollout in _Subrollouts.Rollouts do
			(
				execute  ( "AddSubRollout "+_Rollout.id+"." + _Subrollouts.slot +" "+ _Subrollout.id + " rolledUp:"+(this._getRolledStateFromIni(_Subrollout.id)) )
				
				this.addSubRollouts _Subrollout
			)	
	),
	
	/** Get rolled state from ini
	 */
	function _getRolledStateFromIni subrollout_id =
	(
		--print "RolloutCreator_v._getRolledStateFromIni()"
		rolledup_state = "false"

		if( Ini.getPath() != undefined and (rolledup_state_ini = getINISetting (Ini.getPath())subrollout_id "rolledUp") != "" ) then
			rolledup_state = rolledup_state_ini

		rolledup_state --return
	),
	
	 /** _set ini to event creators
	  */
	 function _setIniToEventCreators =
	 (
		ini_path = Ini.getPath()

		RolloutEvents.ini_path	= ini_path

		ControlCreator.EventsCreator.ini_path	= ini_path

		ControlCreator.ParamsCreator.ControlValue.ini_path	= ini_path
	 ),
	 
	 /** _create subrollouts
	  */
	 function _createSubrollouts  _Rollout Subrollouts =
	 (
		--print "RolloutCreator_v._createSubrollouts()"
		this._addSubrolloutsSlots (_Rollout) (Subrollouts)
		
		for _Subrollout in Subrollouts.Rollouts do
			this.createRollout (_Subrollout)
	 ),
	 
	/** Add subrollouts slot
	 */
	function _addSubrolloutsSlots _Rollout Subrollouts =
	(
		--print ("RolloutCreator_v.addSubrolloutsSlot()" + Subrollouts.slot)
		_Rollout._RolloutCreator.addText ("subRollout "+Subrollouts.slot as string +" \"slot_name\" height:128")
	),


	private
	

		
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
		print "ControlCreator_v._addTextToRollout()"
		format "_Rollout.add_text	= % \n" _Rollout.add_text
		--if( _Rollout.add_text != undefined ) then
				--_Rollout._RolloutCreator.addText  _Rollout.add_text filter:true
	),
	
	/** _is control box
	 */
	function _isControls _Struct =
	(
		this._getType _Struct == "controls"
	),
	
	/** _is subrollouts
	 */
	function _isSubrollouts _Struct =
	(
		this._getType _Struct == "subrollouts"
	),
	
	/** Get name given struct
	  * @property	struct	_Struct
	  *
	  * @return	string lower case	name of given struc stripped of "_v" suffix E.G.: "FooStruct_v" returm "foostruct"
	 */
	function _getType _Struct =
	(
		toLower (( filterString( classof _Struct as string ) "_*(:" )[2])  --return
	),
	
	/**  
	 */
	on create do
	(
	)	
)