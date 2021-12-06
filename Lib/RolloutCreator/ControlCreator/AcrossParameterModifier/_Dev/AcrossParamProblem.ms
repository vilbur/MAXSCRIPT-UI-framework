clearListener()

/*------------------------------------------------------------------------------
  
	PROBLEM - across parameter overrides next across if row is not complete
	
	SOLUTION - add fake labels to keep across behaviour as columns
	
--------------------------------------------------------------------------------*/


try( destroyDialog across_problem )catch()
try( destroyDialog across_solution )catch()


/* PROBLEM 
*/ 
rollout across_problem "across_problem"
(
	button button_1 "b1" across:4
	button button_2 "b2"
	button button_3 "b3"
	button button_4 "b4"
	button button_5 "b5"
	button button_6 "b6"
	
	listbox list_1 "list_1" across:1 --pos:[0,64]
	listbox list_2 "list_2" across:2
	listbox list_3 "list_3" 
	
)

CreateDialog across_problem width:256 pos:[1024,512]


/* SOLUTION
*/ 
rollout across_solution "across_solution"
(
	button button_1 "b1" across:4
	button button_2 "b2"
	button button_3 "b3"
	label  fake_1    "FAKE" -- fake control to keep layout
	
	listbox list_1 "list_1" across:1 --pos:[0,64]
	listbox list_2 "list_2" across:2
	listbox list_3 "list_3" 
	
)

CreateDialog across_solution width:256 pos:[1300,512]