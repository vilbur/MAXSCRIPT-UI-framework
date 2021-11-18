clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../Dialog.ms" )

try( destroyDialog ROLLOUT_test )catch()


Dialog 	= Dialog_v title:"Test"

Dialog.create()