clearListener(); print("Cleared in:\n"+getSourceFileName())

try( destroyDialog rollout_group_example )catch()

/* PLAYGROUND FOR ACROSS PRAMETER TO SHOW BEHAVIOUR OF PARAMETER


*/ 
rollout rollout_group_example "ACROSS PARAMETER BEHAVIOUR"
(
	group ""
	(
		/* ACROSS */ 
		label lab_1 "1st CONTROL IN ROW DEFINE #ACROSS" across:5
		button btn_9 "Chnage of across has no effect" across:999
		button btn_10 "All NEXT CONTROLS are.."
		button btn_11 "..placed to fill entire row.."
		button btn_1 "..and inherites #across parameter"
		
		/* VERTICAL */ 
		label  lab_2 "VERTICAL LAYOUT WITHOUT ACROSS" offset:[0,16]
		button btn_4 "Controls without across parameter..."
		button btn_5 "...Are placed below each other"
		
		
		/* ROW FILLED WITH PLACEHOLDERS */ 
		button lab_3 "Use PLACEHOLDERS to fill row by count of across controls" across:3  offset:[0,16]
		label  lab_4 "Use HIDDEN labels TO FILL ROW" offset:[0,20]
		label  palceholder "" -- PLACEHODER
		
		/* NEW ROW */ 
		label  lab_5 "NEW ROW STARTS HERE - previous row is filled placeholders"  offset:[0,8] 
	)
)

CreateDialog rollout_group_example width:980


