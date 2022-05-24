/** Ini saver
 */
struct IniSaver_v
(
	--__construct = #( #property_name ),

	/* construct */
	ini_file,

	/* dependency */
	/* reference */
	/* inhered */
	/* properties */
	--Dialog,

	save_classes = #(
		CheckBoxControl ,
		CheckButtonControl ,
		SpinnerControl ,
		EditTextControl ,
		ListBoxControl ,
		MultiListBoxControl ,
		ComboBoxControl

	),

	/** Save to file
	 */
	function saveRollout rollout_id =
	(
		--clearListener()
		--format "\n"; print "IniSaver_v.saveRollout()"
		--format "rollout_id	= % \n" rollout_id

		--_Rollout = execute(rollout_id)

		--if _Rollout.inDialog == true then
			this._saveDialog (execute(rollout_id))

		--else
			--this._saveRollout (_Rollout)

		true --return
	),

	private

	/** _save rollout
	 */
	function _saveDialog _Rollout =
	(
		--format "\n"; print "IniSaver_v._saveDialog()"
		--format "_Rollout	= % \n" _Rollout

		this._saveToIni _Rollout.name "position"	(GetDialogPos _Rollout )
		this._saveToIni _Rollout.name "size"	(GetDialogSize _Rollout )
		this._saveToIni _Rollout.name "dock_state"	(try(cui.getDockState _Rollout )catch())

		this._saveControlsAndSubrollouts(_Rollout)
	),

	/** _save controls and subrollouts
	 */
	function _saveControlsAndSubrollouts _RolloutClass =
	(
		--format "\n"; print "IniSaver_v._saveControlsAndSubrollouts()"

		for control in _RolloutClass.controls do
		(
			--format "control	= % \n" control
			--format "( classOf control )	= % \n" ( classOf control)

			if classOf control == SubRollout then
				this._saveSubRollouts(control)(_RolloutClass.name)

			else if findItem save_classes (classOf control) > 0 then 
				this._saveControl(_RolloutClass)(control)

		)

	),

	/** _save rollout
	 */
	function _saveSubRollouts _SubRolloutClass rollout_id =
	(
		--format "\n"; print "IniSaver_v._saveSubRollouts()"
		--format "_SubRolloutClass	= % \n" _SubRolloutClass;

		rollout_ids = for _rollout in (this._getOrderedRollouts(_SubRolloutClass.Rollouts)) collect _rollout.name as name

		this._saveToIni (rollout_id) (_SubRolloutClass.name) (rollout_ids as string )

		for control in _SubRolloutClass.Rollouts do
		(
			--format "control	= % \n" control

			if classOf control == RolloutClass then
				this._saveRollout(control)

		--	--format "( classOf control)	= % \n" ( classOf control)
		--	--format "control	= % \n" control.Rollouts
		--	
		)

	),

	/** _save rollout
	 */
	function _saveRollout _RolloutClass =
	(
		--format "\n"; print "IniSaver_v._saveRollout()"
		--format "_RolloutClass	= % \n" _RolloutClass.name

		this._saveToIni (_RolloutClass.name) ("rolledUp") ( (not _RolloutClass.open) as string )

		this._saveControlsAndSubrollouts(_RolloutClass)

	),

	/** _save control
	 */
	function _saveControl _RolloutClass Ctrl =
	(
		--format "\n"; print "IniSaver_v._saveControl()"
		--format "Ctrl.name 	= % \n" Ctrl.name

		local val

		--format "classOf control	= % \n" (classOf control)

		if (matches = (this.regexGetMatches( (classOf control) as string ) "Check|Box|EditText|Spinner")).count > 0 then
		(

			--format "matches[1][1]	= % \n" matches[1][1]

			val = case matches[1][1] as name of
				(
					#Check:	Ctrl.checked
					#Spinner:	Ctrl.value
					#EditText:	Ctrl.text
					#Box:	Ctrl.selection
					--#ListBox:	Ctrl.selection
					--default:	
				)
		)

		format "val	= % \n" val

		if( val != undefined ) then 
			this._saveToIni (_RolloutClass.name) Ctrl.name (val as string )

	),

	/**  
	  *	
	  */
	function regexGetMatches string pattern ignorecase:true =
	(
		rx         = dotNetClass "System.Text.RegularExpressions.RegEx"
		rx_options	= dotNetClass "System.Text.RegularExpressions.RegexOptions"

		matches = if (ignorecase) then rx.matches string pattern rx_options.IgnoreCase else rx.matches string pattern

		(for matchIdx = 0 to matches.count-1 collect for groupIdx = 0 to matches.item[matchIdx].groups.count-1 collect ( matches.item[matchIdx].groups.item[groupIdx].value )) --return
	),

	/** Set save to ini default event
	 */
	function _saveToIni section key val =
	(
		--format "\n"; print "IniSaver_v._saveToIni()"
		if( val != undefined ) then 
			setINISetting ini_file section key ( val as string )
	),
	
	/** Get subrollouts by order in UI
	 */
	function _getOrderedRollouts rollouts =
	(
		fn sortByY A B = (windows.getWindowPos A.hWnd).y - (windows.getWindowPos B.hWnd).y
		
		qsort rollouts sortByY --> 'rollouts' will now be sorted based on Y
		
		rollouts --return
	),
	
	/**  
	 */
	on create do
	(
		--print("IniSaver_v.onCreate()")
		--ConstructPropeties test:this
	)	
)