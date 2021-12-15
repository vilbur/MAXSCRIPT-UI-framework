clearListener()

/*------------------------------------------------------------------------------
  

	
--------------------------------------------------------------------------------*/


try( destroyDialog controls_vertical )catch()


/* Controls vertical aside of tall control
*/ 
rollout controls_vertical "controls_vertical"
(
	group "Test"
	(
		/** LIST BOX IN SECOND COLUMN ON RIGHT 
		  *	
		  */
	   groupBox	groupBox_1	"box 1"	across:2
	   listbox	list_1	"list_1"	height:3
	   
	   --button button_1 "b1" align:#left pos:[13, 20] --pos & offset - equivalent values
	   button button_1 "b1" align:#left offset:[0, -50]
	   button button_2 "b2" align:#left 
   
	   
	/** LIST BOX IN FIRST COLUMN ON LEFT 
	  *	
	  */
	   listbox	list_2	"list_2"	height:3	across:2 
	   groupBox	groupBox_2	"box 2"	align:#right	across:2 
	   
	   button button_3 "b3" align:#right offset:[0, -50]
	   button button_4 "b4" align:#right
	   dropdownlist	dropdownlist1 "dd1" align:#right
	   --button button_5 "b5" align:#right
	   
		
	)
	on controls_vertical open do
	(
		/* get width and height of BUTTON does not work in max 2016 */ 
		--width_of_component = if( (maxVersion())[8] != undefined ) then controls_vertical.button_2.width else 96
		
		--messageBox ( width_of_component as string ) title:"Title"  beep:false
	)
	
)

CreateDialog controls_vertical width:256 pos:[1600,512]


 /* in max 2016 is bug when getting size of control */ 
if( (try button_height = (controls_vertical.button_5.height )catch()) == undefined ) then
	button_height = 16


/* SET Groupbox height */ 
controls_vertical.groupBox_1.height = (controls_vertical.button_2.pos.y + button_height )

--messageBox ( controls_vertical.groupBox_1.width as string ) title:"Title"  beep:false


--controls_vertical.button_4.pos = controls_vertical.groupBox_2.pos
--controls_vertical.button_5.pos = controls_vertical.groupBox_2.pos
--
--controls_vertical.button_4.pos.y += 16
--controls_vertical.button_5.pos.y += 32