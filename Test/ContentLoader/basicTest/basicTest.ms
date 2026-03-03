clearListener(); print("Cleared in: "+getSourceFileName())

/** INCLUDE UI
 */
filein( getFilenamePath(getSourceFileName()) + "/../../../Lib/ContentLoader/ContentLoader.ms" )

/** Load content from file tree
 */
function loadContentTest dir_name ini=
(
	current_dir	= getFilenamePath(getSourceFileName())

	ContentLoader	= ContentLoader_v path:(current_dir+"/"+dir_name) ini:ini

	ContentLoader.Dialog.width  = 256
	ContentLoader.Dialog.height = 1024

	(ContentLoader.Dialog.get (#ROLLOUT_test)).title = "Title changed" -- change property of rollout

	ContentLoader.create() --return
)



/*---------------------------------------
	RUN TESTS
-----------------------------------------*/

Dialog = loadContentTest("Test Content") ini_file


