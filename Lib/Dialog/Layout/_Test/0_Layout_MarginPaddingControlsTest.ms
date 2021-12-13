clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../../Rollout.ms" )


global _Rollout
	
CONTROLS_COUNT = 4

/** Create multiple types of controls
 */
function addControl control_type label_test:false =
(
	 global _Controls	= _Rollout.Controls.new groupbox:control_type
	
	for i = 1 to CONTROLS_COUNT do
	(
		_label =  if ( label_test and i == 1 ) then "" else control_type + " "+i as string
		--format "_label	= % \n" _label
		execute ("_Controls."+control_type+" \"" + _label+"\"") -- execute this kind of code "_Buttons.button ("Button "+i as string )"
		
	)
)

/** Add rollouts
 */
function addRollouts padding: margin_x: margin_y: =
(
	
	rollout_titles = #(
		"Rollout_1",
		"Rollout_2",
		"Rollout_3",
		"Rollout_4",
		"Rollout_5"
	)
	
	offset_position_x = 1024
	
	for rollout_title in rollout_titles do 
	(
		try( execute("destroyDialog ROLLOUT_"+rollout_title) )catch()
	
		r = (findItem rollout_titles rollout_title) - 1
		
		/* ROLLOUT DEFINITION */
		_Rollout	= Rollout_v title:rollout_title
		
		/** LAYOUT SETUP	 */
		--_Rollout.Layout.columns  = 24
		_Rollout.Layout.grid     = 48
		
		_Rollout.Layout.padding  = r*padding
		_Rollout.Layout.margin.x = r*margin_x
		_Rollout.Layout.margin.y = r*margin_y
		
		--_Rollout.Layout.padding  = padding
		--_Rollout.Layout.margin.x = margin_x
		--_Rollout.Layout.margin.y = margin_y
		format "\n"
		--print rollout_title
		format "_Rollout.Layout.padding = % \n" _Rollout.Layout.padding 
		format "_Rollout.Layout.margin  = % \n" _Rollout.Layout.margin
	
		/*---------------------------------------
			ADD CONTROLS
		-----------------------------------------*/
		addControl "Button"
		--addControl "Checkbox"
		--addControl "Spinner"
		--addControl "Dropdownlist"	label_test:true
		--addControl "Listbox"	label_test:true
		addControl "BrowsePath"
		
		
		/* CREATE ROLLOUT */
		_Rollout.createRollout()
		
		/* CREATE DIALOG */
		CreateDialog ( _Rollout.RolloutCreator.getDefinition()) pos:[ offset_position_x, 512 ]
		--width:512
		
		execute("ROLLOUT_"+rollout_title+".width = " + (_Rollout.setRolloutWidth() as string ))
		
		offset_position_x += execute("ROLLOUT_"+rollout_title+".width") + 32
		
		--_Rollout.addSubRollouts()
	
	)
	
)

--addRollouts padding:0 margin_x:0 margin_y:0
--addRollouts padding:0 margin_x:8 margin_y:0

--addRollouts padding:4 margin_x:4 margin_y:4

addRollouts padding:4 margin_x:0 margin_y:0
--addRollouts padding:8 margin_x:0 margin_y:0






