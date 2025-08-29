clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../../../Lib/Dialog/Dialog.ms" )	--"./../../../Lib/Dialog/Dialog.ms"


/*	Use of GroupControl and GroupBox
  
	===================================================================================================================================================
	Group:    https://help.autodesk.com/view/3DSMAX/2016/ENU/?guid=__files_GUID_1361B847_7878_4C52_98DE_5BC5CA830B40_htm&v=2015
	GroupBox: https://help.autodesk.com/view/3DSMAX/2015/ENU/?guid=__files_GUID_A8C801C7_BA79_448C_A1EE_28C40B16287C_htm
	===================================================================================================================================================

	Hierarchy of controls:
	
		Rollout
		------------------------
			Controls
			Group
			------------------------
				Controls
				GroupBox
				------------------------
					Controls
	
	--------------------------------------------------------------------------
	
	Group    divide rollout HORIZONTALY 
	GroupBox divide rollout VERTICALY


	===================================================================================================================================================


	POSITION AND SIZE DIFERENCIES:

		Group:
			• Create "rows" in rollout 
			
			• SIZE BY CONTROLS in group
				◦ Width is full width of rollout
				◦ Height is set by position of last control in group
	
			• Position can be changed
			
		--------------------------------------------------------------------------

	
		GroupBox:
			• Create "columns" in GroupControl
			
			• Affected by #ACROSS parameter - works like other controls
			
			• Size can be defined and changed
				• Width is set by parameters #ACROSS or #WIDTH
			

	===================================================================================================================================================
	
	
	AUTO POSITION OF CONTROLS IN GRPOUPS:
		
		Group:
		
			DEFAULT:
			• Controls are sorted VERTICALY in default
			• Rows of controls are driven by #ACROSS parameter
			• Across parameter define number of controls in row EXAMPLE: "./Dev/across_parameter_default_beahaviour.ms"
			
			UI-FRAMEWORK WORKAROUNDS:
				• Use PLACEHOLDERS to fill row by count of across controls
			
			
		--------------------------------------------------------------------------
	
		GroupBox:
		
			• CONTROLS ARE NOT PLACED INSIDE GROUPBOX by default
				◦ HOW TO REPAIR LAYOUT:
					A. Group box must be REPOSITIONED and RESIZED around controls 
					B. Controls  must be PLACED INTO GroupBox
					C. Or both A. and B.
					
					
			• UI-FRAMEWORK WORKAROUNDS:
				◦ Controls in GroupBox:
					1. Move controls to pos [0,0] to prevent break of layout
					2. Rendere controls in separated temp rollout to get layout of controls
					3. Reposition controls by controls in temp rollout
					4. Close temp rollout
					
*/ 






/* DIALOG */
--Dialog 	= Dialog_v title:(getFilenameFile(getSourceFileName()))
Dialog 	= Dialog_v title:(getFilenameFile(getSourceFileName())) width:1024

/* CONTROLS */
_Controls = Dialog.Controls group:"Test Dialog"

/* GROUPBOX */
_GroupBox_A1 = _Controls.control #GroupBox "Groupbox A 1" across:2 --params:#( #height, 128 )
--_GroupBox_A2 = _Controls.control #GroupBox "Groupbox A 2" across:2 --params:#( #height, 128 )

/* CONTROLS */
_across = 1
_across = 2

_Controls.control #button ("Button 1") groupbox:_GroupBox_A1.id across:_across align:#LEFT
_Controls.control #button ("Button 2") groupbox:_GroupBox_A1.id across:_across align:#RIGHT

_Spinner = _Controls.control #spinner "Spinner params"  groupbox:_GroupBox_A1.id across:1 align:#LEFT --fieldWidth:64

--/* CONTROLS */
--_Controls_2 = Dialog.Controls group:"Controls 2"
--
--/* GROUPBOX */
--_GroupBox = _Controls_2.control #GroupBox (groupbox_name_2 = "Groupbox 2") params:#( #height, 128 )
--
--/* BUTTON */
--_Controls_2.control #button ("Button Controls 2") across:1 params:#(#groupbox, groupbox_name_2)


/* CREATE DIALOG */
 Dialog.create()
--Dialog.create width:512

