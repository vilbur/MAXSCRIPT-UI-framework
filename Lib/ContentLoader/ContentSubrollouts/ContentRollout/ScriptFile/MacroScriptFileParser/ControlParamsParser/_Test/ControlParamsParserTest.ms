clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../ControlParamsParser.ms" )

ControlParamsParser = ControlParamsParser_v()


params = ControlParamsParser.parse ("#event: #rightclick| #width:128 | height : 64|border:true|items: #('item1', 'item2')" )


format "params	= % \n" params

for i = 1 to params[1].count do 
	format "param	= % \nvalue	= %  \nclassOf	= %\n\n" params[1][i] ( params[2][i] as string ) (classOf params[2][i])
