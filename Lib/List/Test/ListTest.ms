clearListener()

filein ( getFilenamePath(getSourceFileName()) + "/../List.ms" );

/* create a list */ 
List           = List_v()

/* Add value */ 
List.setVal #first  "First Item"
List.setVal #second     "Second Item"
List.setVal #third      "Third Item Remove"
List.setVal #fourth     "Fourth"


/* copy a list */  
List_copy        = List.copy()

List_copy.setVal #first  "First Item Copy"
List_copy.setVal #fifth      "Fifth"
List_copy.setVal #undefined  undefined
List_copy.setVal #unsupplied unsupplied
List_copy.setVal #delete     "Delete"


/* MERGE */ 
List.merge (List_copy)	                     -- Keep unique, values are not overrided
--List.merge (List_copy) unique:false        -- Add all values, simply merge Lists
--List.merge (List_copy) unique:unsupplied   -- Keep unique, BUT OVERRIDE first List by List_to_merge
format "List merged	= % \n" List


/* MAKE LIST UNIQUE */ 

List.unique()
format "List unique = % \n" List



/* UNIQUE ADD Test */ 
List.setVal #last      "New value"
format "Add new value Test:% \n" (List.values[List.values.count]== "New value") as string

List.setVal #last      "Replaced"
format "Replace value Test:% \n" (List.values[List.values.count]== "Replaced") as string

List.setVal #last      "Don`t replace" unique:true 
format "Unique true   Test:% \n" (List.values[List.values.count] == "Replaced") as string

List.setVal #last      "Added anyway" unique:false 
format "Unique false  Test:% \n" (List.values[List.values.count] == "Added anyway") as string



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