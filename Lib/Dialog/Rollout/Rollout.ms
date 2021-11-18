filein( getFilenamePath(getSourceFileName()) + "/Controls/Controls.ms" )
filein( getFilenamePath(getSourceFileName()) + "/Controls/ControlsBox/ControlsBox.ms" )



/** Rollout
 */
struct Rollout_v
(

	/* required */
	title,
	
	/* dependency */
	_RolloutCreator, -- https://help.autodesk.com/view/3DSMAX/2016/ENU/?guid=__files_GUID_5FC5036F_E2D7_46C9_9AFA_7B3550B9F254_htm

	/* reference */
	/* properties */
	id,
	
	Controls = Controls_v(),
	include "Library/UI/Lib/Dialog/Rollout/RolloutSubrollouts.ms"

	/** Create dialog
	 */
	function createRollout =
	(
		print ("Rollout_v.createDialog() " + id)
		
		
		for ControlsBox in Controls._Controls do
			this.addControlsOrSubrolloutes ControlsBox
		
		--format "this.getDefinition()	= % \n" (this.getDefinition())
		--CreateDialog (this.getDefinition()) width:width height:height style:#(#style_titlebar, #style_border, #style_sysmenu, #style_resizing) 
		_RolloutCreator.end() --return
	),
	
	
	
	private
	
	/** Add controls or subrolloutes
	 */
	function addControlsOrSubrolloutes ControlsBox_or_Subrollouts =
	(
		print "Rollout_v.addControlsOrSubrolloutes()"
		format "ControlsBox_or_Subrollouts	= % \n" ControlsBox_or_Subrollouts
		format "this._isControlsBox(ControlsBox_or_Subrollouts)	= % \n" this._isControlsBox(ControlsBox_or_Subrollouts)
		
		if( this._isControlsBox(ControlsBox_or_Subrollouts) ) then
			this.addControlsBoxToUi ControlsBox_or_Subrollouts
		
		else
			this.addSubrolloutsSlot ControlsBox_or_Subrollouts
	),
	
	
	/** Add controls box to ui
	 */
	function addControlsBoxToUi ControlsBox =
	(
		format "\n"
		print "Rollout_v.addControlsBoxToUi()"
		format "ControlsBox	= % \n" ControlsBox.caption
		_RolloutCreator.addText ("group \"" + ControlsBox.caption + "\" (") 
					
		for i = 1 to ControlsBox.controls.count do
				this.addControlToUI (ControlsBox.controls[i])
		
		_RolloutCreator.addText (")")
	),
	
	/** Add control to UI
	 */
	function addControlToUI _Control =
	(
		print "Rollout_v.addControlToUI()"
		format "_Control	= % \n" _Control.id
		
		--/** Test
		-- */
		--(function addHandlers _Control =
		--(
		--	print "Rollout_v.addHandlers()"
		--	
		--	for _Event in _Control.Events.list do
		--		_RolloutCreator.addHandler _Control.id _Event.type codeStr:_Event.code paramStr:_Event.params filter:on 
		--
		--))(_Control)

		_RolloutCreator.addControl _Control.type ( _Control.id as string ) _Control.caption paramStr:_Control.params
	),
	
	/** Add subrollouts slot
	 */
	function addSubrolloutsSlot Subrollouts =
	(
		print "Rollout_v.addSubrolloutsSlot()"
		format "Subrollouts	= % \n" Subrollouts.slot
		
		_RolloutCreator.addText ("subRollout slot_"+Subrollouts.slot as string +" \"slot_name\" height:128") 

	),
	
	/** _is control box
	 */
	function _isControlsBox _Struct =
	(
		this._getType _Struct == "controlsbox"
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
	
	/** Get definition
	 */
	function getDefinition =
	(
		--print "Rollout_v.getDefinition()"
		--format "_RolloutCreator.def	= % \n" _RolloutCreator
		_RolloutCreator.def
	),

	/** Set id by title if not defined
	 */
	function _getId =
	(
		print "Rollout_v._getId()"
		if ( id == undefined or id == unsupplied ) then
			id = "ROLLOUT_" + (( dotNetObject "System.Text.RegularExpressions.Regex" @"[^A-Za-z0-9_]+" ).Replace ( (substituteString title " " "_") ) "")
		
		id --return
	),
	
	/**  
	 */
	on create do
	(
		this._getId()
		
		_RolloutCreator = rolloutCreator (this._getId()) title

		_RolloutCreator.begin() 
	)
	
)
