--filein( getFilenamePath(getSourceFileName()) + "/Controls/Controls.ms" )
--filein( getFilenamePath(getSourceFileName()) + "/Controls/ControlsBox/ControlsBox.ms" )
--filein( getFilenamePath(getSourceFileName()) + "/RolloutEvent/RolloutEvent.ms" )
filein( getFilenamePath(getSourceFileName()) + "/Rollout/Rollout.ms" )
filein( getFilenamePath(getSourceFileName()) + "/Rollout/Subrollouts/Subrollouts.ms" )

/** RolloutCreator_v
 */
struct RolloutCreator_v
(
	/* required */
	
	/* dependency */
	_RolloutCreator, -- https://help.autodesk.com/view/3DSMAX/2016/ENU/?guid=__files_GUID_5FC5036F_E2D7_46C9_9AFA_7B3550B9F254_htm

	_Rollout,

	/** New
	 */
	function new title id: =
	(
		this._Rollout = Rollout_v title:title id:id --return
		
		--_RolloutCreator = rolloutCreator ( title as string ) title
		
		--_RolloutCreator.begin()
	),

	/** Get definition
	 */
	function getDefinition =
	(
		_RolloutCreator.def
	),


	/** Create dialog
	 */
	function createRollout =
	(
		_RolloutCreator = rolloutCreator (_Rollout.id) (_Rollout.title)
		
		_RolloutCreator.begin()
		
		this.addSubrolloutsSlots()
		
		_RolloutCreator.end()
	),
	
	/** Add subrollouts slot
	 */
	function addSubrolloutsSlots  =
	(
		print "RolloutCreator_v.addSubrolloutsSlot()"
		--format "Subrollouts	= % \n" Subrollouts
		
		--Subrollouts.createRollouts()
		
		for _Subrollouts in _Rollout._Controls do
			_RolloutCreator.addText ("subRollout "+Subrollouts.slot as string +" \"slot_name\" height:128")

	),
	
	
	
	/** Add sub rollouts
	 */
	function addSubRollouts =
	(
		for Subrollouts in Controls._Controls where this._isSubrollouts(Subrollouts) do
			Subrollouts.addSubRollouts (id)
			--format "Subrollouts	= % \n" Subrollouts
			--this.addControlsOrSubrolloutes Subrollouts
	),
	
	/** rollouts
     */
    function rollouts =
    (
        Controls.subrollouts() --return
    ),
	
	
	private
	
	
	/** Add controls or subrolloutes
	 */
	function addControlsOrSubrolloutes ControlsBox_or_Subrollouts =
	(
		--print "RolloutCreator_v.addControlsOrSubrolloutes()"
		if( this._isControlsBox(ControlsBox_or_Subrollouts) ) then
		
			this.addControlsBoxToUi ControlsBox_or_Subrollouts
		
		else
			this.addSubrolloutsSlot ControlsBox_or_Subrollouts
	),
	
	
	/** Add controls box to ui
	 */
	function addControlsBoxToUi ControlsBox =
	(
		--print "RolloutCreator_v.addControlsBoxToUi()"
		_RolloutCreator.addText ("group \"" + ControlsBox.caption + "\" (") 
					
		for i = 1 to ControlsBox.controls.count do
				this.addControlToUI (ControlsBox.controls[i])
		
		_RolloutCreator.addText (")")
	),
	
	/** Add control to UI
	 */
	function addControlToUI _Control =
	(
		print ("RolloutCreator_v.addControlToUI() " + _Control.id)
		
		/** Test
		 */
		(function addHandlers _Control =
		(
			print "RolloutCreator_v.addHandlers()"
			
			for _Event in _Control.Events.list do
				_RolloutCreator.addHandler _Control.id _Event.type codeStr:_Event.code paramStr:_Event.params filter:on 
		
		))(_Control)

		_RolloutCreator.addControl _Control.type ( _Control.id as string ) _Control.caption paramStr:_Control.params
	),
	

	
	/** _is control box
	 */
	function _isControlsBox _Struct =
	(
		this._getType _Struct == "controlsbox"
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
	


	/** Set id by title if not defined
	 */
	function _setId =
	(
		print "RolloutCreator_v._setId()"
		if ( id == undefined or id == unsupplied ) then
			id = "ROLLOUT_" + (( dotNetObject "System.Text.RegularExpressions.Regex" @"[^A-Za-z0-9_]+" ).Replace ( (substituteString title " " "_") ) "")
		
		id --return
	),
	
	/**  
	 */
	on create do
	(
		--this._setId()
		--
		--_RolloutCreator = rolloutCreator id title
		--
		--_RolloutCreator.begin() 
	)
	
)
