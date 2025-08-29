/** Group box
 */
struct GroupBox_v
(
	/* construct */
	Groupbox,

	/* required */
	

	/* properties */
	Controls = #(),

	/* private */
	/* dependency */
	/* reference */
	/* inhered */

	/** Create temporary rollout
	 */
	function createTemporaryRollout rollout_width =
	(
		--clearListener(); print("Cleared in:\n"+getSourceFileName())
		--format "\n"; print "GroupBox_v.createTemporaryRollout()"
		--format "rollout_width: %\n" rollout_width
		
		/* CLOSE ON DEVELOPMENT  */ 
		execute ("try( destroyDialog "+Groupbox.id as string +" )catch()")
		
		--format "Controls_in_groupbox: %\n" Controls_in_groupbox
		
		groupbox_across = Groupbox.Params[#ACROSS]
		groupbox_width  = rollout_width / groupbox_across
		--format "groupbox_across: %\n" groupbox_across
		--format "groupbox_width: %\n" groupbox_width
		
		RCI = rolloutCreator ( Groupbox.id as string  ) ( Groupbox.id as string  )
		RCI.begin()
		
		for _Control in Controls do
		(
			
			--format "\n%: %\n" _Control.id _Control.params_str
			
			RCI.addControl (_Control.type) (_Control.id) (_Control.caption) paramStr:_Control.params_str filter:true;
		)


		createDialog (RCI.end()) pos:[ (getMAXWindowPos()).x +512, 512 ] width:groupbox_width
		
		--groupbox_dialog = execute (Groupbox.id as string )
		
		--format "################### GROUPBOX_DIALOG: %\n" groupbox_dialog
		--format "groupbox_dialog.controls: %\n" groupbox_dialog.controls
		--
		--for _control in groupbox_dialog.controls do
		--(
		--	format "\n\n\n"
		--	format "_control: %\n" _control
		--	format "_control.pos: %\n" _control.pos
		--	
		--	--try( format "_control.width: %\n" _control.width )catch()
		--	
		--)
		--format "GB_groupbox_a_1.btn_Button_1.width: %\n" GB_groupbox_a_1.btn_Button_1.width
		
	),

	private


	/**
	 */
	on create do
	(
		--format "\n"; print "GroupBox.onCreate()"
		--for prop in #(  ) where getProperty this prop == undefined do -- CHECK CONSTRUCT PROPERTIES -- Array of this struct properties necessary to run
		--	throw ("\n\n\nUNDEFINED CONSTRUCT PROPERTY\n\n\nSTRUCT:\n\n"+ ((filterString( classof this as string )"(:")[2]) +"\n\n\nPROPERTY:\n\n"+ prop )
	)

)
