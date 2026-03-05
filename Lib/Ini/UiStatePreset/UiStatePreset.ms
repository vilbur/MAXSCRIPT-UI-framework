filein( getFilenamePath(getSourceFileName()) + "/IniSaver/IniSaver.ms" )	--"./IniSaver/IniSaver.ms"

/** Ui state preset
 */
struct UiStatePreset_v
(
	/* construct */
	ini_file,

	/* required */
	/* properties */
	
	
	/* private */
	/* dependency */
	/* reference */
	/* inhered */

	/** Save
	  
	   @param string|name|RolloutClass _Rollout which preset is saved
	 */
	function save _Rollout =
	(
		format "\n"; print "UiStatePreset_v.save()"
		format "ini_file: %\n" ini_file
		_Rollout = this._getRollout( _Rollout )
	
		--if (_Rollout = this._getRollout( _Rollout )) != undefined then
		--(
			IniSaver = IniSaver_v ini_file
			
			--if EVENT_DOCKED_ENABLED != undefined and EVENT_DOCKED_ENABLED then
				--IniSaver.saveDialogDockState (_Rollout)
		
			IniSaver.saveControlsAndSubrollouts (_Rollout)
		--)
		
		
	),
	
	
	/** Load
	 */
	function load rollout_id =
	(
		--format "\n"; print "UiStatePreset_v.load()"
	),
	
	private
	
	
	/** Get rollout
	 */
	function _getRollout _Rollout =
	(
		--format "\n"; print "UiStatePreset_v._getRollout()"
		
		if classOf _Rollout != RolloutClass then
			execute( _Rollout as string ) --return
		else
			_Rollout --return
	),

	/**
	 */
	on create do
	(
		--format "\n"; print "UiStatePreset.onCreate()"
		--for prop in #(  ) where getProperty this prop == undefined do -- CHECK CONSTRUCT PROPERTIES -- Array of this struct properties necessary to run
		--	throw ("\n\n\nUNDEFINED CONSTRUCT PROPERTY\n\n\nSTRUCT:\n\n"+ ((filterString( classof this as string )"(:")[2]) +"\n\n\nPROPERTY:\n\n"+ prop )
	)

)
