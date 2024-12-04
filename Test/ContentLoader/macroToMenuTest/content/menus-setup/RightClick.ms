/*------------------------------------------------------------------------------
	GET QUAD MENU
--------------------------------------------------------------------------------*/
QuadMenuTest 	= QuadMenu_v ("Quad Test")

/*------------------------------------------------------------------------------
	ADD MENU TO QUAD MENU
------------------------------------------------------------------------------*/
QuadMenuTest.Quads[1].clearMenu() -- clear menu is not necessary, jsut for test repetion

QuadMenuTest.Quads[1].addMenu ("_Test Menu") flat:true

/*------------------------------------------------------------------------------
	MODIFY QUAD MENU OPTIONS
------------------------------------------------------------------------------*/

QuadMenuTest.showAllQuads()

QuadMenuTest.setRightClick()