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


/* copy a list */ 
List_copy        = List_v()
List_copy.keys   = deepCopy List.keys
List_copy.values = deepCopy List.values

format "List             = % \n\n" List


/* Delete value */
format "Delete #delete     = % \n" (List.delete #delete);


/* Filter value */
format "Left	only unsupplied = % \n"	(List_copy.filter	unsupplied test:false) 
format "Remove	undefined       = % \n"	(List.filter	undefined  test:true) 
format "Left	'*Item*'        = % \n"	(List.filter	"*Item*"   test:true )
format "Removed	'*Remove'       = % \n"	(List.filter	"*Remove"  test:false )


format "join   \":\" \"|\" = \"%\" \n"	(List.join  ":"	delimeter:"|" ) -- default delimeter:" "
format "joinValues \"|\" = \"%\" \n"	(List.joinValues	delimeter:"|" ) -- default delimeter:" "



--/* Get value */
--second = List.getVal #second                   
----format "get second item  = % \n" second