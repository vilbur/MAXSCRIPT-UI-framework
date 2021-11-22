clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../ControlParams.ms" )
filein( getFilenamePath(getSourceFileName()) + "/../../ControlDefaults/ControlDefaults.ms" )

ControlParams 	= ControlParams_v()
ControlDefaults 	= ControlDefaults_v()

--ControlDefaults.setValues #( #itenger, #float, #string, #array ) #( 256, 512.0, "_string", #( 1, 2.0, #name, "string" ) ) filter:true

ControlDefaults.setValues #( #width, #height ) #( 256, 512 ) filter:true

ControlParams.setDefaults (ControlDefaults)
format "ControlParams.defaults	= % \n" ControlParams.defaults


params_string = "width:256"
params_array  = #(#width, 64, #height, 32 )


format "getParams params_string	= \"%\" \n" (ControlParams.getParams (params_string))
format "getParams params_array	= \"%\" \n" (ControlParams.getParams (params_array))