clearListener()

filein ( getFilenamePath(getSourceFileName()) + "/../List.ms" );

/* create a list */ 
List           = List_v()

/* Add value */ 
List.setVal #first  "First Item"

List.setVal #second     "Second Item"
List.setVal #third      "Third Item Remove"
List.setVal #fourth     "Fourth"
List.setVal #fifth      "Fifth"
List.setVal #undefined  undefined
List.setVal #unsupplied unsupplied
List.setVal #delete     "Delete"


/* UNIQUE ADD Test */ 
List.setVal #last      "New value"
format "Add new value Test:% \n" (List.values[List.values.count]== "New value") as string

List.setVal #last      "Replaced"
format "Replace value Test:% \n" (List.values[List.values.count]== "Replaced") as string

List.setVal #last      "Don`t replace" unique:true 
format "Unique true   Test:% \n" (List.values[List.values.count] == "Replaced") as string

List.setVal #last      "Added anyway" unique:false 
format "Unique false  Test:% \n" (List.values[List.values.count] == "Added anyway") as string



/* MAKE LIST UNIQUE */ 
List.setVal #fifth      "Duplicated key" unique:false	-- prepare test
count_before_unique = List.count()	-- prepare test

List.unique()
format "Unique()      Test:% \n" (count_before_unique != List.count() ) as string



/* copy a list */  
List_copy        = List.copy()
format "List copy     Test:% \n" (List.keys[1] == List_copy.keys[1])



--
--/* Delete value */
--format "Delete #delete     = % \n" (List.delete #delete);
--
--
--/* Filter value */
--format "Left	only unsupplied = % \n"	(List_copy.filter	unsupplied test:false) 
--format "Remove	undefined       = % \n"	(List.filter	undefined  test:true) 
--format "Left	'*Item*'        = % \n"	(List.filter	"*Item*"   test:true )
--format "Removed	'*Remove'       = % \n"	(List.filter	"*Remove"  test:false )
--
--
--format "join   \":\" \"|\" = \"%\" \n"	(List.join  ":"	delimeter:"|" ) -- default delimeter:" "
--format "joinValues \"|\" = \"%\" \n"	(List.joinValues	delimeter:"|" ) -- default delimeter:" "



/* Get value */
second = List.getVal #second                   
--format "get second item  = % \n" second